function plotSceneOnly(map, params)
%PLOTSCENEONLY Plot only the scene map without planned path.
% Supports both 3D view and top view. In top view, NFZ circles are explicitly drawn.

hold on; grid on; view(params.figView);
xlim(map.xlim); ylim(map.ylim); zlim(map.zlim);
xlabel('X / m'); ylabel('Y / m'); zlabel('Z / m');

isTopView = false;
[az, el] = view;
if abs(az) < 1e-6 && abs(el - 90) < 1e-6
    isTopView = true;
end

% ---------- Obstacles ----------
for k = 1:size(map.obstacles, 1)
    drawBoxLocal(map.obstacles(k, :), [0.72 0.76 0.78], 0.30, [0.45 0.49 0.51]);
end

% ---------- NFZ ----------
for k = 1:size(map.nfz, 1)
    if ~isTopView
        drawCylinderLocal(map.nfz(k, :), [0.80 0.33 0.42], 0.16, [0.56 0.18 0.25]);
    else
        drawNFZTopCircle(map.nfz(k, :), [0.56 0.18 0.25], 1.8);
    end
end

% ---------- Wind hotspots ----------
if isfield(map, 'windHotspots') && ~isempty(map.windHotspots)
    hs = map.windHotspots;
    scatter3(hs(:,1), hs(:,2), hs(:,3), 45, ...
        'filled', 'MarkerFaceColor', [0.42 0.58 0.72], ...
        'MarkerEdgeColor', [0.28 0.42 0.55]);
end

% ---------- Start / Goal ----------
plot3(params.start(1), params.start(2), params.start(3), ...
    's', 'MarkerSize', 10, 'LineWidth', 2, ...
    'Color', [0.00 0.50 0.35], 'MarkerFaceColor', [0.00 0.62 0.45]);
plot3(params.goal(1), params.goal(2), params.goal(3), ...
    'p', 'MarkerSize', 11, 'LineWidth', 2, ...
    'Color', [0.70 0.20 0.12], 'MarkerFaceColor', [0.82 0.28 0.16]);

% ---------- Manual legend handles ----------
hObs  = patch(nan, nan, [0.72 0.76 0.78], 'FaceAlpha', 0.30, 'EdgeColor', [0.45 0.49 0.51]);
hNFZ  = plot3(nan, nan, nan, '-', 'Color', [0.56 0.18 0.25], 'LineWidth', 1.8);
hWind = scatter3(nan, nan, nan, 45, 'filled', 'MarkerFaceColor', [0.42 0.58 0.72], 'MarkerEdgeColor', [0.28 0.42 0.55]);
hStart = plot3(nan, nan, nan, 's', 'MarkerSize', 10, 'LineWidth', 2, 'Color', [0.00 0.50 0.35], 'MarkerFaceColor', [0.00 0.62 0.45]);
hGoal  = plot3(nan, nan, nan, 'p', 'MarkerSize', 11, 'LineWidth', 2, 'Color', [0.70 0.20 0.12], 'MarkerFaceColor', [0.82 0.28 0.16]);

legend([hObs, hNFZ, hWind, hStart, hGoal], ...
    {'Obstacles', 'NFZ', 'Wind hotspots', 'Start', 'Goal'}, ...
    'Location', 'northeastoutside');
end

function drawBoxLocal(box, faceColor, faceAlpha, edgeColor)
if nargin < 4
    edgeColor = faceColor;
end
[x, y, z] = ndgrid([box(1), box(2)], [box(3), box(4)], [box(5), box(6)]);
verts = [x(:), y(:), z(:)];
faces = [1 3 4 2; 5 6 8 7; 1 2 6 5; 3 7 8 4; 1 5 7 3; 2 4 8 6];
patch('Vertices', verts, 'Faces', faces, ...
      'FaceColor', faceColor, 'FaceAlpha', faceAlpha, ...
      'EdgeColor', edgeColor, 'EdgeAlpha', 0.58, 'LineWidth', 0.55);
end

function drawCylinderLocal(cyl, faceColor, faceAlpha, edgeColor)
if nargin < 4
    edgeColor = faceColor;
end
[xx, yy, zz] = cylinder(cyl(3), 50);
zz = zz * (cyl(5) - cyl(4)) + cyl(4);
xx = xx + cyl(1);
yy = yy + cyl(2);
surf(xx, yy, zz, ...
    'FaceColor', faceColor, 'FaceAlpha', faceAlpha, 'EdgeColor', 'none');

% top rim
th = linspace(0, 2*pi, 200);
xt = cyl(1) + cyl(3)*cos(th);
yt = cyl(2) + cyl(3)*sin(th);
zt = cyl(5) * ones(size(th));
plot3(xt, yt, zt, '-', 'Color', edgeColor, 'LineWidth', 1.2);
end

function drawNFZTopCircle(cyl, colorVal, lw)
th = linspace(0, 2*pi, 300);
x = cyl(1) + cyl(3)*cos(th);
y = cyl(2) + cyl(3)*sin(th);
z = zeros(size(th));
plot3(x, y, z, '-', 'Color', colorVal, 'LineWidth', lw);
end
