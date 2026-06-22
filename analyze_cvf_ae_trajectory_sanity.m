function sanity = analyze_cvf_ae_trajectory_sanity(resultDir)
%ANALYZE_CVF_AE_TRAJECTORY_SANITY Check UAV path plausibility beyond fitness.
%
% Outputs:
%   trajectory_sanity_runs.csv
%   trajectory_sanity_summary.csv
%   trajectory_sanity_flags.csv
%
% The checks target visually invalid or weakly convincing trajectories such
% as high-altitude bypass, boundary hugging, and excessive detours.

if nargin < 1 || isempty(resultDir)
    resultDir = localFindLatestResultDir('cvf_ae_main_comparison_formal_');
end

runDir = fullfile(resultDir, 'run_records');
if ~exist(runDir, 'dir')
    error('Cannot find run_records folder: %s', runDir);
end

[sceneIds, algorithms] = localLoadExperimentLayout(resultDir, runDir);

runRows = table();
for s = 1:numel(sceneIds)
    sceneId = sceneIds(s);

    params = defaultParams();
    params.sceneId = sceneId;
    params = applyUAVSceneOverrides(params);

    for a = 1:numel(algorithms)
        algName = algorithms{a};
        pattern = fullfile(runDir, sprintf('scene%d_%s_run*.mat', sceneId, upper(algName)));
        files = dir(pattern);

        for k = 1:numel(files)
            runFile = fullfile(files(k).folder, files(k).name);
            try
                S = load(runFile);
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
                row = localBuildRunRow(sceneId, algName, files(k).name, result, metrics, bestCtrl);

                if isempty(runRows)
                    runRows = row;
                else
                    runRows = [runRows; row]; %#ok<AGROW>
                end
            catch ME
                warning('Failed to analyze %s: %s', runFile, ME.message);
            end
        end
    end
end

if isempty(runRows)
    error('No trajectory sanity rows were produced.');
end

summaryRows = localBuildSummary(runRows, sceneIds, algorithms);
flagRows = runRows(runRows.VisualReviewFlag, :);
flagRows = sortrows(flagRows, {'Scene','Algorithm','BestFitness'});

writetable(runRows, fullfile(resultDir, 'trajectory_sanity_runs.csv'));
writetable(summaryRows, fullfile(resultDir, 'trajectory_sanity_summary.csv'));
writetable(flagRows, fullfile(resultDir, 'trajectory_sanity_flags.csv'));

sanity = struct();
sanity.resultDir = resultDir;
sanity.runTable = runRows;
sanity.summaryTable = summaryRows;
sanity.flagTable = flagRows;

fprintf('\nTrajectory sanity analysis saved:\n');
fprintf('  %s\n', fullfile(resultDir, 'trajectory_sanity_runs.csv'));
fprintf('  %s\n', fullfile(resultDir, 'trajectory_sanity_summary.csv'));
fprintf('  %s\n', fullfile(resultDir, 'trajectory_sanity_flags.csv'));
fprintf('\nFlagged runs: %d / %d\n', height(flagRows), height(runRows));
end

function [sceneIds, algorithms] = localLoadExperimentLayout(resultDir, runDir)
sceneIds = [];
algorithms = {};

matFile = fullfile(resultDir, 'uav_comparison_results.mat');
if exist(matFile, 'file') == 2
    S = load(matFile, 'cfg');
    if isfield(S, 'cfg')
        if isfield(S.cfg, 'sceneIds')
            sceneIds = S.cfg.sceneIds;
        end
        if isfield(S.cfg, 'algorithms')
            algorithms = S.cfg.algorithms;
        end
    end
end

if isempty(sceneIds) || isempty(algorithms)
    files = dir(fullfile(runDir, 'scene*_run*.mat'));
    sceneSet = [];
    algSet = strings(0, 1);

    for k = 1:numel(files)
        tok = regexp(files(k).name, '^scene(\d+)_(.+)_run\d+\.mat$', 'tokens', 'once');
        if isempty(tok)
            continue;
        end
        sceneSet(end+1) = str2double(tok{1}); %#ok<AGROW>
        algSet(end+1) = string(tok{2}); %#ok<AGROW>
    end

    sceneIds = unique(sceneSet);
    algorithms = cellstr(unique(algSet, 'stable'));
end
end

function row = localBuildRunRow(sceneId, algName, runFileName, result, metrics, bestCtrl)
bestFitness = localGetField(result, {'bestFitness','bestFit'}, NaN);
feasible = localLogical(localGetField(result, {'finalFeasible','isFeasible'}, false));
violation = localGetField(result, {'finalViolation','violation'}, NaN);

highAltitudeFlag = metrics.HighAltitudeFrac > 0.50 || metrics.VeryHighAltitudeFrac > 0.20;
boundaryHugFlag = metrics.BoundaryHugFrac > 0.65 && metrics.MeanBoundaryDist < 2 * metrics.BoundaryBand;
excessiveDetourFlag = metrics.DetourRatio > 1.80;
controlPointEdgeFlag = metrics.ControlPointBoundaryHugFrac > 0.65;
visualReviewFlag = highAltitudeFlag || boundaryHugFlag || excessiveDetourFlag || controlPointEdgeFlag;

row = table( ...
    sceneId, {algName}, {runFileName}, ...
    bestFitness, feasible, violation, ...
    metrics.MeanZ, metrics.MaxZ, metrics.MinZ, metrics.StdZ, ...
    metrics.HighThreshold, metrics.HighAltitudeFrac, metrics.VeryHighThreshold, metrics.VeryHighAltitudeFrac, ...
    metrics.PathLength, metrics.DetourRatio, ...
    metrics.BoundaryBand, metrics.MinBoundaryDist, metrics.MeanBoundaryDist, metrics.BoundaryHugFrac, ...
    metrics.ControlPointBoundaryHugFrac, size(bestCtrl, 1), ...
    highAltitudeFlag, boundaryHugFlag, excessiveDetourFlag, controlPointEdgeFlag, visualReviewFlag, ...
    'VariableNames', {'Scene','Algorithm','RunFile','BestFitness','Feasible','Violation', ...
    'MeanZ','MaxZ','MinZ','StdZ','HighThreshold','HighAltitudeFrac', ...
    'VeryHighThreshold','VeryHighAltitudeFrac','PathLength','DetourRatio', ...
    'BoundaryBand','MinBoundaryDist','MeanBoundaryDist','BoundaryHugFrac', ...
    'ControlPointBoundaryHugFrac','NumControlPoints', ...
    'HighAltitudeFlag','BoundaryHugFlag','ExcessiveDetourFlag','ControlPointEdgeFlag','VisualReviewFlag'} );
end

function summaryRows = localBuildSummary(runRows, sceneIds, algorithms)
summaryRows = table();

for s = 1:numel(sceneIds)
    sceneId = sceneIds(s);
    for a = 1:numel(algorithms)
        algName = algorithms{a};
        mask = runRows.Scene == sceneId & strcmpi(runRows.Algorithm, algName);
        if ~any(mask)
            continue;
        end

        T = runRows(mask, :);
        row = table( ...
            sceneId, {algName}, height(T), ...
            mean(double(T.Feasible), 'omitnan'), ...
            mean(T.BestFitness, 'omitnan'), ...
            mean(T.MeanZ, 'omitnan'), ...
            mean(T.MaxZ, 'omitnan'), ...
            mean(T.HighAltitudeFrac, 'omitnan'), ...
            mean(T.VeryHighAltitudeFrac, 'omitnan'), ...
            mean(T.DetourRatio, 'omitnan'), ...
            mean(T.MeanBoundaryDist, 'omitnan'), ...
            mean(T.BoundaryHugFrac, 'omitnan'), ...
            mean(T.ControlPointBoundaryHugFrac, 'omitnan'), ...
            mean(double(T.HighAltitudeFlag), 'omitnan'), ...
            mean(double(T.BoundaryHugFlag), 'omitnan'), ...
            mean(double(T.ExcessiveDetourFlag), 'omitnan'), ...
            mean(double(T.ControlPointEdgeFlag), 'omitnan'), ...
            mean(double(T.VisualReviewFlag), 'omitnan'), ...
            'VariableNames', {'Scene','Algorithm','NumRuns','FeasibleRate', ...
            'MeanBestFitness','MeanZ','MeanMaxZ','MeanHighAltitudeFrac', ...
            'MeanVeryHighAltitudeFrac','MeanDetourRatio','MeanBoundaryDist', ...
            'MeanBoundaryHugFrac','MeanControlPointBoundaryHugFrac', ...
            'HighAltitudeFlagRate','BoundaryHugFlagRate','ExcessiveDetourFlagRate', ...
            'ControlPointEdgeFlagRate','VisualReviewFlagRate'} );

        if isempty(summaryRows)
            summaryRows = row;
        else
            summaryRows = [summaryRows; row]; %#ok<AGROW>
        end
    end
end
end

function metrics = localPathMetrics(pathPts, params)
pathPts = localNormalizeXYZ(pathPts);
z = pathPts(:, 3);

startPt = pathPts(1, :);
goalPt = pathPts(end, :);
seg = diff(pathPts, 1, 1);
segLen = sqrt(sum(seg.^2, 2));
pathLength = sum(segLen);
straightDist = max(norm(goalPt - startPt), 1e-12);

altMin = localGetParam(params, 'altMin', min(z));
altMax = localGetParam(params, 'altMax', max(z));
refCruiseZ = localGetParam(params, 'refCruiseZ', localGetParam(params, 'heightRef', mean([altMin, altMax])));

highThreshold = min(altMax - 2, refCruiseZ + 8);
veryHighThreshold = min(altMax - 1, refCruiseZ + 16);

if isfield(params, 'map') && isfield(params.map, 'xlim')
    xlim = params.map.xlim;
else
    xlim = [min(pathPts(:,1)), max(pathPts(:,1))];
end
if isfield(params, 'map') && isfield(params.map, 'ylim')
    ylim = params.map.ylim;
else
    ylim = [min(pathPts(:,2)), max(pathPts(:,2))];
end

boundaryBand = min(localGetParam(params, 'boundaryMargin', 8), 8);
boundaryDist = min([ ...
    pathPts(:,1) - xlim(1), xlim(2) - pathPts(:,1), ...
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

function idx = localInteriorIndices(n)
if n <= 10
    idx = 1:n;
else
    first = max(1, floor(0.05 * n));
    last = min(n, ceil(0.95 * n));
    idx = first:last;
end
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
    try
        bestPath = localNormalizeXYZ(bsplinePath(bestCtrl, params.degree, params.nSamples));
    catch
        bestPath = [];
    end
end

end

function frac = localControlBoundaryMetrics(ctrlPts, params)
if isempty(ctrlPts)
    frac = NaN;
    return;
end

if isfield(params, 'map') && isfield(params.map, 'xlim')
    xlim = params.map.xlim;
else
    xlim = [min(ctrlPts(:,1)), max(ctrlPts(:,1))];
end
if isfield(params, 'map') && isfield(params.map, 'ylim')
    ylim = params.map.ylim;
else
    ylim = [min(ctrlPts(:,2)), max(ctrlPts(:,2))];
end

boundaryBand = min(localGetParam(params, 'boundaryMargin', 8), 8);
if size(ctrlPts, 1) > 2
    ctrlPts = ctrlPts(2:end-1, :);
end
boundaryDist = min([ ...
    ctrlPts(:,1) - xlim(1), xlim(2) - ctrlPts(:,1), ...
    ctrlPts(:,2) - ylim(1), ylim(2) - ctrlPts(:,2)], [], 2);
boundaryDist = max(boundaryDist, 0);
frac = mean(boundaryDist <= boundaryBand, 'omitnan');
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

function tf = localLogical(v)
if islogical(v)
    tf = any(v(:));
elseif isnumeric(v)
    tf = any(v(:) ~= 0);
else
    tf = false;
end
end

function resultDir = localFindLatestResultDir(prefix)
resultRoot = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results');
listing = dir(fullfile(resultRoot, [prefix '*']));
listing = listing([listing.isdir]);
if isempty(listing)
    error('No result directory found for prefix: %s', prefix);
end
[~, idx] = max([listing.datenum]);
resultDir = fullfile(listing(idx).folder, listing(idx).name);
end
