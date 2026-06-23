function summary = run_cvf_ae_param_sensitivity(modeOrCfg)
%RUN_CVF_AE_PARAM_SENSITIVITY Route B conservative CVF-AE parameter sensitivity.
%
% Usage:
%   run_cvf_ae_param_sensitivity()
%   run_cvf_ae_param_sensitivity('formal')
%   run_cvf_ae_param_sensitivity('resume-latest')
%   run_cvf_ae_param_sensitivity(cfg)

if nargin < 1 || isempty(modeOrCfg)
    modeOrCfg = 'formal';
end

if ischar(modeOrCfg) || isstring(modeOrCfg)
    cfg = localBuildConfig(char(modeOrCfg));
elseif isstruct(modeOrCfg)
    cfg = localApplyDefaults(modeOrCfg);
else
    error('modeOrCfg must be a mode string or a config struct.');
end

if ~exist(cfg.resultDir, 'dir')
    mkdir(cfg.resultDir);
end
runDir = fullfile(cfg.resultDir, 'run_records');
if ~exist(runDir, 'dir')
    mkdir(runDir);
end

specs = localBuildSpecs();

fprintf('\n============================================================\n');
fprintf('Route B CVF-AE Parameter Sensitivity\n');
fprintf('Result folder : %s\n', cfg.resultDir);
fprintf('Scenes        : %s\n', mat2str(cfg.sceneIds));
fprintf('Runs/value    : %d\n', cfg.nRuns);
fprintf('popSize/maxIt : %d / %d\n', cfg.paramsOverride.popSize, cfg.paramsOverride.maxIter);
fprintf('Resume        : %d\n', logical(cfg.resumeExisting));
fprintf('============================================================\n\n');

runRows = table();
allResults = cell(numel(specs), 1);

for p = 1:numel(specs)
    spec = specs(p);
    fprintf('\n================ Parameter group: %s ================\n', spec.key);
    groupResults = cell(numel(spec.levels), numel(cfg.sceneIds));

    for v = 1:numel(spec.levels)
        level = spec.levels(v);
        fprintf('--- Level: %s (%s) ---\n', level.name, level.label);

        for s = 1:numel(cfg.sceneIds)
            sceneId = cfg.sceneIds(s);
            [params, map, refX, objFun] = localBuildProblem(sceneId, cfg);
            algCfg = getUAVAlgorithmConfig('CVF-AE', params, cfg);
            algCfg = localApplyLevel(algCfg, spec.key, level);

            runs = struct([]);
            for r = 1:cfg.nRuns
                runSeed = cfg.baseSeed + 100000 * p + 10000 * sceneId + 100 * v + r;
                runFile = fullfile(runDir, sprintf('%s_%s_scene%d_run%03d.mat', ...
                    localSafeName(spec.key), localSafeName(level.name), sceneId, r));

                loadedExisting = false;
                if cfg.resumeExisting && exist(runFile, 'file') == 2
                    S = load(runFile);
                    if isfield(S, 'result')
                        result = S.result;
                        loadedExisting = true;
                    end
                end

                if ~loadedExisting
                    result = optimizer_CVF_AE_uav(objFun, params, map, refX, algCfg, runSeed);
                    result = localNormalizeResult(result, sceneId, spec.key, level.name, r, runSeed);
                    save(runFile, 'result', 'spec', 'level', 'sceneId', 'runSeed');
                end

                result = localNormalizeResult(result, sceneId, spec.key, level.name, r, runSeed);
                if isempty(runs)
                    runs = result;
                else
                    [runs, result] = localAlignStructArrayAndScalar(runs, result);
                    runs(end+1) = result; %#ok<AGROW>
                end

                row = localBuildRunRow(spec, level, sceneId, r, runSeed, result);
                if isempty(runRows)
                    runRows = row;
                else
                    runRows = [runRows; row]; %#ok<AGROW>
                end

                if loadedExisting
                    statusText = 'loaded';
                else
                    statusText = 'run';
                end
                fprintf('  %s | scene %d | run %2d/%2d | best %.6f | feas %d | evals %.0f | cvf %.0f | time %.3fs\n', ...
                    statusText, sceneId, r, cfg.nRuns, result.bestFitness, ...
                    logical(result.finalFeasible), localResultScalar(result, 'nEvals'), ...
                    localResultScalar(result, 'viabilityFieldCount'), result.runtime);
            end
            groupResults{v, s} = runs;
        end
    end
    allResults{p} = groupResults;
end

summaryTable = localBuildSummary(runRows);
rankTable = localBuildRankSummary(summaryTable);
interpretation = localWriteInterpretation(cfg, specs, summaryTable, rankTable);

writetable(runRows, fullfile(cfg.resultDir, 'cvf_ae_param_sensitivity_runs.csv'));
writetable(summaryTable, fullfile(cfg.resultDir, 'cvf_ae_param_sensitivity_summary.csv'));
writetable(rankTable, fullfile(cfg.resultDir, 'cvf_ae_param_sensitivity_rank_summary.csv'));

summary = struct();
summary.cfg = cfg;
summary.specs = specs;
summary.runTable = runRows;
summary.summaryTable = summaryTable;
summary.rankTable = rankTable;
summary.interpretation = interpretation;
summary.resultDir = cfg.resultDir;
summary.runDir = runDir;
summary.allResults = allResults;

save(fullfile(cfg.resultDir, 'cvf_ae_param_sensitivity_workspace.mat'), 'summary', 'cfg', '-v7.3');

fprintf('\nSaved CVF-AE parameter sensitivity outputs:\n');
fprintf('  %s\n', fullfile(cfg.resultDir, 'cvf_ae_param_sensitivity_runs.csv'));
fprintf('  %s\n', fullfile(cfg.resultDir, 'cvf_ae_param_sensitivity_summary.csv'));
fprintf('  %s\n', fullfile(cfg.resultDir, 'cvf_ae_param_sensitivity_rank_summary.csv'));
fprintf('  %s\n', fullfile(cfg.resultDir, 'CVF_AE_PARAM_SENSITIVITY_INTERPRETATION.md'));
end

function cfg = localBuildConfig(mode)
mode = lower(strtrim(mode));
switch mode
    case 'formal'
        cfg = localApplyDefaults(struct());
    case {'resume-latest', 'resume_latest', 'resume-formal', 'resume_formal'}
        cfg = localApplyDefaults(struct());
        cfg.resultDir = localFindLatestResultDir('cvf_ae_param_sensitivity_conservative_');
        cfg.resumeExisting = true;
    otherwise
        error('Unknown CVF-AE parameter sensitivity mode: %s', mode);
end
end

function cfg = localApplyDefaults(cfg)
if ~isfield(cfg, 'sceneIds') || isempty(cfg.sceneIds)
    cfg.sceneIds = [2, 4];
end
if ~isfield(cfg, 'nRuns') || isempty(cfg.nRuns)
    cfg.nRuns = 10;
end
if ~isfield(cfg, 'baseSeed') || isempty(cfg.baseSeed)
    cfg.baseSeed = 20260631;
end
if ~isfield(cfg, 'paramsOverride') || ~isstruct(cfg.paramsOverride)
    cfg.paramsOverride = struct();
end
if ~isfield(cfg.paramsOverride, 'popSize')
    cfg.paramsOverride.popSize = 30;
end
if ~isfield(cfg.paramsOverride, 'maxIter')
    cfg.paramsOverride.maxIter = 300;
end
if ~isfield(cfg, 'resumeExisting')
    cfg.resumeExisting = true;
end
if ~isfield(cfg, 'useFairReferenceInit')
    cfg.useFairReferenceInit = false;
end
if ~isfield(cfg, 'resultDir') || isempty(cfg.resultDir)
    cfg.resultDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        ['cvf_ae_param_sensitivity_conservative_' datestr(now, 'yyyymmdd_HHMMSS')]);
end
end

function specs = localBuildSpecs()
specs = struct([]);

specs(1).key = 'quota_scale';
specs(1).label = 'CVF candidate quota scale';
specs(1).levels = localLevels({'low','default','high'}, ...
    {'0.67x CVF sparse trigger quota','default CVF sparse trigger quota','1.33x CVF sparse trigger quota'}, ...
    {0.67, 1.00, 1.33});

specs(2).key = 'step_strength';
specs(2).label = 'CVF step strength';
specs(2).levels = localLevels({'weak','default','strong'}, ...
    {'0.75x CVF field strength','default CVF field strength','1.25x CVF field strength'}, ...
    {0.75, 1.00, 1.25});

specs(3).key = 'state_switch_threshold';
specs(3).label = 'Conservative state switching threshold';
specs(3).levels = localLevels({'strict','default','loose'}, ...
    {'stricter evidence before formation/recovery switch','default conservative switching threshold','looser evidence before formation/recovery switch'}, ...
    {[], [], []});
end

function levels = localLevels(names, labels, values)
levels = struct([]);
for i = 1:numel(names)
    levels(i).name = names{i}; %#ok<AGROW>
    levels(i).label = labels{i};
    levels(i).value = values{i};
end
end

function [params, map, refX, objFun] = localBuildProblem(sceneId, cfg)
params = defaultParams();
params.sceneId = sceneId;
params = localApplyOverrides(params, cfg.paramsOverride);
params = applyUAVSceneOverrides(params);
map = createMap(params);
refCtrl = generateReferencePath(map, params);
refX = encodeControlPoints(refCtrl);
objFun = @(x) fitnessFAEAE(x, map, params);
end

function algCfg = localApplyLevel(algCfg, key, level)
switch key
    case 'quota_scale'
        scale = level.value;
        popSize = algCfg.popSize;
        baseQuota = struct();
        baseQuota.maxPerIter = max(1, round(0.12 * popSize));
        baseQuota.maxPerIterFormation = max(1, round(0.06 * popSize));
        baseQuota.maxPerIterPreservation = max(1, round(0.06 * popSize));
        baseQuota.maxPerIterRefinement = max(1, round(0.01 * popSize));
        baseQuota.maxPerIterRecovery = max(1, round(0.04 * popSize));
        baseQuota.postFeasibleMaxPerIter = max(1, round(0.03 * popSize));
        fields = fieldnames(baseQuota);
        for i = 1:numel(fields)
            f = fields{i};
            algCfg.cvfAe.(f) = max(1, round(scale * baseQuota.(f)));
        end

    case 'step_strength'
        scale = level.value;
        algCfg.cvf.strength = 0.65 * scale;
        algCfg.cvf.maxStepRatio = 0.040;
        algCfg.cvf.maxNormRatio = 0.085;

    case 'state_switch_threshold'
        algCfg.cvfAe.conservativeStateAdaptive = true;
        switch lower(level.name)
            case 'strict'
                algCfg.cvfAe.adaptiveFormationFeasibleRatio = 0.05;
                algCfg.cvfAe.adaptiveFormationViolation = 24;
                algCfg.cvfAe.adaptiveRecoveryFeasibleRatio = 0.45;
                algCfg.cvfAe.adaptiveRecoveryViolation = 9;
                algCfg.cvfAe.adaptiveSwitchConfirm = 3;
            case 'default'
                % Keep defaults from optimizer_CVF_AE_uav.
            case 'loose'
                algCfg.cvfAe.adaptiveFormationFeasibleRatio = 0.20;
                algCfg.cvfAe.adaptiveFormationViolation = 12;
                algCfg.cvfAe.adaptiveRecoveryFeasibleRatio = 0.65;
                algCfg.cvfAe.adaptiveRecoveryViolation = 4;
                algCfg.cvfAe.adaptiveSwitchConfirm = 1;
            otherwise
                error('Unknown state threshold level: %s', level.name);
        end

    otherwise
        error('Unknown sensitivity parameter group: %s', key);
end
end

function row = localBuildRunRow(spec, level, sceneId, runId, runSeed, result)
row = table( ...
    {spec.key}, {spec.label}, {level.name}, {level.label}, sceneId, runId, runSeed, ...
    result.bestFitness, result.runtime, logical(result.finalFeasible), result.finalViolation, ...
    localResultScalar(result, 'nEvals'), localResultScalar(result, 'firstFeasibleIter'), ...
    localResultScalar(result, 'repairCount'), localResultScalar(result, 'repairSuccessCount'), ...
    localResultScalar(result, 'viabilityFieldCount'), localResultScalar(result, 'viabilityFieldSuccessCount'), ...
    'VariableNames', {'ParamKey','ParamLabel','Level','LevelLabel','Scene','Run','Seed', ...
    'BestFitness','Runtime','Feasible','Violation','NEvals','FirstFeasibleIter', ...
    'RepairCount','RepairSuccessCount','ViabilityFieldCount','ViabilityFieldSuccessCount'});
end

function summaryTable = localBuildSummary(runRows)
keys = unique(runRows.ParamKey, 'stable');
rows = table();
for p = 1:numel(keys)
    key = keys{p};
    levels = unique(runRows.Level(strcmp(runRows.ParamKey, key)), 'stable');
    scenes = unique(runRows.Scene(strcmp(runRows.ParamKey, key)))';
    for s = scenes
        sceneRows = runRows(strcmp(runRows.ParamKey, key) & runRows.Scene == s, :);
        levelMeans = nan(numel(levels), 1);
        for i = 1:numel(levels)
            levelMask = strcmp(sceneRows.Level, levels{i});
            levelMeans(i) = mean(sceneRows.BestFitness(levelMask), 'omitnan');
        end
        [~, order] = sort(levelMeans, 'ascend');
        ranks = nan(numel(levels), 1);
        ranks(order) = 1:numel(levels);

        for i = 1:numel(levels)
            mask = strcmp(runRows.ParamKey, key) & strcmp(runRows.Level, levels{i}) & runRows.Scene == s;
            T = runRows(mask, :);
            row = table( ...
                {key}, T.ParamLabel(1), T.Level(1), T.LevelLabel(1), s, ...
                height(T), mean(T.BestFitness, 'omitnan'), std(T.BestFitness, 'omitnan'), ...
                mean(double(T.Feasible), 'omitnan'), mean(T.Violation, 'omitnan'), ...
                mean(T.Runtime, 'omitnan'), mean(T.NEvals, 'omitnan'), ...
                mean(T.FirstFeasibleIter, 'omitnan'), mean(T.RepairCount, 'omitnan'), ...
                mean(T.RepairSuccessCount, 'omitnan'), mean(T.ViabilityFieldCount, 'omitnan'), ...
                mean(T.ViabilityFieldSuccessCount, 'omitnan'), ranks(i), ...
                'VariableNames', {'ParamKey','ParamLabel','Level','LevelLabel','Scene','NumRuns', ...
                'MeanBestFitness','StdBestFitness','FeasibleRate','MeanViolation', ...
                'MeanRuntime','MeanNEvals','MeanFirstFeasibleIter','MeanRepairCount', ...
                'MeanRepairSuccessCount','MeanViabilityFieldCount','MeanViabilityFieldSuccessCount','Rank'});
            if isempty(rows)
                rows = row;
            else
                rows = [rows; row]; %#ok<AGROW>
            end
        end
    end
end
summaryTable = rows;
end

function rankTable = localBuildRankSummary(summaryTable)
keys = unique(summaryTable.ParamKey, 'stable');
rows = table();
for p = 1:numel(keys)
    key = keys{p};
    levels = unique(summaryTable.Level(strcmp(summaryTable.ParamKey, key)), 'stable');
    for i = 1:numel(levels)
        mask = strcmp(summaryTable.ParamKey, key) & strcmp(summaryTable.Level, levels{i});
        T = summaryTable(mask, :);
        row = table({key}, T.ParamLabel(1), T.Level(1), T.LevelLabel(1), ...
            mean(T.Rank, 'omitnan'), mean(T.MeanBestFitness, 'omitnan'), ...
            mean(T.FeasibleRate, 'omitnan'), mean(T.MeanNEvals, 'omitnan'), ...
            mean(T.MeanViabilityFieldCount, 'omitnan'), ...
            'VariableNames', {'ParamKey','ParamLabel','Level','LevelLabel', ...
            'AverageRank','AverageMeanBestFitness','AverageFeasibleRate', ...
            'AverageNEvals','AverageViabilityFieldCount'});
        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end
rankTable = rows;
end

function interpretation = localWriteInterpretation(cfg, specs, ~, rankTable)
filePath = fullfile(cfg.resultDir, 'CVF_AE_PARAM_SENSITIVITY_INTERPRETATION.md');
fid = fopen(filePath, 'w', 'n', 'UTF-8');
if fid < 0
    warning('Could not write interpretation: %s', filePath);
    interpretation = '';
    return;
end
c = onCleanup(@() fclose(fid));

fprintf(fid, '# CVF-AE 参数敏感性实验解释\n\n');
fprintf(fid, '生成时间：2026-06-23\n\n');
fprintf(fid, '## 配置\n\n');
fprintf(fid, '- 场景：`%s`\n', mat2str(cfg.sceneIds));
fprintf(fid, '- nRuns：`%d`\n', cfg.nRuns);
fprintf(fid, '- popSize：`%d`\n', cfg.paramsOverride.popSize);
fprintf(fid, '- maxIter：`%d`\n', cfg.paramsOverride.maxIter);
fprintf(fid, '- baseSeed：`%d`\n', cfg.baseSeed);
fprintf(fid, '- resumeExisting：`%d`\n\n', logical(cfg.resumeExisting));

fprintf(fid, '## 参数组\n\n');
for i = 1:numel(specs)
    fprintf(fid, '- `%s`：%s\n', specs(i).key, specs(i).label);
end
fprintf(fid, '\n');

fprintf(fid, '## 平均排名摘要\n\n');
fprintf(fid, '| Parameter | Level | Average rank | Average mean fitness | Feasible rate | nEvals | CVF count |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(rankTable)
    fprintf(fid, '| %s | %s | %.2f | %.4f | %.2f | %.1f | %.1f |\n', ...
        rankTable.ParamKey{i}, rankTable.Level{i}, rankTable.AverageRank(i), ...
        rankTable.AverageMeanBestFitness(i), rankTable.AverageFeasibleRate(i), ...
        rankTable.AverageNEvals(i), rankTable.AverageViabilityFieldCount(i));
end

fprintf(fid, '\n## 初步判读规则\n\n');
fprintf(fid, '- 默认参数不要求在每个场景和每个参数组中都排名第一，但应保持稳定前列。\n');
fprintf(fid, '- 只有某个非默认参数在 Scene 2-v2 和 Scene 4 中都全面、稳定、显著优于默认，且没有增加明显 `nEvals`、runtime 或轨迹风险，才考虑重新打开主方法冻结。\n');
fprintf(fid, '- 如果非默认参数只在单场景或单指标上更好，则作为鲁棒性观察，不反向修改默认主方法。\n');

interpretation = filePath;
end

function result = localNormalizeResult(result, sceneId, paramKey, levelName, runId, runSeed)
if ~isfield(result, 'bestFitness') && isfield(result, 'bestFit')
    result.bestFitness = result.bestFit;
end
if ~isfield(result, 'runtime') && isfield(result, 'runTime')
    result.runtime = result.runTime;
end
if ~isfield(result, 'runTime') && isfield(result, 'runtime')
    result.runTime = result.runtime;
end
if ~isfield(result, 'finalViolation') && isfield(result, 'bestDetail')
    result.finalViolation = localViolation(result.bestDetail);
end
if ~isfield(result, 'finalFeasible') && isfield(result, 'bestDetail')
    result.finalFeasible = isfield(result.bestDetail, 'isFeasible') && result.bestDetail.isFeasible;
end
result.sceneId = sceneId;
result.paramKey = paramKey;
result.levelName = levelName;
result.runId = runId;
result.seed = runSeed;
end

function val = localResultScalar(result, fieldName)
if isfield(result, fieldName) && ~isempty(result.(fieldName))
    val = result.(fieldName);
    if numel(val) > 1
        val = val(1);
    end
else
    val = NaN;
end
end

function v = localViolation(d)
if isstruct(d) && isfield(d, 'V') && ~isempty(d.V)
    v = d.V;
else
    v = NaN;
end
end

function params = localApplyOverrides(params, overrides)
if ~isstruct(overrides)
    return;
end
f = fieldnames(overrides);
for i = 1:numel(f)
    name = f{i};
    if isstruct(overrides.(name)) && isfield(params, name) && isstruct(params.(name))
        params.(name) = localApplyOverrides(params.(name), overrides.(name));
    else
        params.(name) = overrides.(name);
    end
end
end

function [arr, scalar] = localAlignStructArrayAndScalar(arr, scalar)
arrFields = fieldnames(arr);
scalarFields = fieldnames(scalar);

for k = 1:numel(scalarFields)
    if ~isfield(arr, scalarFields{k})
        [arr.(scalarFields{k})] = deal([]);
    end
end
for k = 1:numel(arrFields)
    if ~isfield(scalar, arrFields{k})
        scalar.(arrFields{k}) = [];
    end
end
end

function safe = localSafeName(name)
safe = regexprep(char(name), '[^A-Za-z0-9]+', '_');
safe = regexprep(safe, '^_+|_+$', '');
end

function resultDir = localFindLatestResultDir(prefix)
resultRoot = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results');
listing = dir(fullfile(resultRoot, [prefix '*']));
listing = listing([listing.isdir]);
if isempty(listing)
    error('No existing parameter sensitivity directory found for prefix: %s', prefix);
end
[~, idx] = max([listing.datenum]);
resultDir = fullfile(listing(idx).folder, listing(idx).name);
fprintf('Resume parameter sensitivity folder: %s\n', resultDir);
end
