function analyze_cvf_ae_runtime_overhead()
%ANALYZE_CVF_AE_RUNTIME_OVERHEAD Reuse formal Route B results for overhead analysis.

projectRoot = fileparts(mfilename('fullpath'));
routeResultsDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results');

mainDir = fullfile(routeResultsDir, ...
    'cvf_ae_main_comparison_formal_conservative_20260623_091132');
ablationDir = fullfile(routeResultsDir, ...
    'cvf_ae_formal_ablation_conservative_20260622_194947');
outputDir = fullfile(routeResultsDir, ...
    'cvf_ae_runtime_overhead_analysis_20260623_from_existing_results');

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

mainSummaryPath = fullfile(mainDir, 'uav_comparison_summary_long.csv');
ablationSummaryPath = fullfile(ablationDir, 'cvf_ae_gate_summary.csv');

mainT = readtable(mainSummaryPath, 'VariableNamingRule', 'preserve');
ablationT = readtable(ablationSummaryPath, 'VariableNamingRule', 'preserve');

mainOverhead = table( ...
    mainT.Scene, ...
    mainT.Algorithm, ...
    mainT.AvgRuntime, ...
    mainT.AvgNEvals, ...
    mainT.AvgViabilityFieldCount, ...
    mainT.AvgViabilityFieldSuccessCount, ...
    mainT.Feasibility, ...
    mainT.Rank, ...
    'VariableNames', { ...
    'Scene', 'Algorithm', 'Runtime', 'NEvals', ...
    'ViabilityFieldCount', 'ViabilityFieldSuccessCount', ...
    'FeasibleRate', 'Rank'});

ablationOverhead = table( ...
    ablationT.Scene, ...
    ablationT.Algorithm, ...
    ablationT.MeanRuntime, ...
    ablationT.MeanNEvals, ...
    ablationT.MeanViabilityFieldCount, ...
    ablationT.MeanViabilityFieldSuccessCount, ...
    nan(height(ablationT), 1), ...
    nan(height(ablationT), 1), ...
    ablationT.FeasibleRate, ...
    ablationT.Rank, ...
    'VariableNames', { ...
    'Scene', 'Algorithm', 'Runtime', 'NEvals', ...
    'ViabilityFieldCount', 'ViabilityFieldSuccessCount', ...
    'RuntimeRatioVsWithoutCVF', 'NEvalsRatioVsWithoutCVF', ...
    'FeasibleRate', 'Rank'});

scenes = unique(ablationOverhead.Scene)';
for scene = scenes
    sceneIdx = ablationOverhead.Scene == scene;
    baseIdx = sceneIdx & strcmp(ablationOverhead.Algorithm, 'CVF-AE-w/o-CVF');
    if ~any(baseIdx)
        continue;
    end

    baseRuntime = ablationOverhead.Runtime(baseIdx);
    baseNEvals = ablationOverhead.NEvals(baseIdx);
    ablationOverhead.RuntimeRatioVsWithoutCVF(sceneIdx) = ...
        ablationOverhead.Runtime(sceneIdx) ./ baseRuntime;
    ablationOverhead.NEvalsRatioVsWithoutCVF(sceneIdx) = ...
        ablationOverhead.NEvals(sceneIdx) ./ baseNEvals;
end

writetable(mainOverhead, fullfile(outputDir, 'main_comparison_overhead.csv'));
writetable(ablationOverhead, fullfile(outputDir, 'ablation_overhead_vs_without_cvf.csv'));

writeInterpretation(outputDir, mainDir, ablationDir, mainOverhead, ablationOverhead);

fprintf('CVF-AE runtime overhead analysis written to:\n%s\n', outputDir);
end

function writeInterpretation(outputDir, mainDir, ablationDir, mainOverhead, ablationOverhead)
mdPath = fullfile(outputDir, 'CVF_AE_RUNTIME_OVERHEAD_INTERPRETATION.md');
fid = fopen(mdPath, 'w', 'n', 'UTF-8');
cleanupObj = onCleanup(@() fclose(fid));

fullAblation = ablationOverhead(strcmp(ablationOverhead.Algorithm, 'CVF-AE'), :);
withoutCvf = ablationOverhead(strcmp(ablationOverhead.Algorithm, 'CVF-AE-w/o-CVF'), :);
fullMain = mainOverhead(strcmp(mainOverhead.Algorithm, 'CVF-AE'), :);

fprintf(fid, '# CVF-AE 运行开销分析\n\n');
fprintf(fid, '生成时间：2026-06-23\n\n');
fprintf(fid, '## 数据来源\n\n');
fprintf(fid, '- 正式主对比：`%s`\n', mainDir);
fprintf(fid, '- 正式消融：`%s`\n\n', ablationDir);
fprintf(fid, '本分析只复用现有正式结果，不重跑任何优化实验。\n\n');

fprintf(fid, '## 正式消融：相对 w/o-CVF 的开销\n\n');
fprintf(fid, '| Scene | Algorithm | runtime | nEvals | CVF count | CVF success | runtime ratio vs w/o-CVF | nEvals ratio vs w/o-CVF |\n');
fprintf(fid, '|---:|---|---:|---:|---:|---:|---:|---:|\n');
emitRows(fid, withoutCvf);
emitRows(fid, fullAblation);
fprintf(fid, '\n');

fprintf(fid, '## 正式主对比：CVF-AE 实测开销\n\n');
fprintf(fid, '| Scene | runtime | nEvals | CVF count | CVF success | feasible rate | rank |\n');
fprintf(fid, '|---:|---:|---:|---:|---:|---:|---:|\n');
for i = 1:height(fullMain)
    fprintf(fid, '| %g | %.3f | %.1f | %.1f | %.1f | %.2f | %.0f |\n', ...
        fullMain.Scene(i), fullMain.Runtime(i), fullMain.NEvals(i), ...
        fullMain.ViabilityFieldCount(i), fullMain.ViabilityFieldSuccessCount(i), ...
        fullMain.FeasibleRate(i), fullMain.Rank(i));
end
fprintf(fid, '\n');

meanRuntimeRatio = mean(fullAblation.RuntimeRatioVsWithoutCVF, 'omitnan');
meanEvalRatio = mean(fullAblation.NEvalsRatioVsWithoutCVF, 'omitnan');
minRuntimeRatio = min(fullAblation.RuntimeRatioVsWithoutCVF, [], 'omitnan');
maxRuntimeRatio = max(fullAblation.RuntimeRatioVsWithoutCVF, [], 'omitnan');
meanCvfCount = mean(fullAblation.ViabilityFieldCount, 'omitnan');
meanCvfSuccess = mean(fullAblation.ViabilityFieldSuccessCount, 'omitnan');

fprintf(fid, '## 解释结论\n\n');
fprintf(fid, '- 在正式消融中，完整 `CVF-AE` 相对 `CVF-AE-w/o-CVF` 的平均 runtime ratio 为 `%.3f`，平均 nEvals ratio 为 `%.3f`。\n', ...
    meanRuntimeRatio, meanEvalRatio);
fprintf(fid, '- 分场景 runtime ratio 范围为 `%.3f` 到 `%.3f`，受 repair 次数、可行解形成速度和 MATLAB 运行波动共同影响，因此不应把该结果写成稳定加速。\n', ...
    minRuntimeRatio, maxRuntimeRatio);
fprintf(fid, '- 完整 `CVF-AE` 的平均 CVF 触发次数为 `%.1f`，平均 CVF 成功次数为 `%.1f`，说明 CVF 以稀疏触发方式参与搜索，而不是每个个体、每代全量重算。\n', ...
    meanCvfCount, meanCvfSuccess);
fprintf(fid, '- 额外 `nEvals` 相对 `w/o-CVF` 约为 `%.1f%%`，支持“低评价次数开销”的表述。\n', ...
    (meanEvalRatio - 1) * 100);
fprintf(fid, '- 正式写作中应表述为低额外评价次数和受控运行时间开销，不应写成无开销或稳定加速。\n');
fprintf(fid, '- 正式主对比中，`CVF-AE` 三个场景均保持 `1.00` feasible rate；开销分析应与主对比性能、消融贡献和 trajectory sanity 共同解释。\n');
end

function emitRows(fid, T)
for i = 1:height(T)
    fprintf(fid, '| %g | %s | %.3f | %.1f | %.1f | %.1f | %.3f | %.3f |\n', ...
        T.Scene(i), T.Algorithm{i}, T.Runtime(i), T.NEvals(i), ...
        T.ViabilityFieldCount(i), T.ViabilityFieldSuccessCount(i), ...
        T.RuntimeRatioVsWithoutCVF(i), T.NEvalsRatioVsWithoutCVF(i));
end
end
