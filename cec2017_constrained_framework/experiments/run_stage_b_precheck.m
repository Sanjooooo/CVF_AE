function resultDir = run_stage_b_precheck()
%RUN_STAGE_B_PRECHECK Execute resumable small-scale precheck.

rootDir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(rootDir, 'experiments'));
cfg = get_cec2017c_config('stage-b');
resultDir = fullfile(rootDir, 'results', 'stage_b_precheck_v2');
runDir = fullfile(resultDir, 'run_records');
if ~exist(runDir, 'dir'), mkdir(runDir); end

for d = cfg.dimensions
    for fid = cfg.functionIds
        for a = 1:numel(cfg.algorithms)
            algorithm = cfg.algorithms{a};
            tag = regexprep(upper(algorithm), '[^A-Z0-9]+', '_');
            for runId = 1:cfg.nRuns
                file = fullfile(runDir, sprintf( ...
                    'C%02d_D%d_%s_run%03d.mat', fid, d, tag, runId));
                if cfg.resumeExisting && exist(file, 'file')
                    continue;
                end
                fprintf('Stage B: C%02d D=%d %s run %d/%d\n', ...
                    fid, d, algorithm, runId, cfg.nRuns);
                runRecord = run_cec2017c_one( ...
                    algorithm, fid, d, runId, cfg);
                save(file, 'runRecord', '-v7');
            end
        end
    end
end

localSummarize(runDir, resultDir);
end

function localSummarize(runDir, resultDir)
files = dir(fullfile(runDir, '*.mat'));
rows = repmat(localEmptyRow(), numel(files), 1);
for k = 1:numel(files)
    data = load(fullfile(files(k).folder, files(k).name), 'runRecord');
    r = data.runRecord;
    rows(k) = struct('FunctionId',r.functionId,'Dimension',r.dimension, ...
        'Algorithm',string(r.algorithm),'RunId',r.runId,'Seed',r.seed, ...
        'BestObjective',r.bestObjective,'Feasible',logical(r.feasible), ...
        'TotalViolation',r.totalViolation, ...
        'NormalizedViolation',r.normalizedViolation, ...
        'FEs',r.FEs,'FirstFeasibleFE',r.firstFeasibleFE, ...
        'Runtime',r.runtime,'CVFTriggers',r.cvfTriggerCount, ...
        'CVFSuccesses',r.cvfSuccessCount,'CVFExtraFEs',r.cvfExtraFEs);
end
runs = struct2table(rows);
runs = sortrows(runs, {'FunctionId','Algorithm','RunId'});
writetable(runs, fullfile(resultDir, 'stage_b_runs.csv'));

[groups, functionId, dimension, algorithm] = findgroups( ...
    runs.FunctionId, runs.Dimension, runs.Algorithm);
feasibleRate = splitapply(@mean, double(runs.Feasible), groups);
meanObjective = splitapply(@localFeasibleMean, ...
    runs.BestObjective, runs.Feasible, groups);
medianObjective = splitapply(@localFeasibleMedian, ...
    runs.BestObjective, runs.Feasible, groups);
meanViolation = splitapply(@mean, runs.TotalViolation, groups);
medianViolation = splitapply(@median, runs.TotalViolation, groups);
meanRuntime = splitapply(@mean, runs.Runtime, groups);
meanFEs = splitapply(@mean, runs.FEs, groups);
meanFirstFeasibleFE = splitapply(@localNanMean, runs.FirstFeasibleFE, groups);
meanCVFTriggers = splitapply(@mean, runs.CVFTriggers, groups);
meanCVFSuccesses = splitapply(@mean, runs.CVFSuccesses, groups);
summary = table(functionId, dimension, algorithm, feasibleRate, ...
    meanObjective, medianObjective, meanViolation, medianViolation, ...
    meanFirstFeasibleFE, meanRuntime, meanFEs, meanCVFTriggers, ...
    meanCVFSuccesses, 'VariableNames', {'FunctionId','Dimension', ...
    'Algorithm','FeasibleRate','MeanFeasibleObjective', ...
    'MedianFeasibleObjective','MeanViolation','MedianViolation', ...
    'MeanFirstFeasibleFE','MeanRuntime','MeanFEs','MeanCVFTriggers', ...
    'MeanCVFSuccesses'});
writetable(summary, fullfile(resultDir, 'stage_b_summary.csv'));
end

function row = localEmptyRow()
row = struct('FunctionId',NaN,'Dimension',NaN,'Algorithm',"", ...
    'RunId',NaN,'Seed',NaN,'BestObjective',NaN,'Feasible',false, ...
    'TotalViolation',NaN,'NormalizedViolation',NaN,'FEs',NaN, ...
    'FirstFeasibleFE',NaN,'Runtime',NaN,'CVFTriggers',NaN, ...
    'CVFSuccesses',NaN,'CVFExtraFEs',NaN);
end

function x = localFeasibleMean(values, feasible)
x = mean(values(logical(feasible)), 'omitnan');
end

function x = localFeasibleMedian(values, feasible)
x = median(values(logical(feasible)), 'omitnan');
end

function x = localNanMean(values)
x = mean(values, 'omitnan');
end
