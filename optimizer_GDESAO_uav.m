function result = optimizer_GDESAO_uav(objFun, params, ~, refX, algCfg, runSeed)
%OPTIMIZER_GDESAO_UAV Paper-based GDSAO optimizer for UAV path planning.
%
% Reimplemented from the GDSAO paper mechanisms: good-point-set
% initialization, adaptive dynamic snowmelt ratio, SAO exploration/
% exploitation, and neighborhood dimensional search.

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

kMin = localGetNestedCfg(algCfg, 'gdesao', 'kMin', 0.5);
kMax = localGetNestedCfg(algCfg, 'gdesao', 'kMax', 2.0);
ddfMin = localGetNestedCfg(algCfg, 'gdesao', 'ddfMin', 0.35);
ddfMax = localGetNestedCfg(algCfg, 'gdesao', 'ddfMax', 0.60);
damping = localGetNestedCfg(algCfg, 'gdesao', 'damping', 1.0);

X = localGoodPointInit(popSize, dim, lb, ub);
if useReferenceInit && ~isempty(refX)
    X = localInjectReference(X, lb, ub, refX, referenceInitRatio, referenceNoiseScale);
end

[fit, detail, nEvals] = localEvaluatePopulation(X, objFun, usePublicProjection, lb, ub);
[bestX, bestFit, bestDetail, ~] = localBestByDeb(X, fit, detail);

bestHist = inf(maxIter, 1);
prevStd = std(fit(isfinite(fit)));
if isempty(prevStd) || prevStd <= 0
    prevStd = 1;
end

tStart = tic;

for t = 1:maxIter
    [~, ~, ~, order] = localBestByDeb(X, fit, detail);
    elite = X(order(1:min(3, popSize)), :);
    leaders = X(order(1:max(1, floor(popSize / 2))), :);
    centroid = mean(leaders, 1);
    Xmean = mean(X, 1);

    currStd = std(fit(isfinite(fit)));
    if isempty(currStd) || currStd <= 0
        currStd = prevStd;
    end
    kTmp = currStd / max(prevStd, eps);
    kDisp = min(max(kTmp, kMin), kMax);
    ddf = ddfMax + (ddfMin - ddfMax) ./ ...
        (1 + exp(-10 * damping * ((2 * t) / (kDisp * maxIter) - 1)));
    melt = ddf * exp(-t / maxIter);
    prevStd = currStd;

    nExplore = max(1, round(popSize * (1 - t / maxIter)));
    Xold = X;

    for i = 1:popSize
        xi = Xold(i, :);
        elitePool = [elite; centroid];
        xElite = elitePool(randi(size(elitePool, 1)), :);

        if i <= nExplore
            r1 = rand;
            brown = randn(1, dim);
            xSao = xElite + brown .* (r1 .* (bestX - xi) + (1 - r1) .* (Xmean - xi));
        else
            r2 = rand;
            brown = randn(1, dim);
            xSao = melt .* bestX + brown .* (r2 .* (bestX - xi) + (1 - r2) .* (Xmean - xi));
        end

        xSao = localProjectSolution(xSao, lb, ub);
        [fSao, dSao] = objFun(xSao);
        nEvals = nEvals + 1;

        xCand = xSao;
        fCand = fSao;
        dCand = dSao;

        if ~ismember(i, order(1:min(3, popSize)))
            xNds = localNeighborhoodDimensionalSearch(i, xi, xSao, Xold);
            xNds = localProjectSolution(xNds, lb, ub);
            [fNds, dNds] = objFun(xNds);
            nEvals = nEvals + 1;

            if debBetter(fNds, dNds, fSao, dSao)
                xCand = xNds;
                fCand = fNds;
                dCand = dNds;
            end
        end

        if debBetter(fCand, dCand, fit(i), detail(i))
            X(i, :) = xCand;
            fit(i) = fCand;
            detail(i) = dCand;
        end

        if debBetter(fit(i), detail(i), bestFit, bestDetail)
            bestX = X(i, :);
            bestFit = fit(i);
            bestDetail = detail(i);
        end
    end

    bestHist(t) = bestFit;
end

runTime = toc(tStart);
result = localBuildResult(bestX, bestFit, bestDetail, bestHist, runTime, nEvals, params);
end

function xNds = localNeighborhoodDimensionalSearch(i, xi, xSao, X)
radius = norm(xSao - xi);
dist = sqrt(sum((X - xi).^2, 2));
near = find(dist <= radius);
far = find(dist > radius);
near(near == i) = [];
far(far == i) = [];

if isempty(near)
    near = setdiff(1:size(X, 1), i);
end
if isempty(far)
    far = setdiff(1:size(X, 1), i);
end

nIdx = near(randi(numel(near)));
rIdx = far(randi(numel(far)));
mask = rand(1, size(X, 2)) < 0.5;
if ~any(mask)
    mask(randi(size(X, 2))) = true;
end

xNds = xSao;
xNds(mask) = xi(mask) + rand(1, sum(mask)) .* (X(nIdx, mask) - X(rIdx, mask));
end

function X = localGoodPointInit(popSize, dim, lb, ub)
p = localSmallestPrime(2 * dim + 3);
r = zeros(1, dim);
for j = 1:dim
    r(j) = mod(2 * cos(2 * pi * j / p), 1);
end
P = zeros(popSize, dim);
for i = 1:popSize
    P(i, :) = mod(r * i, 1);
end
X = repmat(lb, popSize, 1) + P .* repmat(ub - lb, popSize, 1);
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
