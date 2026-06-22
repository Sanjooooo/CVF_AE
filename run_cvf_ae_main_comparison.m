function summary = run_cvf_ae_main_comparison(modeOrCfg)
%RUN_CVF_AE_MAIN_COMPARISON Route B main comparison runner.
%
% Usage:
%   run_cvf_ae_main_comparison()
%   run_cvf_ae_main_comparison('smoke')
%   run_cvf_ae_main_comparison('precheck')
%   run_cvf_ae_main_comparison('formal')
%   run_cvf_ae_main_comparison('resume-formal')
%   run_cvf_ae_main_comparison(cfg)

if nargin < 1 || isempty(modeOrCfg)
    modeOrCfg = 'precheck';
end

if ischar(modeOrCfg) || isstring(modeOrCfg)
    cfg = localBuildConfig(char(modeOrCfg));
elseif isstruct(modeOrCfg)
    cfg = localApplyDefaults(modeOrCfg);
else
    error('modeOrCfg must be a mode string or a config struct.');
end

summary = run_uav_comparison_lite_v2_batch(cfg);
localWriteReadme(cfg, summary);
end

function cfg = localBuildConfig(mode)
mode = lower(strtrim(mode));

cfg = struct();
cfg.sceneIds = [1, 2, 4];
cfg.algorithms = {'CVF-AE', 'AE', 'PSO', 'GWO', 'WOA', 'HHO', 'DBO', 'CPO'};
cfg.baseSeed = 20260624;
cfg.resumeExisting = true;
cfg.verbose = true;
cfg.useLiteFAEAE = true;
cfg.saveFigures = false;
cfg.showSingleRunFigure = false;
cfg.showBatchFigure = false;
cfg.saveBestPathFigure = false;
cfg.saveBestTopViewFigure = false;
cfg.useFairReferenceInit = false;
cfg.paramsOverride = struct();

switch mode
    case 'smoke'
        cfg.mode = 'smoke';
        cfg.sceneIds = 1;
        cfg.algorithms = {'CVF-AE', 'AE', 'PSO', 'DBO', 'CPO'};
        cfg.nRuns = 1;
        cfg.paramsOverride.popSize = 8;
        cfg.paramsOverride.maxIter = 5;

    case 'precheck'
        cfg.mode = 'precheck';
        cfg.nRuns = 3;
        cfg.paramsOverride.popSize = 20;
        cfg.paramsOverride.maxIter = 80;

    case 'formal'
        cfg.mode = 'formal';
        cfg.nRuns = 30;
        cfg.paramsOverride.popSize = 30;
        cfg.paramsOverride.maxIter = 300;

    case {'resume-formal', 'resume_formal'}
        cfg = localBuildConfig('formal');
        cfg.mode = 'formal';
        cfg.resultDir = localFindLatestResultDir('cvf_ae_main_comparison_formal_');
        return;

    otherwise
        error('Unknown CVF-AE main comparison mode: %s', mode);
end

timestamp = datestr(now, 'yyyymmdd_HHMMSS');
cfg.resultDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
    ['cvf_ae_main_comparison_' cfg.mode '_' timestamp]);
end

function cfg = localApplyDefaults(cfg)
if ~isfield(cfg, 'sceneIds') || isempty(cfg.sceneIds)
    cfg.sceneIds = [1, 2, 4];
end
if ~isfield(cfg, 'algorithms') || isempty(cfg.algorithms)
    cfg.algorithms = {'CVF-AE', 'AE', 'PSO', 'GWO', 'WOA', 'HHO', 'DBO', 'CPO'};
end
if ~isfield(cfg, 'nRuns') || isempty(cfg.nRuns)
    cfg.nRuns = 3;
end
if ~isfield(cfg, 'baseSeed') || isempty(cfg.baseSeed)
    cfg.baseSeed = 20260624;
end
if ~isfield(cfg, 'paramsOverride') || ~isstruct(cfg.paramsOverride)
    cfg.paramsOverride = struct();
end
if ~isfield(cfg.paramsOverride, 'popSize')
    cfg.paramsOverride.popSize = 20;
end
if ~isfield(cfg.paramsOverride, 'maxIter')
    cfg.paramsOverride.maxIter = 80;
end
if ~isfield(cfg, 'mode') || isempty(cfg.mode)
    cfg.mode = 'custom';
end
if ~isfield(cfg, 'resultDir') || isempty(cfg.resultDir)
    timestamp = datestr(now, 'yyyymmdd_HHMMSS');
    cfg.resultDir = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results', ...
        ['cvf_ae_main_comparison_' cfg.mode '_' timestamp]);
end
if ~isfield(cfg, 'resumeExisting')
    cfg.resumeExisting = true;
end
if ~isfield(cfg, 'useLiteFAEAE')
    cfg.useLiteFAEAE = true;
end
if ~isfield(cfg, 'saveFigures'), cfg.saveFigures = false; end
if ~isfield(cfg, 'showSingleRunFigure'), cfg.showSingleRunFigure = false; end
if ~isfield(cfg, 'showBatchFigure'), cfg.showBatchFigure = false; end
if ~isfield(cfg, 'saveBestPathFigure'), cfg.saveBestPathFigure = false; end
if ~isfield(cfg, 'saveBestTopViewFigure'), cfg.saveBestTopViewFigure = false; end
end

function resultDir = localFindLatestResultDir(prefix)
resultRoot = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results');
listing = dir(fullfile(resultRoot, [prefix '*']));
listing = listing([listing.isdir]);
if isempty(listing)
    error('No existing formal result directory found for prefix: %s', prefix);
end
[~, idx] = max([listing.datenum]);
resultDir = fullfile(listing(idx).folder, listing(idx).name);
fprintf('Resume formal result folder: %s\n', resultDir);
end

function localWriteReadme(cfg, summary)
readmePath = fullfile(cfg.resultDir, 'CVF_AE_MAIN_COMPARISON_README.md');
fid = fopen(readmePath, 'w');
if fid < 0
    warning('Could not write README: %s', readmePath);
    return;
end
c = onCleanup(@() fclose(fid));

fprintf(fid, '# CVF-AE 主对比实验记录\n\n');
fprintf(fid, '- 模式: `%s`\n', cfg.mode);
fprintf(fid, '- 场景: `%s`\n', mat2str(cfg.sceneIds));
fprintf(fid, '- 算法: `%s`\n', strjoin(cfg.algorithms, ', '));
fprintf(fid, '- nRuns: `%d`\n', cfg.nRuns);
fprintf(fid, '- popSize: `%d`\n', cfg.paramsOverride.popSize);
fprintf(fid, '- maxIter: `%d`\n', cfg.paramsOverride.maxIter);
fprintf(fid, '- baseSeed: `%d`\n\n', cfg.baseSeed);
fprintf(fid, '本 runner 使用统一 UAV B-spline 编码、统一 `fitnessFAEAE` 评价函数、统一边界投影和 Deb 可行性优先准则。\n\n');
fprintf(fid, '主要输出:\n\n');
fprintf(fid, '- `uav_comparison_runs.csv`\n');
fprintf(fid, '- `uav_comparison_summary_long.csv`\n');
fprintf(fid, '- `uav_comparison_average_rank.csv`\n');
fprintf(fid, '- `run_records/`\n\n');

if isfield(summary, 'avgRankTable')
    fprintf(fid, '## 平均排名\n\n');
    for i = 1:height(summary.avgRankTable)
        fprintf(fid, '- `%s`: %.4f\n', summary.avgRankTable.Algorithm{i}, summary.avgRankTable.AverageRank(i));
    end
end
end
