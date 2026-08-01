function result = optimizer_CPO_uav(objFun, params, ~, refX, algCfg, runSeed)
%OPTIMIZER_CPO_UAV Crested Porcupine Optimizer baseline for UAV planning.
%
% The implementation keeps the standard CPO idea of cyclic defensive
% behaviors: visual warning, auditory warning, odor diffusion, and physical
% defense. It is adapted only at the interface level to the repository's UAV
% encoding, objective function, boundary projection, and Deb feasibility rule.

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
defenseCycle = localGetCfg(algCfg, 'defenseCycle', 4);

X = localInitPopulation(popSize, dim, lb, ub, refX, ...
    useReferenceInit, referenceInitRatio, referenceNoiseScale);
[fit, detail, nEvals] = localEvaluatePopulation(X, objFun, usePublicProjection, lb, ub);
[bestX, bestFit, bestDetail] = localBestByDeb(X, fit, detail);

bestHist = inf(maxIter, 1);
tStart = tic;

for t = 1:maxIter
    tau = t / max(maxIter, 1);
    contraction = 1 - tau;
    Xmean = mean(X, 1);

    for i = 1:popSize
        xi = X(i, :);
        behavior = mod(t + i - 2, defenseCycle) + 1;

        switch behavior
            case 1
                r = rand(1, dim);
                xnew = xi + contraction .* r .* (2 .* bestX - xi);

            case 2
                ids = localRandomIndices(popSize, i, 3);
                xnew = xi + rand(1, dim) .* (X(ids(1), :) - X(ids(2), :)) ...
                    + contraction .* rand(1, dim) .* (bestX - X(ids(3), :));

            case 3
                ids = localRandomIndices(popSize, i, 1);
                odor = randn(1, dim) .* abs(Xmean - xi);
                xnew = bestX + contraction .* odor + rand(1, dim) .* (X(ids(1), :) - xi);

            otherwise
                levyStep = localLevyFlight(dim);
                xnew = bestX + contraction .* levyStep .* (bestX - xi) ...
                    + 0.05 * randn(1, dim) .* (ub - lb);
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

function [bestX, bestFit, bestDetail] = localBestByDeb(X, fit, detail)
bestX = X(1, :);
bestFit = fit(1);
bestDetail = detail(1);
for i = 2:size(X, 1)
    if debBetter(fit(i), detail(i), bestFit, bestDetail)
        bestX = X(i, :);
        bestFit = fit(i);
        bestDetail = detail(i);
    end
end
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

function step = localLevyFlight(dim)
beta = 1.5;
sigma = (gamma(1 + beta) * sin(pi * beta / 2) / ...
    (gamma((1 + beta) / 2) * beta * 2^((beta - 1) / 2)))^(1 / beta);
u = randn(1, dim) * sigma;
v = randn(1, dim);
step = u ./ (abs(v).^(1 / beta));
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
