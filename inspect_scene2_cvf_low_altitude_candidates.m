function candidates = inspect_scene2_cvf_low_altitude_candidates()
%INSPECT_SCENE2_CVF_LOW_ALTITUDE_CANDIDATES Rank existing CVF-AE Scene 2 paths.
%
% This diagnostic only reads existing run records. It does not rerun
% optimization.

projectRoot = fileparts(mfilename('fullpath'));
resultDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
    'cvf_ae_main_comparison_formal_conservative_20260623_091132');
sanityPath = fullfile(resultDir, 'trajectory_sanity_runs.csv');
runDir = fullfile(resultDir, 'run_records');

T = readtable(sanityPath, 'TextType', 'string');
T = T(T.Scene == 2 & T.Algorithm == "CVF-AE" & T.Feasible > 0 & ...
    T.VisualReviewFlag == 0 & T.HighAltitudeFlag == 0, :);

params = defaultParams();
params.sceneId = 2;
params = applyUAVSceneOverrides(params);
map = createMap(params);
obstacles = map.obstacles;

footprintFrac = nan(height(T), 1);
meanRoofClearance = nan(height(T), 1);
minRoofClearance = nan(height(T), 1);
for i = 1:height(T)
    S = load(fullfile(runDir, char(T.RunFile(i))));
    [~, path] = localRecoverBestPath(S.result, params);
    [footprintFrac(i), meanRoofClearance(i), minRoofClearance(i)] = ...
        localObstacleFootprintMetrics(path, obstacles);
end

T.ObstacleFootprintFrac = footprintFrac;
T.MeanRoofClearance = meanRoofClearance;
T.MinRoofClearance = minRoofClearance;
T.LowAltitudeScore = T.MeanZ + 0.25 * max(T.MaxZ - params.refCruiseZ, 0) + ...
    30 * T.ObstacleFootprintFrac + 5 * T.BoundaryHugFrac + ...
    0.02 * (T.BestFitness - min(T.BestFitness));
candidates = sortrows(T, {'LowAltitudeScore', 'BestFitness'});

outDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
    'cvf_ae_selected7_paper_artifacts_20260706');
if ~exist(outDir, 'dir')
    mkdir(outDir);
end
writetable(candidates, fullfile(outDir, 'scene2_cvf_ae_low_altitude_candidates.csv'));
disp(candidates(:, {'RunFile','BestFitness','MeanZ','MaxZ','BoundaryHugFrac', ...
    'ObstacleFootprintFrac','MeanRoofClearance','MinRoofClearance','LowAltitudeScore'}));
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

function [footprintFrac, meanRoofClearance, minRoofClearance] = ...
    localObstacleFootprintMetrics(path, obstacles)
insideAny = false(size(path, 1), 1);
roofClearances = [];
for obsIdx = 1:size(obstacles, 1)
    obs = obstacles(obsIdx, :);
    inside = path(:,1) >= obs(1) & path(:,1) <= obs(2) & ...
        path(:,2) >= obs(3) & path(:,2) <= obs(4);
    insideAny = insideAny | inside;
    if any(inside)
        roofClearances = [roofClearances; path(inside, 3) - obs(6)]; %#ok<AGROW>
    end
end
footprintFrac = mean(insideAny);
if isempty(roofClearances)
    meanRoofClearance = NaN;
    minRoofClearance = NaN;
else
    meanRoofClearance = mean(roofClearances, 'omitnan');
    minRoofClearance = min(roofClearances);
end
end
