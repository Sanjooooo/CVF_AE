function feedback = analyzeViolationFeedback(detail, params)
%ANALYZEVIOLATIONFEEDBACK Summarize dominant violation sources in a population.

names = {'obstacle', 'nfz', 'curvature', 'altitude', 'risk'};
scale = localScoreScale(params);
rawScores = zeros(1, numel(names));
totalViolation = zeros(numel(detail), 1);

for i = 1:numel(detail)
    d = detail(i);
    if ~isstruct(d)
        continue;
    end

    if isfield(d, 'V') && ~isempty(d.V) && isfinite(d.V)
        totalViolation(i) = d.V;
    end
    indivWeight = 1 / (1 + max(0, totalViolation(i)));

    rawScores(1) = rawScores(1) + indivWeight * localField(d, 'Cobs');
    rawScores(2) = rawScores(2) + indivWeight * localField(d, 'Cnfz');
    rawScores(3) = rawScores(3) + indivWeight * localField(d, 'Ccurv');
    rawScores(4) = rawScores(4) + indivWeight * localField(d, 'Calt');

    if isfield(d, 'R') && isfield(d, 'L') && isfinite(d.R) && isfinite(d.L)
        rawScores(5) = rawScores(5) + indivWeight * d.R / max(1, d.L);
    end
end

scores = rawScores .* scale;
constraintScores = scores(1:4);
if sum(constraintScores) <= 0
    [~, idx] = max(scores);
else
    [~, idx] = max(constraintScores);
end

if scores(idx) <= 0
    dominantType = 'none';
else
    dominantType = names{idx};
end

weights = scores + 1e-9;
weights = weights / sum(weights);

feedback = struct();
feedback.names = names;
feedback.rawScores = rawScores;
feedback.scores = scores;
feedback.weights = weights;
feedback.dominantType = dominantType;
feedback.meanViolation = mean(totalViolation, 'omitnan');
feedback.totalViolation = sum(totalViolation, 'omitnan');
end

function scale = localScoreScale(params)
scale = ones(1, 5);
if nargin < 1 || ~isstruct(params)
    return;
end
if isfield(params, 'penalty') && isstruct(params.penalty)
    scale(1) = localParamField(params.penalty, 'obs', scale(1));
    scale(2) = localParamField(params.penalty, 'nfz', scale(2));
    scale(3) = localParamField(params.penalty, 'curv', scale(3));
    scale(4) = localParamField(params.penalty, 'alt', scale(4));
end
if isfield(params, 'weights') && isstruct(params.weights)
    scale(5) = localParamField(params.weights, 'R', scale(5));
end
scale = scale / max(scale);
scale(5) = max(scale(5), 0.35);
end

function v = localParamField(s, name, defaultValue)
if isfield(s, name) && ~isempty(s.(name)) && isfinite(s.(name))
    v = s.(name);
else
    v = defaultValue;
end
end

function v = localField(s, name)
if isfield(s, name) && ~isempty(s.(name)) && isfinite(s.(name))
    v = s.(name);
else
    v = 0;
end
end
