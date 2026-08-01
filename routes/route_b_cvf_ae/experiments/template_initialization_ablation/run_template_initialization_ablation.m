function out = run_template_initialization_ablation(resultRoot)
%RUN_TEMPLATE_INITIALIZATION_ABLATION Internal Scene 3 template-only ablation.
% This experiment leaves production MATLAB files and paper artifacts untouched.

expRoot = fileparts(mfilename('fullpath'));
projectRoot = localFindProjectRoot(expRoot);
overrideDir = fullfile(expRoot, 'overrides');

if nargin < 1 || isempty(resultRoot)
    resultRoot = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
        ['template_initialization_ablation_' datestr(now, 'yyyymmdd_HHMMSS')]);
end
if ~exist(resultRoot, 'dir')
    mkdir(resultRoot);
end

originalDir = pwd;
cleanup = onCleanup(@() localRestorePath(originalDir, overrideDir)); %#ok<NASGU>
cd(expRoot);
addpath(overrideDir, '-begin');
addpath(projectRoot, '-end');
clear init_COVE_AE

activeInit = which('init_COVE_AE');
expectedInit = fullfile(overrideDir, 'init_COVE_AE.m');
assert(strcmpi(activeInit, expectedInit), ...
    'Template-ablation override is not active: %s', activeInit);

conditions = struct( ...
    'Name', {'template_on', 'template_off'}, ...
    'UseScenePriorTemplates', {true, false});
summaries = cell(numel(conditions), 1);
resultDirs = cell(numel(conditions), 1);

for c = 1:numel(conditions)
    cfg = localConfig(resultRoot, conditions(c));
    fprintf('\nTemplate ablation: %s\n', conditions(c).Name);
    summaries{c} = run_uav_comparison_lite_v2_batch(cfg);
    resultDirs{c} = cfg.resultDir;
    localWriteConditionReadme(cfg, activeInit);
end

analysisDir = fullfile(resultRoot, 'analysis');
analysis = analyze_template_initialization_ablation( ...
    resultDirs{1}, resultDirs{2}, analysisDir);

manifest = struct();
manifest.projectRoot = projectRoot;
manifest.overrideInit = activeInit;
manifest.conditions = conditions;
manifest.resultDirs = resultDirs;
manifest.baseSeed = 20260711;
manifest.sceneId = 4;
manifest.nRuns = 30;
manifest.popSize = 30;
manifest.maxIter = 300;
save(fullfile(resultRoot, 'template_ablation_manifest.mat'), ...
    'manifest', 'summaries', 'analysis');

out = struct('resultRoot', resultRoot, 'resultDirs', {resultDirs}, ...
    'analysisDir', analysisDir, 'analysis', analysis);
fprintf('\nTemplate initialization ablation complete.\n%s\n', resultRoot);
end

function cfg = localConfig(resultRoot, condition)
cfg = struct();
cfg.mode = 'internal_template_initialization_ablation';
cfg.sceneIds = 4;
cfg.algorithms = {'CVF-AE'};
cfg.nRuns = 30;
cfg.baseSeed = 20260711;
cfg.resultDir = fullfile(resultRoot, condition.Name);
cfg.resumeExisting = true;
cfg.verbose = true;
cfg.saveFigures = false;
cfg.showSingleRunFigure = false;
cfg.showBatchFigure = false;
cfg.saveBestPathFigure = false;
cfg.saveBestTopViewFigure = false;
cfg.useFairReferenceInit = false;
cfg.paramsOverride = struct();
cfg.paramsOverride.popSize = 30;
cfg.paramsOverride.maxIter = 300;
cfg.paramsOverride.templateAblation = struct( ...
    'useScenePriorTemplates', condition.UseScenePriorTemplates);
end

function localWriteConditionReadme(cfg, overrideInit)
readmePath = fullfile(cfg.resultDir, 'INTERNAL_TEMPLATE_ABLATION_README.md');
fid = fopen(readmePath, 'w', 'n', 'UTF-8');
if fid < 0
    warning('Could not write README: %s', readmePath);
    return;
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid, '# Internal template-initialization ablation\n\n');
fprintf(fid, '- Purpose: isolate the effect of fixed corridor templates in Scene 3 initialization\n');
fprintf(fid, '- Algorithm: `CVF-AE`\n');
fprintf(fid, '- Scene ID: `%d`\n', cfg.sceneIds);
fprintf(fid, '- Runs: `%d`\n', cfg.nRuns);
fprintf(fid, '- Population / iterations: `%d` / `%d`\n', ...
    cfg.paramsOverride.popSize, cfg.paramsOverride.maxIter);
fprintf(fid, '- Base seed: `%d`\n', cfg.baseSeed);
fprintf(fid, '- Template enabled: `%d`\n', ...
    cfg.paramsOverride.templateAblation.useScenePriorTemplates);
fprintf(fid, '- Override used: `%s`\n\n', overrideInit);
fprintf(fid, 'Only the template switch changes between conditions. Reference-path generation, guided initialization, state scheduling, CVF, repair, evaluator, budget, and run-seed rule are unchanged.\n');
end

function projectRoot = localFindProjectRoot(startDir)
projectRoot = startDir;
while exist(fullfile(projectRoot, 'defaultParams.m'), 'file') ~= 2
    parent = fileparts(projectRoot);
    if strcmp(parent, projectRoot)
        error('Could not locate project root from %s', startDir);
    end
    projectRoot = parent;
end
end

function localRestorePath(originalDir, overrideDir)
clear init_COVE_AE
if contains(path, overrideDir)
    rmpath(overrideDir);
end
cd(originalDir);
end
