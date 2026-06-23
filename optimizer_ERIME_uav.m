function result = optimizer_ERIME_uav(objFun, params, ~, refX, algCfg, runSeed)
%OPTIMIZER_ERIME_UAV Paper-based enhanced RIME optimizer for UAV planning.
%
% Reimplemented from enhanced RIME mechanisms: elite reverse learning,
% hard-rime puncture, soft-rime search, and greedy Deb selection.

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

reverseProb = localGetNestedCfg(algCfg, 'erime', 'reverseProb', 0.5);
softScale = localGetNestedCfg(algCfg, 'erime', 'softScale', 5.0);

X = localInitPopulation(popSize, dim, lb, ub, refX, ...
    useReferenceInit, referenceInitRatio, referenceNoiseScale);
[fit, detail, nEvals] = localEvaluatePopulation(X, objFun, usePublicProjection, lb, ub);
[bestX, bestFit, bestDetail, ~] = localBestByDeb(X, fit, detail);

bestHist = inf(maxIter, 1);
tStart = tic;

for t = 1:maxIter
    [bestX, ~, ~, order] = localBestByDeb(X, fit, detail);

    if rand < reverseProb
        eliteCount = min(3, popSize);
        for e = 1:eliteCount
            idx = order(e);
            k = rand;
            xRev = k .* (lb + ub) - X(idx, :);
            xRev = localProjectSolution(xRev, lb, ub);
            [fRev, dRev] = objFun(xRev);
            nEvals = nEvals + 1;

            if debBetter(fRev, dRev, fit(idx), detail(idx))
                X(idx, :) = xRev;
                fit(idx) = fRev;
                detail(idx) = dRev;
            end
        end
        [bestX, ~, ~, ~] = localBestByDeb(X, fit, detail);
    end

    normScore = localDebScores(fit, detail);
    eFactor = (t / maxIter) * sin(pi * t / maxIter);

    for i = 1:popSize
        xi = X(i, :);
        xnew = xi;

        % Soft-rime search around the current best.
        for j = 1:dim
            if rand < eFactor
                range = (ub(j) - lb(j));
                xnew(j) = bestX(j) + softScale * randn * range * (1 - t / maxIter);
            end
        end

        % Hard-rime puncture: dimensions are copied from the best according
        % to the normalized fitness score.
        for j = 1:dim
            if rand < normScore(i)
                xnew(j) = bestX(j);
            end
        end

        if isequal(xnew, xi)
            ids = localRandomIndices(popSize, i, 2);
            xnew = xi + rand(1, dim) .* (X(ids(1), :) - X(ids(2), :));
        end

        if usePublicProjection
            xnew = localProjectSolution(xnew, lb, ub);
        end

        [fnew, dnew] = objFun(xnew);
        nEvals = nEvals + 1;

        if debBetter(fnew, dnew, fit(i), detail(i))
            X(i, :) = xnew;
            fit(i) = fnew;
            detail(i) = dnew;
        end
    end

    [bestX, bestFit, bestDetail] = localBestByDeb(X, fit, detail);
    bestHist(t) = bestFit;
end

runTime = toc(tStart);
result = localBuildResult(bestX, bestFit, bestDetail, bestHist, runTime, nEvals, params);
end

function score = localDebScores(fit, detail)
n = numel(fit);
rank = 1:n;
for i = 1:n-1
    for j = i+1:n
        if debBetter(fit(rank(j)), detail(rank(j)), fit(rank(i)), detail(rank(i)))
            tmp = rank(i);
            rank(i) = rank(j);
            rank(j) = tmp;
        end
    end
end
score = zeros(n, 1);
for r = 1:n
    score(rank(r)) = 1 - (r - 1) / max(n - 1, 1);
end
score = max(0.05, score);
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

function X = localInitPopulation(popSize, dim, lb, ub, refX, useReferenceInit, referenceInitRatio, referenceNoiseScale)
X = repmat(lb, popSize, 1) + rand(popSize, dim) .* repmat((ub - lb), popSize, 1);
if useReferenceInit && ~isempty(refX)
    refX = refX(:)';
    nRef = max(1, round(referenceInitRatio * popSize));
    nRef = min(nRef, popSize);
    sigma = referenceNoiseScale * (ub - lb);
    for i = 1:nRef
        X(i, :) = localProjectSolution(refX + randn(1, dim) .* sigma, lb, ub);
    end
end
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
