function out = merge_cvf_ae_extended_main_comparison(mainDir, recentDir, outDir)
%MERGE_CVF_AE_EXTENDED_MAIN_COMPARISON Merge formal main and recent-improved results.

if nargin < 1 || isempty(mainDir)
    mainDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_main_comparison_formal_conservative_20260623_091132');
end
if nargin < 2 || isempty(recentDir)
    recentDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_main_comparison_recent_improved_formal_20260623_161229');
end
if nargin < 3 || isempty(outDir)
    outDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        'cvf_ae_extended_main_comparison_20260623_from_formal_and_recent');
end
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

mainSummary = readtable(fullfile(mainDir, 'uav_comparison_summary_long.csv'), 'TextType', 'string');
recentSummary = readtable(fullfile(recentDir, 'uav_comparison_summary_long.csv'), 'TextType', 'string');
mainSummary.Source = repmat("formal-main", height(mainSummary), 1);
recentSummary.Source = repmat("recent-improved", height(recentSummary), 1);

extendedSummary = [mainSummary; recentSummary];
extendedSummary = localRecomputeRanks(extendedSummary);
extendedAvgRank = localAverageRank(extendedSummary);

mainSanity = readtable(fullfile(mainDir, 'trajectory_sanity_summary.csv'), 'TextType', 'string');
recentSanity = readtable(fullfile(recentDir, 'trajectory_sanity_summary.csv'), 'TextType', 'string');
mainSanity.Source = repmat("formal-main", height(mainSanity), 1);
recentSanity.Source = repmat("recent-improved", height(recentSanity), 1);
extendedSanity = [mainSanity; recentSanity];
extendedSanity = sortrows(extendedSanity, {'Scene','Algorithm'});

writetable(extendedSummary, fullfile(outDir, 'extended_main_comparison_summary_long.csv'));
writetable(extendedAvgRank, fullfile(outDir, 'extended_main_comparison_average_rank.csv'));
writetable(extendedSanity, fullfile(outDir, 'extended_main_comparison_trajectory_sanity_summary.csv'));
localWriteInterpretation(outDir, mainDir, recentDir, extendedSummary, extendedAvgRank, extendedSanity);

out = struct();
out.outDir = outDir;
out.summaryTable = extendedSummary;
out.avgRankTable = extendedAvgRank;
out.sanityTable = extendedSanity;

fprintf('\nExtended main comparison outputs written to:\n%s\n', outDir);
end

function T = localRecomputeRanks(T)
if ~ismember('ExtendedRank', T.Properties.VariableNames)
    T.ExtendedRank = nan(height(T), 1);
end
scenes = unique(T.Scene, 'stable');
for s = 1:numel(scenes)
    mask = T.Scene == scenes(s);
    [~, order] = sort(T.Mean(mask), 'ascend');
    idx = find(mask);
    ranks = nan(numel(idx), 1);
    ranks(order) = (1:numel(idx))';
    T.ExtendedRank(idx) = ranks;
end
T = sortrows(T, {'Scene','ExtendedRank'});
end

function R = localAverageRank(T)
algs = unique(T.Algorithm, 'stable');
R = table();
for i = 1:numel(algs)
    mask = strcmp(T.Algorithm, algs(i));
    row = table(algs(i), mean(T.ExtendedRank(mask), 'omitnan'), ...
        mean(T.Mean(mask), 'omitnan'), mean(T.Feasibility(mask), 'omitnan'), ...
        mean(T.AvgNEvals(mask), 'omitnan'), mean(T.AvgRuntime(mask), 'omitnan'), ...
        'VariableNames', {'Algorithm','AverageRank','AverageMeanFitness','AverageFeasibility','AverageNEvals','AverageRuntime'});
    R = [R; row]; %#ok<AGROW>
end
R = sortrows(R, 'AverageRank');
end

function localWriteInterpretation(outDir, mainDir, recentDir, summary, avgRank, sanity)
fid = fopen(fullfile(outDir, 'CVF_AE_EXTENDED_MAIN_COMPARISON_INTERPRETATION.md'), 'w', 'n', 'UTF-8');
if fid < 0
    warning('Could not write extended comparison interpretation.');
    return;
end
c = onCleanup(@() fclose(fid));

fprintf(fid, '# CVF-AE 扩展主对比结果说明\n\n');
fprintf(fid, '生成时间：2026-06-23\n\n');
fprintf(fid, '## 数据来源\n\n');
fprintf(fid, '- 正式主对比：`%s`\n', mainDir);
fprintf(fid, '- 近年改进算法补充：`%s`\n\n', recentDir);
fprintf(fid, '本目录只合并既有正式结果，不重跑优化实验。\n\n');

fprintf(fid, '## 扩展平均排名\n\n');
fprintf(fid, '| Algorithm | AverageRank | AvgFitness | FeasibleRate | AvgNEvals | AvgRuntime |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|\n');
for i = 1:height(avgRank)
    fprintf(fid, '| %s | %.4f | %.4f | %.4f | %.1f | %.4f |\n', ...
        avgRank.Algorithm(i), avgRank.AverageRank(i), avgRank.AverageMeanFitness(i), ...
        avgRank.AverageFeasibility(i), avgRank.AverageNEvals(i), avgRank.AverageRuntime(i));
end

fprintf(fid, '\n## 分场景关键观察\n\n');
scenes = unique(summary.Scene, 'stable');
for s = 1:numel(scenes)
    sceneId = scenes(s);
    Ts = summary(summary.Scene == sceneId, :);
    Ts = sortrows(Ts, 'ExtendedRank');
    fprintf(fid, '- Scene %d: fitness 前三为 `%s`、`%s`、`%s`。\n', ...
        sceneId, Ts.Algorithm(1), Ts.Algorithm(2), Ts.Algorithm(3));
end

fprintf(fid, '\n## 轨迹 sanity 边界\n\n');
recent = sanity(strcmp(sanity.Source, "recent-improved"), :);
for i = 1:height(recent)
    fprintf(fid, '- Scene %d `%s`: feasible rate %.2f, visual review flag rate %.2f, high-altitude flag rate %.2f, boundary-hug flag rate %.2f。\n', ...
        recent.Scene(i), recent.Algorithm(i), recent.FeasibleRate(i), recent.VisualReviewFlagRate(i), ...
        recent.HighAltitudeFlagRate(i), recent.BoundaryHugFlagRate(i));
end

fprintf(fid, '\n写作建议：扩展主表可以增强 baseline 说服力，但新增近年改进算法存在较高 trajectory sanity 复核比例；论文解释应把 scalar fitness、feasible rate 和 trajectory sanity 联合呈现，不能只按 fitness 排名下结论。\n');
end
