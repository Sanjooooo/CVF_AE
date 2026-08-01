function summary = run_cove_ae_diagnostics(cfg)
%RUN_COVE_AE_DIAGNOSTICS Run a small diagnostic batch for COVE-AE behavior.

if nargin < 1 || isempty(cfg)
    cfg = struct();
end

cfg = localApplyDefaults(cfg);

batchSummary = run_uav_comparison_lite_v2_batch(cfg);
diagTable = summarize_cove_ae_diagnostics(cfg.resultDir);

summary = struct();
summary.cfg = cfg;
summary.batchSummary = batchSummary;
summary.diagTable = diagTable;

save(fullfile(cfg.resultDir, 'cove_ae_diagnostic_summary.mat'), 'summary', '-v7.3');

fprintf('\nCOVE-AE diagnostic table saved:\n  %s\n', ...
    fullfile(cfg.resultDir, 'cove_ae_diagnostics.csv'));
end

function cfg = localApplyDefaults(cfg)
if ~isfield(cfg, 'sceneIds') || isempty(cfg.sceneIds)
    cfg.sceneIds = [1, 2, 4];
end
if ~isfield(cfg, 'algorithms') || isempty(cfg.algorithms)
    cfg.algorithms = {'AE', 'COVE-AE'};
end
if ~isfield(cfg, 'nRuns') || isempty(cfg.nRuns)
    cfg.nRuns = 3;
end
if ~isfield(cfg, 'baseSeed') || isempty(cfg.baseSeed)
    cfg.baseSeed = 20260612;
end
if ~isfield(cfg, 'resultDir') || isempty(cfg.resultDir)
    cfg.resultDir = fullfile(pwd, ['results_cove_ae_diagnostic_' datestr(now, 'yyyymmdd_HHMMSS')]);
end
if ~isfield(cfg, 'paramsOverride') || ~isstruct(cfg.paramsOverride)
    cfg.paramsOverride = struct();
end
if ~isfield(cfg.paramsOverride, 'popSize')
    cfg.paramsOverride.popSize = 10;
end
if ~isfield(cfg.paramsOverride, 'maxIter')
    cfg.paramsOverride.maxIter = 30;
end

cfg.resumeExisting = false;
cfg.saveFigures = false;
cfg.showSingleRunFigure = false;
cfg.showBatchFigure = false;
cfg.saveBestPathFigure = false;
cfg.saveBestTopViewFigure = false;
end
