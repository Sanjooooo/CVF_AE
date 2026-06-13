function result = optimizer_COVE_AE_uav(objFun, params, map, refX, algCfg, runSeed)
%OPTIMIZER_COVE_AE_UAV Constraint-state and violation-feedback AE planner.

if nargin >= 6 && ~isempty(runSeed)
    rng(runSeed, 'twister');
end
if nargin < 5 || isempty(algCfg)
    algCfg = struct();
end

params = localDefaultCoveParams(params);
params = localApplyAlgorithmConfig(params, algCfg);

if isempty(refX)
    refCtrl = localStraightReference(params);
    refX = encodeControlPoints(refCtrl);
else
    try
        refCtrl = decodeSolution(refX, params);
    catch
        refCtrl = localStraightReference(params);
        refX = encodeControlPoints(refCtrl);
    end
end

tStart = tic;
[pop, fit, detail, initInfo] = init_COVE_AE(objFun, params, map, refCtrl, algCfg);
nEvals = initInfo.nEvals;
repairCount = initInfo.repairCount;
repairSuccessCount = initInfo.repairSuccessCount;

[bestFit, bestX, bestDetail] = localExtractBest(pop, fit, detail);

bestHist = inf(params.maxIter, 1);
stateHistory = cell(params.maxIter, 1);
feedbackHistory = cell(params.maxIter, 1);
feedbackScoreHistory = nan(params.maxIter, 5);
operatorHistory = zeros(params.maxIter, params.cove.nOps);
feasibleRatioHistory = nan(params.maxIter, 1);
meanViolationHistory = nan(params.maxIter, 1);
diversityHistory = nan(params.maxIter, 1);

[firstFeasibleIter, firstFeasibleTime] = localInitialFeasible(detail, tStart);
memory = struct('repairStep', zeros(1, params.dim), 'repairAlpha', params.cove.repair.memoryAlpha);

for t = 1:params.maxIter
    state = identifyConstraintState(pop, fit, detail, bestHist, t, params);
    feedback = analyzeViolationFeedback(detail, params);

    stateHistory{t} = state.name;
    feedbackHistory{t} = feedback.dominantType;
    feedbackScoreHistory(t, 1:min(5, numel(feedback.scores))) = feedback.scores(1:min(5, numel(feedback.scores)));
    feasibleRatioHistory(t) = state.feasibleRatio;
    meanViolationHistory(t) = state.meanViolation;
    diversityHistory(t) = state.diversity;

    [~, order] = sort(fit, 'ascend');
    eliteNum = max(2, ceil(params.core.eliteFrac * params.popSize));
    elitePool = pop(order(1:eliteNum), :);
    repairElite = order(1:max(1, round(params.cove.repair.eliteFrac * params.popSize)));
    repairUsedThisIter = 0;

    for i = 1:params.popSize
        fold = fit(i);
        dold = detail(i);

        if localGetFlag(algCfg, 'useViolationFeedback', true)
            opFeedback = feedback;
        else
            opFeedback = localEmptyFeedback();
        end

        [Xnew, opInfo] = applyOperator_COVE_AE(i, pop, bestX, refX, elitePool, state, opFeedback, memory, t, params, map);
        operatorHistory(t, opInfo.id) = operatorHistory(t, opInfo.id) + 1;

        [fnew, dnew] = objFun(Xnew);
        nEvals = nEvals + 1;
        [firstFeasibleIter, firstFeasibleTime] = localUpdateFirstFeasible(dnew, t, tStart, firstFeasibleIter, firstFeasibleTime);

        if localShouldSparseRepair(i, repairElite, dnew, state, repairUsedThisIter, t, params, algCfg)
            xBeforeRepair = Xnew;
            repParams = params;
            repParams.repair.iter = params.cove.repair.iters;
            [Xrep, ~] = repairPath(Xnew, map, repParams);
            [frep, drep] = objFun(Xrep);
            nEvals = nEvals + 1;
            repairCount = repairCount + 1;
            repairUsedThisIter = repairUsedThisIter + 1;
            [firstFeasibleIter, firstFeasibleTime] = localUpdateFirstFeasible(drep, t, tStart, firstFeasibleIter, firstFeasibleTime);

            if debBetter(frep, drep, fnew, dnew)
                Xnew = Xrep;
                fnew = frep;
                dnew = drep;
                repairSuccessCount = repairSuccessCount + 1;
                memory = localUpdateRepairMemory(memory, Xnew - xBeforeRepair);
            end
        end

        if debBetter(fnew, dnew, fold, dold)
            pop(i, :) = Xnew;
            fit(i) = fnew;
            detail(i) = dnew;
        end
    end

    [bestFit, bestX, bestDetail] = localExtractBest(pop, fit, detail, bestFit, bestX, bestDetail);
    bestHist(t) = bestFit;
end

runTime = toc(tStart);
bestCtrl = decodeSolution(bestX, params);
bestPath = bsplinePath(bestCtrl, params.degree, params.nSamples);

result = struct();
result.bestFit = bestFit;
result.bestDetail = bestDetail;
result.bestX = bestX;
result.bestCtrl = bestCtrl;
result.bestPath = bestPath;
result.bestHist = bestHist;
result.runTime = runTime;
result.finalFeasible = bestDetail.isFeasible;
result.finalViolation = localGetViolation(bestDetail);
result.nEvals = nEvals;
result.firstFeasibleIter = firstFeasibleIter;
result.firstFeasibleTime = firstFeasibleTime;
result.repairCount = repairCount;
result.repairSuccessCount = repairSuccessCount;
result.feasibleRatioHistory = feasibleRatioHistory;
result.meanViolationHistory = meanViolationHistory;
result.diversityHistory = diversityHistory;
result.stateHistory = stateHistory;
result.feedbackHistory = feedbackHistory;
result.feedbackScoreHistory = feedbackScoreHistory;
result.operatorHistory = operatorHistory;

result.bestFitness = bestFit;
result.bestPosition = bestX(:);
result.convergence = bestHist(:);
result.runtime = runTime;
end

function params = localDefaultCoveParams(params)
if ~isfield(params, 'useHeightTerm'), params.useHeightTerm = true; end
if ~isfield(params, 'useBoundaryTerm'), params.useBoundaryTerm = true; end

params.cove.nOps = 4;
params.cove.init.guidedRatio = 0.70;
params.cove.init.initialRepairQuota = max(1, round(0.20 * params.popSize));
params.cove.init.initialRepairMaxViolation = 30;
params.cove.init.initialRepairIters = 1;

params.cove.state.window = 15;
params.cove.state.improvementTol = 1e-4;
params.cove.state.formationFeasibleRatio = 0.20;
params.cove.state.refinementFeasibleRatio = 0.65;
params.cove.state.highViolation = 10;
params.cove.state.recoveryDiversityMax = 0.08;

params.cove.repair.eliteFrac = 0.35;
params.cove.repair.maxPerIter = max(1, round(0.12 * params.popSize));
params.cove.repair.maxViolation = 25;
params.cove.repair.iters = 1;
params.cove.repair.startFrac = 0.15;
params.cove.repair.memoryAlpha = 0.25;

params.cove.feedback.strength = 0.70;
params.cove.feedback.avoidanceSamples = 64;
params.cove.feedback.avoidanceMaxHits = 10;
params.cove.feedback.avoidanceLimit = 0.07;
params.cove.feedback.riskActivation = 0.24;
params.cove.feedback.riskStepScale = 2.20;
params.cove.feedback.smoothGamma = 0.32;
params.cove.feedback.altitudeGain = 0.35;
end

function params = localApplyAlgorithmConfig(params, algCfg)
if isfield(algCfg, 'popSize'), params.popSize = algCfg.popSize; end
if isfield(algCfg, 'maxIter'), params.maxIter = algCfg.maxIter; end
if isfield(algCfg, 'cove') && isstruct(algCfg.cove)
    params.cove = localMergeStruct(params.cove, algCfg.cove);
end
end

function out = localMergeStruct(a, b)
out = a;
f = fieldnames(b);
for k = 1:numel(f)
    if isstruct(b.(f{k})) && isfield(out, f{k}) && isstruct(out.(f{k}))
        out.(f{k}) = localMergeStruct(out.(f{k}), b.(f{k}));
    else
        out.(f{k}) = b.(f{k});
    end
end
end

function [bestFit, bestX, bestDetail] = localExtractBest(pop, fit, detail, bestFit, bestX, bestDetail)
if nargin < 4
    bestFit = fit(1);
    bestX = pop(1, :);
    bestDetail = detail(1);
    startIdx = 2;
else
    startIdx = 1;
end

for i = startIdx:size(pop, 1)
    if debBetter(fit(i), detail(i), bestFit, bestDetail)
        bestFit = fit(i);
        bestX = pop(i, :);
        bestDetail = detail(i);
    end
end
end

function tf = localGetFlag(s, name, defaultValue)
tf = defaultValue;
if isstruct(s) && isfield(s, name)
    tf = logical(s.(name));
end
end

function feedback = localEmptyFeedback()
feedback = struct();
feedback.names = {'obstacle', 'nfz', 'curvature', 'altitude', 'risk'};
feedback.scores = zeros(1, 5);
feedback.weights = ones(1, 5) / 5;
feedback.dominantType = 'none';
feedback.meanViolation = 0;
feedback.totalViolation = 0;
end

function tf = localShouldSparseRepair(i, repairElite, dnew, state, repairUsedThisIter, iter, params, algCfg)
tf = false;
if ~localGetFlag(algCfg, 'useSparseRepairReuse', true)
    return;
end
if state.id == 3
    return;
end
if repairUsedThisIter >= params.cove.repair.maxPerIter
    return;
end
if ~any(repairElite == i)
    return;
end
if ~isstruct(dnew) || ~isfield(dnew, 'isFeasible') || dnew.isFeasible
    return;
end
if ~isfield(dnew, 'V') || dnew.V > params.cove.repair.maxViolation
    return;
end
if (state.id ~= 1) && ((state.id ~= 2) || (rand > 0.70))
    return;
end
phase = iter / max(1, params.maxIter);
tf = phase >= params.cove.repair.startFrac;
end

function memory = localUpdateRepairMemory(memory, step)
if isempty(step) || any(~isfinite(step))
    return;
end
alpha = memory.repairAlpha;
memory.repairStep = (1 - alpha) * memory.repairStep + alpha * step;
end

function [iter, tFeas] = localInitialFeasible(detail, tStart)
iter = NaN;
tFeas = NaN;
for i = 1:numel(detail)
    if isfield(detail(i), 'isFeasible') && detail(i).isFeasible
        iter = 0;
        tFeas = toc(tStart);
        return;
    end
end
end

function [firstIter, firstTime] = localUpdateFirstFeasible(d, iter, tStart, firstIter, firstTime)
if isnan(firstIter) && isstruct(d) && isfield(d, 'isFeasible') && d.isFeasible
    firstIter = iter;
    firstTime = toc(tStart);
end
end

function v = localGetViolation(d)
v = inf;
if isstruct(d) && isfield(d, 'V') && ~isempty(d.V)
    v = d.V;
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
