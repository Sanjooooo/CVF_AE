# CVF-AE Route B Project Log

## 2026-06-18 Small Gate Handoff Execution

Scope:

- Route: Route B / CVF-AE.
- Algorithm name: `CVF-AE = Constraint Viability Field guided Alpha Evolution`.
- Stop boundary: complete the small-scale gate and decide whether to enter the medium gate; do not run the medium gate.

### Phase 1: Mechanism Derivation

Added:

- `routes/route_b_cvf_ae/docs/CVF_MECHANISM_DERIVATION.md`

The derivation defines:

- control-point and sampled-path notation;
- sampled point to nearest interior control-point mapping;
- obstacle, no-fly-zone, wind-risk, altitude, curvature, and boundary field directions;
- field normalization and step clipping;
- state-adaptive `alpha_s`, `beta_s`, and `gamma_s` weights;
- CVF-AE candidate generation from AE and CVF directions;
- Deb-better acceptance for the CVF candidate and the population update;
- low-overhead complexity bounds and gate interpretation.

### Phase 2: Minimal Code Implementation

Added:

- `buildConstraintViabilityField.m`
- `applyOperator_CVF_AE.m`
- `optimizer_CVF_AE_uav.m`
- `run_cvf_ae_gate_diagnostics.m`

Updated:

- `getUAVAlgorithmConfig.m`
- `run_single_uav_algorithm_case.m`

Implementation notes:

- The prototype reuses `fitnessFAEAE`, `defaultParams`, `createMap`, `init_COVE_AE`, `identifyConstraintState`, `repairPath`, `debBetter`, `boundSolution`, `decodeSolution`, and `bsplinePath`.
- `CVF-AE` first evaluates the ordinary AE offspring.
- For sparse selected individuals, it builds a bounded CVF candidate and spends at most one additional fitness evaluation.
- The CVF candidate replaces the AE offspring only when it is Deb-better.
- New metrics include `viabilityFieldCount`, `viabilityFieldSuccessCount`, `viabilityFieldNormHistory`, `viabilityFieldTypeHistory`, `cvfOperatorHistory`, `nEvals`, runtime, first feasible iteration, and repair counts.

Verification:

- MATLAB Code Analyzer passed for the new CVF files.
- Analyzer reported only existing-style `datestr/now` informational notes in the new runner.
- A smoke run passed and wrote CSV, MAT, run records, and a decision markdown file. The temporary smoke result directory was removed after verification.

### Phase 3: Small-Scale Gate

Result directory:

- `routes/route_b_cvf_ae/results/cvf_ae_gate_20260618_084956`

Configuration:

- scenes: `[2, 4]`
- algorithms: `Base-AE`, `CVF-AE`, `CVF-AE-w/o-CVF`, `CVF-AE-w/o-Init`
- `nRuns = 5`
- `popSize = 20`
- `maxIter = 80`
- `baseSeed = 20260618`

Key aggregate results:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanCVFCount | MeanCVFSuccess |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | Base-AE | 0.20 | 2661.47 | 12.20 | 0.900 | 1620.0 | NaN | NaN | 0.0 | 0.0 |
| 2 | CVF-AE | 1.00 | 343.90 | 0.00 | 2.047 | 2133.4 | 19.6 | 113.4 | 400.0 | 262.4 |
| 2 | CVF-AE-w/o-CVF | 1.00 | 323.54 | 0.00 | 1.189 | 1703.6 | 16.2 | 83.6 | 0.0 | 0.0 |
| 2 | CVF-AE-w/o-Init | 0.60 | 1077.80 | 4.60 | 1.745 | 2047.4 | 37.0 | 27.4 | 400.0 | 257.4 |
| 4 | Base-AE | 0.00 | 1899.18 | 9.20 | 0.879 | 1620.0 | NaN | NaN | 0.0 | 0.0 |
| 4 | CVF-AE | 1.00 | 393.88 | 0.00 | 1.821 | 2059.4 | 0.0 | 39.4 | 400.0 | 173.2 |
| 4 | CVF-AE-w/o-CVF | 1.00 | 400.58 | 0.00 | 1.009 | 1650.2 | 0.0 | 30.2 | 0.0 | 0.0 |
| 4 | CVF-AE-w/o-Init | 0.00 | 1865.61 | 9.20 | 1.959 | 2094.0 | NaN | 74.0 | 400.0 | 266.8 |

Average rank:

| Algorithm | AverageRank |
|---|---:|
| CVF-AE | 1.5 |
| CVF-AE-w/o-CVF | 1.5 |
| CVF-AE-w/o-Init | 3.0 |
| Base-AE | 4.0 |

### Decision

Do not enter the medium gate yet.

Rationale:

- `CVF-AE` improves Scene 4 mean best fitness over `CVF-AE-w/o-CVF` (`393.88` vs `400.58`), with the same feasibility rate and first feasible iteration.
- `CVF-AE` is worse than `CVF-AE-w/o-CVF` on Scene 2 mean best fitness (`343.90` vs `323.54`) and first feasible iteration (`19.6` vs `16.2`).
- The CVF mechanism adds bounded but nontrivial overhead: evaluation ratios are about `1.25x`, while runtime ratios are about `1.72x` on Scene 2 and `1.80x` on Scene 4.
- Full `CVF-AE` and `CVF-AE-w/o-CVF` tie on average rank, so the current CVF field is not yet strong enough to justify medium validation.
- `CVF-AE-w/o-Init` is weak on Scene 4, confirming that initialization remains important, but that does not establish the CVF field contribution.

Next recommended work, if Route B continues:

- Reduce CVF trigger count or cache field components to lower runtime overhead.
- Rebalance CVF strength so Scene 2 does not lose quality or first feasible iteration relative to `w/o-CVF`.
- Re-run the same small gate only after the mechanism changes; do not proceed directly to medium gate from this result.

## 2026-06-18 Conservative CVF Revision Loop

Goal:

- Reduce the CVF runtime/evaluation overhead observed in the first small gate.
- Prevent CVF from degrading Scene 2 quality after feasibility formation.
- Re-run the same small gate only; do not run the medium gate in this step.

### Mechanism Changes

Updated:

- `optimizer_CVF_AE_uav.m`
- `buildConstraintViabilityField.m`
- `applyOperator_CVF_AE.m`

Changes:

- Reduced the per-iteration CVF trigger budget from `25%` to `12%` of the population.
- Reduced the CVF step strength and clipping bounds:
  - `strength: 0.85 -> 0.65`
  - `maxStepRatio: 0.055 -> 0.040`
  - `maxNormRatio: 0.12 -> 0.085`
- Reduced state-adaptive CVF fusion weights:
  - formation `beta_s: 1.00 -> 0.55`
  - preservation `beta_s: 0.70 -> 0.45`
  - refinement `beta_s: 0.25 -> 0.12`
  - recovery `beta_s: 0.55 -> 0.35`
- Restricted formation-state CVF to near-feasible candidates instead of all rank-eligible candidates.
- Reduced the near-feasible threshold from `V <= 25` to `V <= 15`.
- Added a stricter CVF candidate acceptance rule:
  - CVF candidate must be Deb-better than the AE candidate;
  - and its total fitness must not be worse than the AE candidate.

### Iteration Notes

- First conservative run reduced CVF count from about `400` to `160` per run and lowered overhead, but Scene 2 remained worse than `w/o-CVF`.
- A near-feasible-only trigger reduced some unnecessary CVF activity but still did not give a stable enough result.
- The strict acceptance rule produced the best balance in this loop and was kept as the current Route B prototype.

Intermediate temporary result folders were removed after review. The final retained result folder is:

- `routes/route_b_cvf_ae/results/cvf_ae_gate_strict_accept_20260618_085923`

### Final Small-Gate Recheck

Configuration:

- scenes: `[2, 4]`
- algorithms: `Base-AE`, `CVF-AE`, `CVF-AE-w/o-CVF`, `CVF-AE-w/o-Init`
- `nRuns = 5`
- `popSize = 20`
- `maxIter = 80`
- `baseSeed = 20260618`

Key aggregate results:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanCVFCount | MeanCVFSuccess |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | Base-AE | 0.20 | 2661.47 | 12.20 | 0.851 | 1620.0 | NaN | NaN | 0.0 | 0.0 |
| 2 | CVF-AE | 1.00 | 331.60 | 0.00 | 1.469 | 1859.6 | 15.8 | 97.4 | 142.2 | 104.0 |
| 2 | CVF-AE-w/o-CVF | 1.00 | 323.54 | 0.00 | 1.155 | 1703.6 | 16.2 | 83.6 | 0.0 | 0.0 |
| 2 | CVF-AE-w/o-Init | 0.60 | 755.57 | 2.00 | 1.131 | 1730.8 | 41.67 | 31.0 | 79.8 | 61.0 |
| 4 | Base-AE | 0.00 | 1899.18 | 9.20 | 0.869 | 1620.0 | NaN | NaN | 0.0 | 0.0 |
| 4 | CVF-AE | 1.00 | 385.78 | 0.00 | 1.332 | 1814.0 | 0.0 | 34.0 | 160.0 | 80.8 |
| 4 | CVF-AE-w/o-CVF | 1.00 | 400.58 | 0.00 | 1.005 | 1650.2 | 0.0 | 30.2 | 0.0 | 0.0 |
| 4 | CVF-AE-w/o-Init | 0.20 | 1466.28 | 6.80 | 1.396 | 1804.4 | 51.0 | 76.0 | 108.4 | 90.8 |

Average rank:

| Algorithm | AverageRank |
|---|---:|
| CVF-AE | 1.5 |
| CVF-AE-w/o-CVF | 1.5 |
| CVF-AE-w/o-Init | 3.0 |
| Base-AE | 4.0 |

### Decision After Revision

The revised prototype is now acceptable for a medium-gate check, but the medium gate has not been run.

Rationale:

- CVF overhead is now controlled:
  - Scene 2 evaluation ratio vs `w/o-CVF`: `1.092`
  - Scene 2 runtime ratio vs `w/o-CVF`: `1.271`
  - Scene 4 evaluation ratio vs `w/o-CVF`: `1.099`
  - Scene 4 runtime ratio vs `w/o-CVF`: `1.325`
- Scene 4 shows a clear mean-fitness improvement from CVF:
  - `CVF-AE`: `385.78`
  - `CVF-AE-w/o-CVF`: `400.58`
- Scene 2 still has a small mean-fitness disadvantage:
  - `CVF-AE`: `331.60`
  - `CVF-AE-w/o-CVF`: `323.54`
  - but first feasible iteration is slightly better for full CVF-AE (`15.8` vs `16.2`) and feasibility is tied.
- `CVF-AE-w/o-Init` remains weak, especially on Scene 4, confirming that initialization is still necessary.

Recommended next action:

- Run the medium gate exactly once with the planned medium configuration.
- Treat the medium gate as a risk check, not as a guaranteed pass: if `w/o-CVF` dominates full `CVF-AE` across Scene 2 and Scene 4, stop and redesign the field again rather than proceeding to formal ablation.

## 2026-06-18 Medium Gate Validation

Goal:

- Run one medium-gate validation after the strict-accept small gate.
- Stop after deciding whether the current `CVF-AE` prototype is ready for formal experiments.
- Do not run formal ablation, main comparison, parameter sensitivity, or CEC.

Implementation updates before running:

- Added `CVF-AE-w/o-StateAdaptiveCVF` to the Route B gate runner.
  - This variant keeps initialization, CVF, and sparse preservation.
  - It replaces the state-adaptive CVF state with a static preservation state.
- Added `CVF-AE-w/o-SparsePreservation`.
  - This variant keeps initialization and CVF.
  - It disables sparse repair / preservation.
- Added medium-gate decision mode to `run_cvf_ae_gate_diagnostics.m`.

Verification:

- MATLAB Code Analyzer passed for `optimizer_CVF_AE_uav.m`.
- MATLAB Code Analyzer passed for `run_cvf_ae_gate_diagnostics.m` except existing-style informational `datestr/now` notes.
- A short medium-gate smoke run passed for all six algorithm names. The smoke result directory was removed.

Execution note:

- The first MATLAB MCP call timed out after writing partial run records.
- The same result directory was resumed with `resumeExisting = true` through `matlab -batch`, completing all run records.

Result directory:

- `routes/route_b_cvf_ae/results/cvf_ae_medium_gate_20260618_090607`

Configuration:

- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- `nRuns = 10`
- `popSize = 30`
- `maxIter = 150`
- `baseSeed = 20260621`

Average rank:

| Algorithm | AverageRank |
|---|---:|
| CVF-AE | 1.67 |
| CVF-AE-w/o-StateAdaptiveCVF | 2.33 |
| CVF-AE-w/o-CVF | 2.33 |
| CVF-AE-w/o-SparsePreservation | 3.67 |
| CVF-AE-w/o-Init | 5.00 |
| Base-AE | 6.00 |

Key aggregate results:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanCVFCount | MeanCVFSuccess |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | Base-AE | 0.30 | 1068.50 | 3.00 | 2.345 | 4530.0 | NaN | NaN | 0.0 | 0.0 |
| 1 | CVF-AE-w/o-Init | 1.00 | 322.47 | 0.00 | 3.939 | 5323.7 | 18.7 | 213.5 | 580.2 | 416.2 |
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 1.00 | 301.78 | 0.00 | 4.073 | 5390.0 | 1.7 | 260.0 | 600.0 | 572.9 |
| 1 | CVF-AE-w/o-SparsePreservation | 1.00 | 307.71 | 0.00 | 3.333 | 5119.4 | 6.4 | 0.0 | 589.4 | 497.5 |
| 1 | CVF-AE-w/o-CVF | 1.00 | 306.07 | 0.00 | 3.122 | 4758.4 | 6.6 | 228.4 | 0.0 | 0.0 |
| 1 | CVF-AE | 1.00 | 306.62 | 0.00 | 6.214 | 5360.0 | 0.9 | 230.4 | 599.6 | 505.3 |
| 2 | Base-AE | 0.00 | 2481.90 | 12.40 | 4.238 | 4530.0 | NaN | NaN | 0.0 | 0.0 |
| 2 | CVF-AE-w/o-Init | 0.90 | 489.35 | 1.00 | 7.816 | 5076.3 | 46.0 | 133.8 | 412.5 | 291.0 |
| 2 | CVF-AE-w/o-StateAdaptiveCVF | 0.90 | 470.08 | 0.80 | 8.806 | 5197.9 | 34.67 | 204.6 | 463.3 | 347.9 |
| 2 | CVF-AE-w/o-SparsePreservation | 1.00 | 332.87 | 0.00 | 7.485 | 5083.9 | 26.2 | 0.0 | 553.9 | 422.3 |
| 2 | CVF-AE-w/o-CVF | 1.00 | 328.93 | 0.00 | 6.068 | 4698.7 | 35.1 | 168.7 | 0.0 | 0.0 |
| 2 | CVF-AE | 1.00 | 321.17 | 0.00 | 9.056 | 5261.5 | 28.0 | 201.0 | 530.5 | 398.2 |
| 4 | Base-AE | 0.00 | 1789.60 | 8.10 | 3.087 | 4530.0 | NaN | NaN | 0.0 | 0.0 |
| 4 | CVF-AE-w/o-Init | 0.50 | 771.68 | 2.40 | 6.391 | 5217.8 | 95.6 | 186.3 | 501.5 | 412.7 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 1.00 | 384.36 | 0.00 | 6.786 | 5197.7 | 0.0 | 67.7 | 600.0 | 259.6 |
| 4 | CVF-AE-w/o-SparsePreservation | 1.00 | 392.61 | 0.00 | 6.369 | 5130.0 | 0.0 | 0.0 | 600.0 | 303.0 |
| 4 | CVF-AE-w/o-CVF | 1.00 | 388.39 | 0.00 | 3.580 | 4615.5 | 0.0 | 85.5 | 0.0 | 0.0 |
| 4 | CVF-AE | 1.00 | 367.28 | 0.00 | 6.018 | 5224.6 | 0.0 | 94.6 | 600.0 | 296.0 |

### Medium-Gate Decision

Do not enter formal experiments yet.

Rationale:

- Positive evidence:
  - Full `CVF-AE` has the best average rank (`1.67`).
  - Full `CVF-AE` beats `CVF-AE-w/o-CVF` on Scene 2 and Scene 4 mean best fitness.
  - Full `CVF-AE` beats `CVF-AE-w/o-StateAdaptiveCVF` on Scene 2 and Scene 4 mean best fitness.
  - Full `CVF-AE` reaches full feasibility on all scenes.
- Remaining risks:
  - Scene 1 is not supportive: `w/o-StateAdaptiveCVF`, `w/o-CVF`, and `w/o-SparsePreservation` all have better mean fitness than full `CVF-AE`.
  - Runtime overhead is still too high for a low-overhead claim:
    - Scene 1 full vs `w/o-CVF` runtime ratio is about `1.99`.
    - Scene 2 full vs `w/o-CVF` runtime ratio is about `1.49`.
    - Scene 4 full vs `w/o-CVF` runtime ratio is about `1.68`.
  - CVF triggers are near the per-run cap (`~600`) in many medium runs, so the sparse-field design is not yet sparse enough at medium scale.

Recommended next action:

- Do not proceed to formal ablation/main comparison from this medium-gate result.
- Keep the full `CVF-AE` mechanism direction, because Scene 2/4 support exists.
- Before any formal experiment, reduce medium-scale CVF trigger frequency and runtime overhead, especially after feasibility is already established and in Scene 1-like easier states.

## 2026-06-18 CVF Sparse Trigger 2.0

Goal:

- Keep the Scene 2/4 benefit of CVF.
- Reduce medium-scale CVF trigger count and runtime overhead.
- Avoid unnecessary CVF intervention after feasible solutions have already formed.

Mechanism changes:

- Replaced the single CVF per-iteration trigger budget with state-specific budgets:
  - formation: `10%` of population;
  - preservation: `6%` of population;
  - refinement: `2%` of population;
  - recovery: `8%` of population.
- Added a post-feasible budget cap:
  - once the best solution is feasible, CVF is capped at `3%` of population per iteration.
- Added post-feasible throttling:
  - after feasibility is established, CVF can trigger only every `3` iterations.
- Added refinement throttling:
  - quality-refinement CVF can trigger only every `5` iterations.
- Added constraint-pressure gating:
  - CVF is used only for near-feasible infeasible candidates, high mean violation before feasibility, or low population feasibility after the first feasible solution.
- Feasible individuals in already stable populations no longer receive CVF.

Verification:

- MATLAB Code Analyzer passed for `optimizer_CVF_AE_uav.m`.
- `run_cvf_ae_gate_diagnostics.m` retained only existing-style informational `datestr/now` notes.
- A short six-algorithm smoke run passed and was removed.

Result directory:

- `routes/route_b_cvf_ae/results/cvf_ae_medium_gate_sparse2_20260618_095112`

Configuration:

- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- `nRuns = 10`
- `popSize = 30`
- `maxIter = 150`
- `baseSeed = 20260622`

Average rank:

| Algorithm | AverageRank |
|---|---:|
| CVF-AE | 1.67 |
| CVF-AE-w/o-SparsePreservation | 2.67 |
| CVF-AE-w/o-CVF | 2.67 |
| CVF-AE-w/o-StateAdaptiveCVF | 3.00 |
| CVF-AE-w/o-Init | 5.00 |
| Base-AE | 6.00 |

Key aggregate results:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanCVFCount | MeanCVFSuccess |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 1.00 | 302.51 | 4.696 | 4809.3 | 1.7 | 259.1 | 20.2 | 19.1 |
| 1 | CVF-AE-w/o-SparsePreservation | 1.00 | 308.59 | 3.878 | 4590.6 | 4.0 | 0.0 | 60.6 | 52.3 |
| 1 | CVF-AE-w/o-CVF | 1.00 | 306.89 | 3.806 | 4763.2 | 4.0 | 233.2 | 0.0 | 0.0 |
| 1 | CVF-AE | 1.00 | 306.92 | 3.575 | 4811.5 | 0.9 | 229.1 | 52.4 | 43.2 |
| 2 | CVF-AE-w/o-SparsePreservation | 1.00 | 329.03 | 2.985 | 4616.3 | 28.1 | 0.0 | 86.3 | 70.6 |
| 2 | CVF-AE-w/o-CVF | 1.00 | 329.68 | 3.397 | 4697.1 | 36.8 | 167.1 | 0.0 | 0.0 |
| 2 | CVF-AE | 1.00 | 322.14 | 3.774 | 4817.7 | 30.1 | 197.1 | 90.6 | 71.0 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 1.00 | 387.45 | 3.232 | 4628.3 | 0.0 | 64.1 | 34.2 | 21.9 |
| 4 | CVF-AE-w/o-SparsePreservation | 1.00 | 379.96 | 2.879 | 4568.0 | 0.0 | 0.0 | 38.0 | 25.5 |
| 4 | CVF-AE-w/o-CVF | 1.00 | 382.54 | 3.180 | 4616.6 | 0.0 | 86.6 | 0.0 | 0.0 |
| 4 | CVF-AE | 1.00 | 365.31 | 3.338 | 4665.5 | 0.0 | 91.7 | 43.8 | 29.4 |

### Sparse 2.0 Decision

The sparse trigger adjustment passed the medium gate.

Rationale:

- CVF trigger count dropped sharply:
  - Scene 1 full `CVF-AE`: `52.4`
  - Scene 2 full `CVF-AE`: `90.6`
  - Scene 4 full `CVF-AE`: `43.8`
  - Previous medium gate had full `CVF-AE` near `600` in all scenes.
- Runtime overhead is now controlled:
  - Scene 1 full runtime is slightly lower than `w/o-CVF` in this run (`3.575` vs `3.806`).
  - Scene 2 full vs `w/o-CVF` runtime ratio is about `1.11`.
  - Scene 4 full vs `w/o-CVF` runtime ratio is about `1.05`.
- Scene 2 and Scene 4 still support the CVF mechanism:
  - Scene 2 mean fitness: full `322.14` vs `w/o-CVF` `329.68`.
  - Scene 4 mean fitness: full `365.31` vs `w/o-CVF` `382.54`.
- Full `CVF-AE` keeps the best average rank (`1.67`).

Remaining caveat:

- Scene 1 still favors `w/o-StateAdaptiveCVF` by mean best fitness (`302.51` vs full `306.92`), so formal experiments should track whether the state-adaptive CVF schedule is mainly beneficial in harder constrained scenes rather than easy scenes.

Recommended next action:

- It is now reasonable to proceed to formal ablation planning.
- Do not change the map or restore Scene 3.
- Before running formal ablation, freeze the Sparse 2.0 CVF defaults and document that the CVF contribution is expected to matter most in Scene 2/4-style constrained environments.

## 2026-06-18 Sparse 2.0 Freeze And Formal Ablation Runner

Goal:

- Freeze Sparse 2.0 defaults before formal ablation.
- Add a stable formal ablation runner with resume support.
- Do not change the algorithm parameters during formal ablation.

Added:

- `routes/route_b_cvf_ae/docs/CVF_AE_SPARSE2_DEFAULTS.md`
- `run_cvf_ae_formal_ablation.m`

Frozen formal ablation configuration:

- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- default `nRuns = 30`
- default `popSize = 30`
- default `maxIter = 300`
- default `baseSeed = 20260623`

Runner notes:

- `run_cvf_ae_formal_ablation.m` delegates to `run_cvf_ae_gate_diagnostics.m`.
- It preserves per-run `run_records`.
- It supports `resumeExisting = true`.
- It writes an additional `CVF_AE_FORMAL_ABLATION_README.md` into the result folder.
- The existing summary CSV/MAT outputs remain the primary analysis artifacts.

Formal ablation must report runtime, `nEvals`, repair count, and CVF count in addition to fitness and feasibility.

## 2026-06-18 Formal Ablation Completed

Result folder:

- `routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_20260618_102649`

Configuration:

- scenes: `[1, 2, 4]`
- algorithms: `Base-AE`, `CVF-AE-w/o-Init`, `CVF-AE-w/o-StateAdaptiveCVF`, `CVF-AE-w/o-SparsePreservation`, `CVF-AE-w/o-CVF`, `CVF-AE`
- runs: `30` per algorithm per scene
- population size: `30`
- max iterations: `300`
- base seed: `20260623`

Completion:

- completed runs: `540 / 540`
- saved summary CSV, run CSV, average-rank CSV, decision markdown, and formal interpretation markdown
- preserved per-run `.mat` records under the ignored `run_records/` directory
- left the large `cvf_ae_gate_summary_workspace.mat` as a local generated artifact rather than a versioned text result

Average rank:

| Algorithm | Average rank |
|---|---:|
| `CVF-AE` | 1.67 |
| `CVF-AE-w/o-CVF` | 2.00 |
| `CVF-AE-w/o-StateAdaptiveCVF` | 3.00 |
| `CVF-AE-w/o-SparsePreservation` | 3.67 |
| `CVF-AE-w/o-Init` | 4.67 |
| `Base-AE` | 6.00 |

Interpretation:

- Full `CVF-AE` has the best aggregate rank and reaches `100%` feasible rate on Scenes 1, 2, and 4.
- `Base-AE` remains inadequate under stronger constraints, with `0%` feasible rate on Scenes 2 and 4.
- CVF-guided sparse preservation is supported: full `CVF-AE` is better than `CVF-AE-w/o-SparsePreservation` on all three scenes.
- Initialization remains important, especially on Scene 4 where `CVF-AE-w/o-Init` falls to `66.67%` feasible rate.
- The direct CVF field contribution is scene-dependent: full `CVF-AE` beats `w/o-CVF` on Scenes 1 and 4, while `w/o-CVF` has better mean fitness on Scene 2.

Decision:

- Proceed beyond formal ablation to main comparison planning.
- Keep Sparse 2.0 defaults frozen for the next stage.
- Do not change Scene 4, restore Scene 3, or introduce Route A comparisons.
- The manuscript claim should be conservative: CVF-AE improves aggregate feasibility/search quality with strongest evidence in harder constrained scenes, but CVF guidance should not be described as a monotonic win on every scene.

## 2026-06-22 主对比方案与 baseline 接入

目标：

- 冻结当前 `CVF-AE` 配置后进入主对比准备；
- 主对比适当包含经典算法、高被引算法、近年来算法和变体算法；
- 保证复现算法不是占位实现，而是具有完整更新机制、统一评价接口和统一统计输出。

新增方案文档：

- `routes/route_b_cvf_ae/docs/CVF_AE_MAIN_COMPARISON_PROTOCOL.md`

主排名组：

- `CVF-AE`
- `AE`
- `PSO`
- `GWO`
- `WOA`
- `HHO`
- `DBO`
- `CPO`

工程参考组暂不混入主排名：

- `A*`
- `RRT*`

实现动作：

- 新增 `optimizer_DBO_uav.m`
- 新增 `optimizer_CPO_uav.m`
- 扩展 `getUAVAlgorithmConfig.m`
- 扩展 `run_single_uav_algorithm_case.m`
- 扩展 `run_uav_comparison_lite_v2_batch.m`
- 新增 Route B 专用入口 `run_cvf_ae_main_comparison.m`

执行原则：

- 主对比不继续调整 `CVF-AE` 参数；
- 不恢复 code Scene 3；
- 不修改 Scene 4；
- CEC 暂作为后续可选补充，不进入当前主线。

预检执行：

- smoke: `run_cvf_ae_main_comparison('smoke')`，接口通过；
- precheck: `run_cvf_ae_main_comparison('precheck')`；
- result folder: `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_precheck_20260622_101130`；
- completed runs: `72 / 72`。

预检平均排名：

| Algorithm | Average rank |
|---|---:|
| `CVF-AE` | 1.33 |
| `CPO` | 2.00 |
| `DBO` | 3.00 |
| `GWO` | 5.00 |
| `WOA` | 5.00 |
| `HHO` | 6.00 |
| `PSO` | 6.33 |
| `AE` | 7.33 |

预检判断：

- 主对比预检通过，可以进入正式主对比；
- `CPO` 在 Scene 2 表现很强，正式实验需要重点观察；
- `DBO` 在 Scene 4 是强竞争 baseline；
- 当前结果只用于链路验证，不作为论文正式结论；
- 不因预检继续调整 `CVF-AE` 参数。

## 2026-06-22 正式主对比断点续跑机制

目标：

- 正式主对比运行时间较长，必须避免中断后从头开始；
- 每个 `(scene, algorithm, run)` 都应有独立断点记录；
- 重新运行时自动加载已完成 run，只补算缺失 run。

实现：

- `run_uav_comparison_lite_v2_batch.m` 在每个 run 前检查 `run_records/*.mat`；
- 当 `cfg.resumeExisting = true` 且记录存在时，直接加载 `result` 并参与汇总；
- 当记录不存在时，才调用对应 optimizer；
- `run_cvf_ae_main_comparison.m` 新增 `resume-formal` 模式；
- `resume-formal` 会自动寻找最新的 `cvf_ae_main_comparison_formal_*` 目录继续运行。

正式主对比命令：

```matlab
run_cvf_ae_main_comparison('formal')
```

中断续跑命令：

```matlab
run_cvf_ae_main_comparison('resume-formal')
```

## 2026-06-22 正式主对比完成

结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_20260622_103121`

配置：

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- runs: `30` per algorithm per scene
- population size: `30`
- max iterations: `300`
- base seed: `20260624`

完成情况：

- completed runs: `720 / 720`
- 每个 run 已保存到 `run_records/`
- 已保存 `uav_comparison_runs.csv`
- 已保存 `uav_comparison_summary_long.csv`
- 已保存 `uav_comparison_average_rank.csv`
- 已新增中文解释文档 `CVF_AE_MAIN_COMPARISON_INTERPRETATION.md`

平均排名：

| Algorithm | Average rank |
|---|---:|
| `CVF-AE` | 1.67 |
| `CPO` | 1.67 |
| `DBO` | 3.00 |
| `GWO` | 3.67 |
| `HHO` | 5.33 |
| `PSO` | 5.67 |
| `WOA` | 7.00 |
| `AE` | 8.00 |

分场景判断：

- Scene 1: `CPO` rank 1，`CVF-AE` rank 2；
- Scene 2: `CPO` rank 1，`CVF-AE` rank 2；
- Scene 4: `CVF-AE` rank 1，`DBO` rank 2，`CPO` rank 3；
- `CVF-AE` 在三场景均达到 `100%` feasible rate；
- `CPO` 是当前最强外部 baseline，必须在论文中正面讨论。

阶段判断：

- 正式主对比完成；
- `CVF-AE` 与 `CPO` 并列平均排名第一，主方法仍成立；
- 不能声称 `CVF-AE` 全面击败所有近年算法；
- 后续应进入统计检验、表格生成、收敛曲线、箱线图和路径可视化阶段；
- 不建议为了超过 `CPO` 继续调参。

## 2026-06-22 轨迹合理性审查

动机：

- 主对比不能只看 `fitness`、`feasible rate` 和平均排名；
- 对低空 UAV 路径规划而言，高空绕行和贴边绕行即使数值可行，也可能不符合任务语义；
- 用户明确提出需要检查轨迹图，避免“完全从高空或者边上绕行”的结果被误判为有效优势。

新增脚本：

- `analyze_cvf_ae_trajectory_sanity.m`

输出文件：

- `trajectory_sanity_runs.csv`
- `trajectory_sanity_summary.csv`
- `trajectory_sanity_flags.csv`
- `CVF_AE_TRAJECTORY_SANITY_INTERPRETATION.md`

关键发现：

- `CVF-AE` 没有明显高空绕行：
  - Scene 1 `MeanZ = 14.95`
  - Scene 2 `MeanZ = 15.96`
  - Scene 4 `MeanZ = 15.40`
- `CPO` 在 Scene 1/2 存在明显高空绕行风险：
  - Scene 1 `MeanZ = 26.12`
  - Scene 2 `MeanZ = 33.41`
  - Scene 2 `VeryHighAltitudeFrac = 0.76`
- `DBO/GWO` 在 Scene 4 存在明显贴边绕行倾向；
- 图像抽查显示 Scene 2 的 `CPO` 最佳轨迹抬高越障，Scene 4 的 `CPO` 最佳轨迹沿地图边界绕行。

结论修正：

- `CVF-AE` 与 `CPO` 数值平均排名并列第一；
- 但 `CPO` 的优势伴随高空绕行语义风险；
- `CVF-AE` 更符合低空巡航轨迹叙事；
- 后续论文应增加轨迹合理性表和代表性轨迹图；
- 不建议为了压过 `CPO` 继续调参。
## 2026-06-22 Scene 2-v2 中等难度场景调整与小规模验证

动机：
- 原 Scene 2 的轨迹图显示，多种算法容易靠近边缘、高空越障或绕开主通道；
- 这会让 Scene 2 更像“过紧约束场景”，不适合作为 Scene 1 和 Scene 4 之间的中等难度场景；
- 因此本轮不优先修改 Scene 4，而是先把 Scene 2 调整为中等约束走廊。

代码调整：
- `createMap.m`
  - Scene 2 从 dense obstacle scene 调整为 medium constrained corridor scene；
  - 建筑数量从 13 个降为 10 个；
  - 第一排建筑由 5 个改为 4 个，并扩大间距；
  - NFZ 从 3 个降为 2 个；
  - wind hotspots 从 4 个降为 3 个。
- `applyUAVSceneOverrides.m`
  - 单独为 Scene 2 设置高度范围 `[8, 32]`；
  - `heightRef` 和 `refCruiseZ` 设置为 `16`；
  - `params.weights.H` 设置为 `1.05`。

验证配置：
- scene: `2`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- runs: `5`
- population size: `20`
- max iterations: `80`
- base seed: `20260625`

结果目录：
- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_scene2_v2_sanity_20260622_130924`

关键结果：
- `CVF-AE`
  - feasible rate: `1.00`
  - mean best fitness: `303.26`
  - mean Z: `16.09`
  - mean high-altitude fraction: `0.00`
  - visual review flag rate: `0.00`
- `CPO`
  - feasible rate: `1.00`
  - mean best fitness: `296.27`
  - mean Z: `26.86`
  - mean high-altitude fraction: `0.74`
  - visual review flag rate: `0.80`
- `GWO` 和 `DBO` 在该场景仍有较明显贴边倾向；
- `WOA`, `PSO`, `HHO`, `AE` 的可行率或轨迹合理性仍不稳定。

轨迹判断：
- 新版 Scene 2 不再系统性迫使所有算法采用高空或边界绕行；
- `CVF-AE` 的最佳轨迹更接近低空通道搜索；
- `CPO` 的数值优势仍然存在，但主要伴随高空越障倾向；
- `GWO/DBO` 的贴边倾向能被轨迹 sanity 指标识别。

阶段判断：
- 保留 Scene 2-v2 作为新的中等难度场景；
- 不建议继续为了让 `CVF-AE` 在 Scene 2 数值 fitness 上超过 `CPO` 而调参；
- 下一步应冻结 Scene 2-v2，使用断点续跑机制重新执行正式主对比，并在论文叙事中同时报告 fitness、feasible rate 和轨迹合理性指标。
## 2026-06-22 Scene 2-v2 正式主对比与合并结果

执行策略：
- 冻结 Scene 2-v2；
- 只对 Scene 2-v2 重新运行正式主对比；
- Scene 1 和 Scene 4 沿用旧正式主对比结果；
- 原因是本轮只修改了 Scene 2，其他两个场景的地图与参数未变。

Scene 2-v2 正式结果目录：
- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_scene2_v2_formal_20260622_152052`

Scene 2-v2 配置：
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260624`
- resume: enabled

完成情况：
- run records: `240 / 240`
- 已生成 `uav_comparison_runs.csv`
- 已生成 `uav_comparison_summary_long.csv`
- 已生成 `uav_comparison_average_rank.csv`
- 已生成 `trajectory_sanity_runs.csv`
- 已生成 `trajectory_sanity_summary.csv`
- 已生成 `trajectory_sanity_flags.csv`
- 已生成最佳轨迹图到本地 `best_path_figures_exact/`

Scene 2-v2 raw fitness 排名：
- `CPO`: rank 1, mean fitness `278.94`, feasible rate `1.00`
- `CVF-AE`: rank 2, mean fitness `302.75`, feasible rate `1.00`
- `DBO`: rank 3, mean fitness `337.29`, feasible rate `1.00`
- `GWO`: rank 4, mean fitness `342.91`, feasible rate `1.00`

Scene 2-v2 轨迹 sanity 关键指标：
- `CVF-AE`
  - MeanZ: `15.99`
  - MeanHighAltitudeFrac: `0.00`
  - VisualReviewFlagRate: `0.00`
- `CPO`
  - MeanZ: `28.22`
  - MeanHighAltitudeFrac: `0.88`
  - VisualReviewFlagRate: `1.00`

解释：
- `CPO` 是强 baseline，应该保留在主表；
- 但 `CPO` 在 Scene 2-v2 的数值优势伴随明显 high-altitude bypass risk；
- `CVF-AE` 的优势应表述为更符合 low-altitude mission-consistent trajectory quality，而不是单纯宣称 raw fitness 全面最优。

合并结果目录：
- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_scene2_v2_merged_20260622_155500`

合并规则：
- Scene 1: 沿用 `cvf_ae_main_comparison_formal_20260622_103121`
- Scene 2: 使用 `cvf_ae_main_comparison_scene2_v2_formal_20260622_152052`
- Scene 4: 沿用 `cvf_ae_main_comparison_formal_20260622_103121`

合并后的平均排名：
- `CPO`: `1.67`
- `CVF-AE`: `1.67`
- `DBO`: `3.00`
- `GWO`: `3.67`
- `HHO`: `5.33`
- `PSO`: `5.67`
- `WOA`: `7.00`
- `AE`: `8.00`

阶段判断：
- Scene 2-v2 正式主对比完成；
- 合并后的主结果仍支持 `CVF-AE` 与 `CPO` 并列第一；
- 后续论文结果部分应采用合并结果目录作为主结果源；
- 不建议继续调整 Scene 2 或继续为了压过 `CPO` 做针对性调参。
## 2026-06-22 CVF-AE 正式消融实验

实验目的：
- 验证 CVF-AE 各机制对 fitness、feasibility、CVF 使用情况和轨迹合理性的贡献；
- 重点检查 `CVF`、constraint-aware initialization、state-adaptive CVF weighting 和 sparse preservation 是否都有稳定正贡献。

结果目录：
- `routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_scene2_v2_20260622_163919`

配置：
- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260626`
- resume: enabled

完成情况：
- run records: `540 / 540`
- 已生成 `cvf_ae_gate_runs.csv`
- 已生成 `cvf_ae_gate_summary.csv`
- 已生成 `cvf_ae_gate_average_rank.csv`
- 已生成 `trajectory_sanity_runs.csv`
- 已生成 `trajectory_sanity_summary.csv`
- 已生成 `trajectory_sanity_flags.csv`
- 已新增中文解释文件 `CVF_AE_FORMAL_ABLATION_INTERPRETATION.md`

执行备注：
- 第一次长 batch 在写入 `cvf_ae_gate_summary_workspace.mat` 时出现技术错误：`Unable to write file ... because it appears to be corrupt`；
- 该错误发生在 540 个 run records 和 CSV 汇总已写出之后；
- 删除 0 字节损坏 MAT 文件并用 `resumeExisting=true` 重新构建汇总后，runner 正常完成；
- 该错误不影响 run records、CSV 和本次结果判断。

平均排名：
- `CVF-AE-w/o-StateAdaptiveCVF`: `1.67`
- `CVF-AE`: `2.00`
- `CVF-AE-w/o-CVF`: `3.00`
- `CVF-AE-w/o-SparsePreservation`: `3.33`
- `CVF-AE-w/o-Init`: `5.00`
- `Base-AE`: `6.00`

关键发现：
- Constraint-aware initialization 是必要机制：
  - `w/o-Init` 在 Scene 4 可行率降至 `0.67`，mean fitness 从 full `CVF-AE` 的 `349.34` 恶化到 `587.23`。
- CVF 在强约束 Scene 4 中有正贡献：
  - full `CVF-AE`: `349.34`
  - `w/o-CVF`: `355.41`
- Sparse preservation 有必要保留：
  - `w/o-SparsePreservation` 在 Scene 4 为 `369.71`，且 trajectory visual risk 更高。
- `StateAdaptiveCVF` 当前不是稳定正贡献：
  - `w/o-StateAdaptiveCVF` 在 Scene 1 和 Scene 2-v2 的 scalar fitness 均优于 full；
  - 平均排名 `w/o-StateAdaptiveCVF = 1.67`，full `CVF-AE = 2.00`；
  - 论文中不应把 state-adaptive weighting 作为核心创新强讲。

轨迹 sanity：
- full `CVF-AE` 三个场景均无 high-altitude bypass；
- Scene 4 中 full `CVF-AE` 的 `VisualReviewFlagRate = 0.27`，低于 `w/o-StateAdaptiveCVF = 0.50` 和 `w/o-SparsePreservation = 0.53`；
- 这支持“完整版本在强约束场景中更稳定”的叙事。

阶段判断：
- 正式消融实验完成；
- 结果支持 initialization、CVF、sparse preservation 的必要性；
- 结果不支持把 state-adaptive weighting 写成全场景稳定增益；
- 下一步建议做统计检验，并考虑对 `StateAdaptiveCVF` 做小规模机制修正或在论文中弱化该模块。

## 2026-06-22 保守状态自适应 CVF 机制修正

目标：

- 针对正式消融中 `CVF-AE-w/o-StateAdaptiveCVF` 反超完整 `CVF-AE` 的问题，检查 `StateAdaptiveCVF` 是否可以通过保守化调整获得稳定正贡献；
- 不继续扩大正式实验规模，先做小规模机制验证；
- 技术性报错和命令仍保留英文，工作记录使用中文。

代码调整：

- 在 `optimizer_CVF_AE_uav.m` 中新增保守状态自适应记忆与状态判定；
- 在 `applyOperator_CVF_AE.m` 中降低 conservative state 下的 CVF 权重；
- 在 `run_cvf_ae_gate_diagnostics.m` 和 `getUAVAlgorithmConfig.m` 中新增 `CVF-AE-SA-lite`；
- 小规模验证通过后，已将保守状态自适应策略提升为默认 `CVF-AE` 配置；
- `CVF-AE-w/o-StateAdaptiveCVF` 保持为静态 CVF 消融入口。

小规模验证：

- 结果目录：`routes/route_b_cvf_ae/results/cvf_ae_sa_lite_validation_20260622_193237`
- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE-SA-lite`, `CVF-AE-w/o-StateAdaptiveCVF`, old `CVF-AE`
- runs: `10`
- population size: `30`
- max iterations: `300`
- base seed: `20260627`

结果：

- 平均排名：
  - `CVF-AE-SA-lite`: `1.00`
  - `CVF-AE-w/o-StateAdaptiveCVF`: `2.33`
  - old `CVF-AE`: `2.67`
- 三个场景中 `CVF-AE-SA-lite` feasible rate 均为 `1.00`；
- `CVF-AE-SA-lite` 未出现 high-altitude bypass；
- Scene 4 中 `CVF-AE-SA-lite` 的 trajectory sanity 风险低于静态 CVF，但略高于旧 full CVF-AE，因此后续正式结果仍需保留轨迹图人工 sanity check。

判断：

- 保守状态自适应策略可以作为新的默认 `CVF-AE` 实现；
- 旧版激进状态自适应不再作为论文主方法；
- 后续正式主对比和正式消融需要基于新的默认 `CVF-AE` 重新生成，不能直接沿用旧版完整 `CVF-AE` 的最终表格；
- 下一阶段建议先重跑正式消融，再视结果决定是否重跑正式主对比的全部场景或只重跑 `CVF-AE` 行。

## 2026-06-22 保守状态自适应 CVF 正式消融重跑

目标：

- 使用新的默认 `CVF-AE` 重新跑正式消融；
- 验证保守状态自适应 CVF、CVF 本体、约束感知初始化和稀疏保留是否均有正贡献；
- 同步生成 trajectory sanity，避免只看 scalar fitness。

结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_conservative_20260622_194947`

配置：

- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260629`
- resume: enabled

执行情况：

- run records: `540 / 540`
- 已生成正式消融 summary、average rank、decision 和 trajectory sanity；
- 第一次前台 batch 因工具 2 小时超时中断在 Scene 4 附近，随后使用同一结果目录和 `resumeExisting=true` 续跑完成；
- 中断前已保存的 run records 被成功复用，最终结果完整。

平均排名：

- `CVF-AE`: `1.00`
- `CVF-AE-w/o-StateAdaptiveCVF`: `2.33`
- `CVF-AE-w/o-CVF`: `3.00`
- `CVF-AE-w/o-SparsePreservation`: `3.67`
- `CVF-AE-w/o-Init`: `5.00`
- `Base-AE`: `6.00`

关键结论：

- 新默认 `CVF-AE` 在 Scene 1、Scene 2-v2、Scene 4 均优于 `CVF-AE-w/o-StateAdaptiveCVF`，说明保守状态自适应 CVF 已经从诊断阶段的负/不稳定贡献调整为稳定正贡献；
- 新默认 `CVF-AE` 在三个场景中均优于 `CVF-AE-w/o-CVF`，说明 CVF 本体保留为核心机制是合理的；
- `w/o-Init` 在 Scene 4 feasible rate 降至 `0.70`，说明约束感知初始化仍是强约束场景必要模块；
- `w/o-SparsePreservation` 在三个场景中均弱于完整方法，Scene 4 的 trajectory risk 也更高，说明稀疏保留应继续保留。

轨迹 sanity：

- 完整 `CVF-AE` 三个场景 feasible rate 均为 `1.00`；
- 完整 `CVF-AE` 三个场景 mean high-altitude fraction 均为 `0`；
- Scene 1 和 Scene 2-v2 的 `VisualReviewFlagRate = 0`；
- Scene 4 的 `VisualReviewFlagRate = 0.20`，低于 `w/o-CVF = 0.30`、`w/o-StateAdaptiveCVF = 0.533`、`w/o-SparsePreservation = 0.60`。

阶段判断：

- 保守状态自适应正式消融通过；
- 本目录应作为论文正式消融结果来源；
- 下一步应基于新的默认 `CVF-AE` 处理正式主对比结果，优先级高于继续调参。

## 2026-06-23 保守状态自适应 CVF 正式主对比重跑

目标：

- 基于新的默认 `CVF-AE` 重新跑正式主对比；
- 全量重跑 baseline 和 `CVF-AE`，避免不同 seed 或不同实现版本混合造成解释成本；
- 同步生成 trajectory sanity，用于识别 high-altitude bypass 和 boundary-hugging 风险。

结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`

配置：

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260630`
- resume: enabled

执行情况：

- run records: `720 / 720`
- 已生成主对比 summary、average rank 和 trajectory sanity；
- 执行中个别 baseline run 出现长时间无新 run record 且 MATLAB CPU 基本不增长的停滞；
- 已通过同一结果目录和 `resumeExisting=true` 断点续跑完成；
- 已完成的 run records 均被成功复用。

平均排名：

- `CVF-AE`: `1.33`
- `CPO`: `2.00`
- `DBO`: `2.67`
- `GWO`: `4.00`
- `HHO`: `5.33`
- `PSO`: `5.67`
- `WOA`: `7.00`
- `AE`: `8.00`

分场景判断：

- Scene 1：`CVF-AE` raw fitness rank 1，`CPO` rank 2；
- Scene 2-v2：`CPO` raw fitness rank 1，`CVF-AE` rank 2；
- Scene 4：`CVF-AE` raw fitness rank 1，`DBO` rank 2，`CPO` rank 3。

轨迹 sanity：

- `CVF-AE` 在 Scene 1 和 Scene 2-v2 的 `VisualReviewFlagRate = 0`；
- `CVF-AE` 在 Scene 4 的 `VisualReviewFlagRate = 0.20`；
- `CVF-AE` 三个场景 feasible rate 均为 `1.00`；
- `CPO` 在 Scene 2-v2 的 raw fitness 最优，但 mean high-altitude fraction 为 `0.882`，`VisualReviewFlagRate = 1.00`；
- `CPO` 在 Scene 1 也存在明显 high-altitude bypass 风险，mean high-altitude fraction 为 `0.663`，`VisualReviewFlagRate = 0.80`；
- 因此主表中可以保留 `CPO`，但论文解释必须配套 trajectory sanity，不能把 `CPO` 的低 scalar fitness 解释为低空任务一致性更优。

阶段判断：

- 保守状态自适应默认 `CVF-AE` 的正式主对比通过；
- 本目录应作为论文正式主对比结果来源；
- 下一步建议生成论文主表、主对比轨迹图和 trajectory sanity 辅助表。

## 2026-06-23 冻结主方法版本说明

阶段目标：

- 冻结路线 B 当前默认主方法，避免后续参数敏感性实验演变成反复调参；
- 明确后续实验只验证鲁棒性，除非出现全面、稳定、显著优于默认版本的参数设置，否则不再反向修改主方法。

新增文档：

- `routes/route_b_cvf_ae/docs/CVF_AE_CONSERVATIVE_FREEZE_NOTE.md`

冻结结论：

- 当前默认主方法为 `CVF-AE = Constraint Viability Field guided Alpha Evolution`；
- 默认实现为“保守状态自适应 CVF 调度版本的 CVF-AE”；
- 保留约束感知初始化、保守状态自适应 CVF 调度和稀疏可行性保持；
- 旧版激进状态自适应结果只作为诊断历史，不作为论文正式主方法。

冻结依据：

- 正式消融目录：`routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_conservative_20260622_194947`；
- 正式主对比目录：`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`；
- 正式消融中完整 `CVF-AE` 平均排名 `1.00`；
- 正式主对比中完整 `CVF-AE` 平均排名 `1.33`；
- `CVF-AE` 三个正式主对比场景 feasible rate 均为 `1.00`，且 Scene 1 / Scene 2-v2 轨迹 sanity 无人工复核风险。

后续边界：

- 参数敏感性只用于验证默认参数鲁棒性；
- 默认参数不要求每项第一，但应处于稳定前列；
- 只有参数变体在关键场景中全面、稳定、显著优于默认，并且不增加明显开销或轨迹 sanity 风险，才考虑重新打开主方法冻结；
- 不继续为了压过 Scene 2-v2 中 `CPO` 的 raw fitness 而修改主方法。

## 2026-06-23 运行开销分析

阶段目标：

- 复用现有正式主对比和正式消融结果，生成 `runtime`、`nEvals`、`viabilityFieldCount`、`viabilityFieldSuccessCount` 及相对 `w/o-CVF` 的开销比例；
- 支撑“低开销 CVF-AE”的论文表述；
- 不重跑任何优化实验。

新增脚本：

- `analyze_cvf_ae_runtime_overhead.m`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_runtime_overhead_analysis_20260623_from_existing_results`

输出文件：

- `main_comparison_overhead.csv`
- `ablation_overhead_vs_without_cvf.csv`
- `CVF_AE_RUNTIME_OVERHEAD_INTERPRETATION.md`

数据来源：

- 正式主对比：`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`
- 正式消融：`routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_conservative_20260622_194947`

关键结果：

- 正式消融中，完整 `CVF-AE` 相对 `CVF-AE-w/o-CVF` 的平均 runtime ratio 为 `0.976`；
- 正式消融中，完整 `CVF-AE` 相对 `CVF-AE-w/o-CVF` 的平均 `nEvals` ratio 为 `1.011`；
- 分场景 runtime ratio 范围为 `0.768` 到 `1.094`，不应写成稳定加速；
- 完整 `CVF-AE` 的平均 CVF 触发次数为 `39.5`，平均 CVF 成功次数为 `28.9`；
- 额外 `nEvals` 约为 `1.1%`，支持“低评价次数开销”和“稀疏 CVF 触发”的表述；
- 正式主对比中，`CVF-AE` 三个场景 feasible rate 均为 `1.00`，开销结论应与主对比性能、消融贡献和 trajectory sanity 一起解释。

写作边界：

- 可以写“低额外评价次数”和“受控运行时间开销”；
- 不应写“无开销”；
- 不应把 Scene 4 中 runtime ratio 小于 1 的结果解释成稳定加速，因为运行时间受 repair 次数、可行解形成速度和 MATLAB 运行波动影响。

## 2026-06-23 参数敏感性实验

阶段目标：

- 验证当前冻结的保守状态自适应 `CVF-AE` 对关键 CVF 参数是否鲁棒；
- 只做小范围参数敏感性，不进入反复调参；
- 判断是否存在全面、稳定、显著优于默认参数的替代设置。

新增脚本：

- `run_cvf_ae_param_sensitivity.m`
- `analyze_cvf_ae_param_sensitivity_sanity.m`

结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_param_sensitivity_conservative_20260623_131249`

配置：

- scenes: `[2, 4]`
- nRuns: `10`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260631`
- resumeExisting: `true`
- run records: `180 / 180`

参数组：

- `quota_scale`: `low / default / high`
- `step_strength`: `weak / default / strong`
- `state_switch_threshold`: `strict / default / loose`

关键结果：

- `quota_scale`
  - `high` 在 Scene 2-v2 和 Scene 4 的 mean best fitness 均略优于 `default`；
  - 但平均 `nEvals` 从 `9444.7` 增至 `9464.1`，平均 CVF 触发从 `47.5` 增至 `53.1`；
  - `low` 在两个场景均弱于 `default`，说明过低 CVF quota 会削弱强约束场景贡献。
- `step_strength`
  - 三档平均排名均为 `2.00`；
  - Scene 2-v2 中 `default` 最好，Scene 4 中 `weak` 最好；
  - 未形成稳定优于默认的方向。
- `state_switch_threshold`
  - `default` 平均排名 `1.50`，优于 `loose = 2.00` 和 `strict = 2.50`；
  - Scene 4 中 `default` 明显优于 `loose` 和 `strict`。

轨迹 sanity：

- 已生成：
  - `param_sensitivity_trajectory_sanity_runs.csv`
  - `param_sensitivity_trajectory_sanity_summary.csv`
  - `param_sensitivity_trajectory_sanity_flags.csv`
- Scene 2-v2 所有参数组和档位 `VisualReviewFlagRate = 0`；
- Scene 4 的 flagged runs 主要来自 boundary-hugging，不是 high-altitude bypass；
- `quota_scale = high` 在 Scene 4 的 `VisualReviewFlagRate = 0`，但其额外 CVF 触发和 `nEvals` 更高；
- `state_switch_threshold = default` 在 Scene 4 的 `VisualReviewFlagRate = 0.4`，后续代表轨迹图阶段需要继续人工筛选 median / best run。

阶段判断：

- 不修改当前主方法默认参数；
- 没有任何非默认参数同时在 fitness、`nEvals`、CVF 触发次数和 trajectory sanity 上全面、稳定、显著优于默认；
- 参数敏感性结论应写为“默认参数处于稳定前列，CVF-AE 对关键 CVF 参数具有鲁棒性”；
- 当前“保守状态自适应 CVF 调度版本的 CVF-AE”继续保持冻结。

## 2026-06-23 收敛曲线生成

阶段目标：

- 基于正式主对比结果生成论文用收敛曲线；
- 只复用已有 `run_records`，不重跑优化实验；
- 输出均值曲线和标准差阴影，用于支撑主对比收敛行为分析。

新增脚本：

- `make_cvf_ae_convergence_curves.m`

数据来源：

- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_convergence_curves_20260623_from_main_comparison`

配置：

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `CPO`, `DBO`, `GWO`, `AE`, `PSO`, `HHO`
- primary algorithms with std shading: `CVF-AE`, `CPO`, `DBO`, `GWO`, `AE`
- source runs per scene / algorithm: `30`

输出文件：

- `cvf_ae_convergence_summary.csv`
- `cvf_ae_convergence_curves.csv`
- `CVF_AE_CONVERGENCE_INTERPRETATION.md`
- `scene1_convergence_mean_std.png`
- `scene2_convergence_mean_std.png`
- `scene4_convergence_mean_std.png`

关键结果：

- summary rows: `21`
- curve rows: `6300`
- Scene 1 最终均值：`CVF-AE = 298.1379`，`CPO = 298.3594`，`DBO = 344.8827`；
- Scene 2-v2 最终均值：`CPO = 278.1196`，`CVF-AE = 301.2018`，`DBO = 337.7867`；
- Scene 4 最终均值：`CVF-AE = 349.2270`，`DBO = 376.3041`，`CPO = 519.8797`；
- CVF-AE 在三个场景的 feasible rate 均为 `1.00`。

解释边界：

- 收敛曲线使用各 run 中由 Deb 可行性优先规则维护的 best-so-far fitness，可写为 feasible-aware best fitness；
- Scene 2-v2 中 `CPO` scalar fitness 最低，但必须结合正式主对比中的 trajectory sanity 一起解释，不能单独写成低空任务一致性更优；
- Scene 1 和 Scene 4 的曲线支持 `CVF-AE` 在强约束场景中具备稳定收敛和较低最终 fitness；
- 本阶段产物可作为论文主对比收敛曲线来源。

## 2026-06-23 近年非 AE 改进算法接入

阶段目标：

- 为扩展主对比补充近年非 AE 改进算法，而不是 AE-family 内部变体；
- 新增算法只使用统一 UAV 编码、统一 objective、统一边界投影和 Deb 可行性优先规则；
- 不使用 `CVF-AE` 的 CVF、repair、参考初始化或 sparse preservation 等主方法专属机制。

新增算法：

- `GDSAO`：source-aligned adaptation of Global Dynamic Evolution Snow Ablation Optimizer；
- `ERIME`：paper-based reimplementation of enhanced RIME；
- `MSCSO`：paper-based reimplementation of Modified Sand Cat Swarm Optimization。

新增脚本：

- `optimizer_GDESAO_uav.m`
- `optimizer_ERIME_uav.m`
- `optimizer_MSCSO_uav.m`

修改入口：

- `getUAVAlgorithmConfig.m`
- `run_single_uav_algorithm_case.m`
- `run_uav_comparison_lite_v2_batch.m`
- `run_cvf_ae_main_comparison.m`

新增 runner 模式：

- `recent-precheck`
- `recent-formal`
- `resume-recent-formal`

precheck：

- command: `run_cvf_ae_main_comparison('recent-precheck')`
- scenes: `[1, 2, 4]`
- algorithms: `GDSAO`, `ERIME`, `MSCSO`
- runs: `2`
- popSize: `12`
- maxIter: `20`
- run records: `18 / 18`

precheck 平均排名：

- `GDSAO`: `1.6667`
- `MSCSO`: `2.0000`
- `ERIME`: `2.3333`

阶段判断：

- 三个新增算法已通过接口和小规模运行验证；
- precheck 不作为论文性能结果，只说明算法能进入统一实验框架；
- 下一步应运行 `recent-formal`，再将新增算法结果与已冻结的正式主对比目录合并为扩展主表；
- Scene 4 中新增算法在小规模 precheck 已出现不可行 run，正式结果必须继续配套 trajectory sanity 和 feasible rate 解读。

## 2026-06-23 近年改进算法正式补充实验

阶段目标：

- 只补跑近年非 AE 改进算法 `GDSAO`、`ERIME`、`MSCSO`；
- 不重跑已冻结的 8 个正式主对比算法；
- 与正式主对比保持相同 scenes、runs、popSize、maxIter 和 UAV objective 口径；
- 运行后生成 trajectory sanity，并与原正式主对比合并为扩展主表。

新增辅助脚本：

- `run_cvf_ae_recent_improved_formal_chunk.m`
- `merge_cvf_ae_extended_main_comparison.m`

正式结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_recent_improved_formal_20260623_161229`

配置：

- scenes: `[1, 2, 4]`
- algorithms: `GDSAO`, `ERIME`, `MSCSO`
- runs: `30`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260701`
- run records: `270 / 270`

新增算法内部平均排名：

- `GDSAO`: `1.6667`
- `MSCSO`: `1.6667`
- `ERIME`: `2.6667`

新增算法分场景结果：

- Scene 1:
  - `MSCSO`: mean `314.3453`, feasible rate `1.00`
  - `GDSAO`: mean `315.7542`, feasible rate `1.00`
  - `ERIME`: mean `322.9893`, feasible rate `1.00`
- Scene 2-v2:
  - `MSCSO`: mean `291.1680`, feasible rate `1.00`
  - `GDSAO`: mean `307.0675`, feasible rate `1.00`
  - `ERIME`: mean `316.1932`, feasible rate `1.00`
- Scene 4:
  - `GDSAO`: mean `346.8474`, feasible rate `1.00`
  - `ERIME`: mean `360.2347`, feasible rate `1.00`
  - `MSCSO`: mean `402.2712`, feasible rate `0.9333`

trajectory sanity：

- 已生成：
  - `trajectory_sanity_runs.csv`
  - `trajectory_sanity_summary.csv`
  - `trajectory_sanity_flags.csv`
- flagged runs: `193 / 270`
- Scene 4:
  - `GDSAO` visual review flag rate `1.00`，主要来自 boundary-hugging；
  - `ERIME` visual review flag rate `0.9667`，主要来自 boundary-hugging；
  - `MSCSO` visual review flag rate `0.6667`，且 feasible rate 为 `0.9333`。

扩展主对比合并目录：

- `routes/route_b_cvf_ae/results/cvf_ae_extended_main_comparison_20260623_from_formal_and_recent`

扩展主对比平均排名：

- `CVF-AE`: `2.0000`
- `CPO`: `3.0000`
- `GDSAO`: `3.0000`
- `MSCSO`: `3.3333`
- `ERIME`: `4.3333`
- `DBO`: `5.3333`
- `GWO`: `7.0000`
- `HHO`: `8.3333`
- `PSO`: `8.6667`
- `WOA`: `10.0000`
- `AE`: `11.0000`

阶段判断：

- 加入近年改进算法后，`CVF-AE` 仍保持扩展平均排名第一；
- `GDSAO` 在 Scene 4 scalar fitness 略优于 `CVF-AE`，但 trajectory sanity 显示其边界贴靠风险极高，不能只按 scalar fitness 下结论；
- `MSCSO` 在 Scene 1 和 Scene 2-v2 scalar fitness 很强，但 Scene 4 feasible rate 降至 `0.9333` 且方差较大；
- 扩展主表应与 trajectory sanity 联合呈现，论文中不应写成“近年改进算法全面弱于 CVF-AE”，而应写成“CVF-AE 在扩展对比中保持最佳综合平均排名，并在强约束场景中具有更均衡的可行性与轨迹合理性”。

## 2026-06-23 代表轨迹图筛选与绘制

阶段目标：

- 固定代表 run 筛选规则，避免人工挑选轨迹；
- 同时生成主对比、扩展对比和消融实验的代表轨迹图；
- 输出 3D 和 top-view 两种视角，并保留代表 run 选择表。

新增脚本：

- `make_cvf_ae_representative_path_figures.m`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_representative_paths_20260623_from_formal_results`

数据来源：

- 正式主对比：`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`
- 近年改进算法补充：`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_recent_improved_formal_20260623_161229`
- 正式消融：`routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_conservative_20260622_194947`

筛选规则：

- 优先选择 feasible 且 `VisualReviewFlag = false` 的 run，并取 fitness 最接近 feasible 中位数者；
- 若无无复核风险 run，则选择 feasible run 中 fitness 最接近 feasible 中位数者；
- 若无 feasible run，则选择 violation 最小且 fitness 接近中位数者；
- 所有选择写入 `representative_run_selection_all.csv`。

图集：

- `main`: `CVF-AE`, `CPO`, `DBO`, `GWO`, `AE`
- `extended`: `CVF-AE`, `CPO`, `DBO`, `GDSAO`, `MSCSO`, `ERIME`
- `ablation`: `CVF-AE`, `w/o CVF`, `w/o StateCVF`, `w/o Sparse`, `w/o Init`, `Base-AE`

输出规模：

- 代表选择行数：`51`
- `feasible_clean_median`: `38`
- `feasible_flagged_median`: `9`
- `infeasible_min_violation_median`: `4`
- 每个图集每个场景输出 3D 和 top-view PNG，共 `18` 张 PNG。

人工检查：

- 已检查 `extended` Scene 4 的 3D / top-view 图，`GDSAO`、`CPO`、`DBO` 的 boundary-hugging 风险在图中可见；
- 已检查 `ablation` Scene 4 top-view 图，`Base-AE` 的不可行代表轨迹和消融变体差异可见；
- 这些图支持论文中“只看 scalar fitness 不足以判断路径合理性”的解释。

阶段判断：

- Stage 5 初版代表轨迹图已生成；
- 带有 `feasible_flagged_median` 或 `infeasible_min_violation_median` 的代表轨迹必须在论文图注或正文中明确说明其复核风险；
- 后续若要进入最终论文排版，可在当前 PNG 基础上进一步调整图例位置、线宽和是否拆分拥挤图。

## 2026-06-24 正式显著性检验

阶段目标：

- 基于已有正式逐次运行结果完成非参数显著性检验；
- 不重跑任何优化实验；
- 同时覆盖扩展主对比和正式消融；
- 对多重成对比较进行 Holm 校正，并报告效应量。

新增脚本：

- `analyze_cvf_ae_formal_significance.m`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_formal_significance_20260624_from_formal_results`

统计方案：

- 两批主对比和正式消融中，不同算法的随机种子均包含算法序号偏移，因此算法样本不是严格配对样本；
- 成对检验统一使用双侧 Wilcoxon rank-sum test（Mann-Whitney U），不使用 paired signed-rank test；
- 每个场景内对全部成对比较使用 Holm 校正；
- 同时输出跨所有场景比较的全局 Holm 校正结果；
- 使用 lower-is-better Cliff's delta 报告效应量，正值表示 `CVF-AE` 更优；
- 使用 Kruskal-Wallis 检验每个场景内全部算法分布是否存在总体差异。

扩展主对比结果：

- 三个场景的 Kruskal-Wallis 检验均显著，p 值范围为 `6.11e-43` 至 `1.64e-46`；
- 场景内 Holm 校正后，`CVF-AE` 对全部 10 个基线共得到 `21 胜 / 7 平 / 2 负`；
- Scene 1：`9 胜 / 1 平 / 0 负`，仅与 `CPO` 无显著差异；
- Scene 2：`6 胜 / 2 平 / 2 负`，显著弱于 `CPO` 和 `MSCSO`，与 `GDSAO`、`ERIME` 无显著差异；
- Scene 4：`6 胜 / 4 平 / 0 负`，对 `GDSAO`、`ERIME`、`MSCSO` 和 `CPO` 均无显著差异；
- 对原正式主对比 7 个算法为 `18 胜 / 2 平 / 1 负`；
- 对 3 个近年改进算法为 `3 胜 / 5 平 / 1 负`。

正式消融结果：

- 三个场景的 Kruskal-Wallis 检验均显著；
- 场景内 Holm 校正后，完整 `CVF-AE` 对 5 个消融版本共得到 `9 胜 / 6 平 / 0 负`；
- Scene 1：`4 胜 / 1 平 / 0 负`；
- Scene 2：`3 胜 / 2 平 / 0 负`；
- Scene 4：`2 胜 / 3 平 / 0 负`；
- 完整方法在任何场景均未显著弱于消融版本，但不能声称每个模块在每个场景都产生显著提升。

写作边界：

- 论文中应写为 Wilcoxon rank-sum / Mann-Whitney U test，而不是 paired Wilcoxon signed-rank test；
- 主结论使用场景内 Holm 校正 p 值，原始 p 值放入完整统计表或补充材料；
- Scene 2 中 `CPO` 和 `MSCSO` 的 scalar fitness 显著优于 `CVF-AE`，必须结合 trajectory sanity 与可行率讨论；
- Scene 4 中 `GDSAO` 的均值略优，但差异不显著，且存在高 boundary-hugging 风险；
- 消融显著性支持完整方法的综合有效性，但不支持“所有模块在所有场景均显著有效”的绝对表述。

## 2026-06-24 论文结果材料包与图表索引

阶段目标：

- 将已完成的主对比、显著性、消融、参数敏感性、开销和轨迹 sanity 结果统一整理成论文可用表格；
- 建立收敛曲线和代表轨迹图的正文/补充材料索引；
- 生成集中审阅用 Excel 工作簿；
- 不重跑任何优化实验。

新增脚本：

- `export_cvf_ae_paper_results_package.m`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_paper_results_package_20260624_from_formal_results`

输出内容：

- `CVF_AE_PAPER_RESULTS_PACKAGE.xlsx`
- `paper_table_main_compact.csv`
- `paper_table_main_extended_long.csv`
- `paper_table_main_significance.csv`
- `paper_table_ablation.csv`
- `paper_table_ablation_significance.csv`
- `paper_table_parameter_sensitivity.csv`
- `paper_table_overhead.csv`
- `paper_table_trajectory_sanity.csv`
- `paper_figure_index.csv`
- `CVF_AE_PAPER_RESULTS_PACKAGE_README.md`
- `CVF_AE_PAPER_RESULTS_WRITEUP_DRAFT.md`

整理规模：

- 扩展主对比：`33` 行，覆盖 `11` 个算法和 `3` 个正式场景；
- 正式消融：`18` 行，覆盖 `6` 个版本和 `3` 个正式场景；
- 图索引：`21` 张 PNG；
- 正文建议图：`8` 张；
- 补充材料建议图：`13` 张；
- Excel 工作簿：`10` 个 sheet，包括概览、正文主表、完整长表、显著性、消融、参数、开销、轨迹 sanity 和图索引。

正文材料建议：

- 主表优先使用 `paper_table_main_compact.csv`；
- 显著性正文报告场景内 Holm 校正后的 `+ / = / -`，完整 p 值和 Cliff's delta 放补充表；
- 消融正文使用 `paper_table_ablation.csv`，并结合消融显著性解释模块互补性；
- runtime 与 `NEvals` 单独成效率表，不将绝对 runtime 跨批次直接比较；
- 图索引建议正文放三场景收敛曲线、三场景扩展 top-view，以及 Scene 2/4 消融 top-view；
- 其余 3D 视图和经典基线轨迹放补充材料。

验证：

- MATLAB Code Analyzer 通过；
- CSV 行数、算法数、场景数和关键结论完成断言检查；
- Excel 共 `10` 个 sheet，全部完成渲染检查；
- Excel 公式错误扫描未发现 `#REF!`、`#DIV/0!`、`#VALUE!`、`#NAME?` 或 `#N/A`。

## 2026-06-24 参数图、箱线图与方法流程图

阶段目标：

- 补齐论文参数敏感性可视化；
- 补齐正式主对比运行分布箱线图；
- 绘制 CVF-AE 方法总体流程图；
- 更新论文结果包图索引和 Excel 工作簿；
- 不重跑任何优化实验。

新增脚本：

- `make_cvf_ae_paper_completion_figures.m`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_paper_completion_figures_20260624_from_formal_results`

输出图：

- `cvf_ae_parameter_sensitivity.png/.pdf`
  - 三个子图：CVF trigger quota、CVF step strength、state switching threshold；
  - 使用 Scene 2 和 Scene 4 的 mean best fitness ± std；
  - 虚线标记默认参数档位。
- `cvf_ae_boxplots_strong_algorithms.png/.pdf`
  - 算法：`CVF-AE`、`CPO`、`GDSAO`、`MSCSO`、`ERIME`、`DBO`；
  - 每算法每场景使用 `30` 次正式运行；
  - 建议正文使用。
- `cvf_ae_boxplots_all_algorithms_log.png/.pdf`
  - 覆盖扩展主对比全部 `11` 个算法；
  - 采用对数纵轴以容纳尺度差异；
  - 建议补充材料使用。
- `cvf_ae_method_flowchart.png/.pdf`
  - 展示约束感知初始化、状态识别、AE 候选、稀疏 CVF 分支、局部接受、稀疏 repair、Deb population acceptance 和迭代终止。

视觉检查：

- 参数图默认档位标记、误差棒和图例无重叠；
- 强算法箱线图算法颜色可区分，异常值可见；
- 全算法箱线图完整显示 `11` 个算法；
- 流程图分支、回环和终止路径无交叉遮挡，文本未溢出；
- PNG 和 vector PDF 均已输出。

图索引更新：

- 论文总图数从 `21` 更新为 `25`；
- 正文建议图从 `8` 更新为 `11`；
- 补充材料建议图从 `13` 更新为 `14`；
- `CVF_AE_PAPER_RESULTS_PACKAGE.xlsx` 的 Figure Index sheet 已同步更新；
- Excel 更新后公式错误扫描仍为零。

写作边界：

- 参数敏感性图用于支持默认参数处于稳定前列，不用于宣称默认值逐场景逐参数最优；
- Scene 4 的 CPO 箱体和离群点跨度较大，支持其稳定性和可行性风险解释；
- 箱线图仅呈现 scalar BestFitness 分布，仍需与 feasible rate 和 trajectory sanity 联合解释；
- 流程图中的 CVF 分支必须描述为稀疏触发，不是所有个体每代强制执行。
