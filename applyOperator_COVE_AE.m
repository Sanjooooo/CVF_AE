function [Xnew, opInfo] = applyOperator_COVE_AE(i, pop, bestX, refX, elitePool, state, feedback, memory, iter, params)
%APPLYOPERATOR_COVE_AE Lightweight operator driven by state and violations.

[N, D] = size(pop); %#ok<ASGLU>
x = pop(i, :);
span = params.ub(:)' - params.lb(:)';
tau = iter / params.maxIter;

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

bias = localViolationMask(feedback, params);
noise = (2 * rand(1, D) - 1) .* span .* bias;
reuseStep = localReuseStep(memory, D);

switch state.id
    case 1
        opId = 1;
        step = ...
            (0.25 + 0.25 * (1 - tau)) * rand(1, D) .* dirRef + ...
            (0.20 + 0.20 * (1 - tau)) * rand(1, D) .* dirElite + ...
            0.18 * diff1 + ...
            (0.08 + 0.10 * (1 - tau)) * noise + ...
            0.18 * reuseStep;

    case 2
        opId = 2;
        step = ...
            (0.25 + 0.10 * tau) * rand(1, D) .* dirBest + ...
            0.28 * rand(1, D) .* dirElite + ...
            0.16 * diff1 + ...
            0.08 * rand(1, D) .* dirRef + ...
            0.08 * noise + ...
            0.22 * reuseStep;

    case 3
        opId = 3;
        step = ...
            (0.38 + 0.16 * tau) * rand(1, D) .* dirBest + ...
            (0.30 + 0.12 * tau) * rand(1, D) .* dirSample + ...
            0.08 * diff1 + ...
            0.04 * noise + ...
            0.10 * reuseStep;

    otherwise
        opId = 4;
        step = ...
            0.24 * diff1 + ...
            0.18 * diff2 + ...
            0.22 * rand(1, D) .* dirBest + ...
            0.10 * randn(1, D) .* span .* bias + ...
            0.25 * reuseStep;
end

Xnew = x + step;

anchor = 0.05 + 0.10 * tau;
if state.id == 1 && ~isempty(refX)
    anchor = anchor + 0.10;
end
Xnew = (1 - anchor) * Xnew + anchor * xElite;

if strcmp(feedback.dominantType, 'curvature')
    Xnew = localSmoothControlVector(Xnew, params, 0.20);
end

Xnew = boundSolution(Xnew, params);

opInfo = struct();
opInfo.id = opId;
opInfo.stateId = state.id;
opInfo.stateName = state.name;
opInfo.feedbackType = feedback.dominantType;
end

function mask = localViolationMask(feedback, params)
D = params.dim;
mask = ones(1, D);

switch feedback.dominantType
    case {'obstacle', 'nfz', 'risk'}
        mask(1:3:end) = 1.20;
        mask(2:3:end) = 1.20;
        mask(3:3:end) = 0.65;
    case 'altitude'
        mask(1:3:end) = 0.55;
        mask(2:3:end) = 0.55;
        mask(3:3:end) = 1.35;
    case 'curvature'
        mask(:) = 0.75;
    otherwise
        mask(:) = 1.0;
end
end

function step = localReuseStep(memory, D)
step = zeros(1, D);
if isstruct(memory) && isfield(memory, 'repairStep') && numel(memory.repairStep) == D
    step = memory.repairStep(:)';
end
end

function X = localSmoothControlVector(X, params, gamma)
ctrl = decodeSolution(X, params);
for k = 3:size(ctrl, 1)-2
    target = 0.5 * (ctrl(k-1, :) + ctrl(k+1, :));
    ctrl(k, :) = ctrl(k, :) + gamma * (target - ctrl(k, :));
end
X = encodeControlPoints(ctrl);
end
