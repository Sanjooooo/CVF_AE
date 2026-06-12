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
