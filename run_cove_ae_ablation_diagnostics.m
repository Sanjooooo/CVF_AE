function summary = run_cove_ae_ablation_diagnostics(cfg)
%RUN_COVE_AE_ABLATION_DIAGNOSTICS Run small COVE-AE mechanism ablation.

if nargin < 1 || isempty(cfg)
    cfg = struct();
end

cfg = localApplyDefaults(cfg);

batchSummary = run_uav_ablation_lite_v2_batch(cfg);
diagTable = summarize_cove_ae_diagnostics(cfg.resultDir);
aggregateTable = localBuildAggregate(diagTable, cfg.algorithms);

writetable(diagTable, fullfile(cfg.resultDir, 'cove_ae_ablation_diagnostics.csv'));
writetable(aggregateTable, fullfile(cfg.resultDir, 'cove_ae_ablation_diagnostic_summary.csv'));

summary = struct();
summary.cfg = cfg;
summary.batchSummary = batchSummary;
summary.diagTable = diagTable;
summary.aggregateTable = aggregateTable;

save(fullfile(cfg.resultDir, 'cove_ae_ablation_diagnostic_summary.mat'), 'summary', '-v7.3');

fprintf('\nCOVE-AE ablation diagnostics saved:\n');
fprintf('  %s\n', fullfile(cfg.resultDir, 'cove_ae_ablation_diagnostics.csv'));
fprintf('  %s\n', fullfile(cfg.resultDir, 'cove_ae_ablation_diagnostic_summary.csv'));
end

function cfg = localApplyDefaults(cfg)
if ~isfield(cfg, 'sceneIds') || isempty(cfg.sceneIds)
    cfg.sceneIds = [1, 2, 4];
end
if ~isfield(cfg, 'algorithms') || isempty(cfg.algorithms)
    cfg.algorithms = {'Base-AE', ...
                      'COVE-AE-w/o-Init', ...
                      'COVE-AE-w/o-Feedback', ...
                      'COVE-AE-w/o-RepairReuse', ...
                      'COVE-AE'};
end
if ~isfield(cfg, 'nRuns') || isempty(cfg.nRuns)
    cfg.nRuns = 5;
end
if ~isfield(cfg, 'baseSeed') || isempty(cfg.baseSeed)
    cfg.baseSeed = 20260612;
end
if ~isfield(cfg, 'resultDir') || isempty(cfg.resultDir)
    cfg.resultDir = fullfile(pwd, ['results_cove_ae_ablation_diagnostic_' datestr(now, 'yyyymmdd_HHMMSS')]);
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

if ~isfield(cfg, 'resumeExisting')
    cfg.resumeExisting = false;
end
cfg.saveFigures = false;
cfg.showSingleRunFigure = false;
cfg.showBatchFigure = false;
cfg.saveBestPathFigure = false;
cfg.saveBestTopViewFigure = false;
end

function T = localBuildAggregate(diagTable, algorithms)
rows = table();
sceneIds = unique(diagTable.Scene(:).');

for s = 1:numel(sceneIds)
    sceneId = sceneIds(s);
    for a = 1:numel(algorithms)
        alg = algorithms{a};
        mask = diagTable.Scene == sceneId & strcmpi(diagTable.Algorithm, alg);
        if ~any(mask)
            continue;
        end

        sub = diagTable(mask, :);
        row = table( ...
            sceneId, {alg}, height(sub), ...
            mean(double(sub.FinalFeasible), 'omitnan'), ...
            mean(sub.BestFitness, 'omitnan'), ...
            std(sub.BestFitness, 'omitnan'), ...
            mean(sub.FinalViolation, 'omitnan'), ...
            mean(sub.Runtime, 'omitnan'), ...
            mean(sub.NEvals, 'omitnan'), ...
            mean(sub.FirstFeasibleIter, 'omitnan'), ...
            mean(sub.RepairCount, 'omitnan'), ...
            mean(sub.RepairSuccessCount, 'omitnan'), ...
            mean(sub.StateFormationFrac, 'omitnan'), ...
            mean(sub.StatePreservationFrac, 'omitnan'), ...
            mean(sub.StateRefinementFrac, 'omitnan'), ...
            mean(sub.StateRecoveryFrac, 'omitnan'), ...
            mean(localColumnOrNan(sub, 'FeedbackObstacleFrac'), 'omitnan'), ...
            mean(localColumnOrNan(sub, 'FeedbackNFZFrac'), 'omitnan'), ...
            mean(localColumnOrNan(sub, 'FeedbackCurvatureFrac'), 'omitnan'), ...
            mean(localColumnOrNan(sub, 'FeedbackAltitudeFrac'), 'omitnan'), ...
            mean(localColumnOrNan(sub, 'FeedbackRiskFrac'), 'omitnan'), ...
            mean(localColumnOrNan(sub, 'FeedbackNoneFrac'), 'omitnan'), ...
            mean(sub.Operator1Count, 'omitnan'), ...
            mean(sub.Operator2Count, 'omitnan'), ...
            mean(sub.Operator3Count, 'omitnan'), ...
            mean(sub.Operator4Count, 'omitnan'), ...
            'VariableNames', { ...
            'Scene','Algorithm','NumRuns','FeasibleRate', ...
            'MeanBestFitness','StdBestFitness','MeanFinalViolation', ...
            'MeanRuntime','MeanNEvals','MeanFirstFeasibleIter', ...
            'MeanRepairCount','MeanRepairSuccessCount', ...
            'MeanStateFormationFrac','MeanStatePreservationFrac', ...
            'MeanStateRefinementFrac','MeanStateRecoveryFrac', ...
            'MeanFeedbackObstacleFrac','MeanFeedbackNFZFrac', ...
            'MeanFeedbackCurvatureFrac','MeanFeedbackAltitudeFrac', ...
            'MeanFeedbackRiskFrac','MeanFeedbackNoneFrac', ...
            'MeanOperator1Count','MeanOperator2Count', ...
            'MeanOperator3Count','MeanOperator4Count'} );

        if isempty(rows)
            rows = row;
        else
            rows = [rows; row]; %#ok<AGROW>
        end
    end
end

T = rows;
end

function values = localColumnOrNan(T, name)
if any(strcmp(T.Properties.VariableNames, name))
    values = T.(name);
else
    values = nan(height(T), 1);
end
end
