function result = optimizer_MSCSO_uav(objFun, params, ~, refX, algCfg, runSeed)
%OPTIMIZER_MSCSO_UAV Paper-based modified SCSO optimizer for UAV planning.
%
% Reimplemented from MSCSO mechanisms: chaotic initialization, SCSO
% sensitivity-range search, Levy-Metropolis disturbance, SA-PSO local
% exploitation, and elite mutation.

if nargin >= 6 && ~isempty(runSeed)
    rng(runSeed, 'twister');
end

dim = algCfg.dim;
lb = algCfg.lb(:)';
ub = algCfg.ub(:)';
popSize = algCfg.popSize;
maxIter = algCfg.maxIter;

useReferenceInit = localGetCfg(algCfg, 'useReferenceInit', false);
referenceInitRatio = localGetCfg(algCfg, 'referenceInitRatio', 0.0);
referenceNoiseScale = localGetCfg(algCfg, 'referenceNoiseScale', 0.05);
usePublicProjection = localGetCfg(algCfg, 'usePublicProjection', true);

temp0 = localGetNestedCfg(algCfg, 'mscso', 'temp0', 1.0);
cooling = localGetNestedCfg(algCfg, 'mscso', 'cooling', 0.98);
eliteRate = localGetNestedCfg(algCfg, 'mscso', 'eliteRate', 0.20);
mutRate = localGetNestedCfg(algCfg, 'mscso', 'mutRate', 0.15);
levyProb = localGetNestedCfg(algCfg, 'mscso', 'levyProb', 0.35);
wMax = localGetNestedCfg(algCfg, 'mscso', 'wMax', 0.9);
wMin = localGetNestedCfg(algCfg, 'mscso', 'wMin', 0.4);
c1 = localGetNestedCfg(algCfg, 'mscso', 'c1', 1.5);
c2 = localGetNestedCfg(algCfg, 'mscso', 'c2', 1.5);

X = localChaoticInit(popSize, dim, lb, ub);
if useReferenceInit && ~isempty(refX)
    X = localInjectReference(X, lb, ub, refX, referenceInitRatio, referenceNoiseScale);
end
V = zeros(popSize, dim);

[fit, detail, nEvals] = localEvaluatePopulation(X, objFun, usePublicProjection, lb, ub);
[bestX, ~, ~, ~] = localBestByDeb(X, fit, detail);
pbestX = X;
pbestFit = fit;
pbestDetail = detail;

bestHist = inf(maxIter, 1);
tStart = tic;

for t = 1:maxIter
    sensitivityRange = 2 * (1 - t / maxIter);
    w = wMax - (wMax - wMin) * (t / maxIter);
    temperature = temp0 * cooling^(t - 1);
    [bestX, ~, ~, order] = localBestByDeb(X, fit, detail);
    eliteCount = max(1, round(eliteRate * popSize));
    eliteIds = order(1:eliteCount);

    for i = 1:popSize
        xi = X(i, :);
        r = sensitivityRange * (2 * rand - 1);
        angle = 2 * pi * rand;
        if abs(r) > 1
            ids = localRandomIndices(popSize, i, 1);
            xnew = xi + r * cos(angle) .* abs(rand(1, dim) .* bestX - X(ids(1), :));
        else
            xnew = bestX - r * cos(angle) .* abs(rand(1, dim) .* bestX - xi);
        end

        if rand < levyProb
            xlevy = xnew + localLevyFlight(dim) .* (xnew - bestX);
            xlevy = localProjectSolution(xlevy, lb, ub);
            [fLevy, dLevy] = objFun(xlevy);
            nEvals = nEvals + 1;
            [fBase, dBase] = objFun(localProjectSolution(xnew, lb, ub));
            nEvals = nEvals + 1;

            if debBetter(fLevy, dLevy, fBase, dBase) || rand < exp(-(fLevy - fBase) / max(temperature, eps))
                xnew = xlevy;
                fCand = fLevy;
                dCand = dLevy;
            else
                xnew = localProjectSolution(xnew, lb, ub);
                fCand = fBase;
                dCand = dBase;
            end
        else
            xnew = localProjectSolution(xnew, lb, ub);
            [fCand, dCand] = objFun(xnew);
            nEvals = nEvals + 1;
        end

        % SA-PSO exploitation around personal and global best.
        V(i, :) = w .* V(i, :) + c1 .* rand(1, dim) .* (pbestX(i, :) - xi) ...
            + c2 .* rand(1, dim) .* (bestX - xi);
        xpso = localProjectSolution(xi + V(i, :), lb, ub);
        [fPso, dPso] = objFun(xpso);
        nEvals = nEvals + 1;
        if debBetter(fPso, dPso, fCand, dCand)
            xnew = xpso;
            fCand = fPso;
            dCand = dPso;
        end

        if debBetter(fCand, dCand, fit(i), detail(i))
            X(i, :) = xnew;
            fit(i) = fCand;
            detail(i) = dCand;
        elseif rand < exp(-(fCand - fit(i)) / max(temperature, eps))
            X(i, :) = xnew;
            fit(i) = fCand;
            detail(i) = dCand;
        end

        if debBetter(fit(i), detail(i), pbestFit(i), pbestDetail(i))
            pbestX(i, :) = X(i, :);
            pbestFit(i) = fit(i);
            pbestDetail(i) = detail(i);
        end
    end

    for e = 1:numel(eliteIds)
        if rand >= mutRate
            continue;
        end
        idx = eliteIds(e);
        xmut = X(idx, :) + 0.05 * (1 - t / maxIter) * randn(1, dim) .* (ub - lb);
        xmut = localProjectSolution(xmut, lb, ub);
        [fMut, dMut] = objFun(xmut);
        nEvals = nEvals + 1;
        if debBetter(fMut, dMut, fit(idx), detail(idx))
            X(idx, :) = xmut;
            fit(idx) = fMut;
            detail(idx) = dMut;
            pbestX(idx, :) = xmut;
            pbestFit(idx) = fMut;
            pbestDetail(idx) = dMut;
        end
    end

    [bestX, bestFit, bestDetail] = localBestByDeb(X, fit, detail);
    bestHist(t) = bestFit;
end

runTime = toc(tStart);
result = localBuildResult(bestX, bestFit, bestDetail, bestHist, runTime, nEvals, params);
end

function X = localChaoticInit(popSize, dim, lb, ub)
z = rand(popSize, dim);
for k = 1:20
    z = 4 .* z .* (1 - z);
end
X = repmat(lb, popSize, 1) + z .* repmat(ub - lb, popSize, 1);
end

function X = localInjectReference(X, lb, ub, refX, ratio, noiseScale)
refX = refX(:)';
nRef = max(1, round(ratio * size(X, 1)));
nRef = min(nRef, size(X, 1));
sigma = noiseScale * (ub - lb);
for i = 1:nRef
    X(i, :) = localProjectSolution(refX + randn(1, numel(lb)) .* sigma, lb, ub);
end
end

function step = localLevyFlight(dim)
beta = 1.5;
sigma = (gamma(1 + beta) * sin(pi * beta / 2) / ...
    (gamma((1 + beta) / 2) * beta * 2^((beta - 1) / 2)))^(1 / beta);
u = randn(1, dim) * sigma;
v = randn(1, dim);
step = u ./ (abs(v).^(1 / beta));
end

function [fit, detail, nEvals] = localEvaluatePopulation(X, objFun, usePublicProjection, lb, ub)
popSize = size(X, 1);
fit = zeros(popSize, 1);
if usePublicProjection
    X(1, :) = localProjectSolution(X(1, :), lb, ub);
end
[fit(1), detail1] = objFun(X(1, :));
nEvals = 1;
detail = repmat(detail1, popSize, 1);
detail(1) = detail1;
for i = 2:popSize
    xi = X(i, :);
    if usePublicProjection
        xi = localProjectSolution(xi, lb, ub);
    end
    [fit(i), detail(i)] = objFun(xi);
    nEvals = nEvals + 1;
end
end

function [bestX, bestFit, bestDetail, order] = localBestByDeb(X, fit, detail)
order = 1:size(X, 1);
for i = 1:numel(order)-1
    for j = i+1:numel(order)
        if debBetter(fit(order(j)), detail(order(j)), fit(order(i)), detail(order(i)))
            tmp = order(i);
            order(i) = order(j);
            order(j) = tmp;
        end
    end
end
bestX = X(order(1), :);
bestFit = fit(order(1));
bestDetail = detail(order(1));
end

function ids = localRandomIndices(popSize, avoidIdx, count)
pool = setdiff(1:popSize, avoidIdx);
if numel(pool) >= count
    ids = pool(randperm(numel(pool), count));
else
    ids = pool(randi(numel(pool), 1, count));
end
end

function x = localProjectSolution(x, lb, ub)
x = min(max(x, lb), ub);
end

function result = localBuildResult(bestX, bestFit, bestDetail, bestHist, runTime, nEvals, params)
bestCtrl = [];
bestPath = [];
if exist('decodeSolution', 'file') == 2
    try
        bestCtrl = decodeSolution(bestX, params);
    catch
        bestCtrl = [];
    end
end
if ~isempty(bestCtrl) && exist('bsplinePath', 'file') == 2
    try
        bestPath = bsplinePath(bestCtrl, params.degree, params.nSamples);
    catch
        bestPath = [];
    end
end

result = struct();
result.bestFit = bestFit;
result.bestDetail = bestDetail;
result.bestX = bestX;
result.bestCtrl = bestCtrl;
result.bestPath = bestPath;
result.bestHist = bestHist;
result.runTime = runTime;
result.finalFeasible = localGetField(bestDetail, {'isFeasible', 'feasible'}, NaN);
result.finalViolation = localGetField(bestDetail, {'V', 'violation'}, NaN);
result.nEvals = nEvals;
result.bestFitness = bestFit;
result.bestPosition = bestX(:);
result.convergence = bestHist(:);
result.runtime = runTime;
end

function val = localGetField(s, names, defaultVal)
val = defaultVal;
for k = 1:numel(names)
    if isfield(s, names{k})
        val = s.(names{k});
        return;
    end
end
end

function val = localGetCfg(s, name, defaultVal)
if isfield(s, name)
    val = s.(name);
else
    val = defaultVal;
end
end

function val = localGetNestedCfg(s, parent, name, defaultVal)
val = defaultVal;
if isfield(s, parent) && isstruct(s.(parent)) && isfield(s.(parent), name)
    val = s.(parent).(name);
end
end
