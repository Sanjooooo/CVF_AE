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
