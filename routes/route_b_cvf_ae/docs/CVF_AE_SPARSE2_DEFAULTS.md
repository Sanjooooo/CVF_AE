# CVF-AE Sparse 2.0 Frozen Defaults

Status: frozen after the medium-gate Sparse 2.0 check on 2026-06-18.

This document freezes the current Route B default configuration for formal
ablation planning. Do not change these defaults during formal ablation unless
the formal run fails and the mechanism design is explicitly reopened.

## Algorithm Name

`CVF-AE = Constraint Viability Field guided Alpha Evolution`

## Frozen Evidence

Medium-gate result:

- `routes/route_b_cvf_ae/results/cvf_ae_medium_gate_sparse2_20260618_095112`

Decision:

- Sparse 2.0 passed the medium gate.
- Full `CVF-AE` kept the best average rank (`1.67`).
- CVF count and runtime overhead were reduced enough for the low-overhead claim to remain plausible.
- CVF contribution is strongest on Scene 2 and Scene 4-style constrained environments.

## Formal Ablation Set

Use exactly these algorithm variants:

1. `Base-AE`
2. `CVF-AE-w/o-Init`
3. `CVF-AE-w/o-StateAdaptiveCVF`
4. `CVF-AE-w/o-SparsePreservation`
5. `CVF-AE-w/o-CVF`
6. `CVF-AE`

Use scenes:

```text
[1, 2, 4]
```

Do not restore code Scene 3.

## Frozen CVF Trigger Defaults

Location: `optimizer_CVF_AE_uav.m`, `localDefaultCVFAEParams`.

Population-level CVF budget:

```text
params.cvfAe.maxPerIter = max(1, round(0.12 * popSize))
```

State-specific budget:

```text
formation    = max(1, round(0.10 * popSize))
preservation = max(1, round(0.06 * popSize))
refinement   = max(1, round(0.02 * popSize))
recovery     = max(1, round(0.08 * popSize))
```

After the current best is feasible:

```text
postFeasibleMaxPerIter = max(1, round(0.03 * popSize))
postFeasibleInterval   = 3
```

Refinement throttling:

```text
refinementInterval = 5
```

Constraint-pressure thresholds:

```text
lowFeasibleRatio  = 0.35
highFeasibleRatio = 0.75
highMeanViolation = 8
maxViolation      = 15
```

Selection:

```text
eliteFrac             = 0.25
nearFeasibleRankFrac  = 0.45
refinementEliteFrac   = 0.08
```

## Frozen CVF Field Defaults

Location: `buildConstraintViabilityField.m`, `localDefaultCVFParams`.

```text
samples      = 64
strength     = 0.65
maxStepRatio = 0.040
maxNormRatio = 0.085
```

## Frozen CVF-AE Fusion Weights

Location: `applyOperator_CVF_AE.m`, `localStateWeights`.

| State | `alpha_s` | `beta_s` | `gamma_s` |
|---|---:|---:|---:|
| Feasibility formation | 0.80 | 0.55 | 0.05 |
| Feasibility preservation | 0.90 | 0.45 | 0.08 |
| Quality refinement | 1.00 | 0.12 | 0.14 |
| Stagnation recovery | 0.90 | 0.35 | 0.04 |

## Frozen Acceptance Rule

The CVF candidate replaces the ordinary AE offspring only if:

```text
DebBetter(X_CVF, X_AE) && J(X_CVF) <= J(X_AE)
```

This prevents CVF from accepting candidates that reduce violation but damage the
total path cost.

## Sparse Preservation Defaults

```text
repairEliteFrac       = 0.30
repairMaxPerIter      = max(1, round(0.08 * popSize))
repairMaxViolation    = 25
repairIters           = 1
repairStartFrac       = 0.15
```

## Formal Reporting Requirements

Formal ablation must report at least:

- feasible rate;
- mean and std best fitness;
- final violation;
- first feasible iteration;
- runtime;
- `nEvals`;
- repair count and repair success count;
- CVF count and CVF success count;
- CVF dominant field fractions.

Do not report only fitness.

## Known Caveat

Scene 1 may favor `CVF-AE-w/o-StateAdaptiveCVF` by mean fitness. The formal
analysis should state plainly whether the full state-adaptive CVF mechanism is
mainly beneficial in the stronger constrained Scene 2/4 cases.
