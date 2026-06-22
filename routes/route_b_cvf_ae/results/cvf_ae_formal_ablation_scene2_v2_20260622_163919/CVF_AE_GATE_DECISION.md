# CVF-AE Formal Ablation Decision

- Scenes: `[1 2 4]`
- Algorithms: `Base-AE, CVF-AE-w/o-Init, CVF-AE-w/o-StateAdaptiveCVF, CVF-AE-w/o-SparsePreservation, CVF-AE-w/o-CVF, CVF-AE`
- nRuns: `30`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260626`

## Decision

**Do not enter formal experiments**

Medium gate did not pass strongly enough for formal experiments. Inspect whether w/o-CVF or w/o-StateAdaptiveCVF dominates Scene 2/4 or whether overhead is too high.

## Gate Notes

- Scene 1: full-vs-noCVF fitness 305.855 vs 306.352, full-vs-static 305.855 vs 298.132, evalRatio 1.010, runtimeRatio 1.033
- Scene 2: full-vs-noCVF fitness 303.211 vs 303.224, full-vs-static 303.211 vs 301.513, evalRatio 1.009, runtimeRatio 0.793
- Scene 4: full-vs-noCVF fitness 349.340 vs 355.412, full-vs-static 349.340 vs 359.229, evalRatio 1.010, runtimeRatio 1.085

## Average Rank

| Algorithm | AverageRank |
|---|---|
| CVF-AE-w/o-StateAdaptiveCVF | 1.66667 |
| CVF-AE | 2 |
| CVF-AE-w/o-CVF | 3 |
| CVF-AE-w/o-SparsePreservation | 3.33333 |
| CVF-AE-w/o-Init | 5 |
| Base-AE | 6 |

## Summary

| Scene | Algorithm | NumRuns | FeasibleRate | MeanBestFitness | StdBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanRepairSuccessCount | MeanViabilityFieldCount | MeanViabilityFieldSuccessCount | MeanViabilityFieldNorm | MeanCVFObstacleFrac | MeanCVFNFZFrac | MeanCVFRiskFrac | MeanCVFAltitudeFrac | MeanCVFCurvatureFrac | MeanCVFBoundaryFrac | Rank |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Base-AE | 30 | 0.566667 | 711.505 | 375.772 | 1.43333 | 4.56501 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 1 | CVF-AE-w/o-Init | 30 | 1 | 316.795 | 9.99103 | 0 | 6.1463 | 9589.7 | 20.1667 | 420.4 | 223.3 | 139.3 | 91.6667 | 1.33109 | 0.133778 | 0.00533333 | 0.166444 | 0.00677778 | 0.0275556 | 0.00544444 | 5 |
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 298.132 | 2.78621 | 0 | 6.16322 | 9566.13 | 1.36667 | 515.233 | 138.9 | 20.9 | 19.8667 | 0.0682584 | 0.0386667 | 0 | 0.0261111 | 0 | 0 | 0.000333333 | 1 |
| 1 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 307.044 | 4.28519 | 0 | 4.95499 | 9140.47 | 5.53333 | 0 | 0 | 110.467 | 90.9 | 0.595785 | 0.152222 | 0.00388889 | 0.137111 | 0 | 0.00188889 | 0.0367778 | 4 |
| 1 | CVF-AE-w/o-CVF | 30 | 1 | 306.352 | 3.51514 | 0 | 5.91953 | 9474.67 | 1.93333 | 444.667 | 151.567 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 1 | CVF-AE | 30 | 1 | 305.855 | 5.16485 | 0 | 6.11633 | 9572.6 | 3.53333 | 439.733 | 140.367 | 102.867 | 85.5667 | 0.534142 | 0.147222 | 0.000333333 | 0.144889 | 0.002 | 0.00666667 | 0.0182222 | 2 |
| 2 | Base-AE | 30 | 0 | 1586.51 | 369.473 | 7.1 | 4.5901 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 2 | CVF-AE-w/o-Init | 30 | 1 | 312.326 | 18.7598 | 0 | 9.12166 | 9600.8 | 34.5667 | 411.033 | 274.233 | 159.767 | 111.867 | 1.46173 | 0.349222 | 0.00433333 | 0 | 0.000222222 | 0.006 | 0.0161111 | 5 |
| 2 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 301.513 | 3.07126 | 0 | 19.352 | 9558.33 | 8.9 | 511.6 | 311.767 | 16.7333 | 11.8667 | 0.140369 | 0.0296667 | 0 | 0 | 0 | 0.000222222 | 0.00811111 | 1 |
| 2 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 302.666 | 5.59476 | 0 | 9.12728 | 9108 | 5.33333 | 0 | 0 | 78 | 52.7 | 0.970629 | 0.162444 | 0.000111111 | 0 | 0 | 0.0243333 | 0.0548889 | 2 |
| 2 | CVF-AE-w/o-CVF | 30 | 1 | 303.224 | 5.19184 | 0 | 12.6075 | 9429 | 5.53333 | 399 | 223.6 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 4 |
| 2 | CVF-AE | 30 | 1 | 303.211 | 4.87809 | 0 | 9.99814 | 9515.73 | 5.93333 | 399.4 | 232.933 | 86.3333 | 60.6 | 1.0038 | 0.198222 | 0.00133333 | 0 | 0.000444444 | 0.0144444 | 0.046 | 3 |
| 4 | Base-AE | 30 | 0 | 1646.41 | 200.538 | 7.50584 | 8.85452 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 4 | CVF-AE-w/o-Init | 30 | 0.666667 | 587.231 | 368.363 | 1.33333 | 16.0452 | 9805.07 | 126.4 | 352 | 186.167 | 423.067 | 337.667 | 2.69859 | 0.692778 | 0 | 0 | 0.00177778 | 0 | 0.00144444 | 5 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 359.229 | 34.5934 | 0 | 12.7885 | 9329.43 | 0 | 228.967 | 130.467 | 70.4667 | 44.5333 | 0.74335 | 0.234333 | 0 | 0 | 0 | 0 | 0.000555556 | 3 |
| 4 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 369.711 | 20.0694 | 0 | 10.404 | 9119.17 | 0 | 0 | 0 | 89.1667 | 57.2333 | 1.07687 | 0.262 | 0 | 0 | 0 | 0 | 0.0352222 | 4 |
| 4 | CVF-AE-w/o-CVF | 30 | 1 | 355.412 | 20.3977 | 0 | 12.2956 | 9252.2 | 0 | 222.2 | 147.633 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 4 | CVF-AE | 30 | 1 | 349.34 | 19.2079 | 0 | 13.3429 | 9342.83 | 0 | 223.4 | 147.533 | 89.4333 | 58.4667 | 1.04894 | 0.278556 | 0 | 0 | 0 | 0 | 0.0195556 | 1 |
