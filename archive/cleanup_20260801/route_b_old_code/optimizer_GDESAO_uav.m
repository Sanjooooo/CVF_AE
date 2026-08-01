function result = optimizer_GDESAO_uav(objFun, params, ~, refX, algCfg, runSeed)
%OPTIMIZER_GDESAO_UAV Source-aligned GDSAO optimizer for UAV path planning.
%
% Adapted from the authors' GDSAO.m and initialization_GPSAO.m source code
% to this repository's UAV encoding, objective adapter, bounds, and Deb
% feasibility ordering. The implementation keeps the official GPSAO
% initialization, elite pool, dynamic DDF, SAO update, and NDS update.

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

ddfBase = localGetNestedCfg(algCfg, 'gdesao', 'ddfBase', 0.35);
ddfRange = localGetNestedCfg(algCfg, 'gdesao', 'ddfRange', 0.25);
ddfSlope = localGetNestedCfg(algCfg, 'gdesao', 'ddfSlope', 0.6);

X = localGoodPointInit(popSize, dim, lb, ub);
if useReferenceInit && ~isempty(refX)
    X = localInjectReference(X, lb, ub, refX, referenceInitRatio, referenceNoiseScale);
end

[fit, detail, nEvals] = localEvaluatePopulation(X, objFun, usePublicProjection, lb, ub);
[bestX, bestFit, bestDetail, order] = localBestByDeb(X, fit, detail);
elitePool = localElitePool(X, order);

bestHist = inf(maxIter, 1);
bestHist(1) = bestFit;

prevStd = localSafeStd(fit);
ddf = ddfBase;
na = floor(popSize * 0.5);
nb = popSize - na;

tStart = tic;

for t = 2:maxIter
    rb = randn(popSize, dim);
    temp = exp(-t / maxIter);
    melt = ddf * temp;
    centroid = mean(X, 1);

    index = 1:popSize;
    index1 = randperm(popSize, na);
    index2 = setdiff(index, index1);

    XSao = X;
    fitSao = fit;
    detailSao = detail;

    for k = 1:numel(index1)
        idx = index1(k);
        r1 = rand;
        eliteIdx = randi(size(elitePool, 1));
        xnew = elitePool(eliteIdx, :) + rb(idx, :) .* ...
            (r1 .* (bestX - X(idx, :)) + (1 - r1) .* (centroid - X(idx, :)));
        xnew = localProjectSolution(xnew, lb, ub);
        [fitSao(idx), detailSao(idx)] = objFun(xnew);
        nEvals = nEvals + 1;
        XSao(idx, :) = xnew;
    end

    if na < popSize
        na = na + 1;
        nb = max(0, nb - 1);
    end

    for k = 1:min(nb, numel(index2))
        idx = index2(k);
        r2 = 2 * rand - 1;
        xnew = melt .* bestX + rb(idx, :) .* ...
            (r2 .* (bestX - X(idx, :)) + (1 - r2) .* (centroid - X(idx, :)));
        xnew = localProjectSolution(xnew, lb, ub);
        [fitSao(idx), detailSao(idx)] = objFun(xnew);
        nEvals = nEvals + 1;
        XSao(idx, :) = xnew;
    end

    Xnds = XSao;
    fitNds = fitSao;
    detailNds = detailSao;
    distX = localPairwiseDistance(XSao);
    r1perm = randperm(popSize, popSize);

    for row = 1:popSize
        radius = norm(XSao(row, :) - Xnds(row, :));
        neighbors = find(distX(row, :) <= radius + eps);
        if isempty(neighbors)
            neighbors = row;
        end

        xnew = XSao(row, :);
        randNeighbor = neighbors(randi(numel(neighbors), 1, dim));
        for d = 1:dim
            xnew(d) = XSao(row, d) + rand .* ...
                (XSao(randNeighbor(d), d) - XSao(r1perm(row), d));
        end
        xnew = localProjectSolution(xnew, lb, ub);
        [fitNds(row), detailNds(row)] = objFun(xnew);
        nEvals = nEvals + 1;
        Xnds(row, :) = xnew;
    end

    for i = 1:popSize
        if debBetter(fitNds(i), detailNds(i), fitSao(i), detailSao(i))
            X(i, :) = Xnds(i, :);
            fit(i) = fitNds(i);
            detail(i) = detailNds(i);
        else
            X(i, :) = XSao(i, :);
            fit(i) = fitSao(i);
            detail(i) = detailSao(i);
        end

        if debBetter(fit(i), detail(i), bestFit, bestDetail)
            bestX = X(i, :);
            bestFit = fit(i);
            bestDetail = detail(i);
        end
    end

    [~, ~, ~, order] = localBestByDeb(X, fit, detail);
    elitePool = localElitePool(X, order);
    bestHist(t) = bestFit;

    currStd = localSafeStd(fit);
    sigma = currStd / max(prevStd, eps);
    sigma = min(max(sigma, 0.5), 2.0);
    ddf = ddfBase + ddfRange / ...
        (1 + exp(-10 * ddfSlope * ((2 * t) / (maxIter * sigma) - 1)));
    prevStd = currStd;
end

runTime = toc(tStart);
result = localBuildResult(bestX, bestFit, bestDetail, bestHist, runTime, nEvals, params);
end

function pool = localElitePool(X, order)
topCount = min(3, numel(order));
pool = X(order(1:topCount), :);
if topCount < 3
    pool(end+1:3, :) = repmat(pool(end, :), 3 - topCount, 1);
end
nHalf = max(1, floor(size(X, 1) * 0.5));
halfBestMean = mean(X(order(1:nHalf), :), 1);
pool(4, :) = halfBestMean;
end

function s = localSafeStd(fit)
finiteFit = fit(isfinite(fit));
if isempty(finiteFit)
    s = 1;
else
    s = std(finiteFit(:));
    if s <= 0 || ~isfinite(s)
        s = 1;
    end
end
end

function D = localPairwiseDistance(X)
n = size(X, 1);
D = zeros(n, n);
for i = 1:n
    diffs = X - X(i, :);
    D(i, :) = sqrt(sum(diffs .^ 2, 2))';
end
end

function X = localGoodPointInit(popSize, dim, lb, ub)
p = localSmallestPrime(2 * dim + 3);
X = zeros(popSize, dim);
for i = 1:popSize
    for j = 1:dim
        r = mod(2 * cos(2 * pi * j / p) * i, 1);
        X(i, j) = lb(j) + r * (ub(j) - lb(j));
    end
end
end

function p = localSmallestPrime(n)
p = max(3, n);
while ~isprime(p)
    p = p + 1;
end
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
