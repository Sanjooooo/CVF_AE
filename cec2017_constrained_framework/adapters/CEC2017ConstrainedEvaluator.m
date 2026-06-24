classdef CEC2017ConstrainedEvaluator < handle
    %CEC2017CONSTRAINEDEVALUATOR Counted adapter around the author code.

    properties (SetAccess = private)
        Problem
        MaxFEs
        FEs = 0
    end

    methods
        function obj = CEC2017ConstrainedEvaluator(problem, maxFEs)
            obj.Problem = problem;
            obj.MaxFEs = maxFEs;
            addpath(problem.sourceDir);
            clear global initial_flag
            global initial_flag
            initial_flag = 0;
        end

        function records = evaluate(obj, X)
            if isvector(X)
                X = X(:)';
            end
            if size(X, 2) ~= obj.Problem.dimension
                error('CVFAE:DimensionMismatch', ...
                    'Expected %d columns, received %d.', ...
                    obj.Problem.dimension, size(X, 2));
            end
            nCandidates = size(X, 1);
            if obj.FEs + nCandidates > obj.MaxFEs
                error('CVFAE:FEBudgetExceeded', ...
                    'Evaluation would exceed FE budget (%d + %d > %d).', ...
                    obj.FEs, nCandidates, obj.MaxFEs);
            end

            [f, gRaw, hRaw] = CEC2017(X, obj.Problem.functionId);
            f = f(:);
            gRaw = localTrim(gRaw, obj.Problem.nInequality, nCandidates);
            hRaw = localTrim(hRaw, obj.Problem.nEquality, nCandidates);

            template = struct('f', NaN, 'g', [], 'h', [], ...
                'violation', NaN, 'normalizedViolation', NaN, ...
                'violationVector', [], 'isFeasible', false, ...
                'violatedCount', NaN);
            records = repmat(template, nCandidates, 1);
            for k = 1:nCandidates
                vm = cec2017c_violation(gRaw(k, :), hRaw(k, :), ...
                    obj.Problem.equalityTolerance);
                records(k).f = f(k);
                records(k).g = gRaw(k, :);
                records(k).h = hRaw(k, :);
                records(k).violation = vm.officialViolation;
                records(k).normalizedViolation = vm.normalizedViolation;
                records(k).violationVector = vm.officialVector;
                records(k).isFeasible = vm.isFeasible;
                records(k).violatedCount = vm.violatedCount;
            end
            obj.FEs = obj.FEs + nCandidates;
        end

        function n = remaining(obj)
            n = obj.MaxFEs - obj.FEs;
        end
    end
end

function out = localTrim(raw, count, nRows)
if count == 0
    out = zeros(nRows, 0);
    return;
end
if size(raw, 1) ~= nRows
    raw = reshape(raw, nRows, []);
end
out = raw(:, 1:count);
end

