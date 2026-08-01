function out = make_cvf_ae_selected7_paper_artifacts(mainDir, recentDir, outDir)
%MAKE_CVF_AE_SELECTED7_PAPER_ARTIFACTS Rebuild paper artifacts for selected algorithms.
%
% This script rebuilds paper tables and figures from the frozen unified
% selected-seven CSV/MAT run records. Explicit split sources remain accepted
% only for recovery of an older export.

projectRoot = fileparts(mfilename('fullpath'));
addpath(projectRoot);

if nargin < 1 || isempty(mainDir)
    mainDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_selected7_main_comparison_formal_20260707_101155');
end
if nargin < 2 || isempty(recentDir)
    recentDir = mainDir;
end
if nargin < 3 || isempty(outDir)
    outDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_selected7_paper_artifacts_rerun_20260707_101155');
end
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

paperDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'paper_ajse_zh');
figureDir = fullfile(paperDir, 'figures');
tableDir = fullfile(paperDir, 'tables');

sceneIds = [1, 2, 4];
algorithms = ["AE", "PSO", "GWO", "HHO", "ERIME", "MSCSO", "CVF-AE"];
baselines = algorithms(1:end-1);
alpha = 0.05;

runs = localReadSelectedRuns(mainDir, recentDir, algorithms);
sanity = localReadSelectedSanity(mainDir, recentDir, algorithms);
summary = localBuildSummary(runs, sanity, sceneIds, algorithms);
avgRank = localBuildAverageRank(summary, algorithms);
pairwise = localBuildPairwise(runs, sceneIds, baselines, alpha);
wtl = localBuildWTL(pairwise);

writetable(runs, fullfile(outDir, 'selected7_runs.csv'));
writetable(sanity, fullfile(outDir, 'selected7_trajectory_sanity_summary.csv'));
writetable(summary, fullfile(outDir, 'selected7_summary_long.csv'));
writetable(avgRank, fullfile(outDir, 'selected7_average_rank.csv'));
writetable(pairwise, fullfile(outDir, 'selected7_pairwise_rank_sum_holm.csv'));
writetable(wtl, fullfile(outDir, 'selected7_wtl_summary.csv'));

localWriteMainTable(fullfile(tableDir, 'table_main_comparison.tex'), summary, algorithms);
localWriteSignificanceTable(fullfile(tableDir, 'table_significance.tex'), pairwise, baselines);
localPlotBoxplots(runs, outDir, figureDir, sceneIds, algorithms);
localPlotConvergence(mainDir, recentDir, outDir, figureDir, sceneIds, algorithms);
selection = localPlotRepresentativePaths(mainDir, recentDir, outDir, figureDir, sceneIds, algorithms);
writetable(selection, fullfile(outDir, 'selected7_representative_run_selection.csv'));
localWriteRunNote(outDir, mainDir, recentDir, summary, avgRank, pairwise, wtl);

out = struct();
out.outDir = outDir;
out.summary = summary;
out.averageRank = avgRank;
out.pairwise = pairwise;
out.wtl = wtl;
out.selection = selection;

fprintf('\nSelected-7 paper artifacts written to:\n%s\n', outDir);
disp(avgRank);
disp(wtl);
end

function T = localReadSelectedRuns(mainDir, recentDir, algorithms)
mainRuns = readtable(fullfile(mainDir, 'uav_comparison_runs.csv'), 'TextType', 'string');
if strcmp(char(mainDir), char(recentDir))
    mainRuns.Source = repmat("unified-rerun", height(mainRuns), 1);
    T = mainRuns(ismember(mainRuns.Algorithm, algorithms), :);
else
    recentRuns = readtable(fullfile(recentDir, 'uav_comparison_runs.csv'), 'TextType', 'string');
    mainKeep = ["AE", "PSO", "GWO", "HHO", "CVF-AE"];
    recentKeep = ["ERIME", "MSCSO"];
    mainRuns.Source = repmat("formal-main", height(mainRuns), 1);
    recentRuns.Source = repmat("recent-improved", height(recentRuns), 1);
    T = [mainRuns(ismember(mainRuns.Algorithm, mainKeep), :); ...
         recentRuns(ismember(recentRuns.Algorithm, recentKeep), :)];
end
T.PaperScene = cvfAePaperSceneId(T.Scene);
T.AlgorithmOrder = localAlgorithmIndex(T.Algorithm, algorithms);
T = sortrows(T, {'PaperScene', 'AlgorithmOrder', 'Run'});
end

function T = localReadSelectedSanity(mainDir, recentDir, algorithms)
mainSanity = readtable(fullfile(mainDir, 'trajectory_sanity_summary.csv'), 'TextType', 'string');
if strcmp(char(mainDir), char(recentDir))
    mainSanity.Source = repmat("unified-rerun", height(mainSanity), 1);
    T = mainSanity(ismember(mainSanity.Algorithm, algorithms), :);
else
    recentSanity = readtable(fullfile(recentDir, 'trajectory_sanity_summary.csv'), 'TextType', 'string');
    mainKeep = ["AE", "PSO", "GWO", "HHO", "CVF-AE"];
    recentKeep = ["ERIME", "MSCSO"];
    mainSanity.Source = repmat("formal-main", height(mainSanity), 1);
    recentSanity.Source = repmat("recent-improved", height(recentSanity), 1);
    T = [mainSanity(ismember(mainSanity.Algorithm, mainKeep), :); ...
         recentSanity(ismember(recentSanity.Algorithm, recentKeep), :)];
end
T.PaperScene = cvfAePaperSceneId(T.Scene);
T.AlgorithmOrder = localAlgorithmIndex(T.Algorithm, algorithms);
T = sortrows(T, {'PaperScene', 'AlgorithmOrder'});
end

function order = localAlgorithmIndex(values, algorithms)
values = string(values);
order = nan(numel(values), 1);
for idx = 1:numel(algorithms)
    order(values == algorithms(idx)) = idx;
end
assert(all(isfinite(order)), 'Unexpected algorithm in selected table.');
end

function summary = localBuildSummary(runs, sanity, sceneIds, algorithms)
rows = cell(numel(sceneIds) * numel(algorithms), 12);
rowIdx = 0;
for sceneId = sceneIds
    sceneMeans = nan(numel(algorithms), 1);
    for algIdx = 1:numel(algorithms)
        alg = algorithms(algIdx);
        values = localFitness(runs, sceneId, alg);
        sceneMeans(algIdx) = mean(values, 'omitnan');
    end
    [~, sortedIdx] = sort(sceneMeans, 'ascend');
    ranks = nan(numel(algorithms), 1);
    ranks(sortedIdx) = 1:numel(algorithms);

    for algIdx = 1:numel(algorithms)
        alg = algorithms(algIdx);
        mask = runs.Scene == sceneId & runs.Algorithm == alg;
        algRuns = runs(mask, :);
        sanityMask = sanity.Scene == sceneId & sanity.Algorithm == alg;
        assert(nnz(sanityMask) == 1, 'Missing sanity summary for Scene %d, %s.', sceneId, alg);
        rowIdx = rowIdx + 1;
        rows(rowIdx, :) = { ...
            cvfAePaperSceneId(sceneId), sceneId, alg, ...
            mean(algRuns.BestFitness, 'omitnan'), std(algRuns.BestFitness, 0, 'omitnan'), ...
            mean(algRuns.Feasible, 'omitnan'), mean(algRuns.Violation, 'omitnan'), ...
            mean(algRuns.NEvals, 'omitnan'), ranks(algIdx), ...
            sanity.VisualReviewFlagRate(sanityMask), sanity.HighAltitudeFlagRate(sanityMask), ...
            sanity.BoundaryHugFlagRate(sanityMask)};
    end
end
summary = cell2table(rows, 'VariableNames', { ...
    'Scene', 'InternalScene', 'Algorithm', 'Mean', 'Std', 'Feasibility', ...
    'MeanViolation', 'AvgNEvals', 'SelectedRank', 'VisualReviewFlagRate', ...
    'HighAltitudeFlagRate', 'BoundaryHugFlagRate'});
summary.AlgorithmOrder = localAlgorithmIndex(summary.Algorithm, algorithms);
summary = sortrows(summary, {'Scene', 'AlgorithmOrder'});
end

function avgRank = localBuildAverageRank(summary, algorithms)
rows = cell(numel(algorithms), 5);
for idx = 1:numel(algorithms)
    alg = algorithms(idx);
    mask = summary.Algorithm == alg;
    rows(idx, :) = {alg, mean(summary.SelectedRank(mask), 'omitnan'), ...
        mean(summary.Mean(mask), 'omitnan'), mean(summary.Feasibility(mask), 'omitnan'), ...
        mean(summary.VisualReviewFlagRate(mask), 'omitnan')};
end
avgRank = cell2table(rows, 'VariableNames', { ...
    'Algorithm', 'AverageRank', 'AverageMeanFitness', 'AverageFeasibility', ...
    'EngineeringFlagRate'});
avgRank.AlgorithmOrder = localAlgorithmIndex(avgRank.Algorithm, algorithms);
avgRank = sortrows(avgRank, 'AlgorithmOrder');
end

function pairwise = localBuildPairwise(runs, sceneIds, baselines, alpha)
rows = cell(numel(sceneIds) * numel(baselines), 15);
rowIdx = 0;
for sceneId = sceneIds
    sceneRows = cell(numel(baselines), 15);
    cvf = localFitness(runs, sceneId, "CVF-AE");
    for idx = 1:numel(baselines)
        baselineName = baselines(idx);
        baseline = localFitness(runs, sceneId, baselineName);
        [p, h, stats] = ranksum(cvf, baseline, 'alpha', alpha, ...
            'tail', 'both', 'method', 'approximate');
        delta = localLowerIsBetterCliffsDelta(cvf, baseline);
        sceneRows(idx, :) = {cvfAePaperSceneId(sceneId), sceneId, baselineName, ...
            numel(cvf), numel(baseline), mean(cvf), std(cvf), mean(baseline), ...
            std(baseline), p, logical(h), stats.ranksum, delta, "", NaN};
    end
    rawP = cell2mat(sceneRows(:, 10));
    holmP = localHolmAdjust(rawP);
    for idx = 1:numel(baselines)
        sceneRows{idx, 14} = localResult(holmP(idx) < alpha, sceneRows{idx, 6}, sceneRows{idx, 8});
        sceneRows{idx, 15} = holmP(idx);
    end
    rows(rowIdx + (1:numel(baselines)), :) = sceneRows;
    rowIdx = rowIdx + numel(baselines);
end
pairwise = cell2table(rows, 'VariableNames', { ...
    'Scene', 'InternalScene', 'Baseline', 'CVFN', 'BaselineN', 'CVFMean', ...
    'CVFStd', 'BaselineMean', 'BaselineStd', 'RawP', 'RawSignificant', ...
    'RankSumStatistic', 'CliffsDeltaLowerBetter', 'SceneHolmResult', 'SceneHolmP'});
pairwise.SceneHolmSignificant = pairwise.SceneHolmP < alpha;
pairwise = movevars(pairwise, 'SceneHolmSignificant', 'Before', 'SceneHolmResult');
end

function wtl = localBuildWTL(pairwise)
labels = pairwise.SceneHolmResult;
wtl = table(height(pairwise), sum(labels == "+"), sum(labels == "="), sum(labels == "-"), ...
    median(pairwise.CliffsDeltaLowerBetter), mean(pairwise.CliffsDeltaLowerBetter), ...
    'VariableNames', {'NumComparisons', 'Wins', 'Ties', 'Losses', ...
    'MedianCliffsDelta', 'MeanCliffsDelta'});
end

function values = localFitness(runs, sceneId, algorithm)
mask = runs.Scene == sceneId & runs.Algorithm == algorithm;
values = runs.BestFitness(mask);
values = values(isfinite(values));
assert(numel(values) == 30, 'Expected 30 runs for Scene %d, %s.', sceneId, algorithm);
end

function adjusted = localHolmAdjust(p)
p = p(:);
m = numel(p);
[sortedP, order] = sort(p);
sortedAdjusted = zeros(m, 1);
runningMax = 0;
for idx = 1:m
    candidate = (m - idx + 1) * sortedP(idx);
    runningMax = max(runningMax, candidate);
    sortedAdjusted(idx) = min(1, runningMax);
end
adjusted = zeros(m, 1);
adjusted(order) = sortedAdjusted;
end

function delta = localLowerIsBetterCliffsDelta(cvf, baseline)
comparisons = baseline(:)' - cvf(:);
delta = (nnz(comparisons(:) > 0) - nnz(comparisons(:) < 0)) / numel(comparisons);
end

function label = localResult(significant, cvfMean, baselineMean)
if ~significant
    label = "=";
elseif cvfMean < baselineMean
    label = "+";
else
    label = "-";
end
end

function localWriteMainTable(filePath, summary, algorithms)
fid = fopen(filePath, 'w', 'n', 'UTF-8');
assert(fid >= 0, 'Cannot write table: %s', filePath);
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '\\begin{table*}[tbp]\n');
fprintf(fid, '\\centering\n');
fprintf(fid, '\\caption{主对比实验结果}\n');
fprintf(fid, '\\label{tab:main-comparison}\n');
fprintf(fid, '\\scriptsize\n');
fprintf(fid, '\\setlength{\\tabcolsep}{3pt}\n');
fprintf(fid, '\\resizebox{\\textwidth}{!}{%%\n');
fprintf(fid, '\\begin{tabular}{lccccccccccc}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, 'Algorithm & S1 $J$ & S1 FR & S1 R & S2 $J$ & S2 FR & S2 R & S3 $J$ & S3 FR & S3 R & Avg. R & Eng. flag \\\\\n');
fprintf(fid, '\\midrule\n');
for alg = algorithms
    rows = summary(summary.Algorithm == alg, :);
    rows = sortrows(rows, 'Scene');
    avgRank = mean(rows.SelectedRank, 'omitnan');
    engFlag = mean(rows.VisualReviewFlagRate, 'omitnan');
    fprintf(fid, '%s & %s & %.2f & %d & %s & %.2f & %d & %s & %.2f & %d & %.2f & %.2f \\\\\n', ...
        alg, localMeanStd(rows.Mean(1), rows.Std(1)), rows.Feasibility(1), rows.SelectedRank(1), ...
        localMeanStd(rows.Mean(2), rows.Std(2)), rows.Feasibility(2), rows.SelectedRank(2), ...
        localMeanStd(rows.Mean(3), rows.Std(3)), rows.Feasibility(3), rows.SelectedRank(3), ...
        avgRank, engFlag);
end
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}%%\n');
fprintf(fid, '}\n');
fprintf(fid, '\\vspace{1mm}\n');
fprintf(fid, ['\\parbox{\\textwidth}{\\footnotesize 注：FR 为可行率，R 为主对比算法按平均适应度升序得到的场景排名，', ...
    'Avg. R 为三场景平均排名。Eng. flag 为三场景共 90 次运行中被任一工程轨迹复核规则标记的比例；', ...
    '该固定阈值复核仅作 sanity check，不作为安全认证指标。}\n']);
fprintf(fid, '\\end{table*}\n');
clear cleanup;
end

function s = localMeanStd(mu, sigma)
s = sprintf('%.4f $\\pm$ %.4f', mu, sigma);
end

function localWriteSignificanceTable(filePath, pairwise, baselines)
fid = fopen(filePath, 'w', 'n', 'UTF-8');
assert(fid >= 0, 'Cannot write table: %s', filePath);
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '\\begin{table}[tbp]\n');
fprintf(fid, '\\centering\n');
fprintf(fid, '\\caption{CVF-AE 与所选基线算法的逐场景显著性比较}\n');
fprintf(fid, '\\label{tab:significance}\n');
fprintf(fid, '\\tiny\n');
fprintf(fid, '\\setlength{\\tabcolsep}{2pt}\n');
fprintf(fid, '\\resizebox{\\columnwidth}{!}{%%\n');
fprintf(fid, '\\begin{tabular}{@{}lcccccc@{}}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, 'Baseline & S1 $p/R$ & S1 $\\delta$ & S2 $p/R$ & S2 $\\delta$ & S3 $p/R$ & S3 $\\delta$ \\\\\n');
fprintf(fid, '\\midrule\n');
for baseline = baselines
    rows = pairwise(pairwise.Baseline == baseline, :);
    rows = sortrows(rows, 'Scene');
    fprintf(fid, '%s & %s & %+0.2f & %s & %+0.2f & %s & %+0.2f \\\\\n', ...
        baseline, localPResult(rows.SceneHolmP(1), rows.SceneHolmResult(1)), rows.CliffsDeltaLowerBetter(1), ...
        localPResult(rows.SceneHolmP(2), rows.SceneHolmResult(2)), rows.CliffsDeltaLowerBetter(2), ...
        localPResult(rows.SceneHolmP(3), rows.SceneHolmResult(3)), rows.CliffsDeltaLowerBetter(3));
end
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}%%\n');
fprintf(fid, '}\n');
fprintf(fid, '\\vspace{1mm}\n');
fprintf(fid, '\\parbox{\\columnwidth}{\\footnotesize 注：$p$ 为场景内 6 次比较的 Holm 校正值，$R$ 为胜/平/负关系，$\\delta$ 为面向最小化问题定义的 Cliff''s delta；正值表示 CVF-AE 分布更优。}\n');
fprintf(fid, '\\end{table}\n');
clear cleanup;
end

function s = localPResult(p, result)
if p < 1e-3
    ps = sprintf('%.1e', p);
else
    ps = sprintf('%.3f', p);
end
s = sprintf('%s/%s', ps, result);
end

function localPlotBoxplots(runs, outDir, figureDir, sceneIds, algorithms)
fig = figure('Visible', 'off', 'Color', 'w', 'Position', [40, 60, 1460, 460]);
layout = tiledlayout(fig, 1, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
colors = localAlgorithmColors(algorithms);
for sceneIdx = 1:numel(sceneIds)
    sceneId = sceneIds(sceneIdx);
    ax = nexttile(layout, sceneIdx);
    hold(ax, 'on');
    for algIdx = 1:numel(algorithms)
        alg = algorithms(algIdx);
        vals = localFitness(runs, sceneId, alg);
        groups = categorical(repmat(alg, numel(vals), 1), algorithms, 'Ordinal', true);
        chart = boxchart(ax, groups, vals, 'MarkerStyle', '.', 'JitterOutliers', 'on', 'BoxWidth', 0.58);
        chart.BoxFaceColor = colors(algIdx, :);
        chart.BoxFaceAlpha = 0.55;
        chart.WhiskerLineColor = colors(algIdx, :) * 0.65;
        chart.MarkerColor = colors(algIdx, :) * 0.65;
        if alg == "CVF-AE"
            chart.LineWidth = 1.35;
        end
        plot(ax, groups(1), mean(vals, 'omitnan'), 'd', ...
            'LineStyle', 'none', ...
            'MarkerSize', 5.8, ...
            'MarkerFaceColor', 'w', ...
            'MarkerEdgeColor', colors(algIdx, :) * 0.55, ...
            'LineWidth', 1.15);
    end
    if sceneIdx == 1
        ylabel(ax, 'Best fitness');
    end
    grid(ax, 'on');
    box(ax, 'on');
    xtickangle(ax, 35);
    set(ax, 'FontName', 'Times New Roman', 'FontSize', 9.5, 'LineWidth', 0.9);
end
localExportFigure(fig, outDir, figureDir, 'selected7_boxplots');
close(fig);
end

function localPlotConvergence(mainDir, recentDir, outDir, figureDir, sceneIds, algorithms)
for sceneId = sceneIds
    curves = struct();
    sceneLen = 0;
    for alg = algorithms
        runDir = fullfile(localSourceDir(alg, mainDir, recentDir), 'run_records');
        files = dir(fullfile(runDir, sprintf('scene%d_%s_run*.mat', sceneId, alg)));
        algCurves = {};
        for idx = 1:numel(files)
            S = load(fullfile(files(idx).folder, files(idx).name));
            if isfield(S, 'result')
                curve = localExtractConvergence(S.result);
                if ~isempty(curve)
                    algCurves{end+1} = curve(:); %#ok<AGROW>
                end
            end
        end
        assert(numel(algCurves) == 30, 'Expected 30 convergence curves for Scene %d, %s.', sceneId, alg);
        [meanCurve, stdCurve] = localCurveStats(algCurves);
        sceneLen = max(sceneLen, numel(meanCurve));
        fieldName = localSafeName(alg);
        curves.(fieldName).Algorithm = alg;
        curves.(fieldName).Mean = meanCurve(:);
        curves.(fieldName).Std = stdCurve(:);
    end
    fields = fieldnames(curves);
    for idx = 1:numel(fields)
        curves.(fields{idx}).Mean = localPad(curves.(fields{idx}).Mean, sceneLen);
        curves.(fields{idx}).Std = localPad(curves.(fields{idx}).Std, sceneLen);
    end
    localPlotConvergenceScene(curves, outDir, figureDir, sceneId, sceneLen, algorithms);
end
end

function sourceDir = localSourceDir(algorithm, mainDir, recentDir)
if algorithm == "ERIME" || algorithm == "MSCSO"
    if strcmp(char(mainDir), char(recentDir))
        sourceDir = mainDir;
    else
        sourceDir = recentDir;
    end
else
    sourceDir = mainDir;
end
end

function curve = localExtractConvergence(result)
curve = [];
fields = {'convergence', 'bestHist', 'bestFitHistory', 'bestFitnessHistory', ...
    'bestCostHistory', 'curve', 'fitnessCurve', 'costHistory', 'gbestHistory', 'fbestHistory'};
for i = 1:numel(fields)
    f = fields{i};
    if isfield(result, f) && isnumeric(result.(f)) && ~isempty(result.(f))
        curve = result.(f)(:);
        curve = curve(isfinite(curve));
        if ~isempty(curve)
            return;
        end
    end
end
end

function [meanCurve, stdCurve] = localCurveStats(curves)
maxLen = max(cellfun(@numel, curves));
M = nan(numel(curves), maxLen);
for i = 1:numel(curves)
    c = curves{i}(:);
    M(i, 1:numel(c)) = c;
    if numel(c) < maxLen
        M(i, numel(c)+1:end) = c(end);
    end
end
meanCurve = mean(M, 1, 'omitnan');
stdCurve = std(M, 0, 1, 'omitnan');
end

function y = localPad(y, targetLen)
y = y(:);
if numel(y) < targetLen
    y(numel(y)+1:targetLen) = y(end);
else
    y = y(1:targetLen);
end
end

function localPlotConvergenceScene(curves, outDir, figureDir, sceneId, sceneLen, algorithms)
paperSceneId = cvfAePaperSceneId(sceneId);
fig = figure('Visible', 'off', 'Color', 'w', 'Position', [80, 80, 980, 620]);
ax = axes(fig);
set(ax, 'Position', [0.085, 0.115, 0.875, 0.795]);
hold(ax, 'on');
grid(ax, 'on');
box(ax, 'on');
colors = localAlgorithmColors(algorithms);
lineStyles = ["-", "--", "-.", ":", "-", "--", "-"];
handles = gobjects(0);
labels = {};
x = (1:sceneLen)';
for algIdx = 1:numel(algorithms)
    alg = algorithms(algIdx);
    fieldName = localSafeName(alg);
    C = curves.(fieldName);
    meanCurve = C.Mean(:);
    stdCurve = C.Std(:);
    color = colors(algIdx, :);
    if alg == "CVF-AE"
        lo = max(meanCurve - stdCurve, eps);
        hi = meanCurve + stdCurve;
        patch(ax, [x; flipud(x)], [lo; flipud(hi)], color, ...
            'FaceAlpha', 0.12, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        lineWidth = 2.7;
    else
        lineWidth = 1.25;
    end
    h = plot(ax, x, meanCurve, 'LineWidth', lineWidth, 'Color', color, ...
        'LineStyle', lineStyles(algIdx));
    handles(end+1) = h; %#ok<AGROW>
    labels{end+1} = char(alg); %#ok<AGROW>
end
xlabel(ax, 'Iteration');
ylabel(ax, 'Feasible-aware best fitness');
set(ax, 'FontName', 'Times New Roman', 'FontSize', 11, 'LineWidth', 0.9);
xlim(ax, [1, sceneLen]);
legend(ax, handles, labels, 'Location', 'northeast', 'Interpreter', 'none', 'Box', 'on');
localExportFigure(fig, outDir, figureDir, sprintf('selected_scene%d_convergence_mean_std', paperSceneId));
close(fig);
end

function selection = localPlotRepresentativePaths(mainDir, recentDir, outDir, figureDir, sceneIds, algorithms)
selection = table();
for sceneId = sceneIds
    reps = repmat(localEmptyRep(), numel(algorithms), 1);
    for algIdx = 1:numel(algorithms)
        alg = algorithms(algIdx);
        reps(algIdx) = localSelectRepresentative(sceneId, alg, localSourceDir(alg, mainDir, recentDir));
        selection = [selection; localRepToTable(reps(algIdx))]; %#ok<AGROW>
    end
    localPlotPathScene(outDir, figureDir, sceneId, reps, true);
    localPlotPathScene(outDir, figureDir, sceneId, reps, false);
end
end

function rep = localSelectRepresentative(sceneId, algorithm, resultDir)
sanityPath = fullfile(resultDir, 'trajectory_sanity_runs.csv');
runDir = fullfile(resultDir, 'run_records');
T = readtable(sanityPath, 'TextType', 'string');
T = T(T.Scene == sceneId & T.Algorithm == algorithm, :);
assert(~isempty(T), 'No sanity rows for Scene %d, %s.', sceneId, algorithm);
feasibleRows = T(T.Feasible > 0, :);
if ~isempty(feasibleRows)
    medFit = median(feasibleRows.BestFitness, 'omitnan');
    cleanRows = feasibleRows(~logical(feasibleRows.VisualReviewFlag), :);
else
    medFit = median(T.BestFitness, 'omitnan');
    cleanRows = table();
end
if ~isempty(cleanRows)
    C = cleanRows;
    tierName = "feasible_clean_median";
    C.SelectionDistance = abs(C.BestFitness - medFit);
    C = sortrows(C, {'SelectionDistance', 'BestFitness'});
elseif ~isempty(feasibleRows)
    C = feasibleRows;
    tierName = "feasible_flagged_median";
    C.SelectionDistance = abs(C.BestFitness - medFit);
    C = sortrows(C, {'SelectionDistance', 'BestFitness'});
else
    C = T;
    tierName = "infeasible_min_violation_median";
    C.SelectionDistance = abs(C.BestFitness - medFit);
    C = sortrows(C, {'Violation', 'SelectionDistance', 'BestFitness'});
end
selected = C(1, :);
S = load(fullfile(runDir, char(selected.RunFile)));
params = defaultParams();
params.sceneId = sceneId;
params = applyUAVSceneOverrides(params);
[bestCtrl, bestPath] = localRecoverBestPath(S.result, params);
rep = localEmptyRep();
rep.Scene = cvfAePaperSceneId(sceneId);
rep.InternalScene = sceneId;
rep.Algorithm = algorithm;
rep.RunFile = selected.RunFile;
rep.SelectionTier = tierName;
rep.SelectionDistance = selected.SelectionDistance;
rep.BestFitness = selected.BestFitness;
rep.Feasible = logical(selected.Feasible);
rep.Violation = selected.Violation;
rep.VisualReviewFlag = logical(selected.VisualReviewFlag);
rep.HighAltitudeFlag = logical(selected.HighAltitudeFlag);
rep.BoundaryHugFlag = logical(selected.BoundaryHugFlag);
rep.ExcessiveDetourFlag = logical(selected.ExcessiveDetourFlag);
rep.bestCtrl = bestCtrl;
rep.bestPath = bestPath;
end

function rep = localEmptyRep()
rep = struct();
rep.Scene = NaN;
rep.InternalScene = NaN;
rep.Algorithm = "";
rep.RunFile = "";
rep.SelectionTier = "";
rep.SelectionDistance = NaN;
rep.BestFitness = NaN;
rep.Feasible = false;
rep.Violation = NaN;
rep.VisualReviewFlag = false;
rep.HighAltitudeFlag = false;
rep.BoundaryHugFlag = false;
rep.ExcessiveDetourFlag = false;
rep.bestCtrl = [];
rep.bestPath = [];
end

function row = localRepToTable(rep)
row = table(rep.Scene, rep.InternalScene, rep.Algorithm, rep.RunFile, ...
    rep.SelectionTier, rep.SelectionDistance, rep.BestFitness, rep.Feasible, ...
    rep.Violation, rep.VisualReviewFlag, rep.HighAltitudeFlag, ...
    rep.BoundaryHugFlag, rep.ExcessiveDetourFlag, ...
    'VariableNames', {'Scene', 'InternalScene', 'Algorithm', 'RunFile', ...
    'SelectionTier', 'SelectionDistance', 'BestFitness', 'Feasible', ...
    'Violation', 'VisualReviewFlag', 'HighAltitudeFlag', 'BoundaryHugFlag', ...
    'ExcessiveDetourFlag'});
end

function localPlotPathScene(outDir, figureDir, sceneId, reps, topView)
paperSceneId = cvfAePaperSceneId(sceneId);
params = defaultParams();
params.sceneId = sceneId;
params = applyUAVSceneOverrides(params);
if topView
    params.figView = [0, 90];
else
    params.figView = [-37.5, 30];
end
map = createMap(params);

fig = figure('Visible', 'off', 'Color', 'w', 'Position', [80, 80, 1320, 900]);
plotSceneOnly(map, params);
hold on;
if topView
    view(2);
    axis equal;
end
oldLegend = findobj(fig, 'Type', 'Legend');
if ~isempty(oldLegend)
    delete(oldLegend);
end
algorithms = string({reps.Algorithm});
colors = localAlgorithmColors(algorithms);
handles = gobjects(0);
labels = {};
for idx = 1:numel(reps)
    if isempty(reps(idx).bestPath)
        continue;
    end
    color = colors(idx, :);
    if reps(idx).Algorithm == "CVF-AE"
        lineWidth = 3.1;
    else
        lineWidth = 2.0;
    end
    h = plot3(reps(idx).bestPath(:,1), reps(idx).bestPath(:,2), reps(idx).bestPath(:,3), ...
        'LineStyle', localAlgorithmLineStyle(reps(idx).Algorithm), ...
        'Color', color, 'LineWidth', lineWidth);
    if ~isempty(reps(idx).bestCtrl)
        plot3(reps(idx).bestCtrl(:,1), reps(idx).bestCtrl(:,2), reps(idx).bestCtrl(:,3), ...
            'o', 'Color', color, 'MarkerSize', 3.2, 'LineWidth', 0.8);
    end
    handles(end+1) = h; %#ok<AGROW>
    labels{end+1} = char(reps(idx).Algorithm); %#ok<AGROW>
end
if ~topView && ~isempty(handles)
    legend(handles, labels, 'Location', 'northeastoutside', 'Interpreter', 'none');
end
if topView
    legend off;
    viewName = 'top';
else
    viewName = '3d';
end
localExportFigure(fig, outDir, figureDir, sprintf('selected_scene%d_representative_%s', paperSceneId, viewName));
close(fig);
end

function [bestCtrl, bestPath] = localRecoverBestPath(result, params)
bestCtrl = [];
bestPath = [];
if isfield(result, 'bestCtrl') && ~isempty(result.bestCtrl)
    bestCtrl = result.bestCtrl;
end
if isfield(result, 'bestPath') && ~isempty(result.bestPath)
    bestPath = result.bestPath;
end
if isempty(bestCtrl)
    bestX = localGetField(result, {'bestX', 'bestPosition'}, []);
    if ~isempty(bestX)
        try
            bestCtrl = decodeSolution(bestX, params);
        catch
            bestCtrl = [];
        end
    end
end
if isempty(bestPath) && ~isempty(bestCtrl)
    try
        bestPath = bsplinePath(bestCtrl, params.degree, params.nSamples);
    catch
        bestPath = [];
    end
end
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

function name = localSafeName(algorithm)
name = matlab.lang.makeValidName(char(strrep(algorithm, '-', '_')));
end

function colors = localAlgorithmColors(algorithms)
palette = containers.Map();
palette('AE') = [0.45, 0.45, 0.45];
palette('PSO') = [0.00, 0.45, 0.70];
palette('GWO') = [0.84, 0.37, 0.00];
palette('HHO') = [0.80, 0.47, 0.65];
palette('ERIME') = [0.35, 0.70, 0.90];
palette('MSCSO') = [0.40, 0.25, 0.65];
palette('CVF-AE') = [0.00, 0.14, 0.32];
colors = zeros(numel(algorithms), 3);
for idx = 1:numel(algorithms)
    colors(idx, :) = palette(char(algorithms(idx)));
end
end

function lineStyle = localAlgorithmLineStyle(algorithm)
switch string(algorithm)
    case "AE"
        lineStyle = '-';
    case "PSO"
        lineStyle = '--';
    case "GWO"
        lineStyle = '-.';
    case "HHO"
        lineStyle = ':';
    case "ERIME"
        lineStyle = '--';
    case "MSCSO"
        lineStyle = '-.';
    otherwise
        lineStyle = '-';
end
end

function localExportFigure(fig, outDir, figureDir, baseName)
pngPath = fullfile(outDir, baseName + ".png");
pdfPath = fullfile(outDir, baseName + ".pdf");
exportgraphics(fig, pngPath, 'Resolution', 300);
exportgraphics(fig, pdfPath, 'ContentType', 'vector');
copyfile(pngPath, fullfile(figureDir, baseName + ".png"));
end

function localWriteRunNote(outDir, mainDir, recentDir, summary, avgRank, pairwise, wtl)
fid = fopen(fullfile(outDir, 'SELECTED7_ARTIFACTS_README.md'), 'w', 'n', 'UTF-8');
assert(fid >= 0, 'Cannot write selected-7 README.');
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '# CVF-AE paper artifacts\n\n');
fprintf(fid, 'Generated from CSV/MAT run records.\n\n');
fprintf(fid, '- Source: `%s`\n', mainDir);
if ~strcmp(char(mainDir), char(recentDir))
    fprintf(fid, '\n- Secondary source: `%s`', recentDir);
end
fprintf(fid, '\n\nAlgorithm order: AE, PSO, GWO, HHO, ERIME, MSCSO, CVF-AE.\n\n');
fprintf(fid, 'Average ranks:\n\n');
fprintf(fid, '| Algorithm | Avg. rank | Avg. feasible rate | Eng. flag |\n');
fprintf(fid, '|---|---:|---:|---:|\n');
for i = 1:height(avgRank)
    fprintf(fid, '| %s | %.2f | %.2f | %.2f |\n', avgRank.Algorithm(i), ...
        avgRank.AverageRank(i), avgRank.AverageFeasibility(i), avgRank.EngineeringFlagRate(i));
end
fprintf(fid, '\nPairwise CVF-AE comparisons after scene-wise Holm correction: %d wins, %d ties, %d losses over %d comparisons.\n', ...
    wtl.Wins(1), wtl.Ties(1), wtl.Losses(1), wtl.NumComparisons(1));
fprintf(fid, '\nScene-wise ranks:\n\n');
fprintf(fid, '| Scene | Algorithm | Mean | FR | Rank |\n');
fprintf(fid, '|---:|---|---:|---:|---:|\n');
for i = 1:height(summary)
    fprintf(fid, '| %d | %s | %.4f | %.2f | %d |\n', summary.Scene(i), ...
        summary.Algorithm(i), summary.Mean(i), summary.Feasibility(i), summary.SelectedRank(i));
end
fprintf(fid, '\nPairwise table rows: %d.\n', height(pairwise));
clear cleanup;
end
