function chunkSummary = run_cvf_ae_recent_improved_formal_chunk(algName, sceneId, runIds, resultDir)
%RUN_CVF_AE_RECENT_IMPROVED_FORMAL_CHUNK Run missing recent-improved formal records in chunks.
%
% This helper uses the same seed rule as run_uav_comparison_lite_v2_batch:
%   seed = baseSeed + 10000 * sceneId + 100 * algorithmIndex + runId
% where algorithm order is {'GDSAO','ERIME','MSCSO'}.

if nargin < 1 || isempty(algName)
    algName = 'GDSAO';
end
if nargin < 2 || isempty(sceneId)
    sceneId = 1;
end
if nargin < 3 || isempty(runIds)
    runIds = 1:30;
end
if nargin < 4 || isempty(resultDir)
    resultDir = localFindLatestRecentFormalDir();
end

algName = char(algName);
algorithms = {'GDSAO', 'ERIME', 'MSCSO'};
algIdx = find(strcmpi(algorithms, algName), 1);
if isempty(algIdx)
    error('Unknown recent improved algorithm: %s', algName);
end
canonicalAlg = algorithms{algIdx};

baseSeed = 20260701;
runDir = fullfile(resultDir, 'run_records');
if ~exist(runDir, 'dir')
    mkdir(runDir);
end

params = defaultParams();
params.sceneId = sceneId;
params.popSize = 30;
params.maxIter = 300;
params.saveFigures = false;
params.showSingleRunFigure = false;
params.showBatchFigure = false;
params.saveBestPathFigure = false;
params.saveBestTopViewFigure = false;
params = applyUAVSceneOverrides(params);

map = createMap(params);
refCtrl = generateReferencePath(map, params);
refX = encodeControlPoints(refCtrl);
objFun = @(x) fitnessFAEAE(x, map, params);

cfg = struct();
cfg.sceneIds = [1, 2, 4];
cfg.algorithms = algorithms;
cfg.nRuns = 30;
cfg.baseSeed = baseSeed;
cfg.paramsOverride = struct('popSize', 30, 'maxIter', 300);
cfg.resumeExisting = true;
cfg.useLiteFAEAE = true;
cfg.saveFigures = false;
cfg.showSingleRunFigure = false;
cfg.showBatchFigure = false;
cfg.saveBestPathFigure = false;
cfg.saveBestTopViewFigure = false;

algCfg = getUAVAlgorithmConfig(canonicalAlg, params, cfg);

rows = table();
fprintf('\nRecent improved formal chunk: scene %d | %s | runs %s\n', ...
    sceneId, canonicalAlg, mat2str(runIds));
fprintf('Result folder: %s\n', resultDir);

for r = runIds(:)'
    runFile = fullfile(runDir, sprintf('scene%d_%s_run%03d.mat', ...
        sceneId, upper(canonicalAlg), r));
    runSeed = baseSeed + 10000 * sceneId + 100 * algIdx + r;

    if exist(runFile, 'file') == 2
        fprintf('  run %03d | exists | skipped\n', r);
        continue;
    end

    rng(runSeed, 'twister');
    tRun = tic;
    result = localRunSingle(canonicalAlg, objFun, params, map, refX, algCfg, runSeed);
    result = localNormalizeResultStruct(result, sceneId, canonicalAlg, r, runSeed);
    save(runFile, 'result');
    elapsed = toc(tRun);

    row = table(sceneId, {canonicalAlg}, r, runSeed, result.bestFitness, ...
        result.runtime, logical(result.finalFeasible), result.finalViolation, ...
        localResultScalar(result, 'nEvals'), elapsed, ...
        'VariableNames', {'Scene','Algorithm','Run','Seed','BestFitness','Runtime','Feasible','Violation','NEvals','WallClock'});
    rows = [rows; row]; %#ok<AGROW>

    fprintf('  run %03d | best = %.6f | feas = %d | nEvals = %.0f | time = %.3fs\n', ...
        r, result.bestFitness, logical(result.finalFeasible), localResultScalar(result, 'nEvals'), result.runtime);
end

chunkSummary = struct();
chunkSummary.resultDir = resultDir;
chunkSummary.rows = rows;
chunkSummary.completedRows = height(rows);
end

function result = localRunSingle(algName, objFun, params, map, refX, algCfg, runSeed)
switch upper(algName)
    case {'GDSAO', 'GDESAO'}
        result = optimizer_GDESAO_uav(objFun, params, map, refX, algCfg, runSeed);
    case {'ERIME', 'ELRIME'}
        result = optimizer_ERIME_uav(objFun, params, map, refX, algCfg, runSeed);
    case 'MSCSO'
        result = optimizer_MSCSO_uav(objFun, params, map, refX, algCfg, runSeed);
    otherwise
        error('Unknown recent improved algorithm: %s', algName);
end
end

function result = localNormalizeResultStruct(result, sceneId, algName, runId, runSeed)
if ~isfield(result, 'bestFitness') && isfield(result, 'bestFit')
    result.bestFitness = result.bestFit;
end
if ~isfield(result, 'bestFit') && isfield(result, 'bestFitness')
    result.bestFit = result.bestFitness;
end
if ~isfield(result, 'runtime') && isfield(result, 'runTime')
    result.runtime = result.runTime;
end
if ~isfield(result, 'runTime') && isfield(result, 'runtime')
    result.runTime = result.runtime;
end
if ~isfield(result, 'convergence') && isfield(result, 'bestHist')
    result.convergence = result.bestHist;
end
if ~isfield(result, 'bestHist') && isfield(result, 'convergence')
    result.bestHist = result.convergence;
end
if ~isfield(result, 'finalFeasible')
    if isfield(result, 'bestDetail') && isfield(result.bestDetail, 'isFeasible')
        result.finalFeasible = logical(result.bestDetail.isFeasible);
    else
        result.finalFeasible = NaN;
    end
end
if ~isfield(result, 'finalViolation')
    if isfield(result, 'bestDetail') && isfield(result.bestDetail, 'V')
        result.finalViolation = result.bestDetail.V;
    else
        result.finalViolation = NaN;
    end
end
result.algorithmName = upper(algName);
result.sceneId = sceneId;
result.runId = runId;
result.seed = runSeed;
end

function val = localResultScalar(result, fieldName)
if isfield(result, fieldName) && ~isempty(result.(fieldName))
    val = result.(fieldName);
    if ~isscalar(val)
        val = val(1);
    end
else
    val = NaN;
end
end

function resultDir = localFindLatestRecentFormalDir()
root = fullfile(pwd, 'routes', 'route_b_cvf_ae', 'results');
listing = dir(fullfile(root, 'cvf_ae_main_comparison_recent_improved_formal_*'));
listing = listing([listing.isdir]);
if isempty(listing)
    timestamp = datestr(now, 'yyyymmdd_HHMMSS');
    resultDir = fullfile(root, ['cvf_ae_main_comparison_recent_improved_formal_' timestamp]);
    mkdir(resultDir);
    return;
end
[~, idx] = max([listing.datenum]);
resultDir = fullfile(listing(idx).folder, listing(idx).name);
end
