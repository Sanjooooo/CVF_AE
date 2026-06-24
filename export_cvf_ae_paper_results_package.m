function outputs = export_cvf_ae_paper_results_package(outDir)
%EXPORT_CVF_AE_PAPER_RESULTS_PACKAGE Export paper-ready CVF-AE tables and index.
%
% This function only reuses existing formal CSV and PNG artifacts. It does
% not rerun any optimization experiment.

projectRoot = fileparts(mfilename('fullpath'));
resultsRoot = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results');
if nargin < 1 || isempty(outDir)
    outDir = fullfile(resultsRoot, ...
        'cvf_ae_paper_results_package_20260624_from_formal_results');
end
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

sources = localSourcePaths(resultsRoot);
localAssertSources(sources);

main = readtable(sources.extendedMain, 'TextType', 'string');
avgRank = readtable(sources.extendedRank, 'TextType', 'string');
sanity = readtable(sources.extendedSanity, 'TextType', 'string');
significance = readtable(sources.mainSignificance, 'TextType', 'string');
ablation = readtable(sources.ablation, 'TextType', 'string');
ablationRank = readtable(sources.ablationRank, 'TextType', 'string');
ablationSignificance = readtable(sources.ablationSignificance, 'TextType', 'string');
paramSummary = readtable(sources.paramSummary, 'TextType', 'string');
paramRank = readtable(sources.paramRank, 'TextType', 'string');
runtimeMain = readtable(sources.runtimeMain, 'TextType', 'string');
runtimeAblation = readtable(sources.runtimeAblation, 'TextType', 'string');

main.Scene = cvfAePaperSceneId(main.Scene);
sanity.Scene = cvfAePaperSceneId(sanity.Scene);
ablation.Scene = cvfAePaperSceneId(ablation.Scene);
paramSummary.Scene = cvfAePaperSceneId(paramSummary.Scene);
runtimeMain.Scene = cvfAePaperSceneId(runtimeMain.Scene);
runtimeAblation.Scene = cvfAePaperSceneId(runtimeAblation.Scene);

tables = struct();
tables.mainExtended = localMakeMainExtended(main, avgRank, sanity);
tables.mainCompact = localMakeMainCompact(tables.mainExtended);
tables.mainSignificance = localMakeSignificance(significance);
tables.ablation = localMakeAblation(ablation, ablationRank);
tables.ablationSignificance = localMakeSignificance(ablationSignificance);
tables.parameterSensitivity = localMakeParameterSensitivity(paramSummary, paramRank);
tables.overhead = localMakeOverhead(runtimeMain, runtimeAblation);
tables.trajectorySanity = localMakeTrajectorySanity(sanity);
tables.figureIndex = localMakeFigureIndex(projectRoot, sources);

fileMap = struct();
fileMap.mainExtended = 'paper_table_main_extended_long.csv';
fileMap.mainCompact = 'paper_table_main_compact.csv';
fileMap.mainSignificance = 'paper_table_main_significance.csv';
fileMap.ablation = 'paper_table_ablation.csv';
fileMap.ablationSignificance = 'paper_table_ablation_significance.csv';
fileMap.parameterSensitivity = 'paper_table_parameter_sensitivity.csv';
fileMap.overhead = 'paper_table_overhead.csv';
fileMap.trajectorySanity = 'paper_table_trajectory_sanity.csv';
fileMap.figureIndex = 'paper_figure_index.csv';

names = fieldnames(fileMap);
for idx = 1:numel(names)
    name = names{idx};
    writetable(tables.(name), fullfile(outDir, fileMap.(name)));
end

localWriteReadme(fullfile(outDir, 'CVF_AE_PAPER_RESULTS_PACKAGE_README.md'), ...
    sources, fileMap, tables);
localWriteDraft(fullfile(outDir, 'CVF_AE_PAPER_RESULTS_WRITEUP_DRAFT.md'), ...
    tables);

outputs = struct();
outputs.outDir = outDir;
outputs.tables = tables;
outputs.files = fileMap;

fprintf('\n=== CVF-AE Paper Results Package ===\n');
fprintf('Output folder: %s\n', outDir);
fprintf('CSV tables   : %d\n', numel(names));
fprintf('Figure rows  : %d\n', height(tables.figureIndex));
fprintf('Main rows    : %d\n', height(tables.mainExtended));
fprintf('Ablation rows: %d\n', height(tables.ablation));
end

function sources = localSourcePaths(resultsRoot)
sources.extendedDir = fullfile(resultsRoot, ...
    'cvf_ae_extended_main_comparison_20260623_from_formal_and_recent');
sources.extendedMain = fullfile(sources.extendedDir, ...
    'extended_main_comparison_summary_long.csv');
sources.extendedRank = fullfile(sources.extendedDir, ...
    'extended_main_comparison_average_rank.csv');
sources.extendedSanity = fullfile(sources.extendedDir, ...
    'extended_main_comparison_trajectory_sanity_summary.csv');

sources.significanceDir = fullfile(resultsRoot, ...
    'cvf_ae_formal_significance_20260624_from_formal_results');
sources.mainSignificance = fullfile(sources.significanceDir, ...
    'cvf_ae_pairwise_rank_sum_holm.csv');
sources.ablationSignificance = fullfile(sources.significanceDir, ...
    'cvf_ae_ablation_pairwise_rank_sum_holm.csv');

sources.ablationDir = fullfile(resultsRoot, ...
    'cvf_ae_formal_ablation_conservative_20260622_194947');
sources.ablation = fullfile(sources.ablationDir, 'cvf_ae_gate_summary.csv');
sources.ablationRank = fullfile(sources.ablationDir, ...
    'cvf_ae_gate_average_rank.csv');

sources.paramDir = fullfile(resultsRoot, ...
    'cvf_ae_param_sensitivity_conservative_20260623_131249');
sources.paramSummary = fullfile(sources.paramDir, ...
    'cvf_ae_param_sensitivity_summary.csv');
sources.paramRank = fullfile(sources.paramDir, ...
    'cvf_ae_param_sensitivity_rank_summary.csv');

sources.runtimeDir = fullfile(resultsRoot, ...
    'cvf_ae_runtime_overhead_analysis_20260623_from_existing_results');
sources.runtimeMain = fullfile(sources.runtimeDir, ...
    'main_comparison_overhead.csv');
sources.runtimeAblation = fullfile(sources.runtimeDir, ...
    'ablation_overhead_vs_without_cvf.csv');

sources.convergenceDir = fullfile(resultsRoot, ...
    'cvf_ae_convergence_curves_20260623_from_main_comparison');
sources.pathDir = fullfile(resultsRoot, ...
    'cvf_ae_representative_paths_20260623_from_formal_results');
sources.completionDir = fullfile(resultsRoot, ...
    'cvf_ae_paper_completion_figures_20260624_from_formal_results');
end

function localAssertSources(sources)
names = fieldnames(sources);
for idx = 1:numel(names)
    value = sources.(names{idx});
    if endsWith(names{idx}, 'Dir')
        assert(isfolder(value), 'Missing source directory: %s', value);
    else
        assert(isfile(value), 'Missing source file: %s', value);
    end
end
end

function T = localMakeMainExtended(main, avgRank, sanity)
algorithmOrder = ["CVF-AE", "CPO", "GDSAO", "MSCSO", "ERIME", ...
    "DBO", "GWO", "HHO", "PSO", "WOA", "AE"];
T = outerjoin(main, avgRank(:, {'Algorithm','AverageRank'}), ...
    'Keys', 'Algorithm', 'MergeKeys', true, 'Type', 'left');
sanityKeep = sanity(:, {'Scene','Algorithm','MeanHighAltitudeFrac', ...
    'MeanDetourRatio','MeanBoundaryHugFrac','VisualReviewFlagRate'});
T = outerjoin(T, sanityKeep, 'Keys', {'Scene','Algorithm'}, ...
    'MergeKeys', true, 'Type', 'left');
T.MeanStd = compose("%.4f +/- %.4f", T.Mean, T.Std);
T.AlgorithmOrder = localOrder(T.Algorithm, algorithmOrder);
T = sortrows(T, {'Scene','AlgorithmOrder'});
T = T(:, {'Scene','Algorithm','Mean','Std','MeanStd','Feasibility', ...
    'ExtendedRank','AverageRank','AvgRuntime','AvgNEvals', ...
    'AvgFirstFeasibleIter','VisualReviewFlagRate', ...
    'MeanHighAltitudeFrac','MeanBoundaryHugFrac','MeanDetourRatio','Source'});
T.Properties.VariableNames = {'Scene','Algorithm','MeanFitness','StdFitness', ...
    'MeanPlusMinusStd','FeasibleRate','SceneRank','AverageRank', ...
    'RuntimeSeconds','NEvals','FirstFeasibleIteration','VisualReviewFlagRate', ...
    'HighAltitudeFraction','BoundaryHugFraction','DetourRatio','Source'};
end

function T = localMakeMainCompact(longTable)
algorithmOrder = unique(longTable.Algorithm, 'stable');
scenes = [1, 2, 3];
rows = cell(numel(algorithmOrder), 12);
for algIdx = 1:numel(algorithmOrder)
    alg = algorithmOrder(algIdx);
    algRows = longTable(longTable.Algorithm == alg, :);
    row = cell(1, 12);
    row{1} = alg;
    column = 2;
    for sceneId = scenes
        sceneRow = algRows(algRows.Scene == sceneId, :);
        row{column} = sceneRow.MeanPlusMinusStd(1);
        row{column + 1} = sceneRow.FeasibleRate(1);
        row{column + 2} = sceneRow.SceneRank(1);
        column = column + 3;
    end
    row{11} = algRows.AverageRank(1);
    row{12} = mean(algRows.VisualReviewFlagRate, 'omitnan');
    rows(algIdx, :) = row;
end
T = cell2table(rows, 'VariableNames', {'Algorithm', ...
    'Scene1MeanStd','Scene1FeasibleRate','Scene1Rank', ...
    'Scene2MeanStd','Scene2FeasibleRate','Scene2Rank', ...
    'Scene3MeanStd','Scene3FeasibleRate','Scene3Rank', ...
    'AverageRank','AverageVisualReviewFlagRate'});
end

function T = localMakeSignificance(S)
T = S(:, {'Scene','Baseline','Source','CVFMean','BaselineMean', ...
    'RawP','SceneHolmP','SceneHolmResult','CliffsDeltaLowerBetter', ...
    'EffectMagnitude','GlobalHolmP','GlobalHolmResult'});
T.Properties.VariableNames = {'Scene','ComparedMethod','Source', ...
    'CVFAEMean','ComparedMean','RawP','SceneHolmP','Result', ...
    'CliffsDelta','EffectMagnitude','GlobalHolmP','GlobalResult'};
end

function T = localMakeAblation(summary, avgRank)
algorithmOrder = ["CVF-AE", "CVF-AE-w/o-CVF", ...
    "CVF-AE-w/o-StateAdaptiveCVF", "CVF-AE-w/o-SparsePreservation", ...
    "CVF-AE-w/o-Init", "Base-AE"];
T = outerjoin(summary, avgRank, 'Keys', 'Algorithm', ...
    'MergeKeys', true, 'Type', 'left');
T.MeanStd = compose("%.4f +/- %.4f", T.MeanBestFitness, T.StdBestFitness);
T.AlgorithmOrder = localOrder(T.Algorithm, algorithmOrder);
T = sortrows(T, {'Scene','AlgorithmOrder'});
T = T(:, {'Scene','Algorithm','MeanBestFitness','StdBestFitness','MeanStd', ...
    'FeasibleRate','Rank','AverageRank','MeanRuntime','MeanNEvals', ...
    'MeanFirstFeasibleIter','MeanRepairCount','MeanViabilityFieldCount', ...
    'MeanViabilityFieldSuccessCount'});
T.Properties.VariableNames = {'Scene','Variant','MeanFitness','StdFitness', ...
    'MeanPlusMinusStd','FeasibleRate','SceneRank','AverageRank', ...
    'RuntimeSeconds','NEvals','FirstFeasibleIteration','RepairCount', ...
    'CVFTriggerCount','CVFSuccessCount'};
end

function T = localMakeParameterSensitivity(summary, avgRank)
rankKeep = avgRank(:, {'ParamKey','Level','AverageRank'});
T = outerjoin(summary, rankKeep, 'Keys', {'ParamKey','Level'}, ...
    'MergeKeys', true, 'Type', 'left');
T.IsDefault = strcmpi(T.Level, "default");
T = sortrows(T, {'ParamKey','Scene','Rank'});
T = T(:, {'ParamKey','ParamLabel','Level','LevelLabel','IsDefault','Scene', ...
    'MeanBestFitness','StdBestFitness','FeasibleRate','Rank','AverageRank', ...
    'MeanRuntime','MeanNEvals','MeanViabilityFieldCount'});
T.Properties.VariableNames = {'Parameter','ParameterLabel','Level', ...
    'LevelDescription','IsDefault','Scene','MeanFitness','StdFitness', ...
    'FeasibleRate','SceneRank','AverageRank','RuntimeSeconds','NEvals', ...
    'CVFTriggerCount'};
end

function T = localMakeOverhead(main, ablation)
main.Analysis = repmat("main-comparison", height(main), 1);
main.RuntimeRatioVsWithoutCVF = nan(height(main), 1);
main.NEvalsRatioVsWithoutCVF = nan(height(main), 1);
ablation.Analysis = repmat("ablation-vs-w/o-CVF", height(ablation), 1);
commonVars = {'Analysis','Scene','Algorithm','Runtime','NEvals', ...
    'ViabilityFieldCount','ViabilityFieldSuccessCount', ...
    'RuntimeRatioVsWithoutCVF','NEvalsRatioVsWithoutCVF','FeasibleRate','Rank'};
T = [main(:, commonVars); ablation(:, commonVars)];
T.Properties.VariableNames = {'Analysis','Scene','Algorithm','RuntimeSeconds', ...
    'NEvals','CVFTriggerCount','CVFSuccessCount','RuntimeRatioVsWithoutCVF', ...
    'NEvalsRatioVsWithoutCVF','FeasibleRate','Rank'};
end

function T = localMakeTrajectorySanity(sanity)
T = sanity(:, {'Scene','Algorithm','FeasibleRate','MeanBestFitness', ...
    'MeanHighAltitudeFrac','MeanDetourRatio','MeanBoundaryHugFrac', ...
    'HighAltitudeFlagRate','BoundaryHugFlagRate','ExcessiveDetourFlagRate', ...
    'VisualReviewFlagRate','Source'});
T.Properties.VariableNames = {'Scene','Algorithm','FeasibleRate', ...
    'MeanFitness','HighAltitudeFraction','DetourRatio','BoundaryHugFraction', ...
    'HighAltitudeFlagRate','BoundaryHugFlagRate','ExcessiveDetourFlagRate', ...
    'VisualReviewFlagRate','Source'};
T = sortrows(T, {'Scene','VisualReviewFlagRate'}, {'ascend','descend'});
end

function T = localMakeFigureIndex(projectRoot, sources)
convergence = dir(fullfile(sources.convergenceDir, '*.png'));
paths = dir(fullfile(sources.pathDir, '**', '*.png'));
completion = dir(fullfile(sources.completionDir, '*.png'));
files = [convergence; paths; completion];
rows = cell(numel(files), 9);
for idx = 1:numel(files)
    absolutePath = fullfile(files(idx).folder, files(idx).name);
    relativePath = erase(absolutePath, [projectRoot filesep]);
    [group, sceneId, viewName, placement, purpose] = ...
        localClassifyFigure(relativePath, files(idx).name);
    rows(idx, :) = {idx, group, sceneId, viewName, files(idx).name, ...
        placement, purpose, "ready", relativePath};
end
T = cell2table(rows, 'VariableNames', {'FigureId','Group','Scene','View', ...
    'FileName','SuggestedPlacement','Purpose','Status','RelativePath'});
T.Scene = string(T.Scene);
T.Scene(T.Scene == "NaN") = "";
T = sortrows(T, {'Group','Scene','View'});
T.FigureId = (1:height(T))';
end

function [group, sceneId, viewName, placement, purpose] = localClassifyFigure(path, name)
sceneToken = regexp(name, 'scene(\d+)', 'tokens', 'once');
if isempty(sceneToken)
    sceneId = NaN;
else
    sceneId = str2double(sceneToken{1});
end
if contains(path, 'convergence')
    group = "convergence";
    viewName = "mean-std";
    placement = "main-text";
    purpose = "Compare feasible-aware convergence behavior";
elseif contains(name, 'parameter_sensitivity')
    group = "parameter-sensitivity";
    viewName = "mean-std";
    placement = "main-text";
    purpose = "Evaluate robustness to key CVF parameters";
elseif contains(name, 'boxplots_strong')
    group = "boxplot";
    viewName = "strong-linear";
    placement = "main-text";
    purpose = "Compare run distributions of six strong algorithms";
elseif contains(name, 'boxplots_all')
    group = "boxplot";
    viewName = "all-log";
    placement = "supplement";
    purpose = "Compare run distributions of all eleven algorithms";
elseif contains(name, 'method_flowchart')
    group = "method";
    viewName = "flowchart";
    placement = "main-text";
    purpose = "Present the complete CVF-AE procedure";
elseif contains(path, [filesep 'extended' filesep])
    group = "extended-path";
    viewName = localView(name);
    if viewName == "top"
        placement = "main-text";
    else
        placement = "supplement";
    end
    purpose = "Compare CVF-AE with strong and recent improved methods";
elseif contains(path, [filesep 'ablation' filesep])
    group = "ablation-path";
    viewName = localView(name);
    if viewName == "top" && ismember(sceneId, [2, 4])
        placement = "main-text";
    else
        placement = "supplement";
    end
    purpose = "Visualize module contribution and failure cases";
else
    group = "main-path";
    viewName = localView(name);
    placement = "supplement";
    purpose = "Classic-baseline representative path comparison";
end
end

function viewName = localView(name)
if contains(name, '_top')
    viewName = "top";
elseif contains(name, '_3d')
    viewName = "3d";
else
    viewName = "unknown";
end
end

function order = localOrder(values, desiredOrder)
order = nan(numel(values), 1);
for idx = 1:numel(desiredOrder)
    order(strcmpi(values, desiredOrder(idx))) = idx;
end
assert(all(isfinite(order)), 'An algorithm is missing from the declared order.');
end

function localWriteReadme(filePath, sources, fileMap, tables)
fid = fopen(filePath, 'w', 'n', 'UTF-8');
assert(fid >= 0, 'Cannot write package README: %s', filePath);
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# CVF-AE 论文结果材料包\n\n');
fprintf(fid, '生成日期：2026-06-24\n\n');
fprintf(fid, '本目录只整理已有正式实验，不重跑优化算法。\n\n');
fprintf(fid, '全部正式结果的中文名称与位置统一记录在：\n\n');
fprintf(fid, '`routes/route_b_cvf_ae/docs/CVF_AE_RESULTS_INDEX.md`\n\n');
fprintf(fid, '- `CVF_AE_PAPER_RESULTS_PACKAGE.xlsx`：集中审阅全部结果表和图索引的格式化工作簿。\n\n');
fprintf(fid, '## 正文建议表格\n\n');
fprintf(fid, '- `%s`：扩展主对比紧凑表，正文主表首选。\n', fileMap.mainCompact);
fprintf(fid, '- `%s`：正式显著性检验，正文可报告 Holm 结果，完整 p 值放补充材料。\n', fileMap.mainSignificance);
fprintf(fid, '- `%s`：正式消融结果。\n', fileMap.ablation);
fprintf(fid, '- `%s`：运行时间、评价次数和 CVF 触发开销。\n\n', fileMap.overhead);
fprintf(fid, '## 补充材料表格\n\n');
fprintf(fid, '- `%s`：扩展主对比完整长表。\n', fileMap.mainExtended);
fprintf(fid, '- `%s`：消融显著性检验。\n', fileMap.ablationSignificance);
fprintf(fid, '- `%s`：参数敏感性完整结果。\n', fileMap.parameterSensitivity);
fprintf(fid, '- `%s`：轨迹 sanity 指标。\n\n', fileMap.trajectorySanity);
fprintf(fid, '## 图索引\n\n');
fprintf(fid, '- `%s`：共 %d 张 PNG，其中正文建议 %d 张，补充材料建议 %d 张。\n\n', ...
    fileMap.figureIndex, height(tables.figureIndex), ...
    nnz(tables.figureIndex.SuggestedPlacement == "main-text"), ...
    nnz(tables.figureIndex.SuggestedPlacement == "supplement"));
fprintf(fid, '## 数据来源\n\n');
fprintf(fid, '- 扩展主对比：`%s`\n', sources.extendedDir);
fprintf(fid, '- 正式显著性：`%s`\n', sources.significanceDir);
fprintf(fid, '- 正式消融：`%s`\n', sources.ablationDir);
fprintf(fid, '- 参数敏感性：`%s`\n', sources.paramDir);
fprintf(fid, '- 开销分析：`%s`\n', sources.runtimeDir);
fprintf(fid, '- 收敛曲线：`%s`\n', sources.convergenceDir);
fprintf(fid, '- 代表轨迹：`%s`\n\n', sources.pathDir);
fprintf(fid, '- 补充论文图：`%s`\n\n', sources.completionDir);
fprintf(fid, '## 使用边界\n\n');
fprintf(fid, '- `MeanPlusMinusStd` 采用纯 ASCII `+/-`，最终排版时替换为数学符号。\n');
fprintf(fid, '- `AverageRank` 是三个 UAV 场景的平均场景名次；Kruskal-Wallis 和 rank-sum 结果另表报告。\n');
fprintf(fid, '- runtime 受 MATLAB 会话和批处理环境影响，应优先解释同批次比值与 `NEvals`。\n');
fprintf(fid, '- scalar fitness 必须与可行率和 trajectory sanity 联合解释。\n');

clear cleanup;
end

function localWriteDraft(filePath, tables)
fid = fopen(filePath, 'w', 'n', 'UTF-8');
assert(fid >= 0, 'Cannot write results draft: %s', filePath);
cleanup = onCleanup(@() fclose(fid));

main = tables.mainExtended;
significance = tables.mainSignificance;
ablation = tables.ablation;

fprintf(fid, '# CVF-AE 论文结果分析初稿\n\n');
fprintf(fid, '## 主对比\n\n');
fprintf(fid, '在三个强约束 UAV 场景和 11 个算法的扩展对比中，');
fprintf(fid, '`CVF-AE` 的平均场景排名为 %.2f，位列第一。', ...
    main.AverageRank(main.Algorithm == "CVF-AE" & main.Scene == 1));
fprintf(fid, '其三个场景可行率均为 1.00，说明方法能够稳定形成满足约束的路径。');
fprintf(fid, '该结论应表述为综合竞争力与可行性更均衡，而不是每个场景的 scalar fitness 均最优。\n\n');

losses = significance(significance.Result == "-", :);
fprintf(fid, 'Holm 校正后的成对秩和检验共出现 %d 个显著劣势，', height(losses));
for idx = 1:height(losses)
    fprintf(fid, 'Scene %d 相对 `%s`%s', losses.Scene(idx), ...
        losses.ComparedMethod(idx), localDelimiter(idx, height(losses)));
end
fprintf(fid, '。其中 CPO 和 MSCSO 在 Scene 2 的 scalar fitness 更低，');
fprintf(fid, '但最终讨论仍需结合高空绕行、可行率和轨迹复核指标。\n\n');

scene3 = main(main.Scene == 3 & ismember(main.Algorithm, ["CVF-AE","GDSAO"]), :);
fprintf(fid, 'Scene 3 中，`GDSAO` 的平均 fitness 为 %.4f，`CVF-AE` 为 %.4f；', ...
    scene3.MeanFitness(scene3.Algorithm == "GDSAO"), ...
    scene3.MeanFitness(scene3.Algorithm == "CVF-AE"));
fprintf(fid, '两者经 Holm 校正后差异不显著。GDSAO 同时存在较高边界贴靠复核风险，');
fprintf(fid, '因此不宜仅依据均值判定其路径规划质量更优。\n\n');

fprintf(fid, '## 消融实验\n\n');
fullRows = ablation(ablation.Variant == "CVF-AE", :);
fprintf(fid, '完整 `CVF-AE` 在三个场景中的平均排名为 %.2f。', fullRows.AverageRank(1));
fprintf(fid, '正式消融显著性结果为 9 胜、6 平、0 负，');
fprintf(fid, '表明完整机制未在任何场景显著弱于删减版本。');
fprintf(fid, '不过，状态自适应 CVF 和部分稀疏保持组件在个别场景未达到统计显著，');
fprintf(fid, '因此更准确的结论是各组件在不同约束阶段形成互补，而非每个组件在所有场景独立显著。\n\n');

fprintf(fid, '## 运行开销\n\n');
fprintf(fid, '正式消融中，完整方法相对 `w/o-CVF` 的平均 runtime ratio 为 0.976，');
fprintf(fid, '平均 `NEvals` ratio 为 1.011。结果支持“低额外评价次数和受控运行时间开销”，');
fprintf(fid, '但不支持“无开销”或“稳定加速”的表述。\n\n');

fprintf(fid, '## 参数敏感性\n\n');
fprintf(fid, '小范围敏感性实验未发现一个非默认参数能够同时在 fitness、评价次数、');
fprintf(fid, 'CVF 触发次数和轨迹合理性上稳定优于默认值。');
fprintf(fid, '因此默认参数保持冻结，并将结论限定为对关键 CVF 参数具有一定鲁棒性。\n\n');

fprintf(fid, '## 推荐总论\n\n');
fprintf(fid, '`CVF-AE` 的主要优势不是在所有场景获得最低单一目标值，而是在');
fprintf(fid, '完整可行率、平均排名、强约束场景稳定性、受控评价开销和轨迹合理性之间取得更均衡的结果。\n');

clear cleanup;
end

function text = localDelimiter(index, count)
if index < count
    text = "，";
else
    text = "";
end
end
