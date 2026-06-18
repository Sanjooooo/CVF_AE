function summary = run_cvf_ae_gate_diagnostics(cfg)
%RUN_CVF_AE_GATE_DIAGNOSTICS Small Route B gate for CVF-AE.

if nargin < 1 || isempty(cfg)
    cfg = struct();
end
cfg = localApplyDefaults(cfg);

if ~exist(cfg.resultDir, 'dir')
    mkdir(cfg.resultDir);
end
runDir = fullfile(cfg.resultDir, 'run_records');
if ~exist(runDir, 'dir')
    mkdir(runDir);
end

fprintf('\n============================================================\n');
fprintf('Route B CVF-AE Small Gate Diagnostics\n');
fprintf('Result folder : %s\n', cfg.resultDir);
fprintf('Scenes        : %s\n', mat2str(cfg.sceneIds));
fprintf('Algorithms    : %s\n', strjoin(cfg.algorithms, ', '));
fprintf('Runs          : %d\n', cfg.nRuns);
fprintf('============================================================\n\n');

runRows = table();
allResults = cell(numel(cfg.sceneIds), numel(cfg.algorithms));

for s = 1:numel(cfg.sceneIds)
    sceneId = cfg.sceneIds(s);
    params = defaultParams();
    params.sceneId = sceneId;
    params = localApplyOverrides(params, cfg.paramsOverride);
    params = applyUAVSceneOverrides(params);

    map = createMap(params);
    refCtrl = generateReferencePath(map, params);
    refX = encodeControlPoints(refCtrl);
    objFun = @(x) fitnessFAEAE(x, map, params);

    for a = 1:numel(cfg.algorithms)
        algName = cfg.algorithms{a};
        algCfg = localGateAlgorithmConfig(algName, params);

        fprintf('--- Scene %d | %s ---\n', sceneId, algName);
        runs = struct([]);

        for r = 1:cfg.nRuns
            runSeed = cfg.baseSeed + 10000 * sceneId + 100 * a + r;
            runFile = fullfile(runDir, sprintf('scene%d_%s_run%03d.mat', ...
                sceneId, localSafeName(algName), r));

            if localGetFlag(cfg, 'resumeExisting', false) && exist(runFile, 'file')
                S = load(runFile);
                result = S.result;
            else
                result = localRunAlgorithm(objFun, params, map, refX, algCfg, runSeed);
                result = localNormalizeResult(result, sceneId, algName, r, runSeed);
                save(runFile, 'result');
            end

            result = localNormalizeResult(result, sceneId, algName, r, runSeed);
            if isempty(runs)
                runs = result;
            else
                [runs, result] = localAlignStructArrayAndScalar(runs, result);
                runs(end+1) = result; %#ok<AGROW>
            end

            row = localBuildRunRow(sceneId, algName, r, runSeed, result);
            if isempty(runRows)
                runRows = row;
            else
                runRows = [runRows; row]; %#ok<AGROW>
            end

            fprintf('  run %2d/%2d | best = %.6f | feas = %d | evals = %.0f | cvf = %.0f | time = %.3fs\n', ...
                r, cfg.nRuns, result.bestFitness, logical(result.finalFeasible), ...
                localResultScalar(result, 'nEvals'), localResultScalar(result, 'viabilityFieldCount'), ...
                result.runtime);
        end

        allResults{s, a} = runs;
    end
end

summaryTable = localBuildSummary(runRows, cfg.sceneIds, cfg.algorithms);
avgRankTable = localAverageRank(summaryTable, cfg.algorithms);
decision = localGateDecision(summaryTable, cfg.algorithms);

writetable(runRows, fullfile(cfg.resultDir, 'cvf_ae_gate_runs.csv'));
writetable(summaryTable, fullfile(cfg.resultDir, 'cvf_ae_gate_summary.csv'));
writetable(avgRankTable, fullfile(cfg.resultDir, 'cvf_ae_gate_average_rank.csv'));
localWriteDecision(fullfile(cfg.resultDir, 'CVF_AE_GATE_DECISION.md'), cfg, summaryTable, avgRankTable, decision);

summary = struct();
summary.cfg = cfg;
summary.runTable = runRows;
summary.summaryTable = summaryTable;
summary.avgRankTable = avgRankTable;
summary.decision = decision;
summary.resultDir = cfg.resultDir;
summary.runDir = runDir;
summary.allResults = allResults;

save(fullfile(cfg.resultDir, 'cvf_ae_gate_summary_workspace.mat'), 'summary', 'cfg', '-v7.3');

fprintf('\nSaved CVF-AE gate diagnostics:\n');
fprintf('  %s\n', fullfile(cfg.resultDir, 'cvf_ae_gate_runs.csv'));
fprintf('  %s\n', fullfile(cfg.resultDir, 'cvf_ae_gate_summary.csv'));
fprintf('  %s\n', fullfile(cfg.resultDir, 'cvf_ae_gate_average_rank.csv'));
fprintf('  %s\n', fullfile(cfg.resultDir, 'CVF_AE_GATE_DECISION.md'));
fprintf('\nDecision: %s\n', decision.label);
fprintf('%s\n', decision.reason);
end

function cfg = localApplyDefaults(cfg)
if ~isfield(cfg, 'sceneIds') || isempty(cfg.sceneIds)
    cfg.sceneIds = [2, 4];
end
if ~isfield(cfg, 'algorithms') || isempty(cfg.algorithms)
    cfg.algorithms = {'Base-AE', 'CVF-AE', 'CVF-AE-w/o-CVF', 'CVF-AE-w/o-Init'};
end
if ~isfield(cfg, 'nRuns') || isempty(cfg.nRuns)
    cfg.nRuns = 5;
end
if ~isfield(cfg, 'baseSeed') || isempty(cfg.baseSeed)
    cfg.baseSeed = 20260618;
end
if ~isfield(cfg, 'resultDir') || isempty(cfg.resultDir)
    cfg.resultDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        ['cvf_ae_gate_' datestr(now, 'yyyymmdd_HHMMSS')]);
end
if ~isfield(cfg, 'paramsOverride') || ~isstruct(cfg.paramsOverride)
    cfg.paramsOverride = struct();
end
if ~isfield(cfg.paramsOverride, 'popSize')
    cfg.paramsOverride.popSize = 20;
end
if ~isfield(cfg.paramsOverride, 'maxIter')
    cfg.paramsOverride.maxIter = 80;
end
if ~isfield(cfg, 'resumeExisting')
    cfg.resumeExisting = false;
end
end

function algCfg = localGateAlgorithmConfig(algName, params)
algCfg = struct();
algCfg.name = algName;
algCfg.dim = params.dim;
algCfg.lb = params.lb(:)';
algCfg.ub = params.ub(:)';
algCfg.popSize = params.popSize;
algCfg.maxIter = params.maxIter;
algCfg.useReferenceInit = false;
algCfg.referenceInitRatio = 0.0;
algCfg.referenceNoiseScale = 0.05;
algCfg.usePublicProjection = true;
algCfg.useConstraintStateInit = true;
algCfg.useCVF = true;
algCfg.useSparseRepairReuse = true;
algCfg.runner = 'CVF_AE';

switch upper(strtrim(algName))
    case 'BASE-AE'
        algCfg.runner = 'AE';
        algCfg.useConstraintStateInit = false;
        algCfg.useCVF = false;
        algCfg.useSparseRepairReuse = false;
    case {'CVF-AE', 'CVF_AE'}
        algCfg.runner = 'CVF_AE';
    case {'CVF-AE-W/O-CVF', 'CVF_AE_W/O_CVF'}
        algCfg.runner = 'CVF_AE';
        algCfg.useCVF = false;
    case {'CVF-AE-W/O-INIT', 'CVF_AE_W/O_INIT'}
        algCfg.runner = 'CVF_AE';
        algCfg.useConstraintStateInit = false;
    otherwise
        error('Unknown CVF-AE gate algorithm: %s', algName);
end
end

function result = localRunAlgorithm(objFun, params, map, refX, algCfg, runSeed)
switch upper(algCfg.runner)
    case 'AE'
        result = optimizer_AE_uav(objFun, params, map, refX, algCfg, runSeed);
    case 'CVF_AE'
        result = optimizer_CVF_AE_uav(objFun, params, map, refX, algCfg, runSeed);
    otherwise
        error('Unknown runner: %s', algCfg.runner);
end
end

function params = localApplyOverrides(params, overrides)
f = fieldnames(overrides);
for k = 1:numel(f)
    if isstruct(overrides.(f{k})) && isfield(params, f{k}) && isstruct(params.(f{k}))
        params.(f{k}) = localApplyOverrides(params.(f{k}), overrides.(f{k}));
    else
        params.(f{k}) = overrides.(f{k});
    end
end
end

function result = localNormalizeResult(result, sceneId, algName, runId, runSeed)
if ~isfield(result, 'bestFitness') && isfield(result, 'bestFit')
    result.bestFitness = result.bestFit;
end
if ~isfield(result, 'bestFit') && isfield(result, 'bestFitness')
    result.bestFit = result.bestFitness;
end
if ~isfield(result, 'runtime') && isfield(result, 'runTime')
    result.runtime = result.runTime;
end
if ~isfield(result, 'runTime') && isfield(result, 'runtime')
    result.runTime = result.runtime;
end
if ~isfield(result, 'finalFeasible')
    result.finalFeasible = false;
end
if ~isfield(result, 'finalViolation')
    result.finalViolation = NaN;
end
if ~isfield(result, 'nEvals')
    result.nEvals = NaN;
end
if ~isfield(result, 'firstFeasibleIter')
    result.firstFeasibleIter = NaN;
end
if ~isfield(result, 'firstFeasibleTime')
    result.firstFeasibleTime = NaN;
end
if ~isfield(result, 'repairCount')
    result.repairCount = NaN;
end
if ~isfield(result, 'repairSuccessCount')
    result.repairSuccessCount = NaN;
end
if ~isfield(result, 'viabilityFieldCount')
    result.viabilityFieldCount = 0;
end
if ~isfield(result, 'viabilityFieldSuccessCount')
    result.viabilityFieldSuccessCount = 0;
end
if ~isfield(result, 'viabilityFieldNormHistory')
    result.viabilityFieldNormHistory = [];
end
if ~isfield(result, 'viabilityFieldTypeHistory')
    result.viabilityFieldTypeHistory = {};
end
result.sceneId = sceneId;
result.runId = runId;
result.seed = runSeed;
result.algName = algName;
result.algorithmName = algName;
end

function row = localBuildRunRow(sceneId, algName, runId, runSeed, result)
normTrace = localField(result, 'viabilityFieldNormHistory', []);
typeCounts = localTypeFractions(localField(result, 'viabilityFieldTypeHistory', {}));
row = table( ...
    sceneId, {algName}, runId, runSeed, ...
    result.bestFitness, result.runtime, logical(result.finalFeasible), result.finalViolation, ...
    localResultScalar(result, 'nEvals'), ...
    localResultScalar(result, 'firstFeasibleIter'), ...
    localResultScalar(result, 'firstFeasibleTime'), ...
    localResultScalar(result, 'repairCount'), ...
    localResultScalar(result, 'repairSuccessCount'), ...
    localResultScalar(result, 'viabilityFieldCount'), ...
    localResultScalar(result, 'viabilityFieldSuccessCount'), ...
    mean(normTrace(:), 'omitnan'), ...
    typeCounts.obstacle, typeCounts.nfz, typeCounts.risk, typeCounts.altitude, ...
    typeCounts.curvature, typeCounts.boundary, typeCounts.none, ...
    'VariableNames', {'Scene','Algorithm','Run','Seed','BestFitness','Runtime', ...
    'Feasible','Violation','NEvals','FirstFeasibleIter','FirstFeasibleTime', ...
    'RepairCount','RepairSuccessCount','ViabilityFieldCount', ...
    'ViabilityFieldSuccessCount','MeanViabilityFieldNorm', ...
    'CVFObstacleFrac','CVFNFZFrac','CVFRiskFrac','CVFAltitudeFrac', ...
    'CVFCurvatureFrac','CVFBoundaryFrac','CVFNoneFrac'} );
end

function T = localBuildSummary(runRows, sceneIds, algorithms)
rows = table();
for s = 1:numel(sceneIds)
    sid = sceneIds(s);
    means = nan(1, numel(algorithms));
    for a = 1:numel(algorithms)
        mask = runRows.Scene == sid & strcmpi(runRows.Algorithm, algorithms{a});
        means(a) = mean(runRows.BestFitness(mask), 'omitnan');
    end
    [~, order] = sort(means, 'ascend');
    ranks = nan(1, numel(algorithms));
    ranks(order) = 1:numel(algorithms);

    for a = 1:numel(algorithms)
        alg = algorithms{a};
        mask = runRows.Scene == sid & strcmpi(runRows.Algorithm, alg);
        row = table( ...
            sid, {alg}, sum(mask), ...
            mean(double(runRows.Feasible(mask)), 'omitnan'), ...
            mean(runRows.BestFitness(mask), 'omitnan'), ...
            std(runRows.BestFitness(mask), 'omitnan'), ...
            mean(runRows.Violation(mask), 'omitnan'), ...
            mean(runRows.Runtime(mask), 'omitnan'), ...
            mean(runRows.NEvals(mask), 'omitnan'), ...
            mean(runRows.FirstFeasibleIter(mask), 'omitnan'), ...
            mean(runRows.RepairCount(mask), 'omitnan'), ...
            mean(runRows.RepairSuccessCount(mask), 'omitnan'), ...
            mean(runRows.ViabilityFieldCount(mask), 'omitnan'), ...
            mean(runRows.ViabilityFieldSuccessCount(mask), 'omitnan'), ...
            mean(runRows.MeanViabilityFieldNorm(mask), 'omitnan'), ...
            mean(runRows.CVFObstacleFrac(mask), 'omitnan'), ...
            mean(runRows.CVFNFZFrac(mask), 'omitnan'), ...
            mean(runRows.CVFRiskFrac(mask), 'omitnan'), ...
            mean(runRows.CVFAltitudeFrac(mask), 'omitnan'), ...
            mean(runRows.CVFCurvatureFrac(mask), 'omitnan'), ...
            mean(runRows.CVFBoundaryFrac(mask), 'omitnan'), ...
            ranks(a), ...
            'VariableNames', {'Scene','Algorithm','NumRuns','FeasibleRate', ...
            'MeanBestFitness','StdBestFitness','MeanFinalViolation','MeanRuntime', ...
            'MeanNEvals','MeanFirstFeasibleIter','MeanRepairCount', ...
            'MeanRepairSuccessCount','MeanViabilityFieldCount', ...
            'MeanViabilityFieldSuccessCount','MeanViabilityFieldNorm', ...
            'MeanCVFObstacleFrac','MeanCVFNFZFrac','MeanCVFRiskFrac', ...
            'MeanCVFAltitudeFrac','MeanCVFCurvatureFrac','MeanCVFBoundaryFrac','Rank'} );
        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end
T = rows;
end

function Tavg = localAverageRank(T, algorithms)
avgRanks = nan(numel(algorithms), 1);
for a = 1:numel(algorithms)
    avgRanks(a) = mean(T.Rank(strcmpi(T.Algorithm, algorithms{a})), 'omitnan');
end
Tavg = table(algorithms(:), avgRanks, 'VariableNames', {'Algorithm','AverageRank'});
Tavg = sortrows(Tavg, 'AverageRank', 'ascend');
end

function decision = localGateDecision(T, algorithms)
decision = struct();
decision.enterMediumGate = false;
decision.label = 'Do not enter medium gate';

hasFull = any(strcmpi(algorithms, 'CVF-AE'));
hasNoCVF = any(strcmpi(algorithms, 'CVF-AE-w/o-CVF'));
if ~hasFull || ~hasNoCVF
    decision.reason = 'Required full and w/o-CVF rows are missing.';
    return;
end

sceneIds = unique(T.Scene(:).');
evidence = false;
overheadOK = true;
fullWorseBoth = true;
notes = {};

for s = 1:numel(sceneIds)
    sid = sceneIds(s);
    full = T(T.Scene == sid & strcmpi(T.Algorithm, 'CVF-AE'), :);
    noCvf = T(T.Scene == sid & strcmpi(T.Algorithm, 'CVF-AE-w/o-CVF'), :);
    if isempty(full) || isempty(noCvf)
        continue;
    end
    fitnessBetter = full.MeanBestFitness < noCvf.MeanBestFitness;
    feasBetter = full.FeasibleRate > noCvf.FeasibleRate;
    violBetter = full.MeanFinalViolation < noCvf.MeanFinalViolation;
    firstBetter = localNanBetter(full.MeanFirstFeasibleIter, noCvf.MeanFirstFeasibleIter);
    sceneEvidence = fitnessBetter || feasBetter || violBetter || firstBetter;
    evidence = evidence || sceneEvidence;
    fullWorseBoth = fullWorseBoth && ~sceneEvidence;

    evalRatio = full.MeanNEvals / max(1, noCvf.MeanNEvals);
    runtimeRatio = full.MeanRuntime / max(1e-9, noCvf.MeanRuntime);
    if evalRatio > 1.30 || runtimeRatio > 1.75
        overheadOK = false;
    end
    notes{end+1} = sprintf('Scene %d: evidence=%d, evalRatio=%.3f, runtimeRatio=%.3f', ...
        sid, sceneEvidence, evalRatio, runtimeRatio); %#ok<AGROW>
end

if evidence && overheadOK && ~fullWorseBoth
    decision.enterMediumGate = true;
    decision.label = 'Enter medium gate';
    decision.reason = ['CVF-AE improved at least one gate metric on Scene 2 or 4 ', ...
        'without excessive evaluation/runtime overhead. Do not run medium gate automatically.'];
else
    decision.reason = ['Small gate did not justify medium validation. ', ...
        'Either CVF evidence was absent on both scenes or overhead was too high.'];
end
decision.notes = notes;
end

function tf = localNanBetter(a, b)
if isnan(a) && isnan(b)
    tf = false;
elseif isnan(a)
    tf = false;
elseif isnan(b)
    tf = true;
else
    tf = a < b;
end
end

function localWriteDecision(filePath, cfg, T, avgRank, decision)
fid = fopen(filePath, 'w');
if fid < 0
    warning('Could not write decision file: %s', filePath);
    return;
end
c = onCleanup(@() fclose(fid));
fprintf(fid, '# CVF-AE Small Gate Decision\n\n');
fprintf(fid, '- Scenes: `%s`\n', mat2str(cfg.sceneIds));
fprintf(fid, '- Algorithms: `%s`\n', strjoin(cfg.algorithms, ', '));
fprintf(fid, '- nRuns: `%d`\n', cfg.nRuns);
fprintf(fid, '- popSize: `%d`\n', cfg.paramsOverride.popSize);
fprintf(fid, '- maxIter: `%d`\n', cfg.paramsOverride.maxIter);
fprintf(fid, '- baseSeed: `%d`\n\n', cfg.baseSeed);
fprintf(fid, '## Decision\n\n');
fprintf(fid, '**%s**\n\n%s\n\n', decision.label, decision.reason);
if isfield(decision, 'notes')
    fprintf(fid, '## Gate Notes\n\n');
    for i = 1:numel(decision.notes)
        fprintf(fid, '- %s\n', decision.notes{i});
    end
    fprintf(fid, '\n');
end
fprintf(fid, '## Average Rank\n\n');
localWriteMarkdownTable(fid, avgRank);
fprintf(fid, '\n## Summary\n\n');
localWriteMarkdownTable(fid, T);
end

function localWriteMarkdownTable(fid, T)
vars = T.Properties.VariableNames;
fprintf(fid, '| %s |\n', strjoin(vars, ' | '));
fprintf(fid, '|%s|\n', strjoin(repmat({'---'}, 1, numel(vars)), '|'));
for r = 1:height(T)
    vals = cell(1, numel(vars));
    for c = 1:numel(vars)
        x = T.(vars{c})(r);
        if iscell(x)
            vals{c} = char(x{1});
        elseif isnumeric(x) || islogical(x)
            vals{c} = sprintf('%.6g', x);
        else
            vals{c} = char(string(x));
        end
    end
    fprintf(fid, '| %s |\n', strjoin(vals, ' | '));
end
end

function val = localField(s, name, defaultVal)
if isstruct(s) && isfield(s, name)
    val = s.(name);
else
    val = defaultVal;
end
end

function counts = localTypeFractions(typeHistory)
names = {'obstacle', 'nfz', 'risk', 'altitude', 'curvature', 'boundary', 'none'};
counts = cell2struct(num2cell(zeros(1, numel(names))), names, 2);
if isempty(typeHistory)
    counts.none = 1;
    return;
end
if iscell(typeHistory)
    types = typeHistory(:);
else
    types = cellstr(string(typeHistory(:)));
end
types = types(~cellfun(@isempty, types));
den = max(1, numel(types));
for i = 1:numel(names)
    counts.(names{i}) = sum(strcmp(types, names{i})) / den;
end
end

function safe = localSafeName(name)
safe = upper(name);
safe = strrep(safe, '+', '_');
safe = strrep(safe, '-', '_');
safe = strrep(safe, '/', '_');
safe = strrep(safe, '\', '_');
safe = strrep(safe, ' ', '_');
end

function tf = localGetFlag(s, name, defaultValue)
tf = defaultValue;
if isstruct(s) && isfield(s, name)
    tf = logical(s.(name));
end
end

function v = localResultScalar(result, fieldName)
if isfield(result, fieldName) && ~isempty(result.(fieldName)) && isnumeric(result.(fieldName))
    v = result.(fieldName);
    v = v(1);
else
    v = NaN;
end
end

function [A, b] = localAlignStructArrayAndScalar(A, b)
aFields = fieldnames(A);
bFields = fieldnames(b);
allFields = unique([aFields; bFields]);

for i = 1:numel(allFields)
    fn = allFields{i};
    if ~isfield(A, fn)
        defaultVal = localDefaultValueLike(b.(fn));
        for k = 1:numel(A)
            A(k).(fn) = defaultVal;
        end
    end
end

for i = 1:numel(allFields)
    fn = allFields{i};
    if ~isfield(b, fn)
        b.(fn) = localDefaultValueLike(A(1).(fn));
    end
end

A = orderfields(A, b);
b = orderfields(b, A(1));
end

function v = localDefaultValueLike(example)
if isnumeric(example)
    if isempty(example)
        v = [];
    else
        v = nan(size(example));
    end
elseif islogical(example)
    v = false;
elseif ischar(example)
    v = '';
elseif isstring(example)
    v = "";
elseif iscell(example)
    v = cell(size(example));
elseif isstruct(example)
    v = struct();
else
    v = [];
end
end
