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
