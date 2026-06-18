function [Xae, Xcvf, opInfo] = applyOperator_CVF_AE(i, pop, bestX, refX, elitePool, state, fieldStep, iter, params)
%APPLYOPERATOR_CVF_AE Generate AE and optional CVF-AE offspring.

[~, D] = size(pop);
x = pop(i, :);
span = params.ub(:)' - params.lb(:)';
tau = iter / max(1, params.maxIter);

eliteNum = size(elitePool, 1);
xElite = elitePool(randi(eliteNum), :);
eliteMean = mean(elitePool, 1);

idx = 1:size(pop, 1);
idx(i) = [];
idx = idx(randperm(numel(idx), min(4, numel(idx))));
while numel(idx) < 4
    idx(end+1) = randi(size(pop, 1)); %#ok<AGROW>
end

diff1 = pop(idx(1), :) - pop(idx(2), :);
diff2 = pop(idx(3), :) - pop(idx(4), :);
dirBest = bestX - x;
dirElite = eliteMean - x;
dirSample = xElite - x;

if isempty(refX)
    dirRef = zeros(1, D);
else
    dirRef = refX(:)' - x;
end

noise = (2 * rand(1, D) - 1) .* span;

switch state.id
    case 1
        opId = 1;
        aeStep = ...
            (0.25 + 0.25 * (1 - tau)) * rand(1, D) .* dirRef + ...
            (0.20 + 0.20 * (1 - tau)) * rand(1, D) .* dirElite + ...
            0.18 * diff1 + ...
            (0.08 + 0.10 * (1 - tau)) * noise;
    case 2
        opId = 2;
        aeStep = ...
            (0.25 + 0.10 * tau) * rand(1, D) .* dirBest + ...
            0.28 * rand(1, D) .* dirElite + ...
            0.16 * diff1 + ...
            0.08 * rand(1, D) .* dirRef + ...
            0.08 * noise;
    case 3
        opId = 3;
        aeStep = ...
            (0.38 + 0.16 * tau) * rand(1, D) .* dirBest + ...
            (0.30 + 0.12 * tau) * rand(1, D) .* dirSample + ...
            0.08 * diff1 + ...
            0.04 * noise;
    otherwise
        opId = 4;
        aeStep = ...
            0.24 * diff1 + ...
            0.18 * diff2 + ...
            0.22 * rand(1, D) .* dirBest + ...
            0.10 * randn(1, D) .* span;
end

Xae = x + aeStep;
anchor = 0.05 + 0.10 * tau;
if state.id == 1 && ~isempty(refX)
    anchor = anchor + 0.10;
end
Xae = (1 - anchor) * Xae + anchor * xElite;
Xae = boundSolution(Xae, params);

[alphaS, betaS, gammaS] = localStateWeights(state);
qualityStep = localQualityStep(x, bestX, xElite, params);
Xcvf = x + alphaS * aeStep + betaS * fieldStep + gammaS * qualityStep;
Xcvf = (1 - anchor) * Xcvf + anchor * xElite;
Xcvf = boundSolution(Xcvf, params);

opInfo = struct();
opInfo.id = opId;
opInfo.stateId = state.id;
opInfo.stateName = state.name;
opInfo.alpha = alphaS;
opInfo.beta = betaS;
opInfo.gamma = gammaS;
opInfo.fieldNorm = norm(fieldStep);
end

function [alphaS, betaS, gammaS] = localStateWeights(state)
switch state.id
    case 1
        alphaS = 0.80;
        betaS = 0.55;
        gammaS = 0.05;
    case 2
        alphaS = 0.90;
        betaS = 0.45;
        gammaS = 0.08;
    case 3
        alphaS = 1.00;
        betaS = 0.12;
        gammaS = 0.14;
    otherwise
        alphaS = 0.90;
        betaS = 0.35;
        gammaS = 0.04;
end
end

function step = localQualityStep(x, bestX, xElite, params)
step = 0.60 * (bestX - x) + 0.40 * (xElite - x);
try
    ctrl = decodeSolution(x, params);
    delta = zeros(size(ctrl));
    for k = 3:size(ctrl, 1)-2
        target = 0.5 * (ctrl(k-1, :) + ctrl(k+1, :));
        delta(k, :) = 0.20 * (target - ctrl(k, :));
    end
    step = step + encodeControlPoints(delta);
catch
end
limit = 0.05 * (params.ub(:)' - params.lb(:)');
step = min(max(step, -limit), limit);
end
