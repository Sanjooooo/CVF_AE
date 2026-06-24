function tests = test_cec2017c_framework
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
rootDir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(rootDir, 'adapters'));
addpath(fullfile(rootDir, 'algorithms'));
addpath(fullfile(rootDir, 'experiments'));
testCase.TestData.rootDir = rootDir;
end

function testAllFunctionsInterface(testCase)
for fid = 1:28
    problem = cec2017c_problem_info(fid, 10);
    evaluator = CEC2017ConstrainedEvaluator(problem, 2);
    records = evaluator.evaluate(zeros(2, 10));
    verifySize(testCase, records, [2 1]);
    verifyTrue(testCase, all(isfinite([records.f])));
    verifyTrue(testCase, all(isfinite([records.violation])));
    verifyEqual(testCase, numel(records(1).g), problem.nInequality);
    verifyEqual(testCase, numel(records(1).h), problem.nEquality);
end
end

function testKnownReferenceC01(testCase)
problem = cec2017c_problem_info(1, 10);
source = load(fullfile(problem.sourceDir, 'Function1.mat'), 'o');
evaluator = CEC2017ConstrainedEvaluator(problem, 1);
record = evaluator.evaluate(source.o(1:10));
verifyLessThanOrEqual(testCase, abs(record.f), 1e-10);
verifyTrue(testCase, record.isFeasible);
end

function testEqualityTolerance(testCase)
m1 = cec2017c_violation([], 0.9e-4, 1e-4);
m2 = cec2017c_violation([], 1.1e-4, 1e-4);
verifyTrue(testCase, m1.isFeasible);
verifyEqual(testCase, m1.officialViolation, 0);
verifyFalse(testCase, m2.isFeasible);
verifyEqual(testCase, m2.officialViolation, 1.1e-4, ...
    'AbsTol', 1e-15);
verifyEqual(testCase, m2.cvfVector, 0.1e-4, 'AbsTol', 1e-15);
end

function testFECountingAndBudget(testCase)
problem = cec2017c_problem_info(1, 10);
evaluator = CEC2017ConstrainedEvaluator(problem, 3);
evaluator.evaluate(zeros(2,10));
verifyEqual(testCase, evaluator.FEs, 2);
evaluator.evaluate(zeros(1,10));
verifyEqual(testCase, evaluator.FEs, 3);
verifyError(testCase, @() evaluator.evaluate(zeros(1,10)), ...
    'CVFAE:FEBudgetExceeded');
end

function testVectorizedCorrectionsC18C27(testCase)
for fid = [18, 27]
    problem = cec2017c_problem_info(fid, 10);
    X = reshape(linspace(-2, 2, 30), 3, 10);
    batchEvaluator = CEC2017ConstrainedEvaluator(problem, 3);
    batch = batchEvaluator.evaluate(X);
    single = repmat(batch(1), 3, 1);
    for k = 1:3
        evaluator = CEC2017ConstrainedEvaluator(problem, 1);
        single(k) = evaluator.evaluate(X(k,:));
    end
    verifyEqual(testCase, [batch.f], [single.f], 'RelTol', 1e-12);
    verifyEqual(testCase, [batch.violation], [single.violation], ...
        'RelTol', 1e-12);
end
end

function testReproducibility(testCase)
cfg = get_cec2017c_config('stage-b');
cfg.maxFEs = 120;
cfg.popSize = 10;
r1 = run_cec2017c_one('AE', 1, 10, 1, cfg);
r2 = run_cec2017c_one('AE', 1, 10, 1, cfg);
verifyEqual(testCase, r1.bestObjective, r2.bestObjective, ...
    'AbsTol', 0);
verifyEqual(testCase, r1.totalViolation, r2.totalViolation, ...
    'AbsTol', 0);
verifyEqual(testCase, r1.bestPosition, r2.bestPosition, 'AbsTol', 0);
verifyEqual(testCase, r1.FEs, cfg.maxFEs);
end

