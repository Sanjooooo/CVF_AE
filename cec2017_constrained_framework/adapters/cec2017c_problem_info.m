function problem = cec2017c_problem_info(functionId, dimension)
%CEC2017C_PROBLEM_INFO Metadata for one CEC2017 constrained problem.

arguments
    functionId (1,1) double {mustBeInteger, mustBeInRange(functionId,1,28)}
    dimension (1,1) double {mustBeMember(dimension,[10,30,50,100])}
end

counts = [ ...
    1 0; 1 0; 1 1; 2 0; 2 0; 0 6; 0 2; 0 2; 1 1; 0 2; 1 1; ...
    2 0; 3 0; 1 1; 1 1; 1 1; 1 1; 2 1; 2 0; 2 0; 2 0; 3 0; ...
    1 1; 1 1; 1 1; 1 1; 2 1; 2 0];

rootDir = fileparts(fileparts(mfilename('fullpath')));
problem = struct();
problem.suite = 'CEC2017 constrained';
problem.functionId = functionId;
problem.name = sprintf('C%02d', functionId);
problem.dimension = dimension;
problem.lb = -100 * ones(1, dimension);
problem.ub = 100 * ones(1, dimension);
problem.nInequality = counts(functionId, 1);
problem.nEquality = counts(functionId, 2);
problem.equalityTolerance = 1e-4;
problem.officialMaxFEs = 10000 * dimension;
problem.officialRuns = 20;
problem.sourceDir = fullfile(rootDir, 'third_party', ...
    'cec2017_matlab_sept_2024');
end

