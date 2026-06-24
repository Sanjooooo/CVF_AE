function outputs = make_cvf_ae_paper_completion_figures(outDir)
%MAKE_CVF_AE_PAPER_COMPLETION_FIGURES Generate remaining paper figures.
%
% Reuses existing formal result CSV files. No optimization is rerun.

projectRoot = fileparts(mfilename('fullpath'));
resultsRoot = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results');
if nargin < 1 || isempty(outDir)
    outDir = fullfile(resultsRoot, ...
        'cvf_ae_paper_completion_figures_20260624_from_formal_results');
end
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

paramFile = fullfile(resultsRoot, ...
    'cvf_ae_param_sensitivity_conservative_20260623_131249', ...
    'cvf_ae_param_sensitivity_summary.csv');
mainRunFile = fullfile(resultsRoot, ...
    'cvf_ae_main_comparison_formal_conservative_20260623_091132', ...
    'uav_comparison_runs.csv');
recentRunFile = fullfile(resultsRoot, ...
    'cvf_ae_main_comparison_recent_improved_formal_20260623_161229', ...
    'uav_comparison_runs.csv');

assert(isfile(paramFile), 'Missing parameter sensitivity summary: %s', paramFile);
assert(isfile(mainRunFile), 'Missing formal main run table: %s', mainRunFile);
assert(isfile(recentRunFile), 'Missing recent-improved run table: %s', recentRunFile);

paramSummary = readtable(paramFile, 'TextType', 'string');
mainRuns = readtable(mainRunFile, 'TextType', 'string');
recentRuns = readtable(recentRunFile, 'TextType', 'string');
allRuns = [mainRuns; recentRuns];

localPlotParameterSensitivity(paramSummary, outDir);
localPlotStrongBoxplots(allRuns, outDir);
localPlotAllBoxplots(allRuns, outDir);
localPlotFlowchart(outDir);
localWriteFigureIndex(outDir);
localWriteInterpretation(outDir, paramFile, mainRunFile, recentRunFile);

outputs = struct();
outputs.outDir = outDir;
outputs.parameterFigure = fullfile(outDir, 'cvf_ae_parameter_sensitivity.png');
outputs.strongBoxplotFigure = fullfile(outDir, ...
    'cvf_ae_boxplots_strong_algorithms.png');
outputs.allBoxplotFigure = fullfile(outDir, ...
    'cvf_ae_boxplots_all_algorithms_log.png');
outputs.flowchartFigure = fullfile(outDir, 'cvf_ae_method_flowchart.png');

fprintf('\n=== CVF-AE Paper Completion Figures ===\n');
fprintf('Output folder: %s\n', outDir);
fprintf('Generated PNG/PDF figure pairs: 4\n');
end

function localPlotParameterSensitivity(T, outDir)
paramOrder = ["quota_scale", "step_strength", "state_switch_threshold"];
titles = ["CVF trigger quota", "CVF step strength", ...
    "State switching threshold"];
levelOrder = {
    ["low", "default", "high"]
    ["weak", "default", "strong"]
    ["strict", "default", "loose"]
    };
colors = [0.000, 0.447, 0.741; 0.850, 0.325, 0.098];
sceneIds = [2, 4];

fig = figure('Visible', 'off', 'Color', 'w', ...
    'Position', [60, 80, 1280, 430]);
layout = tiledlayout(fig, 1, 3, 'TileSpacing', 'compact', ...
    'Padding', 'compact');

for paramIdx = 1:numel(paramOrder)
    ax = nexttile(layout, paramIdx);
    hold(ax, 'on');
    box(ax, 'on');
    grid(ax, 'on');
    levels = levelOrder{paramIdx};
    x = 1:numel(levels);
    for sceneIdx = 1:numel(sceneIds)
        sceneId = sceneIds(sceneIdx);
        y = nan(size(x));
        e = nan(size(x));
        for levelIdx = 1:numel(levels)
            mask = T.ParamKey == paramOrder(paramIdx) & ...
                T.Level == levels(levelIdx) & T.Scene == sceneId;
            assert(nnz(mask) == 1, ...
                'Expected one parameter row for %s/%s/Scene %d.', ...
                paramOrder(paramIdx), levels(levelIdx), sceneId);
            y(levelIdx) = T.MeanBestFitness(mask);
            e(levelIdx) = T.StdBestFitness(mask);
        end
        errorbar(ax, x, y, e, '-o', 'Color', colors(sceneIdx, :), ...
            'LineWidth', 1.7, 'MarkerSize', 6, ...
            'MarkerFaceColor', colors(sceneIdx, :), ...
            'CapSize', 7, 'DisplayName', sprintf('Scene %d', sceneId));
    end
    xline(ax, 2, '--', 'Color', [0.25, 0.25, 0.25], ...
        'LineWidth', 1.0, 'HandleVisibility', 'off');
    xticks(ax, x);
    xticklabels(ax, localLevelLabels(levels));
    xlabel(ax, 'Parameter level');
    if paramIdx == 1
        ylabel(ax, 'Mean best fitness');
    end
    title(ax, titles(paramIdx), 'FontWeight', 'normal');
    set(ax, 'FontName', 'Times New Roman', 'FontSize', 10.5, ...
        'LineWidth', 0.9, 'XLim', [0.65, 3.35]);
    if paramIdx == numel(paramOrder)
        legend(ax, 'Location', 'best', 'Orientation', 'horizontal', ...
            'Box', 'on');
    end
end

localExportFigure(fig, outDir, 'cvf_ae_parameter_sensitivity');
close(fig);
end

function labels = localLevelLabels(levels)
labels = cellstr(levels);
for idx = 1:numel(labels)
    labels{idx} = strrep(labels{idx}, '_', ' ');
    labels{idx}(1) = upper(labels{idx}(1));
end
end

function localPlotStrongBoxplots(T, outDir)
algorithms = ["CVF-AE", "CPO", "GDSAO", "MSCSO", "ERIME", "DBO"];
localPlotBoxplotGrid(T, algorithms, outDir, ...
    'cvf_ae_boxplots_strong_algorithms', false);
end

function localPlotAllBoxplots(T, outDir)
algorithms = ["CVF-AE", "CPO", "GDSAO", "MSCSO", "ERIME", ...
    "DBO", "GWO", "HHO", "PSO", "WOA", "AE"];
localPlotBoxplotGrid(T, algorithms, outDir, ...
    'cvf_ae_boxplots_all_algorithms_log', true);
end

function localPlotBoxplotGrid(T, algorithms, outDir, baseName, useLogScale)
sceneIds = [1, 2, 4];
figWidth = 1480;
if numel(algorithms) <= 6
    figWidth = 1260;
end
fig = figure('Visible', 'off', 'Color', 'w', ...
    'Position', [40, 60, figWidth, 450]);
layout = tiledlayout(fig, 1, 3, 'TileSpacing', 'compact', ...
    'Padding', 'compact');
colors = localAlgorithmColors(algorithms);

for sceneIdx = 1:numel(sceneIds)
    sceneId = sceneIds(sceneIdx);
    ax = nexttile(layout, sceneIdx);
    hold(ax, 'on');
    for algIdx = 1:numel(algorithms)
        mask = T.Scene == sceneId & T.Algorithm == algorithms(algIdx);
        algValues = T.BestFitness(mask);
        algValues = algValues(isfinite(algValues) & algValues > 0);
        assert(numel(algValues) == 30, ...
            'Expected 30 runs for Scene %d, %s.', sceneId, algorithms(algIdx));
        groups = categorical(repmat(algorithms(algIdx), numel(algValues), 1), ...
            algorithms, 'Ordinal', true);
        chart = boxchart(ax, groups, algValues, 'MarkerStyle', '.', ...
            'JitterOutliers', 'on', 'BoxWidth', 0.62);
        chart.BoxFaceColor = colors(algIdx, :);
        chart.BoxFaceAlpha = 0.50;
        chart.WhiskerLineColor = colors(algIdx, :) * 0.65;
        chart.MarkerColor = colors(algIdx, :) * 0.65;
    end
    if useLogScale
        set(ax, 'YScale', 'log');
        ylabelText = 'Best fitness (log scale)';
    else
        ylabelText = 'Best fitness';
    end
    title(ax, sprintf('Scene %d', sceneId), 'FontWeight', 'normal');
    if sceneIdx == 1
        ylabel(ax, ylabelText);
    end
    grid(ax, 'on');
    box(ax, 'on');
    xtickangle(ax, 35);
    set(ax, 'FontName', 'Times New Roman', 'FontSize', 9.5, ...
        'LineWidth', 0.9);
end

localExportFigure(fig, outDir, baseName);
close(fig);
end

function colors = localAlgorithmColors(algorithms)
palette = containers.Map();
palette('CVF-AE') = [0.000, 0.447, 0.741];
palette('CPO') = [0.850, 0.325, 0.098];
palette('GDSAO') = [0.494, 0.184, 0.556];
palette('MSCSO') = [0.466, 0.674, 0.188];
palette('ERIME') = [0.301, 0.745, 0.933];
palette('DBO') = [0.929, 0.694, 0.125];
palette('GWO') = [0.635, 0.078, 0.184];
palette('HHO') = [0.333, 0.333, 0.333];
palette('PSO') = [0.200, 0.600, 0.600];
palette('WOA') = [0.700, 0.500, 0.300];
palette('AE') = [0.550, 0.550, 0.550];
colors = zeros(numel(algorithms), 3);
for idx = 1:numel(algorithms)
    colors(idx, :) = palette(char(algorithms(idx)));
end
end

function localPlotFlowchart(outDir)
fig = figure('Visible', 'off', 'Color', 'w', ...
    'Position', [80, 40, 1000, 1250]);
ax = axes(fig, 'Position', [0, 0, 1, 1], 'Visible', 'off', ...
    'XLim', [0, 1], 'YLim', [0, 1]);
hold(ax, 'on');

styles = localFlowStyles();
localFlowBox(ax, [0.29, 0.94, 0.42, 0.038], ...
    'Input UAV map, start/goal, and parameters', styles.start);
localFlowArrow(fig, [0.50, 0.50], [0.94, 0.905]);
localFlowBox(ax, [0.26, 0.865, 0.48, 0.040], ...
    'Constraint-aware initialization and evaluation', styles.process);
localFlowArrow(fig, [0.50, 0.50], [0.865, 0.83]);
localFlowBox(ax, [0.30, 0.79, 0.40, 0.040], ...
    'Identify population constraint state', styles.state);
localFlowArrow(fig, [0.50, 0.50], [0.79, 0.755]);
localFlowBox(ax, [0.29, 0.715, 0.42, 0.040], ...
    'Generate and evaluate ordinary AE offspring X_{AE}', styles.process);
localFlowArrow(fig, [0.50, 0.50], [0.715, 0.675]);
localFlowBox(ax, [0.31, 0.63, 0.38, 0.045], ...
    'Sparse CVF trigger for selected individuals?', styles.decision);

localFlowArrow(fig, [0.31, 0.17], [0.652, 0.652]);
localFlowArrow(fig, [0.17, 0.17], [0.652, 0.515]);
localFlowBox(ax, [0.04, 0.47, 0.26, 0.045], ...
    'Retain X_{AE}', styles.evaluate);
text(ax, 0.235, 0.665, 'No', 'FontName', 'Times New Roman', ...
    'FontSize', 10, 'HorizontalAlignment', 'center');

localFlowArrow(fig, [0.69, 0.83], [0.652, 0.652]);
localFlowArrow(fig, [0.83, 0.83], [0.652, 0.57]);
localFlowBox(ax, [0.70, 0.525, 0.26, 0.045], ...
    {'Build obstacle / NFZ / risk / altitude /'; ...
     'curvature / boundary viability field'}, styles.cvf);
text(ax, 0.765, 0.665, 'Yes', 'FontName', 'Times New Roman', ...
    'FontSize', 10, 'HorizontalAlignment', 'center');
localFlowArrow(fig, [0.83, 0.83], [0.525, 0.485]);
localFlowBox(ax, [0.70, 0.44, 0.26, 0.045], ...
    {'Fuse AE, CVF, and quality directions'; ...
     'to generate bounded X_{CVF}'}, styles.cvf);
localFlowArrow(fig, [0.83, 0.83], [0.44, 0.40]);
localFlowBox(ax, [0.70, 0.355, 0.26, 0.045], ...
    {'Evaluate X_{CVF}'; 'and apply strict local acceptance'}, styles.evaluate);

localFlowArrow(fig, [0.17, 0.38], [0.47, 0.315]);
localFlowArrow(fig, [0.83, 0.62], [0.355, 0.315]);
localFlowBox(ax, [0.29, 0.27, 0.42, 0.045], ...
    'Select AE or CVF trial; optionally apply sparse repair', styles.process);
localFlowArrow(fig, [0.50, 0.50], [0.27, 0.23]);
localFlowBox(ax, [0.28, 0.185, 0.44, 0.045], ...
    'Deb population acceptance and best/history update', styles.evaluate);
localFlowArrow(fig, [0.50, 0.50], [0.185, 0.145]);
localFlowBox(ax, [0.36, 0.10, 0.28, 0.045], ...
    'Termination condition met?', styles.decision);

localFlowArrow(fig, [0.64, 0.975], [0.122, 0.122]);
localFlowArrow(fig, [0.975, 0.975], [0.122, 0.81]);
localFlowArrow(fig, [0.975, 0.70], [0.81, 0.81]);
text(ax, 0.88, 0.135, 'No', 'FontName', 'Times New Roman', ...
    'FontSize', 10, 'HorizontalAlignment', 'center');

localFlowArrow(fig, [0.36, 0.23], [0.122, 0.122]);
localFlowBox(ax, [0.02, 0.10, 0.21, 0.045], ...
    'Output best feasible path', styles.start);
text(ax, 0.295, 0.135, 'Yes', 'FontName', 'Times New Roman', ...
    'FontSize', 10, 'HorizontalAlignment', 'center');

localExportFigure(fig, outDir, 'cvf_ae_method_flowchart');
close(fig);
end

function styles = localFlowStyles()
styles.start = struct('Fill', [0.86, 0.94, 0.90], ...
    'Edge', [0.18, 0.45, 0.28]);
styles.process = struct('Fill', [0.91, 0.95, 0.98], ...
    'Edge', [0.12, 0.35, 0.55]);
styles.state = struct('Fill', [0.96, 0.93, 0.82], ...
    'Edge', [0.55, 0.42, 0.10]);
styles.decision = struct('Fill', [0.99, 0.92, 0.86], ...
    'Edge', [0.65, 0.28, 0.08]);
styles.cvf = struct('Fill', [0.91, 0.88, 0.96], ...
    'Edge', [0.38, 0.20, 0.55]);
styles.evaluate = struct('Fill', [0.95, 0.95, 0.95], ...
    'Edge', [0.30, 0.30, 0.30]);
end

function localFlowBox(ax, position, label, style)
rectangle(ax, 'Position', position, 'Curvature', 0.10, ...
    'FaceColor', style.Fill, 'EdgeColor', style.Edge, 'LineWidth', 1.4);
if iscell(label)
    label = strjoin(label, newline);
end
text(ax, position(1) + position(3) / 2, ...
    position(2) + position(4) / 2, label, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
    'FontName', 'Times New Roman', 'FontSize', 10.5, ...
    'Interpreter', 'tex', 'Color', [0.08, 0.08, 0.08]);
end

function localFlowArrow(fig, x, y)
annotation(fig, 'arrow', x, y, 'LineWidth', 1.25, ...
    'Color', [0.22, 0.22, 0.22], 'HeadLength', 7, 'HeadWidth', 7);
end

function localExportFigure(fig, outDir, baseName)
pngPath = fullfile(outDir, [baseName '.png']);
pdfPath = fullfile(outDir, [baseName '.pdf']);
figPath = fullfile(outDir, [baseName '.fig']);
savefig(fig, figPath);
exportgraphics(fig, pngPath, 'Resolution', 300);
exportgraphics(fig, pdfPath, 'ContentType', 'vector');
end

function localWriteFigureIndex(outDir)
Figure = ["Parameter sensitivity"; "Strong-algorithm boxplots"; ...
    "All-algorithm boxplots"; "CVF-AE method flowchart"];
PNG = ["cvf_ae_parameter_sensitivity.png"; ...
    "cvf_ae_boxplots_strong_algorithms.png"; ...
    "cvf_ae_boxplots_all_algorithms_log.png"; ...
    "cvf_ae_method_flowchart.png"];
PDF = replace(PNG, ".png", ".pdf");
SuggestedPlacement = ["main-text"; "main-text"; "supplement"; "main-text"];
Purpose = ["Key CVF parameter robustness"; ...
    "Distribution comparison against strong methods"; ...
    "Full 11-algorithm distribution comparison"; ...
    "Overall CVF-AE algorithm procedure"];
Status = repmat("ready", 4, 1);
T = table(Figure, PNG, PDF, SuggestedPlacement, Purpose, Status);
writetable(T, fullfile(outDir, 'paper_completion_figure_index.csv'));
end

function localWriteInterpretation(outDir, paramFile, mainRunFile, recentRunFile)
fid = fopen(fullfile(outDir, ...
    'CVF_AE_PAPER_COMPLETION_FIGURES_INTERPRETATION.md'), ...
    'w', 'n', 'UTF-8');
assert(fid >= 0, 'Cannot write completion figure interpretation.');
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, '# CVF-AE 论文补充图生成说明\n\n');
fprintf(fid, '生成日期：2026-06-24\n\n');
fprintf(fid, '本目录只复用已有正式结果，不重跑优化实验。\n\n');
fprintf(fid, '## 数据来源\n\n');
fprintf(fid, '- 参数敏感性：`%s`\n', paramFile);
fprintf(fid, '- 正式主对比：`%s`\n', mainRunFile);
fprintf(fid, '- 近年改进算法：`%s`\n\n', recentRunFile);
fprintf(fid, '## 输出图\n\n');
fprintf(fid, '- `cvf_ae_parameter_sensitivity.png/.pdf`：三个关键参数在 Scene 2/4 上的均值和标准差。\n');
fprintf(fid, '- `cvf_ae_boxplots_strong_algorithms.png/.pdf`：六个强算法的线性坐标箱线图，建议正文使用。\n');
fprintf(fid, '- `cvf_ae_boxplots_all_algorithms_log.png/.pdf`：全部 11 个算法的对数坐标箱线图，建议补充材料使用。\n');
fprintf(fid, '- `cvf_ae_method_flowchart.png/.pdf`：CVF-AE 方法总体流程，建议方法章节使用。\n\n');
fprintf(fid, '## 解读边界\n\n');
fprintf(fid, '- 参数敏感性图中的默认参数不要求在每个场景逐项最优，应结合平均排名、评价次数和轨迹 sanity 解释。\n');
fprintf(fid, '- 箱线图使用每个算法每个场景 30 次正式运行的最终 BestFitness。\n');
fprintf(fid, '- 全算法箱线图采用对数纵轴，仅用于同时显示尺度差异较大的算法。\n');
fprintf(fid, '- 流程图强调 CVF 是稀疏候选分支，不是每个个体每代必定执行的重 repair。\n');

clear cleanup;
end
