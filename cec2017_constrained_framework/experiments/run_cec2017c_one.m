function runRecord = run_cec2017c_one(algorithm, functionId, dimension, ...
        runId, cfg)
%RUN_CEC2017C_ONE Execute one reproducible run.

rootDir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(rootDir, 'adapters'));
addpath(fullfile(rootDir, 'algorithms'));

problem = cec2017c_problem_info(functionId, dimension);
if isempty(cfg.maxFEs)
    maxFEs = problem.officialMaxFEs;
else
    maxFEs = cfg.maxFEs;
end
seed = cfg.baseSeed + 100000 * dimension + 1000 * functionId + runId;
evaluator = CEC2017ConstrainedEvaluator(problem, maxFEs);
algCfg = cfg;

switch upper(algorithm)
    case 'AE'
        algCfg.useCVF = false;
        result = optimizer_ae_cvf_constrained( ...
            evaluator, problem, algCfg, seed);
    case 'CVF-AE'
        algCfg.useCVF = true;
        result = optimizer_ae_cvf_constrained( ...
            evaluator, problem, algCfg, seed);
    case 'CVF-AE-W/O-CVF'
        algCfg.useCVF = false;
        result = optimizer_ae_cvf_constrained( ...
            evaluator, problem, algCfg, seed);
    case 'DE'
        result = optimizer_de_constrained(evaluator, problem, algCfg, seed);
    case 'PSO'
        result = optimizer_pso_constrained(evaluator, problem, algCfg, seed);
    otherwise
        error('CVFAE:UnknownAlgorithm', 'Unknown algorithm: %s', algorithm);
end

runRecord = result;
runRecord.benchmark = problem.suite;
runRecord.functionId = functionId;
runRecord.functionName = problem.name;
runRecord.dimension = dimension;
runRecord.algorithm = algorithm;
runRecord.runId = runId;
runRecord.seed = seed;
runRecord.maxFEs = maxFEs;
runRecord.equalityTolerance = problem.equalityTolerance;
end

