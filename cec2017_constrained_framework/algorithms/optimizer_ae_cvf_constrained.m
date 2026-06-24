function result = optimizer_ae_cvf_constrained(evaluator, problem, cfg, seed)
%OPTIMIZER_AE_CVF_CONSTRAINED AE with an optional generic CVF branch.
%
% The CVF direction is constructed only from already evaluated population
% members with lower normalized constraint violation. Therefore, direction
% construction consumes zero hidden FEs. Each evaluated CVF candidate
% consumes one ordinary joint objective/constraint FE.

rng(seed, 'twister');
n = cfg.popSize;
d = problem.dimension;
lb = problem.lb;
ub = problem.ub;
span = ub - lb;
useCVF = isfield(cfg, 'useCVF') && cfg.useCVF;

X = lb + rand(n, d) .* span;
records = evaluator.evaluate(X);
[best, bestX] = localBest(records, X);
firstFeasibleFE = localInitialFirstFeasible(records);

cvfTriggerCount = 0;
cvfSuccessCount = 0;
cvfExtraFEs = 0;
historyFE = evaluator.FEs;
historyObjective = best.f;
historyViolation = best.violation;
generation = 0;
tStart = tic;

while evaluator.remaining() > 0
    generation = generation + 1;
    snapshotX = X;
    snapshotRecords = records;
    order = cec_deb_order(snapshotRecords);
    eliteCount = max(2, ceil(0.25 * n));
    eliteMean = mean(snapshotX(order(1:eliteCount), :), 1);
    quota = max(1, ceil(localGet(cfg, 'cvfQuotaRate', 0.10) * n));
    usedThisGeneration = 0;
    infeasibleOrder = order(~[snapshotRecords(order).isFeasible]);
    triggerSet = infeasibleOrder(1:min(quota, numel(infeasibleOrder)));

    for i = 1:n
        if evaluator.remaining() < 1
            break;
        end
        x = snapshotX(i, :);
        peers = setdiff(1:n, i);
        pick = peers(randperm(numel(peers), min(4, numel(peers))));
        while numel(pick) < 4
            pick(end+1) = peers(randi(numel(peers))); %#ok<AGROW>
        end
        xElite = snapshotX(order(randi(eliteCount)), :);
        tau = min(1, evaluator.FEs / evaluator.MaxFEs);
        rho = 0.15 + 0.85 * (1 - tau)^1.2;
        step = ...
            (0.30 + 0.10 * (1 - tau)) * rand(1,d) .* (eliteMean - x) + ...
            (0.25 + 0.10 * tau) * rand(1,d) .* (bestX - x) + ...
            (0.22 + 0.08 * (1 - tau)) * ...
                (0.6 * (snapshotX(pick(1),:) - snapshotX(pick(2),:)) + ...
                 0.4 * (snapshotX(pick(3),:) - snapshotX(pick(4),:))) + ...
            0.08 * rand(1,d) .* (xElite - x) + ...
            0.06 * rho * (2 * rand(1,d) - 1) .* span;
        eta = 0.20 + 0.35 * (1 - tau);
        mixElite = 0.10 + 0.10 * tau;
        xAE = cec_clip((1 - eta - mixElite) * (x + step) + ...
            eta * x + mixElite * xElite, lb, ub);
        aeRecord = evaluator.evaluate(xAE);
        firstFeasibleFE = localUpdateFirstFeasible( ...
            firstFeasibleFE, aeRecord, evaluator.FEs);
        trialX = xAE;
        trialRecord = aeRecord;

        trigger = useCVF && ismember(i, triggerSet) && ...
            usedThisGeneration < quota && evaluator.remaining() >= 1;
        if trigger
            field = localCVFDirection(i, snapshotX, snapshotRecords, span, cfg);
            if any(field ~= 0)
                pressure = snapshotRecords(i).normalizedViolation;
                beta = 0.20 + 0.35 * min(1, 4 * pressure);
                xCVF = cec_clip(xAE + beta * field, lb, ub);
                cvfRecord = evaluator.evaluate(xCVF);
                cvfTriggerCount = cvfTriggerCount + 1;
                cvfExtraFEs = cvfExtraFEs + 1;
                usedThisGeneration = usedThisGeneration + 1;
                firstFeasibleFE = localUpdateFirstFeasible( ...
                    firstFeasibleFE, cvfRecord, evaluator.FEs);
                if cec_deb_better(cvfRecord, aeRecord)
                    trialX = xCVF;
                    trialRecord = cvfRecord;
                    cvfSuccessCount = cvfSuccessCount + 1;
                end
            end
        end

        if cec_deb_better(trialRecord, records(i))
            X(i, :) = trialX;
            records(i) = trialRecord;
            if cec_deb_better(trialRecord, best)
                best = trialRecord;
                bestX = trialX;
            end
        end
    end
    historyFE(end+1,1) = evaluator.FEs; %#ok<AGROW>
    historyObjective(end+1,1) = best.f; %#ok<AGROW>
    historyViolation(end+1,1) = best.violation; %#ok<AGROW>
end

result = localResult(best, bestX, evaluator.FEs, toc(tStart), ...
    firstFeasibleFE, historyFE, historyObjective, historyViolation);
result.cvfTriggerCount = cvfTriggerCount;
result.cvfSuccessCount = cvfSuccessCount;
result.cvfExtraFEs = cvfExtraFEs;
result.generations = generation;
end

function field = localCVFDirection(i, X, records, span, cfg)
v0 = records(i).normalizedViolation;
candidate = find([records.normalizedViolation] < v0);
if isempty(candidate)
    field = zeros(1, size(X,2));
    return;
end
[~, idx] = sort([records(candidate).normalizedViolation], 'ascend');
candidate = candidate(idx(1:min(5, numel(idx))));
delta = X(candidate, :) - X(i, :);
gain = max(0, v0 - [records(candidate).normalizedViolation])';
distance = vecnorm(delta ./ span, 2, 2);
weights = gain ./ (distance + 1e-12);
if sum(weights) <= 0
    field = zeros(1, size(X,2));
    return;
end
field = sum(delta .* weights, 1) / sum(weights);
limit = localGet(cfg, 'cvfMaxStepRatio', 0.08) * span;
field = min(max(field, -limit), limit);
normLimit = localGet(cfg, 'cvfMaxNormRatio', 0.12) * norm(span);
if norm(field) > normLimit
    field = field * (normLimit / norm(field));
end
end

function [best, bestX] = localBest(records, X)
idx = cec_best_index(records);
best = records(idx);
bestX = X(idx, :);
end

function fe = localInitialFirstFeasible(records)
idx = find([records.isFeasible], 1, 'first');
if isempty(idx), fe = NaN; else, fe = idx; end
end

function fe = localUpdateFirstFeasible(fe, record, currentFE)
if isnan(fe) && record.isFeasible
    fe = currentFE;
end
end

function value = localGet(s, name, defaultValue)
if isfield(s, name), value = s.(name); else, value = defaultValue; end
end

function result = localResult(best, bestX, fes, runtime, firstFeasibleFE, ...
        historyFE, historyObjective, historyViolation)
result = struct();
result.bestObjective = best.f;
result.bestError = NaN;
result.bestPosition = bestX;
result.feasible = best.isFeasible;
result.totalViolation = best.violation;
result.normalizedViolation = best.normalizedViolation;
result.violatedCount = best.violatedCount;
result.FEs = fes;
result.firstFeasibleFE = firstFeasibleFE;
result.runtime = runtime;
result.historyFE = historyFE(:);
result.historyObjective = historyObjective(:);
result.historyViolation = historyViolation(:);
end
