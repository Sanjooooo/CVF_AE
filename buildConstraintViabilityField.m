function [fieldStep, fieldInfo] = buildConstraintViabilityField(X, map, params, detail, state)
%BUILDCONSTRAINTVIABILITYFIELD Build a sparse control-point viability field.
%
% The field is computed from sampled-path constraint pressure and mapped back
% to nearest interior B-spline control points. It performs no fitness
% evaluation and returns a bounded decision-vector step.

if nargin < 4
    detail = struct();
end
if nargin < 5
    state = struct('id', 1, 'name', 'FeasibilityFormation');
end

cfg = localDefaultCVFParams(params);
ctrl = decodeSolution(X, params);
nFull = size(ctrl, 1);
nInterior = nFull - 2;
deltaCtrl = zeros(nFull, 3);
hitCount = zeros(nFull, 1);
contrib = struct('obstacle', 0, 'nfz', 0, 'risk', 0, 'altitude', 0, ...
    'curvature', 0, 'boundary', 0);

nSamples = min(params.nSamples, cfg.samples);
path = bsplinePath(ctrl, params.degree, nSamples);

weights = localStateWeights(state, cfg);

for m = 2:size(path, 1)-1
    p = path(m, :);
    k = localNearestInteriorControlPoint(p, ctrl);
    pressure = zeros(1, 3);

    [v, mag] = localObstaclePressure(p, map, cfg);
    if mag > 0
        pressure = pressure + weights.obstacle * v;
        contrib.obstacle = contrib.obstacle + mag;
    end

    [v, mag] = localNFZPressure(p, map, cfg);
    if mag > 0
        pressure = pressure + weights.nfz * v;
        contrib.nfz = contrib.nfz + mag;
    end

    [v, mag] = localRiskPressure(p, map, cfg);
    if mag > 0
        pressure = pressure + weights.risk * v;
        contrib.risk = contrib.risk + mag;
    end

    [v, mag] = localAltitudePressure(p, params, cfg);
    if mag > 0
        pressure = pressure + weights.altitude * v;
        contrib.altitude = contrib.altitude + mag;
    end

    [v, mag] = localBoundaryPressure(p, params, cfg);
    if mag > 0
        pressure = pressure + weights.boundary * v;
        contrib.boundary = contrib.boundary + mag;
    end

    if norm(pressure) > 0
        deltaCtrl(k, :) = deltaCtrl(k, :) + pressure;
        hitCount(k) = hitCount(k) + 1;
    end
end

for k = 2:nFull-1
    if hitCount(k) > 0
        deltaCtrl(k, :) = deltaCtrl(k, :) / hitCount(k);
    end
end

[curvDelta, curvMag] = localCurvaturePressure(ctrl, params, cfg);
if curvMag > 0
    deltaCtrl = deltaCtrl + weights.curvature * curvDelta;
    contrib.curvature = curvMag;
end

fieldStep = encodeControlPoints(deltaCtrl);
limit = cfg.maxStepRatio * (params.ub(:)' - params.lb(:)');
fieldStep = min(max(fieldStep, -limit), limit);
fieldStep = cfg.strength * fieldStep;

if norm(fieldStep) > 0
    normLimit = cfg.maxNormRatio * norm(params.ub(:)' - params.lb(:));
    nrm = norm(fieldStep);
    if nrm > normLimit
        fieldStep = fieldStep * (normLimit / nrm);
    end
end

activeControlCount = sum(hitCount(2:end-1) > 0);
names = {'obstacle', 'nfz', 'risk', 'altitude', 'curvature', 'boundary'};
vals = [contrib.obstacle, contrib.nfz, contrib.risk, contrib.altitude, ...
    contrib.curvature, contrib.boundary];
[maxVal, idx] = max(vals);
if maxVal <= 0
    dominantType = 'none';
else
    dominantType = names{idx};
end

fieldInfo = struct();
fieldInfo.norm = norm(fieldStep);
fieldInfo.activeControlCount = activeControlCount;
fieldInfo.dominantType = dominantType;
fieldInfo.contributions = contrib;
fieldInfo.hitCount = hitCount(2:end-1);
fieldInfo.detailViolation = localViolation(detail);
fieldInfo.nSamples = nSamples;
fieldInfo.nInterior = nInterior;
end

function cfg = localDefaultCVFParams(params)
cfg.samples = 64;
cfg.strength = 0.65;
cfg.maxStepRatio = 0.040;
cfg.maxNormRatio = 0.085;
cfg.obstacleInfluence = 7.0;
cfg.nfzInfluence = 7.0;
cfg.boundaryMargin = 6.0;
cfg.riskActivation = 0.24;
cfg.riskScale = 1.8;
cfg.altitudeBand = 3.0;
cfg.curvatureGamma = 0.22;
cfg.curvatureActivation = 0.85;

cfg.stateFormation = [1.20, 1.15, 0.85, 1.10, 0.85, 0.65];
cfg.statePreservation = [0.95, 0.95, 0.85, 0.90, 0.75, 0.55];
cfg.stateRefinement = [0.35, 0.35, 0.55, 0.40, 0.95, 0.35];
cfg.stateRecovery = [0.80, 0.80, 0.75, 0.75, 0.55, 0.45];

if isfield(params, 'cvf') && isstruct(params.cvf)
    f = fieldnames(params.cvf);
    for k = 1:numel(f)
        cfg.(f{k}) = params.cvf.(f{k});
    end
end
end

function weights = localStateWeights(state, cfg)
if ~isstruct(state) || ~isfield(state, 'id')
    sid = 1;
else
    sid = state.id;
end
switch sid
    case 1
        raw = cfg.stateFormation;
    case 2
        raw = cfg.statePreservation;
    case 3
        raw = cfg.stateRefinement;
    otherwise
        raw = cfg.stateRecovery;
end
weights = struct('obstacle', raw(1), 'nfz', raw(2), 'risk', raw(3), ...
    'altitude', raw(4), 'curvature', raw(5), 'boundary', raw(6));
end

function [v, mag] = localObstaclePressure(p, map, cfg)
v = [0, 0, 0];
mag = 0;
if ~isfield(map, 'obstacles') || isempty(map.obstacles)
    return;
end
for i = 1:size(map.obstacles, 1)
    box = map.obstacles(i, :);
    nearest = [min(max(p(1), box(1)), box(2)), ...
        min(max(p(2), box(3)), box(4)), min(max(p(3), box(5)), box(6))];
    inside = p(1) >= box(1) && p(1) <= box(2) && ...
        p(2) >= box(3) && p(2) <= box(4) && ...
        p(3) >= box(5) && p(3) <= box(6);
    if inside
        d = [p(1) - box(1), box(2) - p(1), p(2) - box(3), box(4) - p(2)];
        [depth, side] = min(d);
        dirs = [-1 0 0; 1 0 0; 0 -1 0; 0 1 0];
        dir = dirs(side, :);
        pressure = (cfg.obstacleInfluence + max(0, depth)) * dir;
    else
        dvec = p - nearest;
        dvec(3) = 0.35 * dvec(3);
        dist = norm(dvec);
        if dist <= 0 || dist > cfg.obstacleInfluence
            continue;
        end
        dir = dvec / dist;
        pressure = (cfg.obstacleInfluence - dist) / cfg.obstacleInfluence * dir;
    end
    v = v + pressure;
    mag = mag + norm(pressure);
end
end

function [v, mag] = localNFZPressure(p, map, cfg)
v = [0, 0, 0];
mag = 0;
if ~isfield(map, 'nfz') || isempty(map.nfz)
    return;
end
for i = 1:size(map.nfz, 1)
    c = map.nfz(i, :);
    if p(3) < c(4) || p(3) > c(5)
        continue;
    end
    dxy = [p(1) - c(1), p(2) - c(2), 0];
    dist = norm(dxy);
    if dist < 1e-9
        dxy = [1, 0, 0];
        dist = 1;
    end
    if dist <= c(3)
        pressure = (c(3) - dist + cfg.nfzInfluence) * dxy / dist;
    elseif dist <= c(3) + cfg.nfzInfluence
        pressure = (c(3) + cfg.nfzInfluence - dist) / cfg.nfzInfluence * dxy / dist;
    else
        continue;
    end
    v = v + pressure;
    mag = mag + norm(pressure);
end
end

function [v, mag] = localRiskPressure(p, map, cfg)
v = [0, 0, 0];
mag = 0;
if ~isfield(map, 'windHotspots') || isempty(map.windHotspots)
    return;
end
for i = 1:size(map.windHotspots, 1)
    h = map.windHotspots(i, :);
    d = p - h(1:3);
    d(3) = 0.35 * d(3);
    dist2 = sum(d.^2);
    pressure = h(5) * exp(-dist2 / (2 * h(4)^2));
    if pressure <= cfg.riskActivation
        continue;
    end
    if norm(d) < 1e-9
        d = [1, 0.5, 0];
    end
    step = cfg.riskScale * (pressure - cfg.riskActivation) * d / norm(d);
    v = v + step;
    mag = mag + norm(step);
end
end

function [v, mag] = localAltitudePressure(p, params, cfg)
v = [0, 0, 0];
if p(3) < params.altMin
    v(3) = params.altMin - p(3);
elseif p(3) > params.altMax
    v(3) = params.altMax - p(3);
elseif p(3) < params.altMin + cfg.altitudeBand
    v(3) = 0.35 * (params.altMin + cfg.altitudeBand - p(3));
elseif p(3) > params.altMax - cfg.altitudeBand
    v(3) = -0.35 * (p(3) - (params.altMax - cfg.altitudeBand));
end
if isfield(params, 'heightRef') && isfinite(params.heightRef)
    v(3) = v(3) + 0.04 * (params.heightRef - p(3));
end
mag = abs(v(3));
end

function [v, mag] = localBoundaryPressure(p, params, cfg)
v = [0, 0, 0];
xmin = params.map.xlim(1) + cfg.boundaryMargin;
xmax = params.map.xlim(2) - cfg.boundaryMargin;
ymin = params.map.ylim(1) + cfg.boundaryMargin;
ymax = params.map.ylim(2) - cfg.boundaryMargin;
if p(1) < xmin
    v(1) = xmin - p(1);
elseif p(1) > xmax
    v(1) = xmax - p(1);
end
if p(2) < ymin
    v(2) = ymin - p(2);
elseif p(2) > ymax
    v(2) = ymax - p(2);
end
mag = norm(v);
end

function [deltaCtrl, mag] = localCurvaturePressure(ctrl, params, cfg)
deltaCtrl = zeros(size(ctrl));
mag = 0;
for k = 3:size(ctrl, 1)-2
    v1 = ctrl(k, :) - ctrl(k-1, :);
    v2 = ctrl(k+1, :) - ctrl(k, :);
    den = norm(v1) * norm(v2) + 1e-9;
    angle = acos(max(min(dot(v1, v2) / den, 1), -1));
    if angle < cfg.curvatureActivation * params.turnMax
        continue;
    end
    target = 0.5 * (ctrl(k-1, :) + ctrl(k+1, :));
    step = cfg.curvatureGamma * (target - ctrl(k, :));
    deltaCtrl(k, :) = deltaCtrl(k, :) + step;
    mag = mag + norm(step);
end
end

function k = localNearestInteriorControlPoint(p, ctrl)
inner = ctrl(2:end-1, :);
[~, idx] = min(sum((inner - p).^2, 2));
k = idx + 1;
end

function v = localViolation(detail)
v = NaN;
if isstruct(detail) && isfield(detail, 'V') && ~isempty(detail.V)
    v = detail.V;
end
end
