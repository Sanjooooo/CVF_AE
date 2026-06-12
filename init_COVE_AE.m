function [pop, fit, detail, info] = init_COVE_AE(objFun, params, map, refCtrl, algCfg)
%INIT_COVE_AE Constraint-state-guided population initialization.

if nargin < 5
    algCfg = struct();
end

N = params.popSize;
pop = zeros(N, params.dim);
fit = inf(N, 1);
detail = [];
info = struct('nEvals', 0, 'repairCount', 0, 'repairSuccessCount', 0);

useStateInit = localGetFlag(algCfg, 'useConstraintStateInit', true);
useSparseRepair = localGetFlag(algCfg, 'useSparseRepairReuse', true);
cfg = localDefaultInitParams(params);

if isempty(refCtrl)
    refCtrl = localStraightReference(params);
end

nGuided = round(cfg.guidedRatio * N);
if ~useStateInit
    nGuided = 0;
end

for j = 1:N
    if j <= nGuided
        ctrl = localGuidedControlPoints(refCtrl, map, params, cfg);
    else
        ctrl = localRandomControlPoints(params);
    end

    X = boundSolution(encodeControlPoints(ctrl), params);
    pop(j, :) = X;
    [fit(j), d] = objFun(X);
    info.nEvals = info.nEvals + 1;

    if isempty(detail)
        detail = repmat(d, N, 1);
    end
    detail(j) = d;
end

if useSparseRepair && cfg.initialRepairQuota > 0
    [~, order] = sort(localViolationVector(detail), 'ascend');
    quota = min(cfg.initialRepairQuota, N);
    for kk = 1:quota
        idx = order(kk);
        if detail(idx).isFeasible || detail(idx).V > cfg.initialRepairMaxViolation
            continue;
        end

        repParams = params;
        repParams.repair.iter = cfg.initialRepairIters;
        [xRep, ~] = repairPath(pop(idx, :), map, repParams);
        [fRep, dRep] = objFun(xRep);
        info.nEvals = info.nEvals + 1;
        info.repairCount = info.repairCount + 1;

        if debBetter(fRep, dRep, fit(idx), detail(idx))
            pop(idx, :) = xRep;
            fit(idx) = fRep;
            detail(idx) = dRep;
            info.repairSuccessCount = info.repairSuccessCount + 1;
        end
    end
end
end

function cfg = localDefaultInitParams(params)
cfg.guidedRatio = 0.70;
cfg.clearanceScale = 0.45;
cfg.riskShrink = 1.80;
cfg.minRadius = 1.0;
cfg.maxTrial = 8;
cfg.initialRepairQuota = max(1, round(0.20 * params.popSize));
cfg.initialRepairMaxViolation = 30;
cfg.initialRepairIters = 1;

if isfield(params, 'cove') && isfield(params.cove, 'init')
    s = params.cove.init;
    f = fieldnames(s);
    for k = 1:numel(f)
        cfg.(f{k}) = s.(f{k});
    end
end
end

function tf = localGetFlag(s, name, defaultValue)
tf = defaultValue;
if isstruct(s) && isfield(s, name)
    tf = logical(s.(name));
end
end

function ctrl = localGuidedControlPoints(refCtrl, map, params, cfg)
ctrl = refCtrl;
for i = 2:size(refCtrl, 1) - 1
    qRef = refCtrl(i, :);
    safeDist = localClearance(qRef, map, params);
    risk = queryWindRisk(qRef, map);
    radius = cfg.clearanceScale * safeDist / (1 + cfg.riskShrink * risk);
    radius = max(radius, cfg.minRadius);

    q = qRef;
    found = false;
    rr = radius;
    for t = 1:cfg.maxTrial
        cand = qRef + (2 * rand(1, 3) - 1) * rr;
        cand = localBoundPoint(cand, params);
        if localPointFeasible(cand, map, params)
            q = cand;
            found = true;
            break;
        end
        rr = 0.65 * rr;
    end

    if ~found
        q = localProjectPoint(qRef, map, params);
    end
    ctrl(i, :) = q;
end
end

function ctrl = localRandomControlPoints(params)
nFull = params.nCtrl + 2;
ctrl = zeros(nFull, 3);
ctrl(1, :) = params.start;
ctrl(end, :) = params.goal;
for i = 2:nFull - 1
    ctrl(i, :) = params.lbSingle + rand(1, 3) .* (params.ubSingle - params.lbSingle);
end
end

function refCtrl = localStraightReference(params)
nFull = params.nCtrl + 2;
refCtrl = zeros(nFull, 3);
for i = 1:nFull
    tau = (i - 1) / (nFull - 1);
    refCtrl(i, :) = (1 - tau) * params.start + tau * params.goal;
end
end

function d = localClearance(p, map, params)
vals = [];
for k = 1:size(map.obstacles, 1)
    box = map.obstacles(k, :);
    dx = max([box(1)-p(1), 0, p(1)-box(2)]);
    dy = max([box(3)-p(2), 0, p(2)-box(4)]);
    dz = max([box(5)-p(3), 0, p(3)-box(6)]);
    vals(end+1) = sqrt(dx^2 + dy^2 + dz^2); %#ok<AGROW>
end
for k = 1:size(map.nfz, 1)
    c = map.nfz(k, :);
    dxy = abs(hypot(p(1)-c(1), p(2)-c(2)) - c(3));
    dz = max([c(4)-p(3), 0, p(3)-c(5)]);
    vals(end+1) = sqrt(dxy^2 + dz^2); %#ok<AGROW>
end
vals(end+1) = min([p(1)-params.map.xlim(1), params.map.xlim(2)-p(1), ...
                   p(2)-params.map.ylim(1), params.map.ylim(2)-p(2), ...
                   p(3)-params.altMin, params.altMax-p(3)]);
d = max(min(vals), 1.0);
end

function tf = localPointFeasible(p, map, params)
tf = true;
for k = 1:size(map.obstacles, 1)
    box = map.obstacles(k, :);
    if p(1) >= box(1) && p(1) <= box(2) && ...
       p(2) >= box(3) && p(2) <= box(4) && ...
       p(3) >= box(5) && p(3) <= box(6)
        tf = false;
        return;
    end
end
for k = 1:size(map.nfz, 1)
    c = map.nfz(k, :);
    if hypot(p(1)-c(1), p(2)-c(2)) <= c(3) && p(3) >= c(4) && p(3) <= c(5)
        tf = false;
        return;
    end
end
tf = tf && p(3) >= params.altMin && p(3) <= params.altMax;
end

function p = localProjectPoint(p, map, params)
for t = 1:20
    if localPointFeasible(p, map, params)
        return;
    end
    grad = [0, 0, 0];
    for k = 1:size(map.obstacles, 1)
        box = map.obstacles(k, :);
        if p(1) >= box(1) && p(1) <= box(2) && p(2) >= box(3) && p(2) <= box(4) && p(3) >= box(5) && p(3) <= box(6)
            center = [(box(1)+box(2))/2, (box(3)+box(4))/2, (box(5)+box(6))/2];
            d = p - center;
            if norm(d) < 1e-9, d = [1, 0.5, 0.2]; end
            grad = grad + d / (norm(d) + 1e-9);
        end
    end
    for k = 1:size(map.nfz, 1)
        c = map.nfz(k, :);
        if hypot(p(1)-c(1), p(2)-c(2)) <= c(3) && p(3) >= c(4) && p(3) <= c(5)
            d = [p(1)-c(1), p(2)-c(2), 0];
            if norm(d) < 1e-9, d = [1, -1, 0]; end
            grad = grad + d / (norm(d) + 1e-9);
        end
    end
    if norm(grad) < 1e-9, grad = [0.5, 1, 0]; end
    p = localBoundPoint(p + 1.5 * grad / (norm(grad) + 1e-9), params);
end
end

function p = localBoundPoint(p, params)
p(1) = min(max(p(1), params.map.xlim(1)), params.map.xlim(2));
p(2) = min(max(p(2), params.map.ylim(1)), params.map.ylim(2));
p(3) = min(max(p(3), params.altMin), params.altMax);
end

function viol = localViolationVector(detail)
viol = inf(numel(detail), 1);
for i = 1:numel(detail)
    if isfield(detail(i), 'V') && ~isempty(detail(i).V)
        viol(i) = detail(i).V;
    end
end
end
