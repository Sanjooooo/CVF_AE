function out = make_cvf_ae_ablation_representative_figure(ablationDir, outDir)
%MAKE_CVF_AE_ABLATION_REPRESENTATIVE_FIGURE Draw the active ablation path figure.
%
% The function selects one representative run for each current ablation
% variant and draws only the Scene 3 three-dimensional overlay used by the
% manuscript. It does not generate historical main or extended comparisons.

projectRoot = fileparts(mfilename('fullpath'));
resultsRoot = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results');
if nargin < 1 || isempty(ablationDir)
    ablationDir = fullfile(resultsRoot, ...
        'cvf_ae_formal_ablation_corrected_20260730_v2');
end
if nargin < 2 || isempty(outDir)
    outDir = fullfile(resultsRoot, ...
        'cvf_ae_corrected_ablation_paper_artifacts_20260730', ...
        'representative_paths', 'ablation');
end
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

sceneId = 4;
entries = [ ...
    localEntry('CVF-AE', 'CVF_AE'), ...
    localEntry('w/o CVF', 'CVF_AE_W_O_CVF'), ...
    localEntry('w/o StateCVF', 'CVF_AE_W_O_STATEADAPTIVECVF'), ...
    localEntry('w/o Sparse', 'CVF_AE_W_O_SPARSEPRESERVATION'), ...
    localEntry('w/o Init', 'CVF_AE_W_O_INIT'), ...
    localEntry('Base-AE', 'BASE_AE')];

reps = repmat(localEmptyRep(), numel(entries), 1);
selection = table();
for entryIndex = 1:numel(entries)
    reps(entryIndex) = localSelectRepresentative( ...
        ablationDir, sceneId, entries(entryIndex));
    selection = [selection; localRepToTable(reps(entryIndex))]; %#ok<AGROW>
end

selectionPath = fullfile(outDir, ...
    'ablation_scene3_representative_selection.csv');
writetable(selection, selectionPath);
[pngPath, figPath] = localPlotScene(outDir, sceneId, reps);

out = struct();
out.sourceDir = ablationDir;
out.outputDir = outDir;
out.selection = selection;
out.selectionCsv = selectionPath;
out.png = pngPath;
out.fig = figPath;

fprintf('Ablation representative path figure written to:\n%s\n', pngPath);
end

function entry = localEntry(label, algorithm)
entry = struct('label', label, 'algorithm', algorithm);
end

function rep = localSelectRepresentative(resultDir, sceneId, entry)
sanityPath = fullfile(resultDir, 'trajectory_sanity_runs.csv');
runDir = fullfile(resultDir, 'run_records');
assert(isfile(sanityPath), 'Missing trajectory sanity table: %s', sanityPath);
assert(isfolder(runDir), 'Missing run-record directory: %s', runDir);

runs = readtable(sanityPath, 'TextType', 'string');
mask = runs.Scene == sceneId & strcmpi(runs.Algorithm, entry.algorithm);
runs = runs(mask, :);
assert(~isempty(runs), ...
    'No Scene 3 sanity rows for ablation variant %s.', entry.algorithm);

feasible = runs(logical(runs.Feasible), :);
if isempty(feasible)
    medianFitness = median(runs.BestFitness, 'omitnan');
else
    medianFitness = median(feasible.BestFitness, 'omitnan');
end

clean = table();
if ~isempty(feasible)
    clean = feasible(~logical(feasible.VisualReviewFlag), :);
end
if ~isempty(clean)
    candidates = clean;
    tier = "feasible_clean_median";
    candidates.SelectionDistance = ...
        abs(candidates.BestFitness - medianFitness);
    candidates = sortrows(candidates, ...
        {'SelectionDistance', 'BestFitness'});
elseif ~isempty(feasible)
    candidates = feasible;
    tier = "feasible_flagged_median";
    candidates.SelectionDistance = ...
        abs(candidates.BestFitness - medianFitness);
    candidates = sortrows(candidates, ...
        {'SelectionDistance', 'BestFitness'});
else
    candidates = runs;
    tier = "infeasible_min_violation_median";
    candidates.SelectionDistance = ...
        abs(candidates.BestFitness - medianFitness);
    candidates = sortrows(candidates, ...
        {'Violation', 'SelectionDistance', 'BestFitness'});
end

selected = candidates(1, :);
runPath = fullfile(runDir, char(selected.RunFile));
data = load(runPath, 'result');
assert(isfield(data, 'result'), 'Run file has no result field: %s', runPath);

params = defaultParams();
params.sceneId = sceneId;
params = applyUAVSceneOverrides(params);
[bestCtrl, bestPath] = localRecoverBestPath(data.result, params);
assert(~isempty(bestPath), 'Could not recover path from %s', runPath);

rep = localEmptyRep();
rep.Scene = cvfAePaperSceneId(sceneId);
rep.DisplayName = string(entry.label);
rep.Algorithm = string(entry.algorithm);
rep.RunFile = selected.RunFile;
runToken = regexp(char(selected.RunFile), 'run(\d+)', 'tokens', 'once');
if ~isempty(runToken)
    rep.Run = str2double(runToken{1});
end
rep.SelectionTier = tier;
rep.SelectionDistance = selected.SelectionDistance;
rep.BestFitness = selected.BestFitness;
rep.Feasible = logical(selected.Feasible);
rep.Violation = selected.Violation;
rep.VisualReviewFlag = logical(selected.VisualReviewFlag);
rep.MeanZ = selected.MeanZ;
rep.MaxZ = selected.MaxZ;
rep.BoundaryHugFrac = selected.BoundaryHugFrac;
rep.DetourRatio = selected.DetourRatio;
rep.bestCtrl = bestCtrl;
rep.bestPath = bestPath;
end

function rep = localEmptyRep()
rep = struct( ...
    'Scene', NaN, ...
    'DisplayName', "", ...
    'Algorithm', "", ...
    'RunFile', "", ...
    'Run', NaN, ...
    'SelectionTier', "", ...
    'SelectionDistance', NaN, ...
    'BestFitness', NaN, ...
    'Feasible', false, ...
    'Violation', NaN, ...
    'VisualReviewFlag', false, ...
    'MeanZ', NaN, ...
    'MaxZ', NaN, ...
    'BoundaryHugFrac', NaN, ...
    'DetourRatio', NaN, ...
    'bestCtrl', [], ...
    'bestPath', []);
end

function row = localRepToTable(rep)
row = table( ...
    rep.Scene, rep.DisplayName, rep.Algorithm, rep.Run, rep.RunFile, ...
    rep.SelectionTier, rep.SelectionDistance, rep.BestFitness, ...
    rep.Feasible, rep.Violation, rep.VisualReviewFlag, rep.MeanZ, ...
    rep.MaxZ, rep.BoundaryHugFrac, rep.DetourRatio, ...
    'VariableNames', {'Scene', 'DisplayName', 'Algorithm', 'Run', ...
    'RunFile', 'SelectionTier', 'SelectionDistance', 'BestFitness', ...
    'Feasible', 'Violation', 'VisualReviewFlag', 'MeanZ', 'MaxZ', ...
    'BoundaryHugFrac', 'DetourRatio'});
end

function [pngPath, figPath] = localPlotScene(outDir, sceneId, reps)
params = defaultParams();
params.sceneId = sceneId;
params = applyUAVSceneOverrides(params);
params.figView = [-37.5, 30];
map = createMap(params);

fig = figure('Visible', 'off', 'Color', 'w', ...
    'Position', [80, 80, 1300, 900]);
plotSceneOnly(map, params);
hold on;
oldLegend = findobj(fig, 'Type', 'Legend');
if ~isempty(oldLegend)
    delete(oldLegend);
end

colors = [ ...
    0.00, 0.14, 0.32
    0.84, 0.37, 0.00
    0.80, 0.47, 0.65
    0.35, 0.70, 0.90
    0.40, 0.25, 0.65
    0.45, 0.45, 0.45];
handles = gobjects(numel(reps), 1);
labels = cell(numel(reps), 1);
for repIndex = 1:numel(reps)
    handles(repIndex) = plot3( ...
        reps(repIndex).bestPath(:, 1), ...
        reps(repIndex).bestPath(:, 2), ...
        reps(repIndex).bestPath(:, 3), ...
        '-', 'Color', colors(repIndex, :), 'LineWidth', 2.2);
    plot3( ...
        reps(repIndex).bestCtrl(:, 1), ...
        reps(repIndex).bestCtrl(:, 2), ...
        reps(repIndex).bestCtrl(:, 3), ...
        'o', 'Color', colors(repIndex, :), ...
        'MarkerSize', 3.5, 'LineWidth', 0.9);
    labels{repIndex} = char(reps(repIndex).DisplayName);
end
legend(handles, labels, 'Location', 'northeastoutside', ...
    'Interpreter', 'none');

pngPath = fullfile(outDir, ...
    'ablation_scene3_representative_3d.png');
figPath = fullfile(outDir, ...
    'ablation_scene3_representative_3d.fig');
savefig(fig, figPath);
exportgraphics(fig, pngPath, 'Resolution', 300);
close(fig);
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

function value = localGetField(s, names, defaultValue)
value = defaultValue;
for nameIndex = 1:numel(names)
    if isfield(s, names{nameIndex})
        value = s.(names{nameIndex});
        return;
    end
end
end
