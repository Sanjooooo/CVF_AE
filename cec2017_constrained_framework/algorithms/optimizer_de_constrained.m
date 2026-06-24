function result = optimizer_de_constrained(evaluator, problem, cfg, seed)
%OPTIMIZER_DE_CONSTRAINED DE/rand/1/bin with shared Deb handling.

rng(seed, 'twister');
n = cfg.popSize;
d = problem.dimension;
lb = problem.lb;
ub = problem.ub;
F = localGet(cfg, 'deF', 0.5);
CR = localGet(cfg, 'deCR', 0.9);
X = lb + rand(n,d) .* (ub-lb);
records = evaluator.evaluate(X);
idx = cec_best_index(records);
best = records(idx);
bestX = X(idx,:);
firstFeasibleFE = localFirst(records);
historyFE = evaluator.FEs;
historyObjective = best.f;
historyViolation = best.violation;
tStart = tic;

while evaluator.remaining() > 0
    snapshot = X;
    for i = 1:n
        if evaluator.remaining() < 1, break; end
        pool = setdiff(1:n, i);
        r = pool(randperm(numel(pool), 3));
        mutant = snapshot(r(1),:) + F * (snapshot(r(2),:) - snapshot(r(3),:));
        mask = rand(1,d) < CR;
        mask(randi(d)) = true;
        trial = snapshot(i,:);
        trial(mask) = mutant(mask);
        trial = cec_clip(trial, lb, ub);
        rec = evaluator.evaluate(trial);
        if isnan(firstFeasibleFE) && rec.isFeasible
            firstFeasibleFE = evaluator.FEs;
        end
        if cec_deb_better(rec, records(i))
            X(i,:) = trial;
            records(i) = rec;
            if cec_deb_better(rec, best)
                best = rec;
                bestX = trial;
            end
        end
    end
    historyFE(end+1,1) = evaluator.FEs; %#ok<AGROW>
    historyObjective(end+1,1) = best.f; %#ok<AGROW>
    historyViolation(end+1,1) = best.violation; %#ok<AGROW>
end

result = localPack(best, bestX, evaluator.FEs, toc(tStart), ...
    firstFeasibleFE, historyFE, historyObjective, historyViolation);
end

function value = localGet(s,name,defaultValue)
if isfield(s,name), value=s.(name); else, value=defaultValue; end
end

function fe = localFirst(records)
idx=find([records.isFeasible],1,'first');
if isempty(idx), fe=NaN; else, fe=idx; end
end

function result = localPack(best,bestX,fes,runtime,firstFE,hFE,hObj,hV)
result=struct('bestObjective',best.f,'bestError',NaN, ...
    'bestPosition',bestX,'feasible',best.isFeasible, ...
    'totalViolation',best.violation, ...
    'normalizedViolation',best.normalizedViolation, ...
    'violatedCount',best.violatedCount,'FEs',fes, ...
    'firstFeasibleFE',firstFE,'runtime',runtime, ...
    'historyFE',hFE(:),'historyObjective',hObj(:), ...
    'historyViolation',hV(:),'cvfTriggerCount',0, ...
    'cvfSuccessCount',0,'cvfExtraFEs',0);
end

