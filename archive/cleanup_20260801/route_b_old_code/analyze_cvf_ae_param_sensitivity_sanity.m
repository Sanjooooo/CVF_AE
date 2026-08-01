function sanity = analyze_cvf_ae_param_sensitivity_sanity(resultDir)
%ANALYZE_CVF_AE_PARAM_SENSITIVITY_SANITY Trajectory sanity for CVF-AE sensitivity runs.

if nargin < 1 || isempty(resultDir)
    resultDir = localFindLatestResultDir('cvf_ae_param_sensitivity_conservative_');
end

runDir = fullfile(resultDir, 'run_records');
if ~exist(runDir, 'dir')
    error('Cannot find run_records folder: %s', runDir);
end

files = dir(fullfile(runDir, '*.mat'));
runRows = table();

for k = 1:numel(files)
    tokens = regexp(files(k).name, '^(.+)_(low|default|high|weak|strong|strict|loose)_scene(\d+)_run(\d+)\.mat$', 'tokens', 'once');
    if isempty(tokens)
        continue;
    end

    paramKey = tokens{1};
    level = tokens{2};
    sceneId = str2double(tokens{3});
    runId = str2double(tokens{4});

    params = defaultParams();
    params.sceneId = sceneId;
    params = applyUAVSceneOverrides(params);

    S = load(fullfile(files(k).folder, files(k).name));
    if ~isfield(S, 'result')
        continue;
    end

    result = S.result;
    [bestCtrl, bestPath] = localRecoverBestPath(result, params);
    if isempty(bestPath)
        continue;
    end

    metrics = localPathMetrics(bestPath, params);
    metrics.ControlPointBoundaryHugFrac = localControlBoundaryMetrics(bestCtrl, params);
    row = localBuildRunRow(paramKey, level, sceneId, runId, files(k).name, result, metrics, bestCtrl);

    if isempty(runRows)
        runRows = row;
    else
        runRows = [runRows; row]; %#ok<AGROW>
    end
end

if isempty(runRows)
    error('No parameter sensitivity trajectory sanity rows were produced.');
end

summaryRows = localBuildSummary(runRows);
flagRows = runRows(runRows.VisualReviewFlag, :);
flagRows = sortrows(flagRows, {'ParamKey','Level','Scene','BestFitness'});

writetable(runRows, fullfile(resultDir, 'param_sensitivity_trajectory_sanity_runs.csv'));
writetable(summaryRows, fullfile(resultDir, 'param_sensitivity_trajectory_sanity_summary.csv'));
writetable(flagRows, fullfile(resultDir, 'param_sensitivity_trajectory_sanity_flags.csv'));

sanity = struct();
sanity.resultDir = resultDir;
sanity.runTable = runRows;
sanity.summaryTable = summaryRows;
sanity.flagTable = flagRows;

fprintf('\nParameter sensitivity trajectory sanity saved:\n');
fprintf('  %s\n', fullfile(resultDir, 'param_sensitivity_trajectory_sanity_runs.csv'));
fprintf('  %s\n', fullfile(resultDir, 'param_sensitivity_trajectory_sanity_summary.csv'));
fprintf('  %s\n', fullfile(resultDir, 'param_sensitivity_trajectory_sanity_flags.csv'));
fprintf('\nFlagged runs: %d / %d\n', height(flagRows), height(runRows));
end

function row = localBuildRunRow(paramKey, level, sceneId, runId, runFileName, result, metrics, bestCtrl)
bestFitness = localGetField(result, {'bestFitness','bestFit'}, NaN);
feasible = localLogical(localGetField(result, {'finalFeasible','isFeasible'}, false));
violation = localGetField(result, {'finalViolation','violation'}, NaN);

highAltitudeFlag = metrics.HighAltitudeFrac > 0.50 || metrics.VeryHighAltitudeFrac > 0.20;
boundaryHugFlag = metrics.BoundaryHugFrac > 0.65 && metrics.MeanBoundaryDist < 2 * metrics.BoundaryBand;
excessiveDetourFlag = metrics.DetourRatio > 1.80;
controlPointEdgeFlag = metrics.ControlPointBoundaryHugFrac > 0.65;
visualReviewFlag = highAltitudeFlag || boundaryHugFlag || excessiveDetourFlag || controlPointEdgeFlag;

row = table( ...
    {paramKey}, {level}, sceneId, runId, {runFileName}, ...
    bestFitness, feasible, violation, ...
    metrics.MeanZ, metrics.MaxZ, metrics.MinZ, metrics.StdZ, ...
    metrics.HighThreshold, metrics.HighAltitudeFrac, metrics.VeryHighThreshold, metrics.VeryHighAltitudeFrac, ...
    metrics.PathLength, metrics.DetourRatio, metrics.BoundaryBand, metrics.MinBoundaryDist, ...
    metrics.MeanBoundaryDist, metrics.BoundaryHugFrac, metrics.ControlPointBoundaryHugFrac, ...
    size(bestCtrl, 1), highAltitudeFlag, boundaryHugFlag, excessiveDetourFlag, ...
    controlPointEdgeFlag, visualReviewFlag, ...
    'VariableNames', {'ParamKey','Level','Scene','Run','RunFile','BestFitness','Feasible','Violation', ...
    'MeanZ','MaxZ','MinZ','StdZ','HighThreshold','HighAltitudeFrac','VeryHighThreshold', ...
    'VeryHighAltitudeFrac','PathLength','DetourRatio','BoundaryBand','MinBoundaryDist', ...
    'MeanBoundaryDist','BoundaryHugFrac','ControlPointBoundaryHugFrac','NumControlPoints', ...
    'HighAltitudeFlag','BoundaryHugFlag','ExcessiveDetourFlag','ControlPointEdgeFlag','VisualReviewFlag'} );
end

function summaryRows = localBuildSummary(runRows)
groups = unique(runRows(:, {'ParamKey','Level','Scene'}), 'rows', 'stable');
summaryRows = table();
for i = 1:height(groups)
    mask = strcmp(runRows.ParamKey, groups.ParamKey{i}) & ...
        strcmp(runRows.Level, groups.Level{i}) & runRows.Scene == groups.Scene(i);
    T = runRows(mask, :);
    row = table( ...
        groups.ParamKey(i), groups.Level(i), groups.Scene(i), height(T), ...
        mean(double(T.Feasible), 'omitnan'), mean(T.BestFitness, 'omitnan'), ...
        mean(T.MeanZ, 'omitnan'), mean(T.MaxZ, 'omitnan'), ...
        mean(T.HighAltitudeFrac, 'omitnan'), mean(T.VeryHighAltitudeFrac, 'omitnan'), ...
        mean(T.DetourRatio, 'omitnan'), mean(T.MeanBoundaryDist, 'omitnan'), ...
        mean(T.BoundaryHugFrac, 'omitnan'), mean(T.ControlPointBoundaryHugFrac, 'omitnan'), ...
        mean(double(T.HighAltitudeFlag), 'omitnan'), mean(double(T.BoundaryHugFlag), 'omitnan'), ...
        mean(double(T.ExcessiveDetourFlag), 'omitnan'), mean(double(T.ControlPointEdgeFlag), 'omitnan'), ...
        mean(double(T.VisualReviewFlag), 'omitnan'), ...
        'VariableNames', {'ParamKey','Level','Scene','NumRuns','FeasibleRate','MeanBestFitness', ...
        'MeanZ','MeanMaxZ','MeanHighAltitudeFrac','MeanVeryHighAltitudeFrac', ...
        'MeanDetourRatio','MeanBoundaryDist','MeanBoundaryHugFrac','MeanControlPointBoundaryHugFrac', ...
        'HighAltitudeFlagRate','BoundaryHugFlagRate','ExcessiveDetourFlagRate', ...
        'ControlPointEdgeFlagRate','VisualReviewFlagRate'} );
    if isempty(summaryRows)
        summaryRows = row;
    else
        summaryRows = [summaryRows; row]; %#ok<AGROW>
    end
end
end

function metrics = localPathMetrics(pathPts, params)
pathPts = localNormalizeXYZ(pathPts);
z = pathPts(:, 3);
seg = diff(pathPts, 1, 1);
pathLength = sum(sqrt(sum(seg.^2, 2)));
straightDist = max(norm(pathPts(end, :) - pathPts(1, :)), 1e-12);

altMin = localGetParam(params, 'altMin', min(z));
altMax = localGetParam(params, 'altMax', max(z));
refCruiseZ = localGetParam(params, 'refCruiseZ', localGetParam(params, 'heightRef', mean([altMin, altMax])));
highThreshold = min(altMax - 2, refCruiseZ + 8);
veryHighThreshold = min(altMax - 1, refCruiseZ + 16);

xlim = localGetNested(params, 'map', 'xlim', [min(pathPts(:,1)), max(pathPts(:,1))]);
ylim = localGetNested(params, 'map', 'ylim', [min(pathPts(:,2)), max(pathPts(:,2))]);
boundaryBand = min(localGetParam(params, 'boundaryMargin', 8), 8);
boundaryDist = min([pathPts(:,1) - xlim(1), xlim(2) - pathPts(:,1), ...
    pathPts(:,2) - ylim(1), ylim(2) - pathPts(:,2)], [], 2);
boundaryDist = max(boundaryDist, 0);
interiorIdx = localInteriorIndices(size(pathPts, 1));
boundaryDistInterior = boundaryDist(interiorIdx);

metrics = struct();
metrics.MeanZ = mean(z, 'omitnan');
metrics.MaxZ = max(z);
metrics.MinZ = min(z);
metrics.StdZ = std(z, 'omitnan');
metrics.HighThreshold = highThreshold;
metrics.HighAltitudeFrac = mean(z >= highThreshold, 'omitnan');
metrics.VeryHighThreshold = veryHighThreshold;
metrics.VeryHighAltitudeFrac = mean(z >= veryHighThreshold, 'omitnan');
metrics.PathLength = pathLength;
metrics.DetourRatio = pathLength / straightDist;
metrics.BoundaryBand = boundaryBand;
metrics.MinBoundaryDist = min(boundaryDistInterior);
metrics.MeanBoundaryDist = mean(boundaryDistInterior, 'omitnan');
metrics.BoundaryHugFrac = mean(boundaryDistInterior <= boundaryBand, 'omitnan');
metrics.ControlPointBoundaryHugFrac = NaN;
end

function [bestCtrl, bestPath] = localRecoverBestPath(result, params)
bestCtrl = [];
bestPath = [];
if isfield(result, 'bestCtrl') && ~isempty(result.bestCtrl)
    bestCtrl = localNormalizeXYZ(result.bestCtrl);
end
if isfield(result, 'bestPath') && ~isempty(result.bestPath)
    bestPath = localNormalizeXYZ(result.bestPath);
end
if isempty(bestCtrl)
    bestX = localGetField(result, {'bestX','bestPosition'}, []);
    if ~isempty(bestX)
        try
            bestCtrl = localNormalizeXYZ(decodeSolution(bestX, params));
        catch
            bestCtrl = [];
        end
    end
end
if isempty(bestPath) && ~isempty(bestCtrl)
    bestPath = localNormalizeXYZ(bsplinePath(bestCtrl, params.degree, params.nSamples));
end
end

function frac = localControlBoundaryMetrics(ctrlPts, params)
if isempty(ctrlPts)
    frac = NaN;
    return;
end
xlim = localGetNested(params, 'map', 'xlim', [min(ctrlPts(:,1)), max(ctrlPts(:,1))]);
ylim = localGetNested(params, 'map', 'ylim', [min(ctrlPts(:,2)), max(ctrlPts(:,2))]);
boundaryBand = min(localGetParam(params, 'boundaryMargin', 8), 8);
if size(ctrlPts, 1) > 2
    ctrlPts = ctrlPts(2:end-1, :);
end
boundaryDist = min([ctrlPts(:,1) - xlim(1), xlim(2) - ctrlPts(:,1), ...
    ctrlPts(:,2) - ylim(1), ylim(2) - ctrlPts(:,2)], [], 2);
boundaryDist = max(boundaryDist, 0);
frac = mean(boundaryDist <= boundaryBand, 'omitnan');
end

function idx = localInteriorIndices(n)
if n <= 10
    idx = 1:n;
else
    idx = max(1, floor(0.05 * n)):min(n, ceil(0.95 * n));
end
end

function arr = localNormalizeXYZ(arr)
if isempty(arr) || ~isnumeric(arr)
    return;
end
if size(arr, 2) >= 3
    arr = arr(:, 1:3);
elseif size(arr, 1) >= 3
    arr = arr(1:3, :).';
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

function val = localGetParam(s, name, defaultVal)
if isfield(s, name)
    val = s.(name);
else
    val = defaultVal;
end
end

function val = localGetNested(s, parent, child, defaultVal)
if isfield(s, parent) && isstruct(s.(parent)) && isfield(s.(parent), child)
    val = s.(parent).(child);
else
    val = defaultVal;
end
end

function tf = localLogical(x)
if islogical(x)
    tf = x;
elseif isnumeric(x)
    tf = x ~= 0;
else
    tf = false;
end
end

function resultDir = localFindLatestResultDir(prefix)
resultRoot = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results');
listing = dir(fullfile(resultRoot, [prefix '*']));
listing = listing([listing.isdir]);
if isempty(listing)
    error('No existing parameter sensitivity directory found for prefix: %s', prefix);
end
[~, idx] = max([listing.datenum]);
resultDir = fullfile(listing(idx).folder, listing(idx).name);
end
