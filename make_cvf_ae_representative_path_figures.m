function out = make_cvf_ae_representative_path_figures(mainDir, recentDir, ablationDir, outDir)
%MAKE_CVF_AE_REPRESENTATIVE_PATH_FIGURES Select and plot representative UAV paths.
%
% Selection priority:
%   1) feasible and VisualReviewFlag == false, closest to feasible median fitness
%   2) feasible, closest to feasible median fitness
%   3) smallest violation, then closest to all-run median fitness

if nargin < 1 || isempty(mainDir)
    mainDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_main_comparison_formal_conservative_20260623_091132');
end
if nargin < 2 || isempty(recentDir)
    recentDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_main_comparison_recent_improved_formal_20260623_161229');
end
if nargin < 3 || isempty(ablationDir)
    ablationDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_formal_ablation_conservative_20260622_194947');
end
if nargin < 4 || isempty(outDir)
    outDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_representative_paths_20260623_from_formal_results');
end
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

sceneIds = [1, 2, 4];
sets = localBuildFigureSets(mainDir, recentDir, ablationDir);
allSelections = table();

for g = 1:numel(sets)
    figSet = sets(g);
    setOutDir = fullfile(outDir, figSet.name);
    if ~exist(setOutDir, 'dir')
        mkdir(setOutDir);
    end

    for s = 1:numel(sceneIds)
        sceneId = sceneIds(s);
        paperSceneId = cvfAePaperSceneId(sceneId);
        reps = repmat(localEmptyRep(), numel(figSet.entries), 1);
        selectionRows = table();

        for a = 1:numel(figSet.entries)
            entry = figSet.entries(a);
            reps(a) = localSelectRepresentative(figSet.name, sceneId, entry);
            row = localRepToTable(reps(a));
            selectionRows = [selectionRows; row]; %#ok<AGROW>
        end

        allSelections = [allSelections; selectionRows]; %#ok<AGROW>
        writetable(selectionRows, fullfile(setOutDir, ...
            sprintf('%s_scene%d_representative_selection.csv', figSet.name, paperSceneId)));

        localPlotSceneSet(setOutDir, figSet.name, sceneId, reps, false);
        localPlotSceneSet(setOutDir, figSet.name, sceneId, reps, true);
    end
end

writetable(allSelections, fullfile(outDir, 'representative_run_selection_all.csv'));
localWriteInterpretation(outDir, allSelections, sets);

out = struct();
out.outDir = outDir;
out.selectionTable = allSelections;

fprintf('\nRepresentative path outputs written to:\n%s\n', outDir);
fprintf('Selection rows: %d\n', height(allSelections));
end

function sets = localBuildFigureSets(mainDir, recentDir, ablationDir)
sets = struct([]);

sets(1).name = 'main';
sets(1).title = 'Main comparison';
sets(1).entries = [ ...
    localEntry('CVF-AE', 'CVF-AE', mainDir), ...
    localEntry('CPO', 'CPO', mainDir), ...
    localEntry('DBO', 'DBO', mainDir), ...
    localEntry('GWO', 'GWO', mainDir), ...
    localEntry('AE', 'AE', mainDir)];

sets(2).name = 'extended';
sets(2).title = 'Extended comparison';
sets(2).entries = [ ...
    localEntry('CVF-AE', 'CVF-AE', mainDir), ...
    localEntry('CPO', 'CPO', mainDir), ...
    localEntry('DBO', 'DBO', mainDir), ...
    localEntry('GDSAO', 'GDSAO', recentDir), ...
    localEntry('MSCSO', 'MSCSO', recentDir), ...
    localEntry('ERIME', 'ERIME', recentDir)];

sets(3).name = 'ablation';
sets(3).title = 'Ablation';
sets(3).entries = [ ...
    localEntry('CVF-AE', 'CVF_AE', ablationDir), ...
    localEntry('w/o CVF', 'CVF_AE_W_O_CVF', ablationDir), ...
    localEntry('w/o StateCVF', 'CVF_AE_W_O_STATEADAPTIVECVF', ablationDir), ...
    localEntry('w/o Sparse', 'CVF_AE_W_O_SPARSEPRESERVATION', ablationDir), ...
    localEntry('w/o Init', 'CVF_AE_W_O_INIT', ablationDir), ...
    localEntry('Base-AE', 'BASE_AE', ablationDir)];
end

function entry = localEntry(label, algName, resultDir)
entry = struct();
entry.label = label;
entry.algName = algName;
entry.resultDir = resultDir;
end

function rep = localSelectRepresentative(figSetName, sceneId, entry)
sanityPath = fullfile(entry.resultDir, 'trajectory_sanity_runs.csv');
runDir = fullfile(entry.resultDir, 'run_records');
if ~exist(sanityPath, 'file')
    error('Missing trajectory sanity table: %s', sanityPath);
end
if ~exist(runDir, 'dir')
    error('Missing run_records folder: %s', runDir);
end

T = readtable(sanityPath, 'TextType', 'string');
mask = T.Scene == sceneId & strcmpi(T.Algorithm, entry.algName);
T = T(mask, :);
if isempty(T)
    error('No sanity rows for scene %d algorithm %s in %s', sceneId, entry.algName, entry.resultDir);
end

T.FeasibleDouble = double(T.Feasible);
feasibleRows = T(T.FeasibleDouble > 0, :);

if ~isempty(feasibleRows)
    medFit = median(feasibleRows.BestFitness, 'omitnan');
else
    medFit = median(T.BestFitness, 'omitnan');
end

if ~isempty(feasibleRows)
    cleanRows = feasibleRows(~logical(feasibleRows.VisualReviewFlag), :);
else
    cleanRows = table();
end

if ~isempty(cleanRows)
    C = cleanRows;
    tierName = "feasible_clean_median";
    C.SelectionDistance = abs(C.BestFitness - medFit);
    C = sortrows(C, {'SelectionDistance','BestFitness'});
elseif ~isempty(feasibleRows)
    C = feasibleRows;
    tierName = "feasible_flagged_median";
    C.SelectionDistance = abs(C.BestFitness - medFit);
    C = sortrows(C, {'SelectionDistance','BestFitness'});
else
    C = T;
    tierName = "infeasible_min_violation_median";
    C.SelectionDistance = abs(C.BestFitness - medFit);
    C = sortrows(C, {'Violation','SelectionDistance','BestFitness'});
end

selected = C(1, :);
runFile = fullfile(runDir, char(selected.RunFile));
S = load(runFile);
if ~isfield(S, 'result')
    error('Run file has no result field: %s', runFile);
end

params = defaultParams();
params.sceneId = sceneId;
params = applyUAVSceneOverrides(params);
[bestCtrl, bestPath] = localRecoverBestPath(S.result, params);

rep = localEmptyRep();
rep.FigureSet = string(figSetName);
rep.Scene = cvfAePaperSceneId(sceneId);
rep.DisplayName = string(entry.label);
rep.Algorithm = string(entry.algName);
rep.SourceDir = string(entry.resultDir);
rep.RunFile = selected.RunFile;
runToken = regexp(char(selected.RunFile), 'run(\d+)', 'tokens', 'once');
if ~isempty(runToken)
    rep.Run = str2double(runToken{1});
end
rep.SelectionTier = tierName;
rep.SelectionDistance = selected.SelectionDistance;
rep.BestFitness = selected.BestFitness;
rep.Feasible = logical(selected.Feasible);
rep.Violation = selected.Violation;
rep.VisualReviewFlag = logical(selected.VisualReviewFlag);
rep.HighAltitudeFlag = logical(selected.HighAltitudeFlag);
rep.BoundaryHugFlag = logical(selected.BoundaryHugFlag);
rep.ExcessiveDetourFlag = logical(selected.ExcessiveDetourFlag);
rep.ControlPointEdgeFlag = logical(selected.ControlPointEdgeFlag);
rep.MeanZ = selected.MeanZ;
rep.MaxZ = selected.MaxZ;
rep.HighAltitudeFrac = selected.HighAltitudeFrac;
rep.BoundaryHugFrac = selected.BoundaryHugFrac;
rep.DetourRatio = selected.DetourRatio;
rep.bestCtrl = bestCtrl;
rep.bestPath = bestPath;
end

function rep = localEmptyRep()
rep = struct();
rep.FigureSet = "";
rep.Scene = NaN;
rep.DisplayName = "";
rep.Algorithm = "";
rep.SourceDir = "";
rep.RunFile = "";
rep.Run = NaN;
rep.SelectionTier = "";
rep.SelectionDistance = NaN;
rep.BestFitness = NaN;
rep.Feasible = false;
rep.Violation = NaN;
rep.VisualReviewFlag = false;
rep.HighAltitudeFlag = false;
rep.BoundaryHugFlag = false;
rep.ExcessiveDetourFlag = false;
rep.ControlPointEdgeFlag = false;
rep.MeanZ = NaN;
rep.MaxZ = NaN;
rep.HighAltitudeFrac = NaN;
rep.BoundaryHugFrac = NaN;
rep.DetourRatio = NaN;
rep.bestCtrl = [];
rep.bestPath = [];
end

function row = localRepToTable(rep)
row = table(rep.FigureSet, rep.Scene, rep.DisplayName, rep.Algorithm, rep.Run, ...
    rep.SelectionTier, rep.SelectionDistance, rep.BestFitness, rep.Feasible, rep.Violation, ...
    rep.VisualReviewFlag, rep.HighAltitudeFlag, rep.BoundaryHugFlag, rep.ExcessiveDetourFlag, ...
    rep.ControlPointEdgeFlag, rep.MeanZ, rep.MaxZ, rep.HighAltitudeFrac, rep.BoundaryHugFrac, ...
    rep.DetourRatio, ...
    'VariableNames', {'FigureSet','Scene','DisplayName','Algorithm','Run', ...
    'SelectionTier','SelectionDistance','BestFitness','Feasible','Violation', ...
    'VisualReviewFlag','HighAltitudeFlag','BoundaryHugFlag','ExcessiveDetourFlag', ...
    'ControlPointEdgeFlag','MeanZ','MaxZ','HighAltitudeFrac','BoundaryHugFrac','DetourRatio'});
end

function localPlotSceneSet(outDir, figSetName, sceneId, reps, topView)
paperSceneId = cvfAePaperSceneId(sceneId);
params = defaultParams();
params.sceneId = sceneId;
params = applyUAVSceneOverrides(params);
if topView
    params.figView = [0, 90];
else
    params.figView = [-37.5, 30];
end
map = createMap(params);

fig = figure('Visible', 'off', 'Color', 'w', 'Position', [80 80 1300 900]);
plotSceneOnly(map, params);
hold on;
if topView
    view(2);
    axis equal;
end

oldLegend = findobj(fig, 'Type', 'Legend');
if ~isempty(oldLegend)
    delete(oldLegend);
end

colors = localColorMap();
handles = gobjects(0);
labels = {};
for i = 1:numel(reps)
    if isempty(reps(i).bestPath)
        continue;
    end
    color = colors(mod(i - 1, size(colors, 1)) + 1, :);
    h = plot3(reps(i).bestPath(:,1), reps(i).bestPath(:,2), reps(i).bestPath(:,3), ...
        '-', 'Color', color, 'LineWidth', 2.2);
    if ~isempty(reps(i).bestCtrl)
        plot3(reps(i).bestCtrl(:,1), reps(i).bestCtrl(:,2), reps(i).bestCtrl(:,3), ...
            'o', 'Color', color, 'MarkerSize', 3.5, 'LineWidth', 0.9);
    end
    handles(end+1) = h; %#ok<AGROW>
    labels{end+1} = char(reps(i).DisplayName); %#ok<AGROW>
end

if ~isempty(handles) && ~topView
    legend(handles, labels, 'Location', 'northeastoutside', 'Interpreter', 'none');
end
if topView
    legend off;
end

if topView
    viewName = 'top';
else
    viewName = '3d';
end
title(sprintf('%s | Scene %d representative paths (%s)', figSetName, paperSceneId, upper(viewName)), ...
    'Interpreter', 'none');

pngPath = fullfile(outDir, sprintf('%s_scene%d_representative_%s.png', figSetName, paperSceneId, viewName));
figPath = fullfile(outDir, sprintf('%s_scene%d_representative_%s.fig', figSetName, paperSceneId, viewName));
savefig(fig, figPath);
exportgraphics(fig, pngPath, 'Resolution', 300);
close(fig);
end

function colors = localColorMap()
colors = [ ...
    0.00, 0.14, 0.32; ...
    0.84, 0.37, 0.00; ...
    0.80, 0.47, 0.65; ...
    0.35, 0.70, 0.90; ...
    0.40, 0.25, 0.65; ...
    0.45, 0.45, 0.45; ...
    0.00, 0.45, 0.70];
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
    bestX = localGetField(result, {'bestX','bestPosition'}, []);
    if ~isempty(bestX)
        try
            bestCtrl = decodeSolution(bestX, params);
        catch
            bestCtrl = [];
        end
    end
end
if isempty(bestPath) && ~isempty(bestCtrl)
    try
        bestPath = bsplinePath(bestCtrl, params.degree, params.nSamples);
    catch
        bestPath = [];
    end
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

function localWriteInterpretation(outDir, selectionTable, sets)
fid = fopen(fullfile(outDir, 'CVF_AE_REPRESENTATIVE_PATHS_INTERPRETATION.md'), 'w', 'n', 'UTF-8');
if fid < 0
    warning('Could not write representative paths interpretation.');
    return;
end
c = onCleanup(@() fclose(fid));

fprintf(fid, '# CVF-AE 代表轨迹图筛选说明\n\n');
fprintf(fid, '生成时间：2026-06-23\n\n');
fprintf(fid, '## 筛选规则\n\n');
fprintf(fid, '1. 优先选择 feasible 且 `VisualReviewFlag = false` 的 run，并取 fitness 最接近 feasible 中位数者；\n');
fprintf(fid, '2. 若无无复核风险 run，则选择 feasible run 中 fitness 最接近 feasible 中位数者；\n');
fprintf(fid, '3. 若无 feasible run，则选择 violation 最小且 fitness 接近中位数者；\n');
fprintf(fid, '4. 所有选择写入 `representative_run_selection_all.csv`，避免人工挑选。\n\n');

fprintf(fid, '## 图集\n\n');
for i = 1:numel(sets)
    fprintf(fid, '- `%s`: %s\n', sets(i).name, sets(i).title);
end

fprintf(fid, '\n## 筛选层级统计\n\n');
tiers = unique(selectionTable.SelectionTier, 'stable');
for i = 1:numel(tiers)
    n = sum(selectionTable.SelectionTier == tiers(i));
    fprintf(fid, '- `%s`: %d\n', tiers(i), n);
end

fprintf(fid, '\n## 注意\n\n');
fprintf(fid, '带有 `feasible_flagged_median` 或 `infeasible_min_violation_median` 的轨迹需要在论文中明确解释其复核风险，不能作为无风险代表路径呈现。\n');
end
