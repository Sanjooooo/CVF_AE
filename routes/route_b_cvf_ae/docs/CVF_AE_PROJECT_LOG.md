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
