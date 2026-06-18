function result = optimizer_CVF_AE_uav(objFun, params, map, refX, algCfg, runSeed)
%OPTIMIZER_CVF_AE_UAV Minimal CVF-AE prototype for UAV path planning.

if nargin >= 6 && ~isempty(runSeed)
    rng(runSeed, 'twister');
end
if nargin < 5 || isempty(algCfg)
    algCfg = struct();
end

params = localDefaultCVFAEParams(params);
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

viabilityFieldCount = 0;
viabilityFieldSuccessCount = 0;
viabilityFieldNormHistory = nan(params.maxIter, 1);
viabilityFieldTypeHistory = cell(params.maxIter, 1);
cvfOperatorHistory = zeros(params.maxIter, params.cvfAe.nOps);

[bestFit, bestX, bestDetail] = localExtractBest(pop, fit, detail);

bestHist = inf(params.maxIter, 1);
stateHistory = cell(params.maxIter, 1);
feasibleRatioHistory = nan(params.maxIter, 1);
meanViolationHistory = nan(params.maxIter, 1);
diversityHistory = nan(params.maxIter, 1);

[firstFeasibleIter, firstFeasibleTime] = localInitialFeasible(detail, tStart);

for t = 1:params.maxIter
    state = identifyConstraintState(pop, fit, detail, bestHist, t, params);
    stateHistory{t} = state.name;
    feasibleRatioHistory(t) = state.feasibleRatio;
    meanViolationHistory(t) = state.meanViolation;
    diversityHistory(t) = state.diversity;

    [~, order] = sort(fit, 'ascend');
    eliteNum = max(2, ceil(params.core.eliteFrac * params.popSize));
    elitePool = pop(order(1:eliteNum), :);
    repairElite = order(1:max(1, round(params.cvfAe.repairEliteFrac * params.popSize)));
    cvfUsedThisIter = 0;
    repairUsedThisIter = 0;
    normSum = 0;
    typeCounts = localEmptyTypeCounts();

    for i = 1:params.popSize
        fold = fit(i);
        dold = detail(i);

        fieldStep = zeros(1, params.dim);
        fieldInfo = localEmptyFieldInfo();
        useCVF = localShouldUseCVF(i, order, detail(i), state, cvfUsedThisIter, params, algCfg);
        if useCVF
            [fieldStep, fieldInfo] = buildConstraintViabilityField(pop(i, :), map, params, detail(i), state);
        end

        [Xae, Xcvf, opInfo] = applyOperator_CVF_AE(i, pop, bestX, refX, elitePool, state, fieldStep, t, params);
        cvfOperatorHistory(t, opInfo.id) = cvfOperatorHistory(t, opInfo.id) + 1;

        [fnew, dnew] = objFun(Xae);
        nEvals = nEvals + 1;
        [firstFeasibleIter, firstFeasibleTime] = localUpdateFirstFeasible(dnew, t, tStart, firstFeasibleIter, firstFeasibleTime);

        if useCVF && fieldInfo.norm > 0
            [fcvf, dcvf] = objFun(Xcvf);
            nEvals = nEvals + 1;
            viabilityFieldCount = viabilityFieldCount + 1;
            cvfUsedThisIter = cvfUsedThisIter + 1;
            normSum = normSum + fieldInfo.norm;
            typeCounts = localAddType(typeCounts, fieldInfo.dominantType);
            [firstFeasibleIter, firstFeasibleTime] = localUpdateFirstFeasible(dcvf, t, tStart, firstFeasibleIter, firstFeasibleTime);

            if localAcceptCVFCandidate(fcvf, dcvf, fnew, dnew)
                fnew = fcvf;
                dnew = dcvf;
                Xae = Xcvf;
                viabilityFieldSuccessCount = viabilityFieldSuccessCount + 1;
            end
        end

        if localShouldSparseRepair(i, repairElite, dnew, state, repairUsedThisIter, t, params, algCfg)
            repParams = params;
            repParams.repair.iter = params.cvfAe.repairIters;
            [Xrep, ~] = repairPath(Xae, map, repParams);
            [frep, drep] = objFun(Xrep);
            nEvals = nEvals + 1;
            repairCount = repairCount + 1;
            repairUsedThisIter = repairUsedThisIter + 1;
            [firstFeasibleIter, firstFeasibleTime] = localUpdateFirstFeasible(drep, t, tStart, firstFeasibleIter, firstFeasibleTime);

            if debBetter(frep, drep, fnew, dnew)
                Xae = Xrep;
                fnew = frep;
                dnew = drep;
                repairSuccessCount = repairSuccessCount + 1;
            end
        end

        if debBetter(fnew, dnew, fold, dold)
            pop(i, :) = Xae;
            fit(i) = fnew;
            detail(i) = dnew;
        end
    end

    if cvfUsedThisIter > 0
        viabilityFieldNormHistory(t) = normSum / cvfUsedThisIter;
        viabilityFieldTypeHistory{t} = localDominantType(typeCounts);
    else
        viabilityFieldNormHistory(t) = 0;
        viabilityFieldTypeHistory{t} = 'none';
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
result.viabilityFieldCount = viabilityFieldCount;
result.viabilityFieldSuccessCount = viabilityFieldSuccessCount;
result.viabilityFieldNormHistory = viabilityFieldNormHistory;
result.viabilityFieldTypeHistory = viabilityFieldTypeHistory;
result.cvfOperatorHistory = cvfOperatorHistory;
result.feasibleRatioHistory = feasibleRatioHistory;
result.meanViolationHistory = meanViolationHistory;
result.diversityHistory = diversityHistory;
result.stateHistory = stateHistory;

result.bestFitness = bestFit;
result.bestPosition = bestX(:);
result.convergence = bestHist(:);
result.runtime = runTime;
end

function params = localDefaultCVFAEParams(params)
if ~isfield(params, 'useHeightTerm'), params.useHeightTerm = true; end
if ~isfield(params, 'useBoundaryTerm'), params.useBoundaryTerm = true; end

params.cvfAe.nOps = 4;
params.cvfAe.maxPerIter = max(1, round(0.12 * params.popSize));
params.cvfAe.eliteFrac = 0.25;
params.cvfAe.maxViolation = 15;
params.cvfAe.nearFeasibleRankFrac = 0.45;
params.cvfAe.refinementEliteFrac = 0.08;
params.cvfAe.repairEliteFrac = 0.30;
params.cvfAe.repairMaxPerIter = max(1, round(0.08 * params.popSize));
params.cvfAe.repairMaxViolation = 25;
params.cvfAe.repairIters = 1;
params.cvfAe.repairStartFrac = 0.15;

params.cove.nOps = 4;
params.cove.init.guidedRatio = 0.70;
params.cove.init.initialRepairQuota = max(1, round(0.15 * params.popSize));
params.cove.init.initialRepairMaxViolation = 30;
params.cove.init.initialRepairIters = 1;
params.cove.state.window = 15;
params.cove.state.improvementTol = 1e-4;
params.cove.state.formationFeasibleRatio = 0.20;
params.cove.state.refinementFeasibleRatio = 0.65;
params.cove.state.highViolation = 10;
params.cove.state.recoveryDiversityMax = 0.08;
end

function params = localApplyAlgorithmConfig(params, algCfg)
if isfield(algCfg, 'popSize'), params.popSize = algCfg.popSize; end
if isfield(algCfg, 'maxIter'), params.maxIter = algCfg.maxIter; end
if isfield(algCfg, 'cvf') && isstruct(algCfg.cvf)
    params.cvf = localMergeStruct(localGetStruct(params, 'cvf'), algCfg.cvf);
end
if isfield(algCfg, 'cvfAe') && isstruct(algCfg.cvfAe)
    params.cvfAe = localMergeStruct(params.cvfAe, algCfg.cvfAe);
end
end

function out = localGetStruct(s, name)
if isstruct(s) && isfield(s, name) && isstruct(s.(name))
    out = s.(name);
else
    out = struct();
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

function tf = localShouldUseCVF(i, order, d, state, usedThisIter, params, algCfg)
tf = false;
if ~localGetFlag(algCfg, 'useCVF', true)
    return;
end
if usedThisIter >= params.cvfAe.maxPerIter
    return;
end
rank = find(order == i, 1, 'first');
if isempty(rank)
    rank = params.popSize;
end
isEliteSide = rank <= max(1, round(params.cvfAe.eliteFrac * params.popSize));
isNearFeasible = isstruct(d) && isfield(d, 'V') && isfinite(d.V) && d.V <= params.cvfAe.maxViolation;
isRankEligible = rank <= max(1, round(params.cvfAe.nearFeasibleRankFrac * params.popSize));
isFeasible = isstruct(d) && isfield(d, 'isFeasible') && d.isFeasible;
isRefinementElite = rank <= max(1, round(params.cvfAe.refinementEliteFrac * params.popSize));

if state.id == 3
    tf = isRefinementElite;
    return;
end
if state.id == 1
    tf = isNearFeasible && (isEliteSide || isRankEligible);
    return;
end
if isFeasible && state.hasFeasible && ~isEliteSide
    return;
end
tf = isNearFeasible && (isEliteSide || isRankEligible || state.id == 4);
end

function tf = localShouldSparseRepair(i, repairElite, dnew, state, repairUsedThisIter, iter, params, algCfg)
tf = false;
if ~localGetFlag(algCfg, 'useSparseRepairReuse', true)
    return;
end
if state.id == 3
    return;
end
if repairUsedThisIter >= params.cvfAe.repairMaxPerIter
    return;
end
if ~any(repairElite == i)
    return;
end
if ~isstruct(dnew) || ~isfield(dnew, 'isFeasible') || dnew.isFeasible
    return;
end
if ~isfield(dnew, 'V') || dnew.V > params.cvfAe.repairMaxViolation
    return;
end
phase = iter / max(1, params.maxIter);
tf = phase >= params.cvfAe.repairStartFrac;
end

function tf = localAcceptCVFCandidate(fcvf, dcvf, fae, dae)
tf = false;
if ~debBetter(fcvf, dcvf, fae, dae)
    return;
end
if ~isfinite(fcvf) || ~isfinite(fae)
    return;
end
tf = fcvf <= fae;
end

function tf = localGetFlag(s, name, defaultValue)
tf = defaultValue;
if isstruct(s) && isfield(s, name)
    tf = logical(s.(name));
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

function info = localEmptyFieldInfo()
info = struct('norm', 0, 'activeControlCount', 0, 'dominantType', 'none');
end

function counts = localEmptyTypeCounts()
counts = struct('obstacle', 0, 'nfz', 0, 'risk', 0, 'altitude', 0, ...
    'curvature', 0, 'boundary', 0, 'none', 0);
end

function counts = localAddType(counts, name)
if isfield(counts, name)
    counts.(name) = counts.(name) + 1;
else
    counts.none = counts.none + 1;
end
end

function name = localDominantType(counts)
f = fieldnames(counts);
vals = zeros(numel(f), 1);
for k = 1:numel(f)
    vals(k) = counts.(f{k});
end
[v, idx] = max(vals);
if v <= 0
    name = 'none';
else
    name = f{idx};
end
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
