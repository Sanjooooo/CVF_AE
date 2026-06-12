function feedback = analyzeViolationFeedback(detail, ~)
%ANALYZEVIOLATIONFEEDBACK Summarize dominant violation sources in a population.

names = {'obstacle', 'nfz', 'curvature', 'altitude', 'risk'};
scores = zeros(1, numel(names));
totalViolation = zeros(numel(detail), 1);

for i = 1:numel(detail)
    d = detail(i);
    if ~isstruct(d)
        continue;
    end

    scores(1) = scores(1) + localField(d, 'Cobs');
    scores(2) = scores(2) + localField(d, 'Cnfz');
    scores(3) = scores(3) + localField(d, 'Ccurv');
    scores(4) = scores(4) + localField(d, 'Calt');

    if isfield(d, 'V') && ~isempty(d.V) && isfinite(d.V)
        totalViolation(i) = d.V;
    end

    if isfield(d, 'R') && isfield(d, 'L') && isfinite(d.R) && isfinite(d.L)
        scores(5) = scores(5) + d.R / max(1, d.L);
    end
end

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
feedback.scores = scores;
feedback.weights = weights;
feedback.dominantType = dominantType;
feedback.meanViolation = mean(totalViolation, 'omitnan');
feedback.totalViolation = sum(totalViolation, 'omitnan');
end

function v = localField(s, name)
if isfield(s, name) && ~isempty(s.(name)) && isfinite(s.(name))
    v = s.(name);
else
    v = 0;
end
end
