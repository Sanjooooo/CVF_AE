# CVF-AE Formal Ablation Decision

- Scenes: `[1 2 4]`
- Algorithms: `Base-AE, CVF-AE-w/o-Init, CVF-AE-w/o-StateAdaptiveCVF, CVF-AE-w/o-SparsePreservation, CVF-AE-w/o-CVF, CVF-AE`
- nRuns: `30`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260623`

## Decision

**Enter formal experiments**

Medium gate passed: full CVF-AE is close to the best average rank, CVF and state-adaptive mechanisms have at least one scene of support, and overhead is controlled.

## Gate Notes

- Scene 1: full-vs-noCVF fitness 305.801 vs 306.350, full-vs-static 305.801 vs 298.108, evalRatio 1.010, runtimeRatio 0.951
- Scene 2: full-vs-noCVF fitness 322.736 vs 319.188, full-vs-static 322.736 vs 427.473, evalRatio 1.012, runtimeRatio 1.037
- Scene 4: full-vs-noCVF fitness 348.850 vs 356.605, full-vs-static 348.850 vs 361.790, evalRatio 1.010, runtimeRatio 1.130

## Average Rank

| Algorithm | AverageRank |
|---|---|
| CVF-AE | 1.66667 |
| CVF-AE-w/o-CVF | 2 |
| CVF-AE-w/o-StateAdaptiveCVF | 3 |
| CVF-AE-w/o-SparsePreservation | 3.66667 |
| CVF-AE-w/o-Init | 4.66667 |
| Base-AE | 6 |

## Summary

| Scene | Algorithm | NumRuns | FeasibleRate | MeanBestFitness | StdBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanRepairSuccessCount | MeanViabilityFieldCount | MeanViabilityFieldSuccessCount | MeanViabilityFieldNorm | MeanCVFObstacleFrac | MeanCVFNFZFrac | MeanCVFRiskFrac | MeanCVFAltitudeFrac | MeanCVFCurvatureFrac | MeanCVFBoundaryFrac | Rank |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Base-AE | 30 | 0.6 | 691.868 | 367.745 | 1.3 | 6.03036 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 1 | CVF-AE-w/o-Init | 30 | 1 | 316.956 | 10.5299 | 0 | 8.26532 | 9582.6 | 19.3333 | 414.967 | 219.7 | 137.633 | 92.2 | 1.29936 | 0.130333 | 0.00577778 | 0.159778 | 0.0153333 | 0.0243333 | 0.00811111 | 5 |
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 298.108 | 2.73327 | 0 | 9.10877 | 9566.13 | 1.63333 | 515.333 | 140.933 | 20.8 | 19.8 | 0.068354 | 0.0334444 | 0 | 0.0301111 | 0 | 0 | 0.000333333 | 1 |
| 1 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 307.721 | 3.96076 | 0 | 6.58733 | 9141.33 | 5.6 | 0 | 0 | 111.333 | 92.1 | 0.586987 | 0.168556 | 0.00388889 | 0.125 | 0 | 0.00466667 | 0.032 | 4 |
| 1 | CVF-AE-w/o-CVF | 30 | 1 | 306.35 | 3.25747 | 0 | 7.41485 | 9473.37 | 3.3 | 443.367 | 147.1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 1 | CVF-AE | 30 | 1 | 305.801 | 5.04558 | 0 | 7.05332 | 9570.77 | 3.1 | 439.067 | 138.667 | 101.7 | 84.6667 | 0.530148 | 0.133444 | 0.000333333 | 0.159444 | 0.002 | 0.00644444 | 0.0166667 | 2 |
| 2 | Base-AE | 30 | 0 | 2335.38 | 498.851 | 11.5333 | 5.48892 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 2 | CVF-AE-w/o-Init | 30 | 0.966667 | 348.274 | 169.595 | 0.166667 | 7.98299 | 9501.67 | 74.8276 | 323.067 | 264.333 | 148.6 | 106.8 | 1.47131 | 0.333444 | 0 | 0 | 0.011 | 0.000111111 | 0.0123333 | 4 |
| 2 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 0.933333 | 427.473 | 416.724 | 0.566667 | 8.60836 | 9550.13 | 41.8571 | 436.767 | 189.933 | 83.3667 | 61.6333 | 0.724622 | 0.133556 | 0 | 0 | 0 | 0.00355556 | 0.0417778 | 5 |
| 2 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 326.1 | 9.56186 | 0 | 7.01447 | 9176.6 | 35.7667 | 0 | 0 | 146.6 | 116.167 | 1.38651 | 0.233333 | 0 | 0 | 0 | 0.0122222 | 0.0974444 | 3 |
| 2 | CVF-AE-w/o-CVF | 30 | 1 | 319.188 | 9.41442 | 0 | 6.89642 | 9390.43 | 34.8333 | 360.433 | 181.333 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| 2 | CVF-AE | 30 | 1 | 322.736 | 11.2398 | 0 | 7.15396 | 9505.97 | 29.4333 | 342.567 | 174.267 | 133.4 | 102.367 | 1.30963 | 0.248889 | 0.00655556 | 0 | 0.00177778 | 0.00155556 | 0.0704444 | 2 |
| 4 | Base-AE | 30 | 0 | 1665.75 | 208.271 | 7.63917 | 5.53563 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 4 | CVF-AE-w/o-Init | 30 | 0.666667 | 590.68 | 372.081 | 1.33333 | 8.39876 | 9795.7 | 120.7 | 347.833 | 182.567 | 417.867 | 332.8 | 2.66233 | 0.685556 | 0 | 0 | 0.00177778 | 0 | 0 | 5 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 361.79 | 33.8787 | 0 | 7.27602 | 9316.17 | 0 | 215.733 | 122.733 | 70.4333 | 43.4 | 0.737153 | 0.234222 | 0 | 0 | 0 | 0 | 0.000555556 | 3 |
| 4 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 369.27 | 21.3276 | 0 | 6.58173 | 9119.87 | 0 | 0 | 0 | 89.8667 | 58.9333 | 1.07595 | 0.273778 | 0 | 0 | 0 | 0 | 0.0257778 | 4 |
| 4 | CVF-AE-w/o-CVF | 30 | 1 | 356.605 | 20.0257 | 0 | 7.3135 | 9252.03 | 0 | 222.033 | 147.667 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 4 | CVF-AE | 30 | 1 | 348.85 | 18.623 | 0 | 8.26726 | 9340.47 | 0 | 220.833 | 143.5 | 89.6333 | 58.1333 | 1.05418 | 0.277889 | 0 | 0 | 0 | 0 | 0.0208889 | 1 |
