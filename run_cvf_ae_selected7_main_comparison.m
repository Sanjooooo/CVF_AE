function out = run_cvf_ae_selected7_main_comparison()
%RUN_CVF_AE_SELECTED7_MAIN_COMPARISON Unified formal rerun for paper comparison.
%
% The run uses one frozen configuration for:
% AE, PSO, GWO, HHO, ERIME, MSCSO, CVF-AE.
% It then computes trajectory review tables and regenerates paper artifacts.

projectRoot = fileparts(mfilename('fullpath'));
addpath(projectRoot);

timestamp = datestr(now, 'yyyymmdd_HHMMSS');
resultDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
    ['cvf_ae_selected7_main_comparison_formal_' timestamp]);
artifactDir = fullfile(projectRoot, 'routes', 'route_b_cvf_ae', 'results', ...
    ['cvf_ae_selected7_paper_artifacts_rerun_' timestamp]);

cfg = struct();
cfg.mode = 'selected7_formal';
cfg.sceneIds = [1, 2, 4];
cfg.algorithms = {'AE', 'PSO', 'GWO', 'HHO', 'ERIME', 'MSCSO', 'CVF-AE'};
cfg.nRuns = 30;
cfg.baseSeed = 20260707;
cfg.resultDir = resultDir;
cfg.resumeExisting = true;
cfg.verbose = true;
cfg.saveFigures = false;
cfg.showSingleRunFigure = false;
cfg.showBatchFigure = false;
cfg.saveBestPathFigure = false;
cfg.saveBestTopViewFigure = false;
cfg.useFairReferenceInit = false;
cfg.paramsOverride = struct();
cfg.paramsOverride.popSize = 30;
cfg.paramsOverride.maxIter = 300;

fprintf('\nUnified selected-7 formal comparison starts.\n');
fprintf('Result directory: %s\n', resultDir);
fprintf('Artifact directory: %s\n', artifactDir);

summary = run_uav_comparison_lite_v2_batch(cfg);
sanity = analyze_cvf_ae_trajectory_sanity(resultDir);
artifacts = make_cvf_ae_selected7_paper_artifacts(resultDir, resultDir, artifactDir);

localWriteReadme(resultDir, artifactDir, cfg);

out = struct();
out.resultDir = resultDir;
out.artifactDir = artifactDir;
out.summary = summary;
out.sanity = sanity;
out.artifacts = artifacts;

fprintf('\nUnified selected-7 formal comparison complete.\n');
fprintf('Result directory: %s\n', resultDir);
fprintf('Artifact directory: %s\n', artifactDir);
end

function localWriteReadme(resultDir, artifactDir, cfg)
readmePath = fullfile(resultDir, 'SELECTED7_UNIFIED_RERUN_README.md');
fid = fopen(readmePath, 'w', 'n', 'UTF-8');
if fid < 0
    warning('Could not write README: %s', readmePath);
    return;
end
c = onCleanup(@() fclose(fid));
fprintf(fid, '# Selected-7 unified formal rerun\n\n');
fprintf(fid, '- Result directory: `%s`\n', resultDir);
fprintf(fid, '- Artifact directory: `%s`\n', artifactDir);
fprintf(fid, '- Scenes: `%s`\n', mat2str(cfg.sceneIds));
fprintf(fid, '- Algorithms: `%s`\n', strjoin(cfg.algorithms, ', '));
fprintf(fid, '- Runs per scene/algorithm: `%d`\n', cfg.nRuns);
fprintf(fid, '- Population size: `%d`\n', cfg.paramsOverride.popSize);
fprintf(fid, '- Maximum iterations: `%d`\n', cfg.paramsOverride.maxIter);
fprintf(fid, '- Base seed: `%d`\n\n', cfg.baseSeed);
fprintf(fid, 'All algorithms use the same path encoding, evaluator, bounds, scenes, run count, population size, and iteration budget.\n');
end
