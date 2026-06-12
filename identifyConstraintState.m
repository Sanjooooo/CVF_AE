function state = identifyConstraintState(pop, ~, detail, bestHist, iter, params)
%IDENTIFYCONSTRAINTSTATE Classify the current constrained-search state.

if nargin < 6
    params = struct();
end

cfg = localDefaultStateParams(params);

viol = localViolationVector(detail);
feas = localFeasibleMask(detail);

finiteViol = viol(isfinite(viol));
if isempty(finiteViol)
    meanViolation = inf;
else
    meanViolation = mean(finiteViol);
end

feasibleRatio = mean(feas);
hasFeasible = any(feas);
diversity = localDiversity(pop, params);
recentImprovement = localRecentImprovement(bestHist, iter, cfg.window);

isStagnant = iter > cfg.window && recentImprovement < cfg.improvementTol;

if isStagnant && (diversity < cfg.recoveryDiversityMax || iter > 2 * cfg.window)
    name = 'StagnationRecovery';
    id = 4;
elseif ~hasFeasible && (feasibleRatio < cfg.formationFeasibleRatio || meanViolation > cfg.highViolation)
    name = 'FeasibilityFormation';
    id = 1;
elseif feasibleRatio < cfg.refinementFeasibleRatio
    name = 'FeasibilityPreservation';
    id = 2;
else
    name = 'QualityRefinement';
    id = 3;
end

state = struct();
state.name = name;
state.id = id;
state.feasibleRatio = feasibleRatio;
state.meanViolation = meanViolation;
state.diversity = diversity;
state.recentImprovement = recentImprovement;
state.isStagnant = isStagnant;
state.hasFeasible = hasFeasible;
end

function cfg = localDefaultStateParams(params)
cfg.window = 15;
cfg.improvementTol = 1e-4;
cfg.formationFeasibleRatio = 0.20;
cfg.refinementFeasibleRatio = 0.65;
cfg.highViolation = 30;
cfg.recoveryDiversityMax = 0.08;

if isfield(params, 'cove') && isfield(params.cove, 'state')
    s = params.cove.state;
    f = fieldnames(s);
    for k = 1:numel(f)
        cfg.(f{k}) = s.(f{k});
    end
end
end

function feas = localFeasibleMask(detail)
feas = false(numel(detail), 1);
for i = 1:numel(detail)
    if isstruct(detail(i)) && isfield(detail(i), 'isFeasible')
        feas(i) = logical(detail(i).isFeasible);
    end
end
end

function viol = localViolationVector(detail)
viol = inf(numel(detail), 1);
for i = 1:numel(detail)
    if isstruct(detail(i)) && isfield(detail(i), 'V') && ~isempty(detail(i).V)
        viol(i) = detail(i).V;
    end
end
end

function diversity = localDiversity(pop, params)
if isempty(pop) || size(pop, 1) < 2
    diversity = 0;
    return;
end

if isfield(params, 'ub') && isfield(params, 'lb')
    span = params.ub(:)' - params.lb(:)';
    span(span <= 0) = 1;
else
    span = ones(1, size(pop, 2));
end

scaled = pop ./ span;
diversity = mean(std(scaled, 0, 1), 'omitnan');
if ~isfinite(diversity)
    diversity = 0;
end
end

function improvement = localRecentImprovement(bestHist, iter, window)
finiteHist = bestHist(1:max(0, min(iter - 1, numel(bestHist))));
finiteHist = finiteHist(isfinite(finiteHist));

if numel(finiteHist) <= window
    improvement = inf;
    return;
end

oldVal = finiteHist(end - window);
newVal = finiteHist(end);
improvement = max(0, oldVal - newVal) / max(1, abs(oldVal));
end
