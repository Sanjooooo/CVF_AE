function out = make_cvf_pressure_mapping_preview()
%MAKE_CVF_PRESSURE_MAPPING_PREVIEW Create a local CVF pressure mapping figure.
%
% This diagnostic figure is generated from the paper Scene 3 map. It
% illustrates how sampled-path pressures are accumulated and mapped back to
% nearby B-spline control points. It is not connected to the LaTeX source.

projectRoot = fileparts(mfilename('fullpath'));
addpath(projectRoot);

params = defaultParams();
params.sceneId = 4; % Paper Scene 3
params = applyUAVSceneOverrides(params);
map = createMap(params);

ctrl = [
    params.start
    18 14 14
    30 29 14
    44 38 14
    58 54 14
    72 70 16
    88 78 16
    params.goal
];
X = encodeControlPoints(ctrl);
path = bsplinePath(ctrl, params.degree, params.nSamples);

sampleIdx = round(linspace(18, params.nSamples - 18, 28));
samplePts = path(sampleIdx, :);
innerCtrl = ctrl(2:end-1, :);

pressure = zeros(size(samplePts));
pressureComponents = zeros(size(samplePts, 1), 5, 3);
pressureSource = strings(size(samplePts, 1), 1);
nearestIdx = zeros(size(samplePts, 1), 1);
for i = 1:size(samplePts, 1)
    p = samplePts(i, :);
    nearestIdx(i) = localNearestControl(p, innerCtrl);
    [pressure(i, :), pressureSource(i), pressureComponents(i, :, :)] = ...
        localPressure2D(p, map, params);
end

ctrlDelta = zeros(size(innerCtrl));
hitCount = zeros(size(innerCtrl, 1), 1);
for i = 1:size(samplePts, 1)
    k = nearestIdx(i);
    ctrlDelta(k, :) = ctrlDelta(k, :) + pressure(i, :);
    hitCount(k) = hitCount(k) + 1;
end
for k = 1:size(ctrlDelta, 1)
    if hitCount(k) > 0
        ctrlDelta(k, :) = ctrlDelta(k, :) / hitCount(k);
    end
end

figDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', ...
    'paper_ajse_zh', 'figures');
if ~exist(figDir, 'dir')
    mkdir(figDir);
end
pngPath = fullfile(figDir, 'draft_cvf_pressure_mapping_preview.png');
pdfPath = fullfile(figDir, 'draft_cvf_pressure_mapping_preview.pdf');
localPngPath = fullfile(figDir, 'draft_cvf_pressure_mapping_target_control_preview.png');
localPdfPath = fullfile(figDir, 'draft_cvf_pressure_mapping_target_control_preview.pdf');
synthesisPngPath = fullfile(figDir, 'draft_cvf_pressure_synthesis_target_control_preview.png');
synthesisPdfPath = fullfile(figDir, 'draft_cvf_pressure_synthesis_target_control_preview.pdf');
combinedPngPath = fullfile(figDir, 'draft_cvf_pressure_mapping_with_synthesis_inset_preview.png');
combinedPdfPath = fullfile(figDir, 'draft_cvf_pressure_mapping_with_synthesis_inset_preview.pdf');

fig = figure('Color', 'w', 'Units', 'pixels', 'Position', [80 80 980 720], ...
    'Visible', 'off');
ax = axes(fig);
hold(ax, 'on');
axis(ax, 'equal');
box(ax, 'on');
xlim(ax, [0 100]);
ylim(ax, [0 100]);
set(ax, 'FontName', 'Arial', 'FontSize', 10, ...
    'LineWidth', 0.9, 'TickDir', 'out', 'Layer', 'top');
xlabel(ax, 'X / m');
ylabel(ax, 'Y / m');
title(ax, 'Local CVF pressure mapping diagnostic', ...
    'FontWeight', 'normal', 'FontSize', 12);

localDrawMapTop(ax, map);

plot(ax, path(:,1), path(:,2), '-', 'Color', [0.12 0.32 0.52], ...
    'LineWidth', 2.2);
plot(ax, ctrl(:,1), ctrl(:,2), '--', 'Color', [0.18 0.34 0.46], ...
    'LineWidth', 0.9);
scatter(ax, innerCtrl(:,1), innerCtrl(:,2), 52, [0.08 0.28 0.46], ...
    'filled', 'MarkerEdgeColor', 'w', 'LineWidth', 0.7);
scatter(ax, samplePts(:,1), samplePts(:,2), 24, [0.85 0.48 0.18], ...
    'filled', 'MarkerEdgeColor', 'w', 'LineWidth', 0.4);

for i = 1:size(samplePts, 1)
    p = samplePts(i, :);
    c = innerCtrl(nearestIdx(i), :);
    plot(ax, [p(1) c(1)], [p(2) c(2)], ':', ...
        'Color', [0.55 0.62 0.68 0.55], 'LineWidth', 0.7);
end

localDrawQuiver(ax, samplePts, pressure, 4.0, [0.62 0.18 0.18], 0.75);
localDrawQuiver(ax, innerCtrl, ctrlDelta, 7.5, [0.06 0.43 0.48], 1.8);

plot(ax, params.start(1), params.start(2), 's', 'MarkerSize', 8, ...
    'MarkerFaceColor', [0.00 0.62 0.45], 'MarkerEdgeColor', [0.00 0.50 0.35], ...
    'LineWidth', 1.2);
plot(ax, params.goal(1), params.goal(2), 'p', 'MarkerSize', 10, ...
    'MarkerFaceColor', [0.82 0.28 0.16], 'MarkerEdgeColor', [0.70 0.20 0.12], ...
    'LineWidth', 1.2);

hPath = plot(ax, nan, nan, '-', 'Color', [0.12 0.32 0.52], 'LineWidth', 2.2);
hSample = scatter(ax, nan, nan, 24, [0.85 0.48 0.18], 'filled');
hCtrl = scatter(ax, nan, nan, 52, [0.08 0.28 0.46], 'filled');
hPressure = quiver(ax, nan, nan, nan, nan, 0, 'Color', [0.62 0.18 0.18], ...
    'LineWidth', 0.9, 'MaxHeadSize', 0.8);
hDelta = quiver(ax, nan, nan, nan, nan, 0, 'Color', [0.06 0.43 0.48], ...
    'LineWidth', 1.8, 'MaxHeadSize', 0.8);
legend(ax, [hPath, hSample, hCtrl, hPressure, hDelta], ...
    {'B-spline path', 'Low-density samples', 'Interior control points', ...
    'Local pressure', 'Mapped control increment'}, ...
    'Location', 'southoutside', 'NumColumns', 3, 'Box', 'off');

text(ax, 3, 97, 'Pressure components: obstacle / NFZ / altitude / boundary / risk', ...
    'FontName', 'Arial', 'FontSize', 9, 'Color', [0.30 0.36 0.40], ...
    'BackgroundColor', [1 1 1 0.78], 'EdgeColor', [0.82 0.86 0.88]);

exportgraphics(fig, pngPath, 'Resolution', 300);
exportgraphics(fig, pdfPath, 'ContentType', 'vector');
close(fig);

localMakeLocalPanel(localPngPath, localPdfPath, map, ctrl, path, ...
    samplePts, innerCtrl, nearestIdx, pressure, pressureSource, ctrlDelta);
localMakeSynthesisPanel(synthesisPngPath, synthesisPdfPath, innerCtrl, ...
    nearestIdx, pressureComponents, ctrlDelta);
localMakeCombinedInsetFigure(combinedPngPath, combinedPdfPath, ...
    localPngPath, synthesisPngPath);

out = struct();
out.pngPath = pngPath;
out.pdfPath = pdfPath;
out.localPngPath = localPngPath;
out.localPdfPath = localPdfPath;
out.synthesisPngPath = synthesisPngPath;
out.synthesisPdfPath = synthesisPdfPath;
out.combinedPngPath = combinedPngPath;
out.combinedPdfPath = combinedPdfPath;
out.maxSamplePressure = max(vecnorm(pressure(:,1:2), 2, 2));
out.maxControlDelta = max(vecnorm(ctrlDelta(:,1:2), 2, 2));

fprintf('CVF pressure mapping preview saved:\n');
fprintf('  %s\n', pngPath);
fprintf('  %s\n', pdfPath);
fprintf('  %s\n', localPngPath);
fprintf('  %s\n', localPdfPath);
fprintf('  %s\n', synthesisPngPath);
fprintf('  %s\n', synthesisPdfPath);
fprintf('  %s\n', combinedPngPath);
fprintf('  %s\n', combinedPdfPath);
fprintf('Max sample pressure %.4f, max mapped control increment %.4f\n', ...
    out.maxSamplePressure, out.maxControlDelta);

% Keep X evaluated by buildConstraintViabilityField to ensure this path is
% valid for the current project API; the returned data are not used directly.
state = struct('id', 1, 'name', 'FeasibilityFormation');
buildConstraintViabilityField(X, map, params, struct(), state);
end

function localMakeLocalPanel(pngPath, pdfPath, map, ctrl, path, ...
    samplePts, innerCtrl, nearestIdx, pressure, pressureSource, ctrlDelta)
targetCtrlIdx = localNearestControl([30 29 14], innerCtrl);
targetMask = nearestIdx == targetCtrlIdx;
targetCtrl = innerCtrl(targetCtrlIdx, :);

win = [8, 52, 6, 50]; % xmin xmax ymin ymax
inWinSample = samplePts(:,1) >= win(1) & samplePts(:,1) <= win(2) & ...
    samplePts(:,2) >= win(3) & samplePts(:,2) <= win(4);
inWinCtrl = innerCtrl(:,1) >= win(1)-5 & innerCtrl(:,1) <= win(2)+5 & ...
    innerCtrl(:,2) >= win(3)-5 & innerCtrl(:,2) <= win(4)+5;

fig = figure('Color', 'w', 'Units', 'pixels', 'Position', [120 120 560 520], ...
    'Visible', 'off');
ax = axes(fig);
hold(ax, 'on');
axis(ax, 'equal');
box(ax, 'on');
xlim(ax, win(1:2));
ylim(ax, win(3:4));
set(ax, 'FontName', 'Arial', 'FontSize', 8.5, ...
    'LineWidth', 0.8, 'TickDir', 'out', 'Layer', 'top');
axis(ax, 'off');

localDrawMapTop(ax, map);

inPath = path(:,1) >= win(1)-8 & path(:,1) <= win(2)+8 & ...
    path(:,2) >= win(3)-8 & path(:,2) <= win(4)+8;
plot(ax, path(inPath,1), path(inPath,2), '-', ...
    'Color', [0.10 0.32 0.52], 'LineWidth', 2.0);
plot(ax, ctrl(:,1), ctrl(:,2), '--', ...
    'Color', [0.20 0.34 0.46 0.55], 'LineWidth', 0.7);

backgroundSample = inWinSample & ~targetMask;
targetSample = inWinSample & targetMask;
scatter(ax, samplePts(backgroundSample,1), samplePts(backgroundSample,2), 18, ...
    [0.84 0.43 0.16], 'filled', 'MarkerFaceAlpha', 0.28, ...
    'MarkerEdgeColor', 'w', 'LineWidth', 0.25);
scatter(ax, samplePts(targetSample,1), samplePts(targetSample,2), 30, ...
    [0.84 0.43 0.16], 'filled', 'MarkerEdgeColor', 'w', 'LineWidth', 0.45);
scatter(ax, innerCtrl(inWinCtrl,1), innerCtrl(inWinCtrl,2), 44, ...
    [0.05 0.26 0.43], 'filled', 'MarkerFaceAlpha', 0.35, ...
    'MarkerEdgeColor', 'w', 'LineWidth', 0.45);
scatter(ax, targetCtrl(1), targetCtrl(2), 76, [0.05 0.26 0.43], ...
    'filled', 'MarkerEdgeColor', 'w', 'LineWidth', 0.75);

idx = find(inWinSample);
for jj = 1:numel(idx)
    i = idx(jj);
    if nearestIdx(i) ~= targetCtrlIdx
        continue;
    end
    c = innerCtrl(nearestIdx(i), :);
    if c(1) >= win(1)-5 && c(1) <= win(2)+5 && c(2) >= win(3)-5 && c(2) <= win(4)+5
        plot(ax, [samplePts(i,1) c(1)], [samplePts(i,2) c(2)], ':', ...
            'Color', [0.48 0.55 0.60 0.72], 'LineWidth', 0.7);
    end
end

localDrawLabeledPressure(ax, samplePts(targetSample,:), pressure(targetSample,:), ...
    pressureSource(targetSample), 2.5, [0.64 0.18 0.18], 0.85);
localDrawQuiver(ax, targetCtrl, ctrlDelta(targetCtrlIdx,:), ...
    4.6, [0.02 0.42 0.47], 1.9);
text(ax, targetCtrl(1)+2.6, targetCtrl(2)-2.2, 'avg step', ...
    'FontName', 'Arial', 'FontSize', 6.4, 'Color', [0.02 0.35 0.40], ...
    'BackgroundColor', [1 1 1 0.55], 'Margin', 0.7);

exportgraphics(fig, pngPath, 'Resolution', 300);
exportgraphics(fig, pdfPath, 'ContentType', 'vector');
close(fig);
end

function localMakeSynthesisPanel(pngPath, pdfPath, innerCtrl, nearestIdx, ...
    pressureComponents, ctrlDelta)
targetCtrlIdx = localNearestControl([30 29 14], innerCtrl);
targetMask = nearestIdx == targetCtrlIdx;
componentNames = ["obs", "NFZ", "risk", "alt", "bnd"];
componentColors = [
    0.64 0.18 0.18
    0.56 0.18 0.25
    0.50 0.31 0.70
    0.38 0.44 0.50
    0.48 0.55 0.60
];
componentLineStyles = ["-", "--", ":", "-.", "--"];

avgComponents = squeeze(mean(pressureComponents(targetMask, :, :), 1));
if isempty(avgComponents)
    avgComponents = zeros(numel(componentNames), 3);
end
xyComponents = avgComponents(:, 1:2);
resultXY = sum(xyComponents, 1);
if norm(resultXY) < 1e-8
    resultXY = ctrlDelta(targetCtrlIdx, 1:2);
end
if norm(resultXY) < 1e-8
    resultXY = [1, 0];
end

componentMag = vecnorm(xyComponents, 2, 2);
valid = componentMag > max(0.03, 0.015 * max(componentMag));
xyShown = xyComponents(valid, :);
namesShown = componentNames(valid);
colorsShown = componentColors(valid, :);
lineStylesShown = componentLineStyles(valid);
magShown = componentMag(valid);

fig = figure('Color', 'w', 'Units', 'pixels', 'Position', [160 160 520 420], ...
    'Visible', 'off');
ax = axes(fig);
hold(ax, 'on');
axis(ax, 'equal');
axis(ax, 'off');

origin = [0, 0];
tail = origin;
scale = 6.2 / max(norm(resultXY), max(1e-8, sum(magShown)));
xyDraw = xyShown * scale;
resultDraw = resultXY * scale;

plot(ax, [-0.45 7.1], [0 0], '-', 'Color', [0.86 0.88 0.89], 'LineWidth', 0.7);
plot(ax, [0 0], [-4.2 2.0], '-', 'Color', [0.86 0.88 0.89], 'LineWidth', 0.7);
scatter(ax, origin(1), origin(2), 42, [0.05 0.26 0.43], 'filled', ...
    'MarkerEdgeColor', 'w', 'LineWidth', 0.55);

for i = 1:size(xyDraw, 1)
    v = xyDraw(i, :);
    nextTail = tail + v;
    quiver(ax, tail(1), tail(2), v(1), v(2), 0, ...
        'Color', colorsShown(i, :), 'LineWidth', 1.22, 'MaxHeadSize', 0.82, ...
        'LineStyle', char(lineStylesShown(i)));
    localLabelVector(ax, tail, nextTail, namesShown(i), magShown(i), ...
        colorsShown(i, :));
    plot(ax, [origin(1) nextTail(1)], [origin(2) nextTail(2)], ':', ...
        'Color', [0.38 0.42 0.45 0.30], 'LineWidth', 0.65);
    tail = nextTail;
end
scatter(ax, tail(1), tail(2), 28, [0.02 0.42 0.47], 'filled', ...
    'MarkerEdgeColor', 'w', 'LineWidth', 0.45);

quiver(ax, origin(1), origin(2), resultDraw(1), resultDraw(2), 0, ...
    'Color', [0.02 0.42 0.47], 'LineWidth', 2.25, 'MaxHeadSize', 0.75);

allPts = [origin; cumsum(xyDraw, 1); resultDraw];
pad = 1.55;
xLimits = [min(allPts(:,1))-pad, max(allPts(:,1))+pad];
yLimits = [min(allPts(:,2))-pad, max(allPts(:,2))+pad];
xlim(ax, xLimits);
ylim(ax, yLimits);
avgNormal = [-resultDraw(2), resultDraw(1)];
if norm(avgNormal) < 1e-8
    avgNormal = [0, 1];
else
    avgNormal = avgNormal / norm(avgNormal);
end
avgLabelPos = 0.56 * resultDraw - 0.52 * avgNormal;
plot(ax, [0.56*resultDraw(1), avgLabelPos(1)], ...
    [0.56*resultDraw(2), avgLabelPos(2)], ':', ...
    'Color', [0.02 0.42 0.47 0.34], 'LineWidth', 0.45);
text(ax, avgLabelPos(1), avgLabelPos(2), ...
    sprintf('avg step |v|=%.2f', norm(resultXY)), ...
    'FontName', 'Arial', 'FontSize', 7.2, 'Color', [0.02 0.35 0.40], ...
    'BackgroundColor', [1 1 1 0.65], 'Margin', 0.8);
text(ax, xLimits(1)+0.18, yLimits(2)-0.35, ...
    sprintf('C3 mapped samples: %d', nnz(targetMask)), ...
    'FontName', 'Arial', 'FontSize', 7.0, 'Color', [0.30 0.36 0.40]);
localDrawSynthesisLegend(ax, xLimits, yLimits, namesShown, colorsShown, ...
    lineStylesShown);

exportgraphics(fig, pngPath, 'Resolution', 300);
exportgraphics(fig, pdfPath, 'ContentType', 'vector');
close(fig);
end

function localMakeCombinedInsetFigure(pngPath, pdfPath, mainPngPath, insetPngPath)
mainImg = imread(mainPngPath);
insetImg = imread(insetPngPath);

fig = figure('Color', 'w', 'Units', 'pixels', 'Position', [180 120 760 650], ...
    'Visible', 'off');
axMain = axes(fig, 'Position', [0.01 0.01 0.98 0.98]);
image(axMain, mainImg);
axis(axMain, 'image');
axis(axMain, 'off');

axInset = axes(fig, 'Position', [0.545 0.055 0.405 0.315]);
image(axInset, insetImg);
axis(axInset, 'image');
axis(axInset, 'off');
rectangle(axMain, 'Position', [0.545*size(mainImg,2), ...
    (1-0.055-0.315)*size(mainImg,1), ...
    0.405*size(mainImg,2), 0.315*size(mainImg,1)], ...
    'EdgeColor', [0.68 0.73 0.76], 'LineWidth', 1.1);

exportgraphics(fig, pngPath, 'Resolution', 300);
exportgraphics(fig, pdfPath, 'ContentType', 'image');
close(fig);
end

function localLabelVector(ax, tail, head, name, mag, colorVal)
mid = (tail + head) / 2;
normal = [-head(2)+tail(2), head(1)-tail(1)];
if norm(normal) < 1e-8
    normal = [0, 1];
else
    normal = normal / norm(normal);
end
dir = head - tail;
if norm(dir) < 1e-8
    dir = [1, 0];
else
    dir = dir / norm(dir);
end
nameText = char(name);
switch lower(nameText)
    case 'obs'
        labelPos = mid + 0.70 * normal + 0.15 * dir;
    case 'nfz'
        labelPos = mid - 0.86 * normal - 0.15 * dir;
    case 'risk'
        labelPos = mid - 0.62 * normal - 0.16 * dir;
    otherwise
        labelPos = mid + 0.48 * normal;
end
plot(ax, [mid(1), labelPos(1)], [mid(2), labelPos(2)], ':', ...
    'Color', [colorVal 0.36], 'LineWidth', 0.45);
text(ax, labelPos(1), labelPos(2), sprintf('%s %.2f', nameText, mag), ...
    'FontName', 'Arial', 'FontSize', 6.7, 'Color', colorVal, ...
    'BackgroundColor', [1 1 1 0.62], 'Margin', 0.7);
end

function localDrawSynthesisLegend(ax, xLimits, yLimits, namesShown, colorsShown, ...
    lineStylesShown)
boxW = 1.45;
boxH = 0.38 * numel(namesShown) + 0.30;
x0 = xLimits(2) - boxW - 0.18;
y0 = yLimits(1) + 0.24;
patch(ax, [x0, x0+boxW, x0+boxW, x0], [y0, y0, y0+boxH, y0+boxH], ...
    [1 1 1], 'FaceAlpha', 0.68, 'EdgeColor', [0.82 0.85 0.87], ...
    'LineWidth', 0.45);
for i = 1:numel(namesShown)
    y = y0 + boxH - 0.26 - 0.34*(i-1);
    plot(ax, [x0+0.14, x0+0.50], [y, y], ...
        'Color', colorsShown(i, :), 'LineStyle', char(lineStylesShown(i)), ...
        'LineWidth', 1.25);
    text(ax, x0+0.58, y-0.025, char(namesShown(i)), ...
        'FontName', 'Arial', 'FontSize', 5.5, 'Color', colorsShown(i, :));
end
end

function localDrawMapTop(ax, map)
for k = 1:size(map.obstacles, 1)
    b = map.obstacles(k, :);
    rectangle(ax, 'Position', [b(1), b(3), b(2)-b(1), b(4)-b(3)], ...
        'FaceColor', [0.72 0.76 0.78 0.32], ...
        'EdgeColor', [0.45 0.49 0.51], 'LineWidth', 0.7);
end

theta = linspace(0, 2*pi, 220);
for k = 1:size(map.nfz, 1)
    z = map.nfz(k, :);
    plot(ax, z(1) + z(3)*cos(theta), z(2) + z(3)*sin(theta), ...
        '-', 'Color', [0.56 0.18 0.25], 'LineWidth', 1.1);
end

if isfield(map, 'windHotspots') && ~isempty(map.windHotspots)
    scatter(ax, map.windHotspots(:,1), map.windHotspots(:,2), 34, ...
        [0.42 0.58 0.72], 'filled', ...
        'MarkerEdgeColor', [0.28 0.42 0.55], 'MarkerFaceAlpha', 0.75);
end
end

function localDrawLabeledPressure(ax, p, v, sourceLabels, scale, colorVal, lineWidth)
mag = vecnorm(v(:,1:2), 2, 2);
valid = mag > 1e-6;
if ~any(valid)
    return;
end
validIdx = find(valid);
vv = v(valid, 1:2);
mm = mag(valid);
vv = vv ./ max(mm, 1e-9) .* min(scale, scale * mm ./ max(mm));
offsets = [
    0.75 0.45
    0.70 -0.55
    -1.25 0.45
    -1.20 -0.50
    0.30 0.88
    -0.45 0.95
];
for ii = 1:numel(validIdx)
    row = validIdx(ii);
    q = p(row, :);
    d = vv(ii, :);
    quiver(ax, q(1), q(2), d(1), d(2), 0, ...
        'Color', colorVal, 'LineWidth', lineWidth, 'MaxHeadSize', 0.8);
    labelPos = q(1:2) + 0.82 * d + offsets(mod(ii-1, size(offsets, 1)) + 1, :);
    plot(ax, [q(1)+d(1), labelPos(1)], [q(2)+d(2), labelPos(2)], ':', ...
        'Color', [colorVal 0.34], 'LineWidth', 0.45);
    text(ax, labelPos(1), labelPos(2), char(sourceLabels(row)), ...
        'FontName', 'Arial', 'FontSize', 6.1, ...
        'Color', [0.44 0.15 0.15], ...
        'BackgroundColor', [1 1 1 0.58], 'Margin', 0.65);
end
end

function localDrawQuiver(ax, p, v, scale, colorVal, lineWidth)
mag = vecnorm(v(:,1:2), 2, 2);
valid = mag > 1e-6;
if ~any(valid)
    return;
end
vv = v(valid, 1:2);
mm = mag(valid);
vv = vv ./ max(mm, 1e-9) .* min(scale, scale * mm ./ max(mm));
quiver(ax, p(valid,1), p(valid,2), vv(:,1), vv(:,2), 0, ...
    'Color', colorVal, 'LineWidth', lineWidth, 'MaxHeadSize', 0.8);
end

function k = localNearestControl(p, innerCtrl)
[~, k] = min(vecnorm(innerCtrl - p, 2, 2));
end

function [pressure, sourceLabel, components] = localPressure2D(p, map, params)
components = [
    1.20 * localObstaclePressure2D(p, map)
    1.15 * localNFZPressure2D(p, map)
    0.85 * localRiskPressure2D(p, map)
    1.10 * localAltitudePressure(p, params)
    0.65 * localBoundaryPressure2D(p, params)
];
pressure = sum(components, 1);
names = ["obs", "NFZ", "risk", "alt", "bnd"];
[maxVal, idx] = max(vecnorm(components, 2, 2));
if maxVal <= 1e-8
    sourceLabel = "none";
else
    sourceLabel = names(idx);
end
end

function v = localObstaclePressure2D(p, map)
v = [0, 0, 0];
r = 7.0;
for i = 1:size(map.obstacles, 1)
    b = map.obstacles(i, :);
    nearest = [min(max(p(1), b(1)), b(2)), min(max(p(2), b(3)), b(4)), 0];
    inside = p(1) >= b(1) && p(1) <= b(2) && ...
        p(2) >= b(3) && p(2) <= b(4) && p(3) >= b(5) && p(3) <= b(6);
    if inside
        d = [p(1)-b(1), b(2)-p(1), p(2)-b(3), b(4)-p(2)];
        [depth, side] = min(d);
        dirs = [-1 0 0; 1 0 0; 0 -1 0; 0 1 0];
        v = v + (r + max(0, depth)) * dirs(side, :);
    else
        dxy = [p(1)-nearest(1), p(2)-nearest(2), 0];
        dist = norm(dxy);
        if dist > 0 && dist <= r
            v = v + (r-dist)/r * dxy/dist;
        end
    end
end
end

function v = localNFZPressure2D(p, map)
v = [0, 0, 0];
rInf = 7.0;
for i = 1:size(map.nfz, 1)
    z = map.nfz(i, :);
    if p(3) < z(4) || p(3) > z(5)
        continue;
    end
    dxy = [p(1)-z(1), p(2)-z(2), 0];
    dist = norm(dxy);
    if dist < 1e-9
        dxy = [1, 0, 0];
        dist = 1;
    end
    if dist <= z(3)
        v = v + (z(3)-dist+rInf) * dxy/dist;
    elseif dist <= z(3) + rInf
        v = v + (z(3)+rInf-dist)/rInf * dxy/dist;
    end
end
end

function v = localRiskPressure2D(p, map)
v = [0, 0, 0];
if ~isfield(map, 'windHotspots') || isempty(map.windHotspots)
    return;
end
phi0 = 0.24;
scale = 1.8;
for i = 1:size(map.windHotspots, 1)
    h = map.windHotspots(i, :);
    d = [p(1)-h(1), p(2)-h(2), 0.35*(p(3)-h(3))];
    phi = h(5) * exp(-sum(d.^2)/(2*h(4)^2));
    if phi > phi0
        if norm(d) < 1e-9
            d = [1, 0.5, 0];
        end
        v = v + scale * (phi - phi0) * d / norm(d);
    end
end
end

function v = localAltitudePressure(p, params)
v = [0, 0, 0];
band = 3.0;
if p(3) < params.altMin
    v(3) = params.altMin - p(3);
elseif p(3) > params.altMax
    v(3) = params.altMax - p(3);
elseif p(3) < params.altMin + band
    v(3) = 0.35 * (params.altMin + band - p(3));
elseif p(3) > params.altMax - band
    v(3) = -0.35 * (p(3) - (params.altMax - band));
end
end

function v = localBoundaryPressure2D(p, params)
v = [0, 0, 0];
b = 6.0;
if p(1) < params.map.xlim(1) + b
    v(1) = params.map.xlim(1) + b - p(1);
elseif p(1) > params.map.xlim(2) - b
    v(1) = params.map.xlim(2) - b - p(1);
end
if p(2) < params.map.ylim(1) + b
    v(2) = params.map.ylim(1) + b - p(2);
elseif p(2) > params.map.ylim(2) - b
    v(2) = params.map.ylim(2) - b - p(2);
end
end
