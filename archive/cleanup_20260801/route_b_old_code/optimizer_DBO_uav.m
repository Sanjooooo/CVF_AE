function result = optimizer_DBO_uav(objFun, params, ~, refX, algCfg, runSeed)
%OPTIMIZER_DBO_UAV Dung Beetle Optimizer baseline for UAV path planning.
%
% This implementation follows the canonical DBO population roles:
% rolling/dancing beetles, brood balls, small beetles, and thieves. It uses
% the same UAV spline encoding, objective function, boundary projection, and
% Deb feasibility rule as the other baselines.

if nargin >= 6 && ~isempty(runSeed)
    rng(runSeed, 'twister');
end

dim = algCfg.dim;
lb = algCfg.lb(:)';
ub = algCfg.ub(:)';
popSize = algCfg.popSize;
maxIter = algCfg.maxIter;

k = localGetCfg(algCfg, 'k', 0.10);
b = localGetCfg(algCfg, 'b', 0.30);
s = localGetCfg(algCfg, 's', 0.50);
useReferenceInit = localGetCfg(algCfg, 'useReferenceInit', false);
referenceInitRatio = localGetCfg(algCfg, 'referenceInitRatio', 0.0);
referenceNoiseScale = localGetCfg(algCfg, 'referenceNoiseScale', 0.05);
usePublicProjection = localGetCfg(algCfg, 'usePublicProjection', true);

X = localInitPopulation(popSize, dim, lb, ub, refX, ...
    useReferenceInit, referenceInitRatio, referenceNoiseScale);
Xprev = X;

[fit, detail, nEvals] = localEvaluatePopulation(X, objFun, usePublicProjection, lb, ub);
[bestX, bestFit, bestDetail] = localBestByDeb(X, fit, detail);
[worstX, ~, ~] = localWorstByDeb(X, fit, detail);

bestHist = inf(maxIter, 1);
tStart = tic;

nRoll = max(1, round(0.20 * popSize));
nBrood = max(nRoll + 1, round(0.40 * popSize));
nSmall = max(nBrood + 1, round(0.75 * popSize));

for t = 1:maxIter
    R = 1 - t / max(maxIter, 1);
    Xold = X;

    for i = 1:popSize
        xi = X(i, :);

        if i <= nRoll
            if rand < 0.9
                alpha = 1;
                if rand < 0.5
                    alpha = -1;
                end
                xnew = xi + alpha * k * Xprev(i, :) + b * abs(xi - worstX);
            else
                theta = randi([1, 179]);
                while theta == 90
                    theta = randi([1, 179]);
                end
                xnew = xi + tan(theta * pi / 180) .* abs(xi - Xprev(i, :));
            end
        elseif i <= nBrood
            localLb = max(lb, bestX .* (1 - R));
            localUb = min(ub, bestX .* (1 + R));
            xnew = bestX + rand(1, dim) .* (xi - localLb) + rand(1, dim) .* (xi - localUb);
        elseif i <= nSmall
            localLb = max(lb, bestX .* (1 - R));
            localUb = min(ub, bestX .* (1 + R));
            xnew = xi + randn(1, dim) .* (xi - localLb) + rand(1, dim) .* (xi - localUb);
        else
            xnew = bestX + s * randn(1, dim) .* (abs(xi - bestX) + abs(xi - worstX));
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

    Xprev = Xold;
    [worstX, ~, ~] = localWorstByDeb(X, fit, detail);
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

function [worstX, worstFit, worstDetail] = localWorstByDeb(X, fit, detail)
worstX = X(1, :);
worstFit = fit(1);
worstDetail = detail(1);
for i = 2:size(X, 1)
    if debBetter(worstFit, worstDetail, fit(i), detail(i))
        worstX = X(i, :);
        worstFit = fit(i);
        worstDetail = detail(i);
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
