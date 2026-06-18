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
