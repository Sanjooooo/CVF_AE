function outputs = analyze_cvf_ae_formal_significance(mainDir, recentDir, outDir)
%ANALYZE_CVF_AE_FORMAL_SIGNIFICANCE Formal nonparametric tests for CVF-AE.
%
% Different algorithms used different random seeds in both formal batches.
% Therefore, the pairwise analysis uses the unpaired Wilcoxon rank-sum test
% (Mann-Whitney U), not the paired signed-rank test.

projectRoot = fileparts(mfilename('fullpath'));
if nargin < 1 || isempty(mainDir)
    mainDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_main_comparison_formal_conservative_20260623_091132');
end
if nargin < 2 || isempty(recentDir)
    recentDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_main_comparison_recent_improved_formal_20260623_161229');
end
if nargin < 3 || isempty(outDir)
    outDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_formal_significance_20260624_from_formal_results');
end

mainFile = fullfile(mainDir, 'uav_comparison_runs.csv');
recentFile = fullfile(recentDir, 'uav_comparison_runs.csv');
ablationDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
    'cvf_ae_formal_ablation_conservative_20260622_194947');
ablationFile = fullfile(ablationDir, 'cvf_ae_gate_runs.csv');
assert(isfile(mainFile), 'Missing formal main run table: %s', mainFile);
assert(isfile(recentFile), 'Missing recent-improved run table: %s', recentFile);
assert(isfile(ablationFile), 'Missing formal ablation run table: %s', ablationFile);
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

mainRuns = readtable(mainFile, 'TextType', 'string');
recentRuns = readtable(recentFile, 'TextType', 'string');
ablationRuns = readtable(ablationFile, 'TextType', 'string');
mainRuns.Source = repmat("formal-main", height(mainRuns), 1);
recentRuns.Source = repmat("recent-improved", height(recentRuns), 1);
runs = [mainRuns; recentRuns];

requiredVars = ["Scene", "Algorithm", "Run", "Seed", "BestFitness"];
assert(all(ismember(requiredVars, string(runs.Properties.VariableNames))), ...
    'Run tables do not contain all required variables.');

scenes = [1, 2, 4];
mainAlgorithms = ["AE", "PSO", "GWO", "WOA", "HHO", "DBO", "CPO"];
recentAlgorithms = ["GDSAO", "ERIME", "MSCSO"];
comparisonAlgorithms = [mainAlgorithms, recentAlgorithms];
alpha = 0.05;

pairwise = localBuildPairwiseTable(runs, scenes, comparisonAlgorithms, ...
    mainAlgorithms, alpha);
pairwise.GlobalHolmP = localHolmAdjust(pairwise.RawP);
pairwise.GlobalHolmSignificant = pairwise.GlobalHolmP < alpha;
pairwise.GlobalHolmResult = localResultLabels( ...
    pairwise.GlobalHolmSignificant, pairwise.CVFMean, pairwise.BaselineMean);

omnibus = localBuildOmnibusTable(runs, scenes, comparisonAlgorithms, alpha);
wtl = localBuildWTLTable(pairwise, ["formal-main", "recent-improved", "all"]);

ablationAlgorithms = ["Base-AE", "CVF-AE-w/o-Init", ...
    "CVF-AE-w/o-StateAdaptiveCVF", "CVF-AE-w/o-SparsePreservation", ...
    "CVF-AE-w/o-CVF"];
ablationPairwise = localBuildAblationPairwiseTable( ...
    ablationRuns, scenes, ablationAlgorithms, alpha);
ablationPairwise.GlobalHolmP = localHolmAdjust(ablationPairwise.RawP);
ablationPairwise.GlobalHolmSignificant = ablationPairwise.GlobalHolmP < alpha;
ablationPairwise.GlobalHolmResult = localResultLabels( ...
    ablationPairwise.GlobalHolmSignificant, ablationPairwise.CVFMean, ...
    ablationPairwise.BaselineMean);
ablationOmnibus = localBuildOmnibusTable( ...
    ablationRuns, scenes, ablationAlgorithms, alpha);
ablationWTL = localBuildWTLTable(ablationPairwise, "all");

pairwiseFile = fullfile(outDir, 'cvf_ae_pairwise_rank_sum_holm.csv');
omnibusFile = fullfile(outDir, 'cvf_ae_kruskal_wallis_omnibus.csv');
wtlFile = fullfile(outDir, 'cvf_ae_significance_wtl_summary.csv');
ablationPairwiseFile = fullfile(outDir, 'cvf_ae_ablation_pairwise_rank_sum_holm.csv');
ablationOmnibusFile = fullfile(outDir, 'cvf_ae_ablation_kruskal_wallis_omnibus.csv');
ablationWTLFile = fullfile(outDir, 'cvf_ae_ablation_significance_wtl_summary.csv');
noteFile = fullfile(outDir, 'CVF_AE_FORMAL_SIGNIFICANCE_INTERPRETATION.md');

writetable(pairwise, pairwiseFile);
writetable(omnibus, omnibusFile);
writetable(wtl, wtlFile);
writetable(ablationPairwise, ablationPairwiseFile);
writetable(ablationOmnibus, ablationOmnibusFile);
writetable(ablationWTL, ablationWTLFile);
localWriteInterpretation(noteFile, mainDir, recentDir, ablationDir, ...
    pairwise, omnibus, wtl, ablationPairwise, ablationOmnibus, ...
    ablationWTL, alpha);

outputs = struct();
outputs.outDir = outDir;
outputs.pairwise = pairwise;
outputs.omnibus = omnibus;
outputs.wtl = wtl;
outputs.ablationPairwise = ablationPairwise;
outputs.ablationOmnibus = ablationOmnibus;
outputs.ablationWTL = ablationWTL;

fprintf('\n=== CVF-AE Formal Significance Analysis ===\n');
fprintf('Pairwise test : two-sided Wilcoxon rank-sum (Mann-Whitney U)\n');
fprintf('Correction    : Holm within each scene; global Holm also reported\n');
fprintf('Effect size   : lower-is-better Cliff''s delta\n');
fprintf('Output folder : %s\n\n', outDir);
disp(wtl);
fprintf('\nFormal ablation:\n');
disp(ablationWTL);
end

function pairwise = localBuildPairwiseTable(runs, scenes, algorithms, mainAlgorithms, alpha)
rows = cell(0, 18);
for sceneId = scenes
    sceneRows = cell(numel(algorithms), 18);
    cvf = localFitness(runs, sceneId, "CVF-AE");
    for idx = 1:numel(algorithms)
        algorithm = algorithms(idx);
        baseline = localFitness(runs, sceneId, algorithm);
        [p, h, stats] = ranksum(cvf, baseline, 'alpha', alpha, ...
            'tail', 'both', 'method', 'approximate');
        delta = localLowerIsBetterCliffsDelta(cvf, baseline);
        if ismember(algorithm, mainAlgorithms)
            source = "formal-main";
        else
            source = "recent-improved";
        end
        sceneRows(idx, :) = {sceneId, algorithm, source, numel(cvf), ...
            numel(baseline), mean(cvf), std(cvf), median(cvf), ...
            mean(baseline), std(baseline), median(baseline), p, logical(h), ...
            stats.ranksum, delta, localEffectMagnitude(delta), "", NaN};
    end
    rawP = cell2mat(sceneRows(:, 12));
    adjustedP = localHolmAdjust(rawP);
    for idx = 1:numel(algorithms)
        sceneRows{idx, 17} = localSingleResult( ...
            adjustedP(idx) < alpha, sceneRows{idx, 6}, sceneRows{idx, 9});
        sceneRows{idx, 18} = adjustedP(idx);
    end
    rows = [rows; sceneRows]; %#ok<AGROW>
end

pairwise = cell2table(rows, 'VariableNames', { ...
    'Scene', 'Baseline', 'Source', 'CVFN', 'BaselineN', ...
    'CVFMean', 'CVFStd', 'CVFMedian', 'BaselineMean', 'BaselineStd', ...
    'BaselineMedian', 'RawP', 'RawSignificant', 'RankSumStatistic', ...
    'CliffsDeltaLowerBetter', 'EffectMagnitude', 'SceneHolmResult', ...
    'SceneHolmP'});
pairwise.SceneHolmSignificant = pairwise.SceneHolmP < alpha;
pairwise = movevars(pairwise, 'SceneHolmSignificant', 'Before', 'SceneHolmResult');
end

function pairwise = localBuildAblationPairwiseTable(runs, scenes, algorithms, alpha)
rows = cell(0, 18);
for sceneId = scenes
    sceneRows = cell(numel(algorithms), 18);
    cvf = localFitness(runs, sceneId, "CVF-AE");
    for idx = 1:numel(algorithms)
        algorithm = algorithms(idx);
        baseline = localFitness(runs, sceneId, algorithm);
        [p, h, stats] = ranksum(cvf, baseline, 'alpha', alpha, ...
            'tail', 'both', 'method', 'approximate');
        delta = localLowerIsBetterCliffsDelta(cvf, baseline);
        sceneRows(idx, :) = {sceneId, algorithm, "formal-ablation", ...
            numel(cvf), numel(baseline), mean(cvf), std(cvf), median(cvf), ...
            mean(baseline), std(baseline), median(baseline), p, logical(h), ...
            stats.ranksum, delta, localEffectMagnitude(delta), "", NaN};
    end
    rawP = cell2mat(sceneRows(:, 12));
    adjustedP = localHolmAdjust(rawP);
    for idx = 1:numel(algorithms)
        sceneRows{idx, 17} = localSingleResult( ...
            adjustedP(idx) < alpha, sceneRows{idx, 6}, sceneRows{idx, 9});
        sceneRows{idx, 18} = adjustedP(idx);
    end
    rows = [rows; sceneRows]; %#ok<AGROW>
end

pairwise = cell2table(rows, 'VariableNames', { ...
    'Scene', 'Baseline', 'Source', 'CVFN', 'BaselineN', ...
    'CVFMean', 'CVFStd', 'CVFMedian', 'BaselineMean', 'BaselineStd', ...
    'BaselineMedian', 'RawP', 'RawSignificant', 'RankSumStatistic', ...
    'CliffsDeltaLowerBetter', 'EffectMagnitude', 'SceneHolmResult', ...
    'SceneHolmP'});
pairwise.SceneHolmSignificant = pairwise.SceneHolmP < alpha;
pairwise = movevars(pairwise, 'SceneHolmSignificant', 'Before', 'SceneHolmResult');
end

function omnibus = localBuildOmnibusTable(runs, scenes, algorithms, alpha)
allAlgorithms = ["CVF-AE", algorithms];
rows = cell(numel(scenes), 8);
for sceneIdx = 1:numel(scenes)
    sceneId = scenes(sceneIdx);
    values = zeros(0, 1);
    groups = strings(0, 1);
    sampleCounts = zeros(numel(allAlgorithms), 1);
    for algIdx = 1:numel(allAlgorithms)
        vals = localFitness(runs, sceneId, allAlgorithms(algIdx));
        values = [values; vals]; %#ok<AGROW>
        groups = [groups; repmat(allAlgorithms(algIdx), numel(vals), 1)]; %#ok<AGROW>
        sampleCounts(algIdx) = numel(vals);
    end
    [p, analysisTable] = kruskalwallis(values, cellstr(groups), 'off');
    chiSquare = analysisTable{2, 5};
    rows(sceneIdx, :) = {sceneId, numel(allAlgorithms), numel(values), ...
        min(sampleCounts), max(sampleCounts), chiSquare, p, p < alpha};
end
omnibus = cell2table(rows, 'VariableNames', { ...
    'Scene', 'NumAlgorithms', 'TotalSamples', 'MinSamplesPerAlgorithm', ...
    'MaxSamplesPerAlgorithm', 'ChiSquare', 'PValue', 'Significant'});
end

function wtl = localBuildWTLTable(pairwise, groupNames)
rows = cell(0, 8);
for groupName = groupNames
    if groupName == "all"
        selected = true(height(pairwise), 1);
    else
        selected = pairwise.Source == groupName;
    end
    groupRows = pairwise(selected, :);
    rows(end + 1, :) = localWTLRow(groupName, "all-scenes", groupRows); %#ok<AGROW>
    for sceneId = unique(groupRows.Scene, 'stable')'
        rows(end + 1, :) = localWTLRow( ...
            groupName, "Scene " + sceneId, groupRows(groupRows.Scene == sceneId, :)); %#ok<AGROW>
    end
end
wtl = cell2table(rows, 'VariableNames', { ...
    'ComparisonGroup', 'Scope', 'NumComparisons', 'Wins', 'Ties', 'Losses', ...
    'MedianCliffsDelta', 'MeanCliffsDelta'});
end

function row = localWTLRow(groupName, scope, rows)
labels = rows.SceneHolmResult;
row = {groupName, scope, height(rows), sum(labels == "+"), ...
    sum(labels == "="), sum(labels == "-"), ...
    median(rows.CliffsDeltaLowerBetter), mean(rows.CliffsDeltaLowerBetter)};
end

function values = localFitness(runs, sceneId, algorithm)
mask = runs.Scene == sceneId & strcmpi(runs.Algorithm, algorithm);
values = runs.BestFitness(mask);
values = values(isfinite(values));
assert(~isempty(values), 'No finite BestFitness values for Scene %d, %s.', ...
    sceneId, algorithm);
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

function magnitude = localEffectMagnitude(delta)
absoluteDelta = abs(delta);
if absoluteDelta < 0.147
    magnitude = "negligible";
elseif absoluteDelta < 0.33
    magnitude = "small";
elseif absoluteDelta < 0.474
    magnitude = "medium";
else
    magnitude = "large";
end
end

function labels = localResultLabels(significant, cvfMean, baselineMean)
labels = strings(numel(significant), 1);
for idx = 1:numel(significant)
    labels(idx) = localSingleResult(significant(idx), cvfMean(idx), baselineMean(idx));
end
end

function label = localSingleResult(significant, cvfMean, baselineMean)
if ~significant
    label = "=";
elseif cvfMean < baselineMean
    label = "+";
else
    label = "-";
end
end

function localWriteInterpretation(filePath, mainDir, recentDir, ablationDir, ...
    pairwise, omnibus, wtl, ablationPairwise, ablationOmnibus, ...
    ablationWTL, alpha)
fid = fopen(filePath, 'w');
assert(fid >= 0, 'Cannot open interpretation file: %s', filePath);
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# CVF-AE 正式显著性检验说明\n\n');
fprintf(fid, '生成日期：2026-06-24\n\n');
fprintf(fid, '## 数据来源\n\n');
fprintf(fid, '- 正式主对比：`%s`\n', mainDir);
fprintf(fid, '- 近年改进算法补充：`%s`\n\n', recentDir);
fprintf(fid, '- 正式消融：`%s`\n\n', ablationDir);
fprintf(fid, '两批实验中，不同算法的随机种子均包含算法序号偏移，');
fprintf(fid, '因此算法之间不是严格配对样本。本分析统一采用双侧 Wilcoxon rank-sum ');
fprintf(fid, '检验（Mann-Whitney U），不使用配对 signed-rank 检验。\n\n');

fprintf(fid, '## 检验规则\n\n');
fprintf(fid, '- 显著性水平：`alpha = %.2f`。\n', alpha);
fprintf(fid, '- 每个场景包含 10 个 `CVF-AE` 对基线比较，论文主结论使用场景内 Holm 校正 p 值。\n');
fprintf(fid, '- 同时输出跨 30 个比较的全局 Holm 校正值，作为更保守的补充结果。\n');
fprintf(fid, '- `+`：CVF-AE 显著更优；`=`：差异不显著；`-`：CVF-AE 显著更差。\n');
fprintf(fid, '- Cliff''s delta 按最小化问题定义，正值表示 CVF-AE 更优。\n');
fprintf(fid, '- Kruskal-Wallis 用于检验每个场景下 11 个算法的总体分布差异。\n\n');

fprintf(fid, '## 总体检验\n\n');
fprintf(fid, '| Scene | Chi-square | p-value | Significant |\n');
fprintf(fid, '|---:|---:|---:|:---:|\n');
for idx = 1:height(omnibus)
    fprintf(fid, '| %d | %.4f | %.4g | %s |\n', omnibus.Scene(idx), ...
        omnibus.ChiSquare(idx), omnibus.PValue(idx), ...
        localYesNo(omnibus.Significant(idx)));
end

fprintf(fid, '\n## Holm 校正胜/平/负\n\n');
fprintf(fid, '| Group | Scope | Comparisons | Win | Tie | Loss | Median delta |\n');
fprintf(fid, '|---|---|---:|---:|---:|---:|---:|\n');
for idx = 1:height(wtl)
    fprintf(fid, '| %s | %s | %d | %d | %d | %d | %.3f |\n', ...
        wtl.ComparisonGroup(idx), wtl.Scope(idx), wtl.NumComparisons(idx), ...
        wtl.Wins(idx), wtl.Ties(idx), wtl.Losses(idx), ...
        wtl.MedianCliffsDelta(idx));
end

fprintf(fid, '\n## 分场景关键结果\n\n');
for sceneId = unique(pairwise.Scene, 'stable')'
    sceneRows = pairwise(pairwise.Scene == sceneId, :);
    fprintf(fid, '### Scene %d\n\n', sceneId);
    fprintf(fid, '| Baseline | Source | CVF mean | Baseline mean | Raw p | Holm p | Result | Delta | Effect |\n');
    fprintf(fid, '|---|---|---:|---:|---:|---:|:---:|---:|---|\n');
    for idx = 1:height(sceneRows)
        fprintf(fid, '| %s | %s | %.4f | %.4f | %.4g | %.4g | %s | %.3f | %s |\n', ...
            sceneRows.Baseline(idx), sceneRows.Source(idx), sceneRows.CVFMean(idx), ...
            sceneRows.BaselineMean(idx), sceneRows.RawP(idx), ...
            sceneRows.SceneHolmP(idx), sceneRows.SceneHolmResult(idx), ...
            sceneRows.CliffsDeltaLowerBetter(idx), sceneRows.EffectMagnitude(idx));
    end
    fprintf(fid, '\n');
end

fprintf(fid, '## 正式消融显著性\n\n');
fprintf(fid, '### 总体检验\n\n');
fprintf(fid, '| Scene | Chi-square | p-value | Significant |\n');
fprintf(fid, '|---:|---:|---:|:---:|\n');
for idx = 1:height(ablationOmnibus)
    fprintf(fid, '| %d | %.4f | %.4g | %s |\n', ablationOmnibus.Scene(idx), ...
        ablationOmnibus.ChiSquare(idx), ablationOmnibus.PValue(idx), ...
        localYesNo(ablationOmnibus.Significant(idx)));
end

fprintf(fid, '\n### Holm 校正胜/平/负\n\n');
fprintf(fid, '| Scope | Comparisons | Win | Tie | Loss | Median delta |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|\n');
for idx = 1:height(ablationWTL)
    if ablationWTL.ComparisonGroup(idx) ~= "all"
        continue;
    end
    fprintf(fid, '| %s | %d | %d | %d | %d | %.3f |\n', ...
        ablationWTL.Scope(idx), ablationWTL.NumComparisons(idx), ...
        ablationWTL.Wins(idx), ablationWTL.Ties(idx), ...
        ablationWTL.Losses(idx), ablationWTL.MedianCliffsDelta(idx));
end

fprintf(fid, '\n### 分场景结果\n\n');
for sceneId = unique(ablationPairwise.Scene, 'stable')'
    sceneRows = ablationPairwise(ablationPairwise.Scene == sceneId, :);
    fprintf(fid, '#### Scene %d\n\n', sceneId);
    fprintf(fid, '| Variant | CVF mean | Variant mean | Raw p | Holm p | Result | Delta | Effect |\n');
    fprintf(fid, '|---|---:|---:|---:|---:|:---:|---:|---|\n');
    for idx = 1:height(sceneRows)
        fprintf(fid, '| %s | %.4f | %.4f | %.4g | %.4g | %s | %.3f | %s |\n', ...
            sceneRows.Baseline(idx), sceneRows.CVFMean(idx), ...
            sceneRows.BaselineMean(idx), sceneRows.RawP(idx), ...
            sceneRows.SceneHolmP(idx), sceneRows.SceneHolmResult(idx), ...
            sceneRows.CliffsDeltaLowerBetter(idx), sceneRows.EffectMagnitude(idx));
    end
    fprintf(fid, '\n');
end

fprintf(fid, '## 写作边界\n\n');
fprintf(fid, '- 不应将不同算法视为配对样本，也不应把本结果写成 paired Wilcoxon signed-rank test。\n');
fprintf(fid, '- 显著性只说明最终 `BestFitness` 分布差异，不能替代 feasible rate 和 trajectory sanity 分析。\n');
fprintf(fid, '- 对 CPO、GDSAO、ERIME 和 MSCSO 的结论必须继续结合高空绕行、边界贴靠和可行率解释。\n');
fprintf(fid, '- 论文主表建议报告 Holm 校正结果；原始 p 值可放补充材料。\n');

clear cleanup;
end

function text = localYesNo(value)
if value
    text = "yes";
else
    text = "no";
end
end
