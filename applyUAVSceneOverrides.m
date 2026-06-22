function params = applyUAVSceneOverrides(params)
%APPLYUAVSCENEOVERRIDES Apply scene-specific UAV planning parameters.
%
% Code scene 4 is the low-altitude delivery-corridor scene used as Paper
% Scene 3 in the inherited FAEAE workflow.

if ~isfield(params, 'sceneId')
    return;
end

switch params.sceneId
    case 4
        params.altMin = 8;
        params.altMax = 26;
        params.heightRef = 14;
        params.weights.H = 1.20;

        params.lbSingle(3) = params.altMin;
        params.ubSingle(3) = params.altMax;
        params.lb = repmat(params.lbSingle, 1, params.nCtrl);
        params.ub = repmat(params.ubSingle, 1, params.nCtrl);

    case 2
        params.altMin = 8;
        params.altMax = 32;
        params.heightRef = 16;
        params.refCruiseZ = 16;
        params.weights.H = 1.05;

        params.lbSingle(3) = params.altMin;
        params.ubSingle(3) = params.altMax;
        params.lb = repmat(params.lbSingle, 1, params.nCtrl);
        params.ub = repmat(params.ubSingle, 1, params.nCtrl);

    case 1
        params.lbSingle(3) = params.altMin;
        params.ubSingle(3) = params.altMax;
        params.lb = repmat(params.lbSingle, 1, params.nCtrl);
        params.ub = repmat(params.ubSingle, 1, params.nCtrl);

    otherwise
        error('Unsupported sceneId: %d. Use 1, 2, or 4.', params.sceneId);
end
end
