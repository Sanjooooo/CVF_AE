function outPath = make_scene2_palette_test_figure()
%MAKE_SCENE2_PALETTE_TEST_FIGURE Create one SCI-style palette test figure.
%
% The figure uses existing selected representative run records only.

projectRoot = fileparts(mfilename('fullpath'));
paperFigDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', ...
    'paper_ajse_zh', 'figures');
resultDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
    'cvf_ae_selected7_paper_artifacts_20260706');
selectionFile = fullfile(resultDir, 'selected7_representative_run_selection.csv');

T = readtable(selectionFile, 'TextType', 'string');
T = T(T.Scene == 2, :);
algorithms = ["AE", "PSO", "GWO", "HHO", "ERIME", "MSCSO", "CVF-AE"];
T.AlgorithmOrder = localAlgorithmIndex(T.Algorithm, algorithms);
T = sortrows(T, 'AlgorithmOrder');

params = defaultParams();
params.sceneId = 2;
params = applyUAVSceneOverrides(params);
map = createMap(params);

fig = figure('Visible', 'off', 'Color', 'w', 'Position', [80, 80, 1380, 900]);
ax = axes(fig);
hold(ax, 'on');
grid(ax, 'on');
box(ax, 'on');
view(ax, [-36, 28]);
xlim(ax, map.xlim);
ylim(ax, map.ylim);
zlim(ax, [0, 45]);
xlabel(ax, 'X / m');
ylabel(ax, 'Y / m');
zlabel(ax, 'Z / m');
set(ax, 'FontName', 'Times New Roman', 'FontSize', 12, 'LineWidth', 0.9, ...
    'GridColor', [0.82, 0.82, 0.82], 'GridAlpha', 0.45);

localPlotMutedScene(ax, map, params);

colors = localPathColors();
lineStyles = containers.Map( ...
    cellstr(algorithms), {'-', '--', '-.', ':', '--', '-.', '-'});
handles = gobjects(0);
labels = {};
for idx = 1:height(T)
    alg = T.Algorithm(idx);
    sourceDir = localSourceDir(projectRoot, alg);
    runPath = fullfile(sourceDir, 'run_records', char(T.RunFile(idx)));
    S = load(runPath);
    [~, path] = localRecoverBestPath(S.result, params);
    if alg == "CVF-AE"
        lw = 3.4;
    else
        lw = 1.9;
    end
    h = plot3(ax, path(:,1), path(:,2), path(:,3), ...
        'LineStyle', lineStyles(char(alg)), 'Color', colors(char(alg)), ...
        'LineWidth', lw);
    handles(end+1) = h; %#ok<AGROW>
    labels{end+1} = char(alg); %#ok<AGROW>
end

legend(ax, handles, labels, 'Location', 'northeastoutside', ...
    'Interpreter', 'none', 'Box', 'off', 'FontName', 'Times New Roman', ...
    'FontSize', 11);
title(ax, 'Scene 2 representative paths with muted SCI-style palette', ...
    'FontName', 'Times New Roman', 'FontWeight', 'normal');

outPath = fullfile(paperFigDir, 'palette_test_scene2_representative_3d.png');
exportgraphics(fig, outPath, 'Resolution', 300);
close(fig);
fprintf('Palette test figure written to:\n%s\n', outPath);
end

function localPlotMutedScene(ax, map, params)
obstacleFace = [0.72, 0.76, 0.78];
obstacleEdge = [0.45, 0.49, 0.51];
nfzFace = [0.80, 0.33, 0.42];
nfzEdge = [0.56, 0.18, 0.25];
windColor = [0.42, 0.58, 0.72];

for k = 1:size(map.obstacles, 1)
    localDrawBox(ax, map.obstacles(k, :), obstacleFace, obstacleEdge, 0.30);
end
for k = 1:size(map.nfz, 1)
    localDrawCylinder(ax, map.nfz(k, :), nfzFace, nfzEdge, 0.16);
end
if isfield(map, 'windHotspots') && ~isempty(map.windHotspots)
    hs = map.windHotspots;
    scatter3(ax, hs(:,1), hs(:,2), hs(:,3), 34, 'filled', ...
        'MarkerFaceColor', windColor, 'MarkerEdgeColor', [0.28, 0.42, 0.55], ...
        'MarkerFaceAlpha', 0.70, 'MarkerEdgeAlpha', 0.80);
end
plot3(ax, params.start(1), params.start(2), params.start(3), ...
    's', 'MarkerSize', 9, 'LineWidth', 1.8, ...
    'Color', [0.00, 0.50, 0.35], 'MarkerFaceColor', [0.00, 0.62, 0.45]);
plot3(ax, params.goal(1), params.goal(2), params.goal(3), ...
    'p', 'MarkerSize', 12, 'LineWidth', 1.8, ...
    'Color', [0.70, 0.20, 0.12], 'MarkerFaceColor', [0.82, 0.28, 0.16]);
end

function localDrawBox(ax, box, faceColor, edgeColor, faceAlpha)
[x, y, z] = ndgrid([box(1), box(2)], [box(3), box(4)], [box(5), box(6)]);
verts = [x(:), y(:), z(:)];
faces = [1 3 4 2; 5 6 8 7; 1 2 6 5; 3 7 8 4; 1 5 7 3; 2 4 8 6];
patch(ax, 'Vertices', verts, 'Faces', faces, ...
    'FaceColor', faceColor, 'FaceAlpha', faceAlpha, ...
    'EdgeColor', edgeColor, 'EdgeAlpha', 0.58, 'LineWidth', 0.55);
end

function localDrawCylinder(ax, cyl, faceColor, edgeColor, faceAlpha)
[xx, yy, zz] = cylinder(cyl(3), 64);
zz = zz * (cyl(5) - cyl(4)) + cyl(4);
xx = xx + cyl(1);
yy = yy + cyl(2);
surf(ax, xx, yy, zz, 'FaceColor', faceColor, 'FaceAlpha', faceAlpha, ...
    'EdgeColor', 'none');
th = linspace(0, 2*pi, 180);
plot3(ax, cyl(1) + cyl(3) * cos(th), cyl(2) + cyl(3) * sin(th), ...
    cyl(5) * ones(size(th)), '-', 'Color', edgeColor, 'LineWidth', 1.1);
end

function colors = localPathColors()
colors = containers.Map();
colors('AE') = [0.45, 0.45, 0.45];
colors('PSO') = [0.00, 0.45, 0.70];
colors('GWO') = [0.84, 0.37, 0.00];
colors('HHO') = [0.80, 0.47, 0.65];
colors('ERIME') = [0.35, 0.70, 0.90];
colors('MSCSO') = [0.40, 0.25, 0.65];
colors('CVF-AE') = [0.00, 0.14, 0.32];
end

function sourceDir = localSourceDir(projectRoot, algorithm)
if algorithm == "ERIME" || algorithm == "MSCSO"
    sourceDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_main_comparison_recent_improved_formal_20260623_161229');
else
    sourceDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_main_comparison_formal_conservative_20260623_091132');
end
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
        bestCtrl = decodeSolution(bestX, params);
    end
end
if isempty(bestPath) && ~isempty(bestCtrl)
    bestPath = bsplinePath(bestCtrl, params.degree, params.nSamples);
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

function order = localAlgorithmIndex(values, algorithms)
values = string(values);
order = nan(numel(values), 1);
for idx = 1:numel(algorithms)
    order(values == algorithms(idx)) = idx;
end
end
