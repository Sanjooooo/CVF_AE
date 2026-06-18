# CVF-AE Formal Ablation Interpretation

Date: 2026-06-18

Result folder:

`routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_20260618_102649`

## Configuration

- Scenes: `[1, 2, 4]`
- Runs per algorithm per scene: `30`
- Population size: `30`
- Max iterations: `300`
- Base seed: `20260623`
- Algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`

Total completed runs: `540 / 540`.

## Main Results

Average rank across scenes:

| Algorithm | Average rank |
|---|---:|
| `CVF-AE` | 1.67 |
| `CVF-AE-w/o-CVF` | 2.00 |
| `CVF-AE-w/o-StateAdaptiveCVF` | 3.00 |
| `CVF-AE-w/o-SparsePreservation` | 3.67 |
| `CVF-AE-w/o-Init` | 4.67 |
| `Base-AE` | 6.00 |

Per-scene full `CVF-AE` results:

| Scene | Feasible rate | Mean best fitness | Rank | Mean runtime | Mean nEvals | Mean CVF count |
|---:|---:|---:|---:|---:|---:|---:|
| 1 | 1.00 | 305.80 | 2 | 7.053 | 9570.8 | 101.7 |
| 2 | 1.00 | 322.74 | 2 | 7.154 | 9506.0 | 133.4 |
| 4 | 1.00 | 348.85 | 1 | 8.267 | 9340.5 | 89.6 |

## Mechanism Reading

The formal ablation supports keeping `CVF-AE` as the main Route B algorithm.

Evidence:

- Full `CVF-AE` has the best average rank (`1.67`) over Scenes 1, 2, and 4.
- Full `CVF-AE` reaches `100%` feasible rate on all three scenes, while `Base-AE` fails on Scenes 2 and 4 and reaches only `60%` on Scene 1.
- Initialization is important in hard constrained scenes. `CVF-AE-w/o-Init` drops to `96.67%` feasible rate on Scene 2 and `66.67%` on Scene 4.
- Sparse preservation is useful after feasibility. Full `CVF-AE` improves mean best fitness over `CVF-AE-w/o-SparsePreservation` on all three scenes:
  - Scene 1: `305.80` vs `307.72`
  - Scene 2: `322.74` vs `326.10`
  - Scene 4: `348.85` vs `369.27`
- State-adaptive CVF behavior is useful in harder scenes but not uniformly dominant in the easiest scene. Full `CVF-AE` is better than `w/o-StateAdaptiveCVF` on Scenes 2 and 4, while `w/o-StateAdaptiveCVF` is best on Scene 1.

The CVF field contribution is positive overall but mixed by scene:

- Scene 1: full `CVF-AE` is slightly better than `w/o-CVF` (`305.80` vs `306.35`).
- Scene 2: `w/o-CVF` is better by mean best fitness (`319.19` vs full `322.74`).
- Scene 4: full `CVF-AE` is clearly better (`348.85` vs `356.61`).

This means the paper should not claim that CVF guidance monotonically improves every scene. The defensible claim is that the low-frequency CVF mechanism improves the aggregate rank and is most valuable in strongly constrained layouts, while a repair-plus-initialization variant can remain competitive on some scenes.

## Runtime And Evaluation Cost

Full `CVF-AE` keeps evaluation overhead bounded:

- Scene 1: `9570.8` mean evaluations.
- Scene 2: `9506.0` mean evaluations.
- Scene 4: `9340.5` mean evaluations.

Runtime overhead remains visible but controlled:

- Full `CVF-AE` is faster than `w/o-Init` and `w/o-StateAdaptiveCVF` on Scene 1.
- Full `CVF-AE` is slightly slower than `w/o-CVF` on Scenes 2 and 4.
- The sparse trigger keeps mean CVF calls far below dense medium-gate behavior.

## Decision

Decision: proceed to the next research stage after formal ablation.

Recommended next stage:

- Prepare the main comparison protocol against external or stronger baselines.
- Keep the Sparse 2.0 defaults frozen unless a later baseline comparison exposes a specific failure mode.
- In the manuscript narrative, present CVF-AE as a low-overhead feasibility-guided evolutionary search mechanism with strongest evidence in harder constrained scenes.

Do not proceed by changing Scene 4, restoring Scene 3, or adding Route A comparisons.
