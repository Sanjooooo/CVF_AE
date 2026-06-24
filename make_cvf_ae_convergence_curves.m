function summary = make_cvf_ae_convergence_curves(resultDir, outDir)
%MAKE_CVF_AE_CONVERGENCE_CURVES Generate Route B convergence curves from run records.

if nargin < 1 || isempty(resultDir)
    resultDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_main_comparison_formal_conservative_20260623_091132');
end
if nargin < 2 || isempty(outDir)
    outDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_convergence_curves_20260623_from_main_comparison');
end

runDir = fullfile(resultDir, 'run_records');
if ~exist(runDir, 'dir')
    error('Cannot find run_records folder: %s', runDir);
end
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

sceneIds = [1, 2, 4];
algorithms = {'CVF-AE', 'CPO', 'DBO', 'GWO', 'AE', 'PSO', 'HHO'};
primaryAlgorithms = {'CVF-AE', 'CPO', 'DBO', 'GWO', 'AE'};

summaryRows = table();
curveRows = table();

for s = 1:numel(sceneIds)
    sceneId = sceneIds(s);
    sceneCurves = struct();
    sceneLen = 0;

    for a = 1:numel(algorithms)
        alg = algorithms{a};
        files = dir(fullfile(runDir, sprintf('scene%d_%s_run*.mat', sceneId, alg)));
        curves = {};
        finalFeasible = [];

        for k = 1:numel(files)
            S = load(fullfile(files(k).folder, files(k).name));
            if ~isfield(S, 'result')
                continue;
            end

            result = S.result;
            curve = localExtractConvergence(result);
            if isempty(curve)
                continue;
            end

            curves{end+1} = curve(:); %#ok<AGROW>
            finalFeasible(end+1) = localResultFeasible(result); %#ok<AGROW>
        end

        if isempty(curves)
            continue;
        end

        [M, meanCurve, stdCurve] = localCurveStats(curves);
        sceneLen = max(sceneLen, numel(meanCurve));

        safeAlg = localSafeName(alg);
        sceneCurves.(safeAlg).Algorithm = alg;
        sceneCurves.(safeAlg).Matrix = M;
        sceneCurves.(safeAlg).Mean = meanCurve(:);
        sceneCurves.(safeAlg).Std = stdCurve(:);
        sceneCurves.(safeAlg).NumRuns = numel(curves);
        sceneCurves.(safeAlg).FeasibleRate = mean(finalFeasible, 'omitnan');

        row = table(cvfAePaperSceneId(sceneId), {alg}, numel(curves), mean(finalFeasible, 'omitnan'), ...
            meanCurve(end), stdCurve(end), ...
            'VariableNames', {'Scene','Algorithm','NumRuns','FeasibleRate','FinalMean','FinalStd'});
        summaryRows = [summaryRows; row]; %#ok<AGROW>
    end

    algFields = fieldnames(sceneCurves);
    for i = 1:numel(algFields)
        C = sceneCurves.(algFields{i});
        meanCurve = localPad(C.Mean, sceneLen);
        stdCurve = localPad(C.Std, sceneLen);

        for iter = 1:sceneLen
            row = table(cvfAePaperSceneId(sceneId), {C.Algorithm}, iter, meanCurve(iter), stdCurve(iter), ...
                max(meanCurve(iter) - stdCurve(iter), eps), meanCurve(iter) + stdCurve(iter), ...
                'VariableNames', {'Scene','Algorithm','Iteration','MeanBestFitness','StdBestFitness','LowerStd','UpperStd'});
            curveRows = [curveRows; row]; %#ok<AGROW>
        end

        sceneCurves.(algFields{i}).Mean = meanCurve;
        sceneCurves.(algFields{i}).Std = stdCurve;
    end

    localPlotScene(outDir, sceneId, sceneCurves, algorithms, primaryAlgorithms, sceneLen);
end

writetable(summaryRows, fullfile(outDir, 'cvf_ae_convergence_summary.csv'));
writetable(curveRows, fullfile(outDir, 'cvf_ae_convergence_curves.csv'));
localWriteInterpretation(outDir, resultDir, summaryRows, algorithms, primaryAlgorithms);

summary = struct();
summary.resultDir = resultDir;
summary.outDir = outDir;
summary.summaryTable = summaryRows;
summary.curveTable = curveRows;

fprintf('\nCVF-AE convergence outputs written to:\n%s\n', outDir);
end

function curve = localExtractConvergence(result)
curve = [];
fields = {'convergence', 'bestHist', 'bestFitHistory', 'bestFitnessHistory', ...
    'bestCostHistory', 'curve', 'fitnessCurve', 'costHistory', 'gbestHistory', 'fbestHistory'};

for i = 1:numel(fields)
    f = fields{i};
    if isfield(result, f) && isnumeric(result.(f)) && ~isempty(result.(f))
        curve = result.(f)(:);
        curve = curve(isfinite(curve));
        if ~isempty(curve)
            return;
        end
    end
end
end

function tf = localResultFeasible(result)
tf = NaN;
if isfield(result, 'finalFeasible')
    tf = double(logical(result.finalFeasible));
elseif isfield(result, 'bestDetail') && isstruct(result.bestDetail) && isfield(result.bestDetail, 'isFeasible')
    tf = double(logical(result.bestDetail.isFeasible));
end
end

function [M, meanCurve, stdCurve] = localCurveStats(curves)
maxLen = max(cellfun(@numel, curves));
M = nan(numel(curves), maxLen);

for i = 1:numel(curves)
    c = curves{i}(:);
    M(i, 1:numel(c)) = c;
    if numel(c) < maxLen
        M(i, numel(c)+1:end) = c(end);
    end
end

meanCurve = mean(M, 1, 'omitnan');
stdCurve = std(M, 0, 1, 'omitnan');
end

function y = localPad(y, targetLen)
y = y(:);
if numel(y) < targetLen
    y(numel(y)+1:targetLen) = y(end);
else
    y = y(1:targetLen);
end
end

function localPlotScene(outDir, sceneId, sceneCurves, algorithms, primaryAlgorithms, sceneLen)
paperSceneId = cvfAePaperSceneId(sceneId);
fig = figure('Visible', 'off', 'Color', 'w', 'Position', [80, 80, 980, 620]);
ax = axes(fig);
set(ax, 'Position', [0.085, 0.115, 0.875, 0.795]);
hold(ax, 'on');
grid(ax, 'on');
box(ax, 'on');

colors = localColorMap();
handles = gobjects(0);
labels = {};

for i = 1:numel(algorithms)
    alg = algorithms{i};
    safeAlg = localSafeName(alg);
    if ~isfield(sceneCurves, safeAlg)
        continue;
    end

    C = sceneCurves.(safeAlg);
    x = (1:sceneLen)';
    meanCurve = C.Mean(:);
    stdCurve = C.Std(:);
    lo = max(meanCurve - stdCurve, eps);
    hi = meanCurve + stdCurve;

    color = colors.(safeAlg);
    isPrimary = any(strcmp(primaryAlgorithms, alg));
    if isPrimary
        patch(ax, [x; flipud(x)], [lo; flipud(hi)], color, ...
            'FaceAlpha', 0.10, 'EdgeColor', 'none', 'HandleVisibility', 'off');
        lineWidth = 1.9;
    else
        lineWidth = 1.1;
    end

    h = plot(ax, x, meanCurve, 'LineWidth', lineWidth, 'Color', color);
    handles(end+1) = h; %#ok<AGROW>
    labels{end+1} = alg; %#ok<AGROW>
end

xlabel(ax, 'Iteration');
ylabel(ax, 'Feasible-aware best fitness');
title(ax, sprintf('Scene %d convergence', paperSceneId));
set(ax, 'FontName', 'Times New Roman', 'FontSize', 11, 'LineWidth', 0.9);
xlim(ax, [1, sceneLen]);
legend(ax, handles, labels, 'Location', 'northeast', 'Interpreter', 'none', 'Box', 'on');

pngPath = fullfile(outDir, sprintf('scene%d_convergence_mean_std.png', paperSceneId));
figPath = fullfile(outDir, sprintf('scene%d_convergence_mean_std.fig', paperSceneId));
savefig(fig, figPath);
exportgraphics(fig, pngPath, 'Resolution', 300);
close(fig);
end

function colors = localColorMap()
colors = struct();
colors.CVF_AE = [0.000, 0.447, 0.741];
colors.CPO = [0.850, 0.325, 0.098];
colors.DBO = [0.929, 0.694, 0.125];
colors.GWO = [0.494, 0.184, 0.556];
colors.AE = [0.466, 0.674, 0.188];
colors.PSO = [0.301, 0.745, 0.933];
colors.HHO = [0.635, 0.078, 0.184];
end

function localWriteInterpretation(outDir, resultDir, summaryRows, algorithms, primaryAlgorithms)
fid = fopen(fullfile(outDir, 'CVF_AE_CONVERGENCE_INTERPRETATION.md'), 'w', 'n', 'UTF-8');
if fid < 0
    warning('Could not write convergence interpretation.');
    return;
end
c = onCleanup(@() fclose(fid));

fprintf(fid, '# CVF-AE 收敛曲线生成说明\n\n');
fprintf(fid, '生成时间：2026-06-23\n\n');
fprintf(fid, '## 数据来源\n\n');
fprintf(fid, '- `%s`\n\n', resultDir);
fprintf(fid, '本阶段只复用正式主对比 run records，不重跑优化实验。\n\n');
fprintf(fid, '## 算法范围\n\n');
fprintf(fid, '- 主显示算法：`%s`\n', strjoin(primaryAlgorithms, ', '));
fprintf(fid, '- 补充显示算法：`%s`\n\n', strjoin(setdiff(algorithms, primaryAlgorithms, 'stable'), ', '));
fprintf(fid, '曲线使用各 run 中由 Deb 可行性优先规则维护的 best-so-far fitness，可视为 feasible-aware best fitness 轨迹。\n\n');

fprintf(fid, '## 汇总\n\n');
fprintf(fid, '| Scene | Algorithm | NumRuns | FeasibleRate | FinalMean | FinalStd |\n');
fprintf(fid, '|---:|---|---:|---:|---:|---:|\n');
for i = 1:height(summaryRows)
    fprintf(fid, '| %g | %s | %d | %.2f | %.4f | %.4f |\n', ...
        summaryRows.Scene(i), summaryRows.Algorithm{i}, summaryRows.NumRuns(i), ...
        summaryRows.FeasibleRate(i), summaryRows.FinalMean(i), summaryRows.FinalStd(i));
end

fprintf(fid, '\n## 输出文件\n\n');
fprintf(fid, '- `cvf_ae_convergence_curves.csv`\n');
fprintf(fid, '- `cvf_ae_convergence_summary.csv`\n');
fprintf(fid, '- `scene1_convergence_mean_std.png`\n');
fprintf(fid, '- `scene2_convergence_mean_std.png`\n');
fprintf(fid, '- `scene3_convergence_mean_std.png`\n');
end

function safe = localSafeName(name)
safe = regexprep(char(name), '[^A-Za-z0-9]+', '_');
safe = regexprep(safe, '^_+|_+$', '');
end
