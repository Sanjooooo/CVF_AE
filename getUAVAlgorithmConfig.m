function algCfg = getUAVAlgorithmConfig(algName, params, cfg)
%GETUAVALGORITHMCONFIG Return selected-seven algorithm configuration.
%
% Inputs:
%   algName - algorithm name
%   params  - defaultParams() output after scene assignment
%   cfg     - comparison config
%
% Output:
%   algCfg  - algorithm-specific configuration

    if nargin < 3 || isempty(cfg)
        cfg = struct();
    end
    algName = upper(algName);

    algCfg = struct();
    algCfg.name = algName;

    % ------------------------------------------------------------
    % Shared search settings
    % IMPORTANT:
    % Your current defaultParams.m uses params.popSize, not params.N.
    % ------------------------------------------------------------
    algCfg.dim = params.dim;
    algCfg.lb = params.lb(:)';
    algCfg.ub = params.ub(:)';
    algCfg.popSize = params.popSize;
    algCfg.maxIter = params.maxIter;

    % Common initialization choices
    algCfg.useReferenceInit = false;
    algCfg.referenceInitRatio = 0.0;
    algCfg.referenceNoiseScale = 0.05;   % relative to range
    algCfg.useDebSelection = true;

    % Public lightweight projection
    algCfg.usePublicProjection = true;

    switch algName
        case 'AE'
            algCfg.useReferenceInit = false;
            algCfg.referenceInitRatio = 0.0;

        case 'PSO'
            algCfg.w = 0.7;
            algCfg.c1 = 1.5;
            algCfg.c2 = 1.5;
            algCfg.vmaxRatio = 0.2;
            algCfg.useReferenceInit = false;
            algCfg.referenceInitRatio = 0.0;

        case 'GWO'
            algCfg.useReferenceInit = false;
            algCfg.referenceInitRatio = 0.0;

        case 'HHO'
            algCfg.useReferenceInit = false;
            algCfg.referenceInitRatio = 0.0;

        case {'ERIME', 'ELRIME'}
            algCfg.name = 'ERIME';
            algCfg.useReferenceInit = false;
            algCfg.referenceInitRatio = 0.0;
            algCfg.erime.reverseProb = 0.5;
            algCfg.erime.softScale = 5.0;

        case 'MSCSO'
            algCfg.useReferenceInit = false;
            algCfg.referenceInitRatio = 0.0;
            algCfg.mscso.temp0 = 1.0;
            algCfg.mscso.cooling = 0.98;
            algCfg.mscso.eliteRate = 0.20;
            algCfg.mscso.mutRate = 0.15;
            algCfg.mscso.levyProb = 0.35;
            algCfg.mscso.wMax = 0.9;
            algCfg.mscso.wMin = 0.4;
            algCfg.mscso.c1 = 1.5;
            algCfg.mscso.c2 = 1.5;

        case {'CVF-AE', 'CVF_AE', 'CVFAE'}
            algCfg.name = 'CVF-AE';
            algCfg.useReferenceInit = true;
            algCfg.referenceInitRatio = 0.7;

            algCfg.useConstraintStateInit = true;
            algCfg.useCVF = true;
            algCfg.useStateAdaptiveCVF = true;
            algCfg.useConservativeStateAdaptiveCVF = true;
            algCfg.useSparseRepairReuse = true;
            algCfg.cvfAe.conservativeStateAdaptive = true;
            algCfg.cvfAe.maxPerIterFormation = max(1, round(0.06 * params.popSize));
            algCfg.cvfAe.maxPerIterRecovery = max(1, round(0.04 * params.popSize));
            algCfg.cvfAe.maxPerIterRefinement = max(1, round(0.01 * params.popSize));
            algCfg.cvfAe.refinementInterval = 8;

        otherwise
            error('Unsupported selected-seven algorithm: %s', algName);
    end

    % ------------------------------------------------------------
    % Fair reference-initialization override
    % When enabled, all algorithms use the same reference-based init,
    % which helps isolate the benefit of the search mechanism itself.
    % ------------------------------------------------------------
    if isfield(cfg, 'useFairReferenceInit') && cfg.useFairReferenceInit
        algCfg.useReferenceInit = true;

        if isfield(cfg, 'fairReferenceInitRatio')
            algCfg.referenceInitRatio = cfg.fairReferenceInitRatio;
        else
            algCfg.referenceInitRatio = 0.7;
        end

        if isfield(cfg, 'fairReferenceNoiseScale')
            algCfg.referenceNoiseScale = cfg.fairReferenceNoiseScale;
        else
            algCfg.referenceNoiseScale = 0.05;
        end
    end
    fprintf('Algorithm %s: useReferenceInit=%d, ratio=%.2f\n', ...
    algCfg.name, algCfg.useReferenceInit, algCfg.referenceInitRatio);
end
