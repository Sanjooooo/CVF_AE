function diagTable = summarize_cove_ae_diagnostics(resultDir)
%SUMMARIZE_COVE_AE_DIAGNOSTICS Summarize state/operator traces from run records.

if nargin < 1 || isempty(resultDir)
    resultDir = uigetdir(pwd, 'Select COVE-AE diagnostic result folder');
    if isequal(resultDir, 0)
        error('No result folder selected.');
    end
end

runDir = fullfile(resultDir, 'run_records');
if ~exist(runDir, 'dir')
    error('Cannot find run_records folder: %s', runDir);
end

files = dir(fullfile(runDir, 'scene*_*.mat'));
if isempty(files)
    error('No run record files found in: %s', runDir);
end

diagTable = table();
for k = 1:numel(files)
    fp = fullfile(files(k).folder, files(k).name);
    S = load(fp);
    if ~isfield(S, 'result')
        continue;
    end

    r = S.result;
    row = localBuildRow(r, files(k).name);
    if isempty(diagTable)
        diagTable = row;
    else
        diagTable = [diagTable; row]; %#ok<AGROW>
    end
end

diagTable = sortrows(diagTable, {'Scene', 'Algorithm', 'Run'});
writetable(diagTable, fullfile(resultDir, 'cove_ae_diagnostics.csv'));
end

function row = localBuildRow(r, runFile)
sceneId = localScalarField(r, 'sceneId', NaN);
runId = localScalarField(r, 'runId', NaN);
algorithm = localAlgorithmName(r);

stateCounts = localStateCounts(localField(r, 'stateHistory', {}));
feedbackCounts = localFeedbackCounts(localField(r, 'feedbackHistory', {}));
opCounts = localOperatorCounts(localField(r, 'operatorHistory', []));

feasibleTrace = localField(r, 'feasibleRatioHistory', []);
violationTrace = localField(r, 'meanViolationHistory', []);

row = table( ...
    sceneId, {algorithm}, runId, {runFile}, ...
    localScalarField(r, 'bestFitness', localScalarField(r, 'bestFit', NaN)), ...
    logical(localScalarField(r, 'finalFeasible', false)), ...
    localScalarField(r, 'finalViolation', NaN), ...
    localScalarField(r, 'runtime', localScalarField(r, 'runTime', NaN)), ...
    localScalarField(r, 'nEvals', NaN), ...
    localScalarField(r, 'firstFeasibleIter', NaN), ...
    localScalarField(r, 'firstFeasibleTime', NaN), ...
    localScalarField(r, 'repairCount', NaN), ...
    localScalarField(r, 'repairSuccessCount', NaN), ...
    localScalarField(r, 'feedbackResponseCount', NaN), ...
    localScalarField(r, 'feedbackResponseSuccessCount', NaN), ...
    stateCounts.total, stateCounts.formation, stateCounts.preservation, ...
    stateCounts.refinement, stateCounts.recovery, stateCounts.static, stateCounts.nUnique, ...
    stateCounts.formationFrac, stateCounts.preservationFrac, ...
    stateCounts.refinementFrac, stateCounts.recoveryFrac, stateCounts.staticFrac, ...
    feedbackCounts.obstacleFrac, feedbackCounts.nfzFrac, ...
    feedbackCounts.curvatureFrac, feedbackCounts.altitudeFrac, ...
    feedbackCounts.riskFrac, feedbackCounts.noneFrac, ...
    opCounts.op1, opCounts.op2, opCounts.op3, opCounts.op4, ...
    localLastFinite(feasibleTrace), localLastFinite(violationTrace), ...
    'VariableNames', { ...
    'Scene','Algorithm','Run','RunFile', ...
    'BestFitness','FinalFeasible','FinalViolation','Runtime', ...
    'NEvals','FirstFeasibleIter','FirstFeasibleTime', ...
    'RepairCount','RepairSuccessCount', ...
    'FeedbackResponseCount','FeedbackResponseSuccessCount', ...
    'StateTotal','StateFormation','StatePreservation','StateRefinement', ...
    'StateRecovery','StateStatic','StateUniqueCount', ...
    'StateFormationFrac','StatePreservationFrac','StateRefinementFrac', ...
    'StateRecoveryFrac','StateStaticFrac', ...
    'FeedbackObstacleFrac','FeedbackNFZFrac','FeedbackCurvatureFrac', ...
    'FeedbackAltitudeFrac','FeedbackRiskFrac','FeedbackNoneFrac', ...
    'Operator1Count','Operator2Count','Operator3Count', ...
    'Operator4Count','FinalFeasibleRatioTrace','FinalMeanViolationTrace'} );
end

function value = localField(s, name, defaultValue)
if isstruct(s) && isfield(s, name)
    value = s.(name);
else
    value = defaultValue;
end
end

function value = localScalarField(s, name, defaultValue)
value = defaultValue;
if isstruct(s) && isfield(s, name) && ~isempty(s.(name))
    raw = s.(name);
    if isnumeric(raw) || islogical(raw)
        value = raw(1);
    end
end
end

function algorithm = localAlgorithmName(r)
if isfield(r, 'algorithmName') && ~isempty(r.algorithmName)
    algorithm = char(r.algorithmName);
elseif isfield(r, 'algName') && ~isempty(r.algName)
    algorithm = char(r.algName);
else
    algorithm = '';
end
end

function counts = localStateCounts(stateHistory)
names = {};
if iscell(stateHistory)
    names = stateHistory(:);
elseif isstring(stateHistory)
    names = cellstr(stateHistory(:));
elseif ischar(stateHistory)
    names = {stateHistory};
end

isEmpty = cellfun(@isempty, names);
names = names(~isEmpty);
total = numel(names);

counts = struct();
counts.total = total;
counts.formation = sum(strcmp(names, 'FeasibilityFormation'));
counts.preservation = sum(strcmp(names, 'FeasibilityPreservation'));
counts.refinement = sum(strcmp(names, 'QualityRefinement'));
counts.recovery = sum(strcmp(names, 'StagnationRecovery'));
counts.static = sum(strcmp(names, 'StaticFeasibilityPreservation'));
counts.nUnique = numel(unique(names));

den = max(1, total);
counts.formationFrac = counts.formation / den;
counts.preservationFrac = counts.preservation / den;
counts.refinementFrac = counts.refinement / den;
counts.recoveryFrac = counts.recovery / den;
counts.staticFrac = counts.static / den;
end

function counts = localFeedbackCounts(feedbackHistory)
names = {};
if iscell(feedbackHistory)
    names = feedbackHistory(:);
elseif isstring(feedbackHistory)
    names = cellstr(feedbackHistory(:));
elseif ischar(feedbackHistory)
    names = {feedbackHistory};
end

isEmpty = cellfun(@isempty, names);
names = names(~isEmpty);
total = numel(names);
den = max(1, total);

counts = struct();
counts.obstacleFrac = sum(strcmp(names, 'obstacle')) / den;
counts.nfzFrac = sum(strcmp(names, 'nfz')) / den;
counts.curvatureFrac = sum(strcmp(names, 'curvature')) / den;
counts.altitudeFrac = sum(strcmp(names, 'altitude')) / den;
counts.riskFrac = sum(strcmp(names, 'risk')) / den;
counts.noneFrac = sum(strcmp(names, 'none')) / den;
end

function counts = localOperatorCounts(operatorHistory)
counts = struct('op1', NaN, 'op2', NaN, 'op3', NaN, 'op4', NaN);
if isnumeric(operatorHistory) && ~isempty(operatorHistory)
    sums = sum(operatorHistory, 1, 'omitnan');
    for i = 1:min(4, numel(sums))
        counts.(sprintf('op%d', i)) = sums(i);
    end
end
end

function value = localLastFinite(x)
value = NaN;
if isnumeric(x) && ~isempty(x)
    x = x(:);
    idx = find(isfinite(x), 1, 'last');
    if ~isempty(idx)
        value = x(idx);
    end
end
end
