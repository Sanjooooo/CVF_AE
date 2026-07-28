function outputs = make_cvf_ae_convergence_inset_figure(figureDir)
%MAKE_CVF_AE_CONVERGENCE_INSET_FIGURE Draw the active convergence figure.
%
% This function reads the frozen selected-seven results. It does not run
% any optimizer or alter the experiment data.

projectRoot = fileparts(mfilename('fullpath'));
if nargin < 1 || isempty(figureDir)
    figureDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', ...
        'paper_ajse_zh', 'figures');
end
assert(isfolder(figureDir), 'Missing paper figure directory: %s', figureDir);

resultPath = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', ...
    'results', 'cvf_ae_selected7_main_comparison_formal_20260707_101155', ...
    'uav_comparison_results.mat');
assert(isfile(resultPath), 'Missing convergence MAT file: %s', resultPath);
data = load(resultPath, 'allResults', 'cfg');
algorithms = string(data.cfg.algorithms);
expected = ["AE", "PSO", "GWO", "HHO", "ERIME", "MSCSO", "CVF-AE"];
assert(isequal(algorithms(:)', expected), ...
    'Unexpected algorithm order in frozen result file.');

colors = [
    0.50, 0.50, 0.50
    0.00, 0.45, 0.70
    0.90, 0.35, 0.00
    0.77, 0.45, 0.65
    0.32, 0.66, 0.82
    0.38, 0.24, 0.64
    0.00, 0.14, 0.32];
lineStyles = ["-", "--", "-.", ":", "-", "--", "-"];
mainPositions = [
    0.055, 0.20, 0.285, 0.69
    0.365, 0.20, 0.285, 0.69
    0.675, 0.20, 0.285, 0.69];

fig = figure( ...
    'Visible', 'off', ...
    'Color', 'w', ...
    'Position', [40, 60, 1500, 520]);
legendHandles = gobjects(numel(algorithms), 1);

for sceneIndex = 1:3
    mainPosition = mainPositions(sceneIndex, :);
    ax = axes(fig, 'Position', mainPosition);
    hold(ax, 'on');
    curves = cell(numel(algorithms), 1);
    for algorithmIndex = 1:numel(algorithms)
        curves{algorithmIndex} = localMeanCurve( ...
            data.allResults{sceneIndex, algorithmIndex});
        width = 1.20;
        if algorithms(algorithmIndex) == "CVF-AE"
            width = 2.35;
        end
        lineHandle = plot(ax, 1:numel(curves{algorithmIndex}), ...
            curves{algorithmIndex}, ...
            'Color', colors(algorithmIndex, :), ...
            'LineStyle', lineStyles(algorithmIndex), ...
            'LineWidth', width);
        if sceneIndex == 1
            legendHandles(algorithmIndex) = lineHandle;
        end
    end
    set(ax, ...
        'FontName', 'Times New Roman', ...
        'FontSize', 9.5, ...
        'LineWidth', 0.9, ...
        'Box', 'on', ...
        'XGrid', 'off', ...
        'YGrid', 'on', ...
        'GridAlpha', 0.14);
    xlabel(ax, 'Iteration');
    if sceneIndex == 1
        ylabel(ax, 'Feasible-aware best fitness');
    end
    title(ax, sprintf('Scene %d', sceneIndex), ...
        'FontWeight', 'normal');

    curveLength = max(cellfun(@numel, curves));
    lateStart = max(1, round(0.72 * curveLength));
    insetPosition = [
        mainPosition(1) + 0.555 * mainPosition(3), ...
        mainPosition(2) + 0.585 * mainPosition(4), ...
        0.395 * mainPosition(3), ...
        0.325 * mainPosition(4)];
    inset = axes(fig, 'Position', insetPosition);
    hold(inset, 'on');
    for algorithmIndex = 1:numel(algorithms)
        curve = curves{algorithmIndex};
        x = lateStart:numel(curve);
        width = 0.85;
        if algorithms(algorithmIndex) == "CVF-AE"
            width = 1.45;
        end
        plot(inset, x, curve(x), ...
            'Color', colors(algorithmIndex, :), ...
            'LineStyle', lineStyles(algorithmIndex), ...
            'LineWidth', width);
    end
    set(inset, ...
        'FontName', 'Times New Roman', ...
        'FontSize', 7.0, ...
        'LineWidth', 0.70, ...
        'Box', 'on', ...
        'XGrid', 'off', ...
        'YGrid', 'on', ...
        'GridAlpha', 0.12);
    xlim(inset, [lateStart, curveLength]);
end

legendHandle = legend(legendHandles, cellstr(algorithms), ...
    'Orientation', 'horizontal', ...
    'NumColumns', 7, ...
    'Box', 'off', ...
    'FontName', 'Times New Roman', ...
    'FontSize', 8.8);
legendHandle.Position = [0.205, 0.035, 0.590, 0.055];

baseName = "selected7_convergence_with_late_insets";
pngPath = fullfile(figureDir, baseName + ".png");
pdfPath = fullfile(figureDir, baseName + ".pdf");
exportgraphics(fig, pngPath, ...
    'Resolution', 300, ...
    'BackgroundColor', 'white');
exportgraphics(fig, pdfPath, ...
    'ContentType', 'vector', ...
    'BackgroundColor', 'white');
close(fig);

outputs = struct('pngPath', pngPath, 'pdfPath', pdfPath);
fprintf('Convergence figure written to:\n%s\n%s\n', pngPath, pdfPath);
end

function meanCurve = localMeanCurve(results)
curves = arrayfun(@(result) result.convergence(:), ...
    results, ...
    'UniformOutput', false);
maxLength = max(cellfun(@numel, curves));
matrix = nan(numel(curves), maxLength);
for runIndex = 1:numel(curves)
    curve = curves{runIndex};
    matrix(runIndex, 1:numel(curve)) = curve;
    if numel(curve) < maxLength
        matrix(runIndex, numel(curve) + 1:end) = curve(end);
    end
end
meanCurve = mean(matrix, 1, 'omitnan');
end
