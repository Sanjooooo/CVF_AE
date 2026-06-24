function result = optimizer_pso_constrained(evaluator, problem, cfg, seed)
%OPTIMIZER_PSO_CONSTRAINED Canonical PSO with Deb pbest/gbest updates.

rng(seed, 'twister');
n=cfg.popSize; d=problem.dimension; lb=problem.lb; ub=problem.ub;
span=ub-lb;
w=localGet(cfg,'psoW',0.7); c1=localGet(cfg,'psoC1',1.5);
c2=localGet(cfg,'psoC2',1.5); vmax=0.2*span;
X=lb+rand(n,d).*span;
V=(2*rand(n,d)-1).*vmax;
records=evaluator.evaluate(X);
pbestX=X; pbestRecords=records;
idx=cec_best_index(records); best=records(idx); bestX=X(idx,:);
firstFeasibleFE=localFirst(records);
historyFE=evaluator.FEs; historyObjective=best.f;
historyViolation=best.violation; tStart=tic;

while evaluator.remaining()>0
    for i=1:n
        if evaluator.remaining()<1, break; end
        V(i,:)=w*V(i,:)+c1*rand(1,d).*(pbestX(i,:)-X(i,:))+ ...
            c2*rand(1,d).*(bestX-X(i,:));
        V(i,:)=min(max(V(i,:),-vmax),vmax);
        X(i,:)=cec_clip(X(i,:)+V(i,:),lb,ub);
        rec=evaluator.evaluate(X(i,:));
        records(i)=rec;
        if isnan(firstFeasibleFE) && rec.isFeasible
            firstFeasibleFE=evaluator.FEs;
        end
        if cec_deb_better(rec,pbestRecords(i))
            pbestRecords(i)=rec; pbestX(i,:)=X(i,:);
            if cec_deb_better(rec,best)
                best=rec; bestX=X(i,:);
            end
        end
    end
    historyFE(end+1,1)=evaluator.FEs; %#ok<AGROW>
    historyObjective(end+1,1)=best.f; %#ok<AGROW>
    historyViolation(end+1,1)=best.violation; %#ok<AGROW>
end

result=struct('bestObjective',best.f,'bestError',NaN, ...
    'bestPosition',bestX,'feasible',best.isFeasible, ...
    'totalViolation',best.violation, ...
    'normalizedViolation',best.normalizedViolation, ...
    'violatedCount',best.violatedCount,'FEs',evaluator.FEs, ...
    'firstFeasibleFE',firstFeasibleFE,'runtime',toc(tStart), ...
    'historyFE',historyFE(:),'historyObjective',historyObjective(:), ...
    'historyViolation',historyViolation(:),'cvfTriggerCount',0, ...
    'cvfSuccessCount',0,'cvfExtraFEs',0);
end

function value=localGet(s,name,defaultValue)
if isfield(s,name), value=s.(name); else, value=defaultValue; end
end

function fe=localFirst(records)
idx=find([records.isFeasible],1,'first');
if isempty(idx), fe=NaN; else, fe=idx; end
end

