# Route B historical-result and old-code migration

Migration date: 2026-08-01

The active MATLAB dependency graph was reduced before migration. Static MATLAB
dependency analysis over the maintained formal-run, artifact-generation, and
internal template-ablation entry points produced 40 required files. The optional
closed-loop framework generator was retained as a forty-first file. None of the
old-code candidates was referenced by this retained set.

## Retained result directories

- `cvf_ae_selected7_main_comparison_formal_20260707_101155/`
- `cvf_ae_selected7_paper_artifacts_rerun_20260707_101155/`
- `cvf_ae_formal_ablation_corrected_20260730_v2/`
- `cvf_ae_corrected_ablation_paper_artifacts_20260730/`
- `template_initialization_ablation_20260711_225319/`

## Migrated historical result directories

- `cvf_ae_convergence_curves_20260623_from_main_comparison/`
- `cvf_ae_extended_main_comparison_20260623_from_formal_and_recent/`
- `cvf_ae_formal_ablation_20260618_102649/`
- `cvf_ae_formal_ablation_conservative_20260622_194947/`
- `cvf_ae_formal_ablation_corrected_20260730/`
- `cvf_ae_formal_ablation_scene2_v2_20260622_163919/`
- `cvf_ae_formal_significance_20260624_from_formal_results/`
- `cvf_ae_gate_20260618_084956/`
- `cvf_ae_gate_strict_accept_20260618_085923/`
- `cvf_ae_main_comparison_formal_20260622_103121/`
- `cvf_ae_main_comparison_formal_conservative_20260623_091132/`
- `cvf_ae_main_comparison_formal_scene2_v2_merged_20260622_155500/`
- `cvf_ae_main_comparison_precheck_20260622_101130/`
- `cvf_ae_main_comparison_recent_improved_formal_20260623_161229/`
- `cvf_ae_main_comparison_scene2_v2_formal_20260622_152052/`
- `cvf_ae_main_comparison_scene2_v2_sanity_20260622_130924/`
- `cvf_ae_medium_gate_20260618_090607/`
- `cvf_ae_medium_gate_sparse2_20260618_095112/`
- `cvf_ae_paper_completion_figures_20260624_from_formal_results/`
- `cvf_ae_paper_results_package_20260624_from_formal_results/`
- `cvf_ae_param_sensitivity_conservative_20260623_131249/`
- `cvf_ae_representative_paths_20260623_from_formal_results/`
- `cvf_ae_runtime_overhead_analysis_20260623_from_existing_results/`
- `cvf_ae_sa_lite_validation_20260622_193237/`
- `cvf_ae_selected7_paper_artifacts_20260706/`
- `formal_run_logs/`
- `scene2_v2_map_preview_20260622_130820/`

The previous
`cvf_ae_corrected_ablation_paper_artifacts_20260730/representative_paths/`
subtree was also migrated because it mixed obsolete main and extended comparison
outputs with the ablation output. The active directory was regenerated with only
the current Scene 3 ablation overlay, editable figure, and selection CSV.

## Migrated old MATLAB files

- `analyze_cvf_ae_formal_significance.m`
- `analyze_cvf_ae_param_sensitivity_sanity.m`
- `analyze_cvf_ae_runtime_overhead.m`
- `analyzeViolationFeedback.m`
- `applyOperator_COVE_AE.m`
- `applyOperator_FAEAE_lite_v2.m`
- `computeReward.m`
- `export_cvf_ae_paper_results_package.m`
- `export_uav_fair_init_paper_artifacts.m`
- `export_uav_main_paper_artifacts.m`
- `getAblationConfigs.m`
- `getDefaultExperimentConfig.m`
- `getUAVComparisonConfig.m`
- `init_baseline_AE.m`
- `init_FAEAE.m`
- `initAOS.m`
- `inspect_scene2_cvf_low_altitude_candidates.m`
- `make_cvf_ae_convergence_curves.m`
- `make_cvf_ae_paper_completion_figures.m`
- `make_cvf_ae_representative_path_figures.m`
- `make_cvf_ae_review_preview_figures.m`
- `make_cvf_pressure_mapping_figure.m`
- `make_cvf_pressure_mapping_preview.m`
- `make_scene2_palette_test_figure.m`
- `make_tab_runtime_feasibility.m`
- `make_tab4_1_uav_main_results.m`
- `make_tab4_2_uav_main_wtl.m`
- `make_tab4_3_uav_ablation_results.m`
- `make_uav_ablation_convergence_paper_v2.m`
- `make_uav_main_convergence_paper.m`
- `make_uav_param_sensitivity_plot_lite_v2.m`
- `make_uav_wilcoxon_table.m`
- `merge_cvf_ae_extended_main_comparison.m`
- `optimizer_COVE_AE_uav.m`
- `optimizer_CPO_uav.m`
- `optimizer_DBO_uav.m`
- `optimizer_FAEAE_lite_v2_uav.m`
- `optimizer_GDESAO_uav.m`
- `optimizer_WOA_uav.m`
- `plot_uav_best_paths_exact.m`
- `plot_uav_representative_corridor_paths_all_paper.m`
- `plotSceneAndPath.m`
- `run_cove_ae_ablation_diagnostics.m`
- `run_cove_ae_diagnostics.m`
- `run_cvf_ae_main_comparison.m`
- `run_cvf_ae_param_sensitivity.m`
- `run_cvf_ae_recent_improved_formal_chunk.m`
- `run_single_uav_algorithm_case.m`
- `run_uav_ablation_lite_v2_batch.m`
- `run_uav_param_sensitivity_lite_v2.m`
- `selectOperator_UCB.m`
- `stagnationDetected.m`
- `summarize_cove_ae_diagnostics.m`
- `updateAOS.m`

## Restore procedure

Restore an item to the matching project-relative path only after checking that
the destination does not already exist. If old comparison algorithms are
restored, do not add them back to the maintained selected-seven dispatcher unless
the paper's experimental protocol is intentionally changed.
