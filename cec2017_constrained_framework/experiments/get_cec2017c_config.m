function cfg = get_cec2017c_config(stage)
%GET_CEC2017C_CONFIG Staged experiment configuration.

if nargin < 1, stage = 'stage-b'; end
stage = lower(string(stage));
cfg = struct();
cfg.baseSeed = 20260624;
cfg.popSize = 20;
cfg.cvfQuotaRate = 0.05;
cfg.cvfMaxStepRatio = 0.08;
cfg.cvfMaxNormRatio = 0.12;
cfg.deF = 0.5;
cfg.deCR = 0.9;
cfg.psoW = 0.7;
cfg.psoC1 = 1.5;
cfg.psoC2 = 1.5;
cfg.resumeExisting = true;

switch stage
    case "stage-a"
        cfg.stage = 'stage-a';
        cfg.dimensions = 10;
        cfg.functionIds = 1:28;
        cfg.algorithms = {'AE'};
        cfg.nRuns = 1;
        cfg.maxFEs = 100;
    case "stage-b"
        cfg.stage = 'stage-b';
        cfg.dimensions = 10;
        cfg.functionIds = [1, 3, 6, 14, 18];
        cfg.algorithms = {'AE','CVF-AE','CVF-AE-w/o-CVF','DE','PSO'};
        cfg.nRuns = 3;
        cfg.maxFEs = 3000;
    case "stage-c"
        cfg.stage = 'stage-c';
        cfg.dimensions = 10;
        cfg.functionIds = 1:28;
        cfg.algorithms = {'AE','CVF-AE','CVF-AE-w/o-CVF','DE','PSO'};
        cfg.nRuns = 5;
        cfg.maxFEs = 20000;
    case "formal"
        cfg.stage = 'formal';
        cfg.dimensions = [10, 100];
        cfg.functionIds = 1:28;
        cfg.algorithms = {'AE','CVF-AE','CVF-AE-w/o-CVF','DE','PSO'};
        cfg.nRuns = 20;
        cfg.maxFEs = [];
    otherwise
        error('CVFAE:UnknownStage', 'Unknown stage: %s', stage);
end
end
