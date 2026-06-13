function [Xnew, opInfo] = applyOperator_COVE_AE(i, pop, bestX, refX, elitePool, state, feedback, memory, iter, params, map)
%APPLYOPERATOR_COVE_AE Lightweight operator driven by state and violations.

if nargin < 11
    map = [];
end

[N, D] = size(pop); %#ok<ASGLU>
x = pop(i, :);
span = params.ub(:)' - params.lb(:)';
tau = iter / params.maxIter;

eliteNum = size(elitePool, 1);
xElite = elitePool(randi(eliteNum), :);
eliteMean = mean(elitePool, 1);

idx = 1:size(pop, 1);
idx(i) = [];
idx = idx(randperm(numel(idx), min(4, numel(idx))));
while numel(idx) < 4
    idx(end+1) = randi(size(pop, 1)); %#ok<AGROW>
end

diff1 = pop(idx(1), :) - pop(idx(2), :);
diff2 = pop(idx(3), :) - pop(idx(4), :);
dirBest = bestX - x;
dirElite = eliteMean - x;
dirSample = xElite - x;

if isempty(refX)
    dirRef = zeros(1, D);
else
    dirRef = refX(:)' - x;
end

bias = localViolationMask(feedback, params);
noise = (2 * rand(1, D) - 1) .* span .* bias;
reuseStep = localReuseStep(memory, D);
fbCfg = localFeedbackParams(params);
feedbackStep = localFeedbackStep(x, map, params, feedback, fbCfg);

switch state.id
    case 1
        opId = 1;
        step = ...
            (0.25 + 0.25 * (1 - tau)) * rand(1, D) .* dirRef + ...
            (0.20 + 0.20 * (1 - tau)) * rand(1, D) .* dirElite + ...
            0.18 * diff1 + ...
            (0.08 + 0.10 * (1 - tau)) * noise + ...
            0.18 * reuseStep + ...
            0.36 * feedbackStep;

    case 2
        opId = 2;
        step = ...
            (0.25 + 0.10 * tau) * rand(1, D) .* dirBest + ...
            0.28 * rand(1, D) .* dirElite + ...
            0.16 * diff1 + ...
            0.08 * rand(1, D) .* dirRef + ...
            0.08 * noise + ...
            0.22 * reuseStep + ...
            0.28 * feedbackStep;

    case 3
        opId = 3;
        step = ...
            (0.38 + 0.16 * tau) * rand(1, D) .* dirBest + ...
            (0.30 + 0.12 * tau) * rand(1, D) .* dirSample + ...
            0.08 * diff1 + ...
            0.04 * noise + ...
            0.10 * reuseStep + ...
            0.16 * feedbackStep;

    otherwise
        opId = 4;
        step = ...
            0.24 * diff1 + ...
            0.18 * diff2 + ...
            0.22 * rand(1, D) .* dirBest + ...
            0.10 * randn(1, D) .* span .* bias + ...
            0.25 * reuseStep + ...
            0.22 * feedbackStep;
end

Xnew = x + step;

anchor = 0.05 + 0.10 * tau;
if state.id == 1 && ~isempty(refX)
    anchor = anchor + 0.10;
end
Xnew = (1 - anchor) * Xnew + anchor * xElite;

if strcmp(feedback.dominantType, 'curvature')
    Xnew = localSmoothControlVector(Xnew, params, 0.5 * fbCfg.smoothGamma);
end

Xnew = boundSolution(Xnew, params);

opInfo = struct();
opInfo.id = opId;
opInfo.stateId = state.id;
opInfo.stateName = state.name;
opInfo.feedbackType = feedback.dominantType;
end

function mask = localViolationMask(feedback, params)
D = params.dim;
mask = ones(1, D);

switch feedback.dominantType
    case {'obstacle', 'nfz', 'risk'}
        mask(1:3:end) = 1.20;
        mask(2:3:end) = 1.20;
        mask(3:3:end) = 0.65;
    case 'altitude'
        mask(1:3:end) = 0.55;
        mask(2:3:end) = 0.55;
        mask(3:3:end) = 1.35;
    case 'curvature'
        mask(:) = 0.75;
    otherwise
        mask(:) = 1.0;
end
end

function step = localReuseStep(memory, D)
step = zeros(1, D);
if isstruct(memory) && isfield(memory, 'repairStep') && numel(memory.repairStep) == D
    step = memory.repairStep(:)';
end
end

function cfg = localFeedbackParams(params)
cfg.strength = 0.70;
cfg.avoidanceSamples = 64;
cfg.avoidanceMaxHits = 10;
cfg.avoidanceLimit = 0.07;
cfg.riskActivation = 0.24;
cfg.riskStepScale = 2.20;
cfg.smoothGamma = 0.32;
cfg.altitudeGain = 0.35;

if isfield(params, 'cove') && isfield(params.cove, 'feedback')
    s = params.cove.feedback;
    f = fieldnames(s);
    for k = 1:numel(f)
        cfg.(f{k}) = s.(f{k});
    end
end
end

function step = localFeedbackStep(X, map, params, feedback, cfg)
step = zeros(1, params.dim);
weights = localFeedbackWeights(feedback);
if all(weights <= 0)
    return;
end

spatialWeight = min(1, weights(1) + weights(2) + 0.75 * weights(5));
curvWeight = weights(3);
altWeight = weights(4);

if spatialWeight > 0
    step = step + spatialWeight * localAvoidanceStep(X, map, params, feedback, weights, cfg);
end
if curvWeight > 0
    step = step + curvWeight * localCurvatureRelaxationStep(X, params, cfg);
end
if altWeight > 0
    step = step + altWeight * localAltitudeStep(X, params, cfg);
end

step = cfg.strength * step;
limit = cfg.avoidanceLimit * (params.ub(:)' - params.lb(:)');
step = min(max(step, -limit), limit);
end

function weights = localFeedbackWeights(feedback)
weights = zeros(1, 5);
if ~isstruct(feedback) || ~isfield(feedback, 'dominantType') || strcmp(feedback.dominantType, 'none')
    return;
end
if isfield(feedback, 'weights') && isnumeric(feedback.weights) && numel(feedback.weights) >= 5
    weights = feedback.weights(1:5);
end
if ~any(isfinite(weights)) || sum(weights, 'omitnan') <= 0
    weights(:) = 0;
    return;
end
weights(~isfinite(weights)) = 0;
weights = weights / sum(weights);
end

function step = localAvoidanceStep(X, map, params, feedback, weights, cfg)
step = zeros(1, params.dim);
if isempty(map) || ~isstruct(map)
    return;
end
if ~ismember(feedback.dominantType, {'obstacle', 'nfz', 'risk'}) && sum(weights([1 2 5])) <= 0
    return;
end

ctrl = decodeSolution(X, params);
nAvoidSamples = min(params.nSamples, cfg.avoidanceSamples);
path = bsplinePath(ctrl, params.degree, nAvoidSamples);
deltaCtrl = zeros(size(ctrl));
hitCount = zeros(size(ctrl, 1), 1);
maxHits = cfg.avoidanceMaxHits;
hits = 0;

for m = 2:size(path, 1)-1
    [isViol, dir, depth] = localPointAvoidance(path(m, :), map, weights, cfg);
    if ~isViol
        continue;
    end

    k = localNearestInteriorControlPoint(path(m, :), ctrl);
    mag = min(4.5, max(0.6, depth + 0.75));
    deltaCtrl(k, :) = deltaCtrl(k, :) + mag * dir;
    hitCount(k) = hitCount(k) + 1;
    hits = hits + 1;

    if hits >= maxHits
        break;
    end
end

if hits == 0
    return;
end

for k = 2:size(ctrl, 1)-1
    if hitCount(k) > 0
        deltaCtrl(k, :) = deltaCtrl(k, :) / hitCount(k);
    end
end

step = encodeControlPoints(deltaCtrl);
limit = cfg.avoidanceLimit * (params.ub(:)' - params.lb(:)');
step = min(max(step, -limit), limit);
end

function [isViol, dir, depth] = localPointAvoidance(p, map, weights, cfg)
isViol = false;
dir = [0, 0, 0];
depth = 0;

for k = 1:size(map.obstacles, 1)
    box = map.obstacles(k, :);
    if p(1) >= box(1) && p(1) <= box(2) && ...
       p(2) >= box(3) && p(2) <= box(4) && ...
       p(3) >= box(5) && p(3) <= box(6)
        dx = [abs(p(1) - box(1)), abs(box(2) - p(1))];
        dy = [abs(p(2) - box(3)), abs(box(4) - p(2))];
        candidates = [dx(1), dx(2), dy(1), dy(2)];
        [depth, side] = min(candidates);
        switch side
            case 1
                dir = [-1, 0, 0];
            case 2
                dir = [1, 0, 0];
            case 3
                dir = [0, -1, 0];
            otherwise
                dir = [0, 1, 0];
        end
        isViol = true;
        return;
    end
end

for k = 1:size(map.nfz, 1)
    cyl = map.nfz(k, :);
    dxy = [p(1) - cyl(1), p(2) - cyl(2), 0];
    dist = norm(dxy);
    if dist <= cyl(3) && p(3) >= cyl(4) && p(3) <= cyl(5)
        if dist < 1e-9
            dxy = [1, 0, 0];
            dist = 1;
        end
        dir = dxy / dist;
        depth = cyl(3) - dist;
        isViol = true;
        return;
    end
end

if weights(5) > 0 && isfield(map, 'windHotspots') && ~isempty(map.windHotspots)
    [riskDir, riskDepth] = localRiskAvoidance(p, map, cfg);
    if riskDepth > 0
        dir = riskDir;
        depth = cfg.riskStepScale * riskDepth;
        isViol = true;
        return;
    end
end
end

function [dir, depth] = localRiskAvoidance(p, map, cfg)
dir = [0, 0, 0];
riskPressure = 0;
for k = 1:size(map.windHotspots, 1)
    h = map.windHotspots(k, :);
    center = h(1:3);
    sigma = h(4);
    amp = h(5);
    d = p - center;
    d(3) = 0.35 * d(3);
    d2 = sum(d.^2);
    pressure = amp * exp(-d2 / (2 * sigma^2));
    if pressure <= cfg.riskActivation
        continue;
    end
    if norm(d) < 1e-9
        d = [1, 0.5, 0];
    end
    dir = dir + pressure * d / (norm(d) + 1e-9);
    riskPressure = riskPressure + pressure;
end

if norm(dir) > 1e-9
    dir = dir / norm(dir);
    depth = max(0, riskPressure - cfg.riskActivation);
else
    depth = 0;
end
end

function step = localCurvatureRelaxationStep(X, params, cfg)
ctrl = decodeSolution(X, params);
deltaCtrl = zeros(size(ctrl));
for k = 3:size(ctrl, 1)-2
    target = 0.5 * (ctrl(k-1, :) + ctrl(k+1, :));
    deltaCtrl(k, :) = cfg.smoothGamma * (target - ctrl(k, :));
end
step = encodeControlPoints(deltaCtrl);
limit = 0.06 * (params.ub(:)' - params.lb(:)');
step = min(max(step, -limit), limit);
end

function step = localAltitudeStep(X, params, cfg)
ctrl = decodeSolution(X, params);
deltaCtrl = zeros(size(ctrl));
if isfield(params, 'heightRef') && isfinite(params.heightRef)
    zTarget = params.heightRef;
else
    zTarget = 0.5 * (params.altMin + params.altMax);
end
for k = 2:size(ctrl, 1)-1
    dz = zTarget - ctrl(k, 3);
    deltaCtrl(k, 3) = cfg.altitudeGain * dz;
end
step = encodeControlPoints(deltaCtrl);
limit = 0.05 * (params.ub(:)' - params.lb(:)');
step = min(max(step, -limit), limit);
end

function k = localNearestInteriorControlPoint(p, ctrl)
inner = ctrl(2:end-1, :);
[~, idx] = min(sum((inner - p).^2, 2));
k = idx + 1;
end

function X = localSmoothControlVector(X, params, gamma)
ctrl = decodeSolution(X, params);
for k = 3:size(ctrl, 1)-2
    target = 0.5 * (ctrl(k-1, :) + ctrl(k+1, :));
    ctrl(k, :) = ctrl(k, :) + gamma * (target - ctrl(k, :));
end
X = encodeControlPoints(ctrl);
end
