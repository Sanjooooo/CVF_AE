function ablationCfgs = getAblationConfigs(sceneId)
%GETABLATIONCONFIGS Build COVE-AE ablation settings.

if nargin < 1
    sceneId = 1;
end

base = getDefaultExperimentConfig();
base.sceneId = sceneId;
base.nRuns = 20;
base.showSingleRunFigure = false;
base.showBatchFigure = false;
base.saveBestPathFigure = false;
base.saveBestTopViewFigure = false;

ablationCfgs = repmat(base, 5, 1);

ablationCfgs(1) = base;
ablationCfgs(1).algorithmName = 'Base-AE';
ablationCfgs(1).outputDir = sprintf('ablation_scene%d_base_ae', sceneId);
ablationCfgs(1).useConstraintStateInit = false;
ablationCfgs(1).useViolationFeedback = false;
ablationCfgs(1).useSparseRepairReuse = false;

ablationCfgs(2) = base;
ablationCfgs(2).algorithmName = 'COVE-AE-w/o-Init';
ablationCfgs(2).outputDir = sprintf('ablation_scene%d_cove_wo_init', sceneId);
ablationCfgs(2).useConstraintStateInit = false;
ablationCfgs(2).useViolationFeedback = true;
ablationCfgs(2).useSparseRepairReuse = true;

ablationCfgs(3) = base;
ablationCfgs(3).algorithmName = 'COVE-AE-w/o-Feedback';
ablationCfgs(3).outputDir = sprintf('ablation_scene%d_cove_wo_feedback', sceneId);
ablationCfgs(3).useConstraintStateInit = true;
ablationCfgs(3).useViolationFeedback = false;
ablationCfgs(3).useSparseRepairReuse = true;

ablationCfgs(4) = base;
ablationCfgs(4).algorithmName = 'COVE-AE-w/o-RepairReuse';
ablationCfgs(4).outputDir = sprintf('ablation_scene%d_cove_wo_repair_reuse', sceneId);
ablationCfgs(4).useConstraintStateInit = true;
ablationCfgs(4).useViolationFeedback = true;
ablationCfgs(4).useSparseRepairReuse = false;

ablationCfgs(5) = base;
ablationCfgs(5).algorithmName = 'COVE-AE';
ablationCfgs(5).outputDir = sprintf('ablation_scene%d_cove_full', sceneId);
ablationCfgs(5).useConstraintStateInit = true;
ablationCfgs(5).useViolationFeedback = true;
ablationCfgs(5).useSparseRepairReuse = true;
end
