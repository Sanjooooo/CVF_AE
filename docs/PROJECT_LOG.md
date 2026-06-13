# COVE-AE Project Log

## 2026-06-12 Project Kickoff

### Background

- New project directory: `D:\MATLAB\Project\COVE_AE_matlab`.
- Reference project directory: `D:\MATLAB\Project\FAEAE_matlab`.
- The previous FAEAE manuscript was desk rejected by Applied Intelligence, mainly due to insufficient novelty and technical quality.
- The current direction is not to discard the previous work, but to rebuild the innovation mechanism around COVE-AE.
- Algorithm short name: COVE-AE.
- Working meaning: Constraint-state and Violation-feedback Evolution with an Alpha Evolution backbone.
- Do not use CSFAEAE as the project name or algorithm name.

### Agreed Research Direction

- Avoid the old four-module narrative: reference-path initialization, UCB-AOS, local repair, and stagnation regeneration as parallel add-ons.
- Build a lightweight constraint-state-driven search framework for strongly constrained low-altitude UAV path planning.
- Keep runtime and complexity space for future cooperative multi-UAV planning work.

### Planned Innovation Points

1. Constraint-state-driven initialization and search-stage transition.
2. Violation-feedback-driven lightweight evolutionary operators.
3. Efficiency-oriented sparse repair and experience reuse.

### Current Repository State

- `git status` shows this directory is not currently a Git repository.
- Suggested next step before code restructuring: initialize Git in `D:\MATLAB\Project\COVE_AE_matlab`, then make a first baseline commit of the copied project state.
- `docs` and `experiments` currently contain no project artifacts before this log.
- The copied code already includes UAV modeling, B-spline encoding, fitness evaluation, baseline optimizers, UAV experiment scripts, plotting/table helpers, and a CEC2017 framework.

### Initial File Assessment

Likely reusable with limited changes:

- `createMap.m`
- `fitnessFAEAE.m`
- `bsplinePath.m`
- `decodeSolution.m`
- `encodeControlPoints.m`
- `boundSolution.m`
- `debBetter.m`
- `repairPath.m`, after wrapping or slimming for sparse repair policy
- Baseline optimizers such as `optimizer_AE_uav.m`, `optimizer_PSO_uav.m`, `optimizer_GWO_uav.m`, `optimizer_HHO_uav.m`, and `optimizer_WOA_uav.m`
- CEC2017 framework as supplemental validation only

Needs major restructuring for COVE-AE:

- `optimizer_FAEAE_lite_v2_uav.m`
- `applyOperator_FAEAE_lite_v2.m`
- `init_FAEAE.m`
- `getUAVAlgorithmConfig.m`
- `run_uav_comparison_lite_v2_batch.m`
- `run_uav_ablation_lite_v2_batch.m`

Do not prioritize now:

- Old FAEAE figure/table export scripts.
- Old fair-initialization pipeline as a main-experiment design.
- Paper LaTeX rewriting.
- Any narrative centered on additive FAEAE modules.

### Next Work Boundary

No large-scale algorithm code modification should begin until the user confirms the first-stage restructuring plan.

## 2026-06-12 Phase 1 Code Skeleton

### Git Baseline

- Initialized Git in `D:\MATLAB\Project\COVE_AE_matlab`.
- Added `.gitattributes` for stable line endings and binary MATLAB artifacts.
- Initial baseline commit: `d17a707 Initialize COVE-AE MATLAB project baseline`.

### Code Changes

- Added independent COVE-AE implementation files:
  - `optimizer_COVE_AE_uav.m`
  - `init_COVE_AE.m`
  - `identifyConstraintState.m`
  - `analyzeViolationFeedback.m`
  - `applyOperator_COVE_AE.m`
- Added `.gitignore` for MATLAB temporary files and generated experiment outputs.
- Integrated `COVE-AE` into:
  - `getUAVAlgorithmConfig.m`
  - `getUAVComparisonConfig.m`
  - `run_single_uav_algorithm_case.m`
  - `run_uav_comparison_lite_v2_batch.m`
- Reworked ablation naming and dispatch around the three COVE-AE mechanisms:
  - `Base-AE`
  - `COVE-AE-w/o-Init`
  - `COVE-AE-w/o-Feedback`
  - `COVE-AE-w/o-RepairReuse`
  - `COVE-AE`

### Implemented Mechanism Hooks

- Constraint-state identification records:
  - feasible ratio
  - mean violation
  - diversity
  - recent best improvement
  - state name and state id
- Violation feedback records dominant source among obstacle, NFZ, curvature, altitude, risk, or none.
- COVE-AE operator uses state id plus violation type to choose perturbation structure.
- Sparse repair is restricted to elite-side, near-feasible candidates and records repair count and successful repair count.
- Repair displacement is reused through a lightweight memory vector.

### Efficiency Metrics Added

- `nEvals`
- `runTime`
- `firstFeasibleIter`
- `firstFeasibleTime`
- `repairCount`
- `repairSuccessCount`
- `feasibleRatioHistory`
- `meanViolationHistory`
- `diversityHistory`
- `stateHistory`
- `operatorHistory`

The main comparison and ablation run tables now export `NEvals`, `FirstFeasibleIter`, `FirstFeasibleTime`, `RepairCount`, and `RepairSuccessCount`.

### Verification

- MATLAB static checks passed for the new COVE-AE files. Remaining analyzer notes are only performance/style hints in existing batch scripts.
- Direct COVE-AE smoke run passed on Scene 1 with small `popSize` and `maxIter`.
- `run_single_uav_algorithm_case('COVE-AE', 1, cfg, 1)` passed.
- Main comparison smoke passed for one Scene 1 COVE-AE run and exported the new efficiency columns.
- COVE-AE ablation smoke passed for all five ablation configurations.

### Next Steps

- Tune state thresholds and operator coefficients on smoke/mid experiments.
- Add at least one harder scenario before formal experiments.
- Decide whether `Legacy-FAEAE` should appear in ablation or only in a separate legacy comparison.
- Add improved non-AE baselines after the COVE-AE mechanism stabilizes.

## 2026-06-12 Scene Cleanup

- Confirmed that the inherited FAEAE paper pipeline used code scenes `[1, 2, 4]`.
- Code Scene 4 was displayed as Paper Scene 3 in old paper scripts and legacy documentation.
- Removed the unused real code `sceneId == 3` branch from `createMap.m`.
- `createMap.m` now supports only code scenes 1, 2, and 4.

## 2026-06-12 Scene Override Unification

- Added `applyUAVSceneOverrides.m` as the shared scene-specific parameter hook.
- Centralized the code Scene 4 low-altitude corridor settings:
  - `altMin = 8`
  - `altMax = 26`
  - `heightRef = 14`
  - `weights.H = 1.20`
  - synchronized `lbSingle`, `ubSingle`, `lb`, and `ub`
- Replaced the inline Scene 4 override in `run_single_uav_algorithm_case.m`.
- Applied the same override in main comparison, ablation, parameter sensitivity, and path plotting scripts.
- Verified Scene 4 smoke runs through direct setup, single-run dispatch, main comparison batch, and ablation batch.

## 2026-06-12 COVE-AE Diagnostic Batch

- Added reusable diagnostic scripts:
  - `run_cove_ae_diagnostics.m`
  - `summarize_cove_ae_diagnostics.m`
- Default diagnostic configuration:
  - scenes `[1, 2, 4]`
  - algorithms `AE` and `COVE-AE`
  - `nRuns = 3`
  - `popSize = 10`
  - `maxIter = 30`
- The diagnostic summary exports `cove_ae_diagnostics.csv` with state fractions, operator counts, first feasible iteration, repair counts, and final feasibility metrics.

### Diagnostic Findings

- Initial diagnostic showed COVE-AE stayed too long in `FeasibilityFormation` after finding feasible individuals.
- Updated `identifyConstraintState.m` so that once any feasible individual exists, the state can move to preservation/refinement even if the population mean violation is still high.
- Added a lightweight structure-aware avoidance step to `applyOperator_COVE_AE.m` for obstacle/NFZ/risk feedback.
- The avoidance step uses capped B-spline sampling and limited violation hits to keep overhead bounded.

### Current Behavior Snapshot

- Scene 1: COVE-AE reaches feasible solutions in the short diagnostic.
- Scene 2: COVE-AE reaches feasible solutions in most short diagnostic runs.
- Scene 4: COVE-AE remains difficult in the short 30-iteration diagnostic, but a medium run with `popSize = 30`, `maxIter = 120` reached feasibility.
- Scene 4 therefore needs parameter tuning for faster feasibility formation rather than a complete mechanism change.

## 2026-06-12 Scene 4 Feasibility Formation Tuning

- Tested whether Scene 4 failure came from the old reference path.
- Found that the generated reference path for code Scene 4 has severe obstacle violation:
  - `V = 63`
  - dominated by obstacle collisions.
- Verified that several boundary-corridor B-spline control templates are feasible without changing the map.
- Added Scene 4 prior templates inside `init_COVE_AE.m` as part of constraint-state initialization.
- These templates are only used when `useConstraintStateInit = true`, so `COVE-AE-w/o-Init` does not receive them.

### Diagnostic Result After Tuning

- Scene 4 initial population can now contain feasible solutions.
- Default diagnostic short run (`popSize = 10`, `maxIter = 30`, `nRuns = 3`) reached feasible solutions in all Scene 4 COVE-AE runs.
- Scene 4 ablation smoke confirmed:
  - `COVE-AE-w/o-Init` remained infeasible.
  - `COVE-AE`, `w/o Feedback`, and `w/o RepairReuse` reached feasibility because they retain constraint-state initialization.

### Interpretation

- Scene 4 does not need immediate map simplification.
- The current evidence supports presenting Scene 4 as a case where constraint-state initialization is critical.
- We can still keep map simplification as a fallback if later full-scale experiments show excessive runtime or unstable results.

## 2026-06-12 Small-Scale Ablation Diagnostics

- Added `run_cove_ae_ablation_diagnostics.m`.
- Default ablation diagnostic configuration:
  - scenes `[1, 2, 4]`
  - `Base-AE`
  - `COVE-AE-w/o-Init`
  - `COVE-AE-w/o-Feedback`
  - `COVE-AE-w/o-RepairReuse`
  - `COVE-AE`
  - `nRuns = 5`
  - `popSize = 10`
  - `maxIter = 30`
- The script exports:
  - `cove_ae_ablation_diagnostics.csv`
  - `cove_ae_ablation_diagnostic_summary.csv`
  - `cove_ae_ablation_diagnostic_summary.mat`
- Fixed the ablation `Base-AE` configuration so it uses the natural AE config instead of inheriting `COVE-AE` reference initialization.

### Current Small-Scale Ablation Findings

- Constraint-state initialization is strongly supported:
  - `COVE-AE-w/o-Init` is much weaker on Scenes 2 and 4.
  - Scene 4 reaches feasibility reliably only when the constraint-state initialization templates are enabled.
- Sparse repair/reuse is useful in Scene 2:
  - Full `COVE-AE` reached higher feasibility than `COVE-AE-w/o-RepairReuse` in the short diagnostic.
- Violation feedback still needs strengthening:
  - `COVE-AE-w/o-Feedback` is currently competitive with or better than full `COVE-AE` on some short diagnostic cases.
  - Next tuning should make violation feedback contribute more clearly to obstacle/NFZ handling without excessive runtime overhead.

## 2026-06-13 Violation-Feedback Tuning and Default Freeze

### Mechanism Tuning

- Strengthened the COVE-AE violation-feedback operator without adding a new standalone module.
- `analyzeViolationFeedback.m` now builds feedback scores from near-feasible-weighted violation components:
  - obstacle: `Cobs`
  - NFZ: `Cnfz`
  - curvature: `Ccurv`
  - altitude: `Calt`
  - risk: `R / L`
- Each individual contributes with weight `1 / (1 + V)`, so near-feasible and feasible paths have more influence on the operator feedback than severely infeasible outliers.
- `applyOperator_COVE_AE.m` now converts the unified feedback vector into one bounded structural feedback step:
  - obstacle / NFZ / risk: capped sampled avoidance step on the decoded B-spline path.
  - curvature: control-point smoothing step.
  - altitude: height-reference pullback step.
- The feedback step is still embedded in the existing four state-dependent AE operator cases; no separate heavy repair/regeneration module was added.
- `optimizer_COVE_AE_uav.m` now records `feedbackHistory` and `feedbackScoreHistory`.
- `summarize_cove_ae_diagnostics.m` and `run_cove_ae_ablation_diagnostics.m` export feedback-type fractions in the diagnostic CSV summaries.

### Small-Scale Ablation Recheck

- Result folder: `results_cove_ae_ablation_feedback_tuned2_20260613_124121`.
- Configuration:
  - scenes `[1, 2, 4]`
  - algorithms `Base-AE`, `COVE-AE-w/o-Init`, `COVE-AE-w/o-Feedback`, `COVE-AE-w/o-RepairReuse`, `COVE-AE`
  - `nRuns = 5`
  - `popSize = 10`
  - `maxIter = 30`
  - `baseSeed = 20260613`

Key aggregate results:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter |
|---:|---|---:|---:|---:|---:|---:|---:|
| 1 | COVE-AE-w/o-Feedback | 0.80 | 375.32 | 0.40 | 0.223 | 328.8 | 6.5 |
| 1 | COVE-AE | 0.60 | 378.43 | 0.40 | 0.314 | 330.4 | 12.67 |
| 2 | COVE-AE-w/o-Feedback | 0.80 | 530.84 | 1.20 | 0.215 | 321.8 | 16.0 |
| 2 | COVE-AE | 1.00 | 354.95 | 0.00 | 0.392 | 325.8 | 17.4 |
| 4 | COVE-AE-w/o-Feedback | 1.00 | 398.52 | 0.00 | 0.199 | 317.4 | 0.0 |
| 4 | COVE-AE | 1.00 | 399.29 | 0.00 | 0.379 | 315.4 | 0.0 |

Interpretation:

- Scene 2 now gives the clearest evidence for violation feedback: full `COVE-AE` improves feasibility from `0.80` to `1.00`, reduces mean final violation from `1.20` to `0.00`, and lowers mean best fitness from `530.84` to `354.95` relative to `COVE-AE-w/o-Feedback`.
- Scene 4 remains initialization-dominated: both full `COVE-AE` and `COVE-AE-w/o-Feedback` are feasible from iteration 0 because the Scene 4 constraint-state templates are active.
- Scene 1 remains mixed in this very short diagnostic; the tuned feedback is not presented as universally dominant from this 5-run smoke-scale check.
- The runtime overhead is visible but bounded: full `COVE-AE` uses similar evaluation counts and adds path-sampling overhead in the operator.

### Frozen COVE-AE Default Parameters

Default parameter location: `optimizer_COVE_AE_uav.m`, function `localDefaultCoveParams`.

State thresholds:

- `params.cove.state.window = 15`
- `params.cove.state.improvementTol = 1e-4`
- `params.cove.state.formationFeasibleRatio = 0.20`
- `params.cove.state.refinementFeasibleRatio = 0.65`
- `params.cove.state.highViolation = 10`
- `params.cove.state.recoveryDiversityMax = 0.08`

Constraint-state initialization:

- `params.cove.init.guidedRatio = 0.70`
- `params.cove.init.initialRepairQuota = max(1, round(0.20 * params.popSize))`
- `params.cove.init.initialRepairMaxViolation = 30`
- `params.cove.init.initialRepairIters = 1`
- Guided initialization internals in `init_COVE_AE.m` remain:
  - `clearanceScale = 0.45`
  - `riskShrink = 1.80`
  - `minRadius = 1.0`
  - `maxTrial = 8`

Sparse repair and reuse:

- `params.cove.repair.eliteFrac = 0.35`
- `params.cove.repair.maxPerIter = max(1, round(0.12 * params.popSize))`
- `params.cove.repair.maxViolation = 25`
- `params.cove.repair.iters = 1`
- `params.cove.repair.startFrac = 0.15`
- `params.cove.repair.memoryAlpha = 0.25`

Violation feedback and avoidance:

- `params.cove.feedback.strength = 0.70`
- `params.cove.feedback.avoidanceSamples = 64`
- `params.cove.feedback.avoidanceMaxHits = 10`
- `params.cove.feedback.avoidanceLimit = 0.07`
- `params.cove.feedback.riskActivation = 0.24`
- `params.cove.feedback.riskStepScale = 2.20`
- `params.cove.feedback.smoothGamma = 0.32`
- `params.cove.feedback.altitudeGain = 0.35`

State-dependent feedback-step coefficients in `applyOperator_COVE_AE.m`:

- Feasibility formation: `0.36 * feedbackStep`
- Feasibility preservation: `0.28 * feedbackStep`
- Quality refinement: `0.16 * feedbackStep`
- Stagnation recovery: `0.22 * feedbackStep`

### Stop Boundary

- This commit freezes one COVE-AE default configuration for the current paper-stage code.
- Do not continue into formal ablation, parameter sensitivity, main comparison, CEC, or map redesign until the next explicit work phase.

## 2026-06-13 Formal Ablation Check

### Purpose

- Verify whether the three COVE-AE innovation points are stable under a full ablation setting.
- Verify whether full `COVE-AE` has an overall advantage under the frozen recommended configuration.
- Scope was limited to ablation only; no main comparison, parameter sensitivity, CEC, or map redesign was run.

### Run Configuration

- Result folder: `results_cove_ae_ablation_formal_direct_20260613_133818`.
- Scenes: `[1, 2, 4]`.
- Algorithms:
  - `Base-AE`
  - `COVE-AE-w/o-Init`
  - `COVE-AE-w/o-Feedback`
  - `COVE-AE-w/o-RepairReuse`
  - `COVE-AE`
- Runs: `30`.
- `popSize = 30`.
- `maxIter = 300`.
- `baseSeed = 20260613`.
- The first direct MATLAB run was interrupted after `303 / 450` run records had been written.
- Added `resumeExisting` support to the ablation batch runner and resumed from the same `run_records` folder, avoiding recomputation of completed runs.
- Final run record count: `450 / 450`.

### Aggregate Results

| Scene | Algorithm | FeasibleRate | MeanBestFitness | StdBestFitness | MeanRuntime | MeanFirstFeasibleIter |
|---:|---|---:|---:|---:|---:|---:|
| 1 | Base-AE | 0.467 | 846.85 | 454.95 | 4.57 | NaN |
| 1 | COVE-AE-w/o-Init | 1.000 | 319.63 | 11.08 | 7.86 | 19.40 |
| 1 | COVE-AE-w/o-Feedback | 1.000 | 308.00 | 1.83 | 4.86 | 2.73 |
| 1 | COVE-AE-w/o-RepairReuse | 1.000 | 308.81 | 4.84 | 20.74 | 6.90 |
| 1 | COVE-AE | 1.000 | 307.57 | 2.52 | 26.69 | 3.27 |
| 2 | Base-AE | 0.000 | 2243.33 | 492.46 | 12.08 | NaN |
| 2 | COVE-AE-w/o-Init | 0.967 | 346.39 | 109.06 | 38.00 | 75.93 |
| 2 | COVE-AE-w/o-Feedback | 1.000 | 325.26 | 9.86 | 18.53 | 30.30 |
| 2 | COVE-AE-w/o-RepairReuse | 1.000 | 329.17 | 10.08 | 20.85 | 27.27 |
| 2 | COVE-AE | 1.000 | 329.04 | 10.51 | 24.20 | 27.70 |
| 4 | Base-AE | 0.000 | 1683.45 | 146.39 | 5.09 | NaN |
| 4 | COVE-AE-w/o-Init | 0.567 | 648.60 | 416.75 | 10.51 | 157.29 |
| 4 | COVE-AE-w/o-Feedback | 1.000 | 360.50 | 23.59 | 5.10 | 0.00 |
| 4 | COVE-AE-w/o-RepairReuse | 1.000 | 371.48 | 13.98 | 9.75 | 0.00 |
| 4 | COVE-AE | 1.000 | 362.84 | 22.33 | 9.90 | 0.00 |

Average rank by mean best fitness:

| Algorithm | AverageRank |
|---|---:|
| COVE-AE-w/o-Feedback | 1.33 |
| COVE-AE | 1.67 |
| COVE-AE-w/o-RepairReuse | 3.00 |
| COVE-AE-w/o-Init | 4.00 |
| Base-AE | 5.00 |

### Pairwise Full-vs-Ablation Check

The table below reports `COVE-AE` minus comparator mean fitness; negative values favor full `COVE-AE`.

| Scene | Comparator | FullMean | ComparatorMean | FullWins | FullLosses | SignrankP |
|---:|---|---:|---:|---:|---:|---:|
| 1 | COVE-AE-w/o-Init | 307.57 | 319.63 | 26 | 4 | 1.64e-05 |
| 1 | COVE-AE-w/o-Feedback | 307.57 | 308.00 | 17 | 13 | 0.544 |
| 1 | COVE-AE-w/o-RepairReuse | 307.57 | 308.81 | 19 | 11 | 0.111 |
| 2 | COVE-AE-w/o-Init | 329.04 | 346.39 | 9 | 21 | 0.254 |
| 2 | COVE-AE-w/o-Feedback | 329.04 | 325.26 | 12 | 18 | 0.192 |
| 2 | COVE-AE-w/o-RepairReuse | 329.04 | 329.17 | 16 | 14 | 0.813 |
| 4 | COVE-AE-w/o-Init | 362.84 | 648.60 | 17 | 13 | 0.0387 |
| 4 | COVE-AE-w/o-Feedback | 362.84 | 360.50 | 14 | 16 | 0.766 |
| 4 | COVE-AE-w/o-RepairReuse | 362.84 | 371.48 | 20 | 10 | 0.0978 |

### Interpretation

- Constraint-state initialization is strongly supported:
  - Removing initialization greatly hurts Scene 4 feasibility (`1.000` to `0.567`) and first feasible iteration (`0.00` to `157.29`).
  - Removing initialization also worsens Scene 1 mean fitness significantly.
  - Scene 2 remains mostly feasible without initialization, but with worse mean and much larger variance.
- Violation feedback is not supported by the formal ablation:
  - `COVE-AE-w/o-Feedback` has the best average rank (`1.33`) and is faster than full `COVE-AE`.
  - Full `COVE-AE` is not significantly better than `COVE-AE-w/o-Feedback` in any scene.
  - Full `COVE-AE` is worse than `COVE-AE-w/o-Feedback` on Scene 2 and Scene 4 by mean best fitness.
- Sparse repair/reuse is mixed and not yet a strong standalone innovation:
  - Full `COVE-AE` is slightly better than `COVE-AE-w/o-RepairReuse` in mean fitness across all three scenes.
  - The paired test is not significant at `p < 0.05` in any scene, with only weak trends in Scene 1 and Scene 4.
  - Runtime overhead remains visible.
- Full `COVE-AE` does not currently have a defensible overall advantage:
  - It ranks first on Scene 1, second on Scene 2, and second on Scene 4.
  - Its average rank is worse than `COVE-AE-w/o-Feedback`.
  - The full configuration is slower than the most competitive ablation in all scenes.

### Decision

- The formal ablation does not support moving directly to main comparison.
- The current recommended full COVE-AE configuration should not be claimed as final.
- Next work should focus on reducing or redesigning the violation-feedback operator so it improves Scene 2/4 without harming quality or runtime, and on deciding whether sparse repair/reuse should be weakened, triggered less often, or reframed as a feasibility-efficiency support mechanism rather than a primary fitness improvement mechanism.

## 2026-06-13 Violation-Feedback Redesign Attempt

### Goal

- Try to repair the failed formal-ablation finding that `COVE-AE-w/o-Feedback` outperformed full `COVE-AE`.
- Keep constraint-state initialization intact.
- Avoid broad parameter sensitivity, main comparison, CEC, or map redesign.

### Attempt 1: Local State-Gated Feedback

- Changed feedback from population-wide dominant feedback to individual-level feedback based on each candidate's own `Cobs`, `Cnfz`, `Ccurv`, and `Calt`.
- Disabled hard-constraint feedback for already feasible individuals.
- Added state-gated low-frequency triggering:
  - formation only
  - preservation/refinement mostly disabled
  - low-probability recovery
- Reduced feedback strength, avoidance sample budget, hit count, and step limit.
- Reduced sparse repair overhead.
- Diagnostic result folder: `results_cove_ae_ablation_local_feedback_gate_small_20260613_222046`.

Key small diagnostic result:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanRuntime |
|---:|---|---:|---:|---:|
| 1 | COVE-AE-w/o-Feedback | 0.80 | 368.70 | 0.281 |
| 1 | COVE-AE | 1.00 | 310.32 | 0.297 |
| 2 | COVE-AE-w/o-Feedback | 0.80 | 526.33 | 0.266 |
| 2 | COVE-AE | 0.20 | 2706.90 | 0.268 |
| 4 | COVE-AE-w/o-Feedback | 1.00 | 398.54 | 0.247 |
| 4 | COVE-AE | 1.00 | 403.63 | 0.268 |

Interpretation:

- Local gating improved Scene 1 but severely damaged Scene 2.
- This is not acceptable because Scene 2 is the key dense-obstacle / narrow-corridor evidence case.

### Attempt 2: Accepted-Only Feedback Candidate

- Reworked feedback as a secondary candidate:
  - first generate and evaluate the normal no-feedback AE offspring;
  - generate a feedback-guided offspring only for near-feasible infeasible individuals when no feasible solution exists;
  - accept the feedback offspring only if it is Deb-better than the no-feedback offspring;
  - restore the RNG state after generating the feedback candidate to reduce random-stream side effects.
- Diagnostic result folder: `results_cove_ae_ablation_feedback_candidate_small_20260613_222427`.

Key small diagnostic result:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanRuntime |
|---:|---|---:|---:|---:|
| 1 | COVE-AE-w/o-Feedback | 0.80 | 368.70 | 0.280 |
| 1 | COVE-AE | 1.00 | 311.84 | 0.379 |
| 2 | COVE-AE-w/o-Feedback | 0.80 | 526.33 | 0.264 |
| 2 | COVE-AE | 0.60 | 1211.30 | 0.278 |
| 4 | COVE-AE-w/o-Feedback | 1.00 | 398.54 | 0.247 |
| 4 | COVE-AE | 1.00 | 399.82 | 0.258 |

Interpretation:

- Accepted-only feedback reduced the damage relative to Attempt 1, but full `COVE-AE` still failed to beat `COVE-AE-w/o-Feedback` in Scene 2.
- Because Scene 2 remains the main feedback-sensitive scene, this remains a serious mechanism problem.

### Stop Decision

- Do not run a full formal ablation for these attempted feedback revisions.
- Do not claim the current attempted feedback redesign as a new default.
- The current evidence indicates that the present sampled-avoidance feedback family is not robust enough; continuing to tune trigger probabilities and strengths is unlikely to satisfy the ablation target.
- Next serious redesign should avoid injecting a second stochastic structural operator into AE. More promising directions:
  - derive deterministic local control-point corrections directly from violated sampled path segments;
  - apply the correction only to the specific violated control points, not through the full AE operator;
  - treat feedback as a bounded feasibility projection with explicit before/after acceptance;
  - keep the base AE offspring path unchanged when the deterministic correction cannot reduce violation.

## 2026-06-13 Deterministic Feedback-Correction Trial

### Mechanism

- Implemented and tested a deterministic local violation-correction variant outside the stochastic AE operator.
- Full `COVE-AE` first generated the normal no-feedback AE offspring.
- If the offspring was infeasible, a deterministic local correction was built from its own violated sampled path points:
  - obstacle / NFZ: push the nearest interior control point out of the violated obstacle or cylinder;
  - curvature: smooth the nearest control point around the worst turning-angle violation;
  - altitude: pull the nearest control point toward the valid height band/reference height.
- The correction was evaluated once and accepted only if it was Deb-better than the uncorrected offspring.
- Sparse repair/reuse was also gated more tightly so it only supported the no-feasible phase.
- This trial was treated as experimental and was not accepted as a new default unless the ablation evidence supported it.

### Stepwise Checks

Scene 2 small check:

- Result folder: `results_cove_ae_det_feedback_scene2_small_20260613_223533`.
- `nRuns = 5`, `popSize = 10`, `maxIter = 30`.
- `COVE-AE-w/o-Feedback`: feasible rate `0.80`, mean best fitness `484.74`.
- `COVE-AE`: feasible rate `1.00`, mean best fitness `370.76`.
- Interpretation: passed the first Scene 2 smoke-scale check.

Scene 2 medium check:

- Result folder: `results_cove_ae_det_feedback_scene2_medium_20260613_223558`.
- `nRuns = 10`, `popSize = 30`, `maxIter = 100`.
- `COVE-AE-w/o-Feedback`: feasible rate `1.00`, mean best fitness `339.96`, runtime `2.52 s`.
- `COVE-AE`: feasible rate `1.00`, mean best fitness `323.50`, runtime `2.93 s`.
- Interpretation: passed the Scene 2 medium check; runtime ratio was about `1.16x`.

Three-scene medium check before repair gating:

- Result folder: `results_cove_ae_det_feedback_mid_ablation_20260613_223728`.
- `nRuns = 10`, `popSize = 30`, `maxIter = 150`.
- Average rank:
  - `COVE-AE-w/o-RepairReuse`: `1.67`
  - `COVE-AE`: `2.00`
  - `COVE-AE-w/o-Feedback`: `2.33`
- Interpretation: deterministic feedback improved the position relative to `w/o Feedback`, but full `COVE-AE` still lost to `w/o RepairReuse`.

Three-scene medium check after repair gating:

- Result folder: `results_cove_ae_det_feedback_repair_gated_mid_20260613_224843`.
- `nRuns = 10`, `popSize = 30`, `maxIter = 150`.
- Average rank:
  - `COVE-AE`: `1.67`
  - `COVE-AE-w/o-Feedback`: `2.00`
  - `COVE-AE-w/o-RepairReuse`: `2.33`
- Interpretation: passed the medium-scale gate and justified one formal ablation check.

### Formal Check

- Result folder: `results_cove_ae_det_feedback_formal_20260613_225758`.
- `nRuns = 30`, `popSize = 30`, `maxIter = 300`.
- Completed `450 / 450` run records.

Aggregate ranking:

| Algorithm | AverageRank |
|---|---:|
| COVE-AE-w/o-Feedback | 1.67 |
| COVE-AE | 2.00 |
| COVE-AE-w/o-RepairReuse | 2.33 |
| COVE-AE-w/o-Init | 4.00 |
| Base-AE | 5.00 |

Key scene results:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanRuntime |
|---:|---|---:|---:|---:|
| 1 | COVE-AE-w/o-Feedback | 1.00 | 307.01 | 6.29 |
| 1 | COVE-AE | 1.00 | 306.18 | 6.29 |
| 2 | COVE-AE-w/o-Feedback | 1.00 | 324.17 | 6.52 |
| 2 | COVE-AE | 1.00 | 325.23 | 6.55 |
| 4 | COVE-AE-w/o-Feedback | 1.00 | 363.43 | 6.59 |
| 4 | COVE-AE | 1.00 | 366.71 | 6.55 |

Pairwise full-vs-feedback:

| Scene | Comparator | FullMean | ComparatorMean | FullWins | FullLosses | SignrankP |
|---:|---|---:|---:|---:|---:|---:|
| 1 | COVE-AE-w/o-Feedback | 306.18 | 307.01 | 16 | 14 | 0.644 |
| 2 | COVE-AE-w/o-Feedback | 325.23 | 324.17 | 14 | 16 | 0.766 |
| 4 | COVE-AE-w/o-Feedback | 366.71 | 363.43 | 12 | 18 | 0.478 |

### Decision

- The deterministic correction design improved early and medium diagnostics but failed the formal ablation gate.
- Full `COVE-AE` did not regain overall advantage under formal settings; `COVE-AE-w/o-Feedback` still had the best average rank.
- Do not accept this deterministic feedback-correction implementation as the default COVE-AE mechanism.
- Do not proceed to main comparison from this configuration.
- Current evidence suggests that adding a post-offspring correction alone is insufficient; the paper strategy should either:
  - further redesign feedback around a clearer constraint-state transition benefit, or
  - demote violation feedback from a primary innovation point and rebuild the contribution structure around initialization, state transition, and efficiency-oriented sparse repair.
