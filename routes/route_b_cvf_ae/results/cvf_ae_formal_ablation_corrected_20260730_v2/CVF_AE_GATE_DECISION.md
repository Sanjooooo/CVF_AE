# CVF-AE Formal Ablation Decision

- Scenes: `[1 2 4]`
- Algorithms: `Base-AE, CVF-AE-w/o-Init, CVF-AE-w/o-StateAdaptiveCVF, CVF-AE-w/o-SparsePreservation, CVF-AE-w/o-CVF, CVF-AE`
- nRuns: `30`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260629`

## Decision

**Do not enter formal experiments**

Medium gate did not pass strongly enough for formal experiments. Inspect whether w/o-CVF or w/o-StateAdaptiveCVF dominates Scene 2/4 or whether overhead is too high.

## Gate Notes

- Scene 1: full-vs-noCVF fitness 297.832 vs 298.212, full-vs-static 297.832 vs 298.304, evalRatio 1.002, runtimeRatio 2.354
- Scene 2: full-vs-noCVF fitness 300.661 vs 301.433, full-vs-static 300.661 vs 301.816, evalRatio 1.001, runtimeRatio 2.341
- Scene 4: full-vs-noCVF fitness 348.586 vs 350.378, full-vs-static 348.586 vs 361.312, evalRatio 1.010, runtimeRatio 1.397

## Average Rank

| Algorithm | AverageRank |
|---|---|
| CVF-AE | 1 |
| CVF-AE-w/o-CVF | 2 |
| CVF-AE-w/o-StateAdaptiveCVF | 3.33333 |
| CVF-AE-w/o-SparsePreservation | 3.66667 |
| CVF-AE-w/o-Init | 5 |
| Base-AE | 6 |

## Summary

| Scene | Algorithm | NumRuns | FeasibleRate | MeanBestFitness | StdBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanRepairSuccessCount | MeanViabilityFieldCount | MeanViabilityFieldSuccessCount | MeanViabilityFieldNorm | MeanCVFObstacleFrac | MeanCVFNFZFrac | MeanCVFRiskFrac | MeanCVFAltitudeFrac | MeanCVFCurvatureFrac | MeanCVFBoundaryFrac | Rank |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Base-AE | 30 | 0.633333 | 654.048 | 328.714 | 1.06667 | 4.37732 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 1 | CVF-AE-w/o-Init | 30 | 1 | 309.948 | 9.63082 | 0 | 11.894 | 9581.83 | 19.6667 | 491.4 | 208.467 | 60.4333 | 41.5333 | 0.637729 | 0.0743333 | 0.004 | 0.0507778 | 0.00377778 | 0.00844444 | 0.000444444 | 5 |
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 298.304 | 3.21609 | 0 | 24.5338 | 9565.97 | 1.73333 | 515.333 | 140.8 | 20.6333 | 19.6667 | 0.0695244 | 0.0392222 | 0 | 0.0231111 | 0 | 0 | 0.000666667 | 3 |
| 1 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 300.777 | 1.76854 | 0 | 8.77849 | 9060.93 | 4.1 | 4.33333 | 0.566667 | 26.6 | 24.4333 | 0.0871583 | 0.0446667 | 0 | 0.027 | 0 | 0.00122222 | 0.00211111 | 4 |
| 1 | CVF-AE-w/o-CVF | 30 | 1 | 298.212 | 2.44708 | 0 | 11.6459 | 9545.1 | 1.5 | 515.1 | 149.133 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 1 | CVF-AE | 30 | 1 | 297.832 | 3.1119 | 0 | 27.409 | 9566.37 | 1.93333 | 515.233 | 146.933 | 21.1333 | 19.1667 | 0.0698321 | 0.0361111 | 0 | 0.0266667 | 0 | 0 | 0.00122222 | 1 |
| 2 | Base-AE | 30 | 0 | 1597.48 | 342.479 | 7.13333 | 18.1764 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 2 | CVF-AE-w/o-Init | 30 | 0.966667 | 314.426 | 51.5188 | 0.0333333 | 12.4179 | 9614.87 | 41.4828 | 464.6 | 318.567 | 120.267 | 90.7 | 1.13113 | 0.252556 | 0 | 0.000555556 | 0.000444444 | 0.003 | 0.00122222 | 5 |
| 2 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 301.816 | 2.93322 | 0 | 28.8628 | 9560.87 | 10.1667 | 510.433 | 311.167 | 20.4333 | 14.5667 | 0.17261 | 0.0363333 | 0.000222222 | 0 | 0.001 | 0.000111111 | 0.00833333 | 4 |
| 2 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 301.725 | 3.54855 | 0 | 8.64709 | 9041.97 | 4.93333 | 0.6 | 0.366667 | 11.3667 | 8.33333 | 0.121269 | 0.0202222 | 0 | 0 | 0.000333333 | 0.00111111 | 0.00855556 | 3 |
| 2 | CVF-AE-w/o-CVF | 30 | 1 | 301.433 | 2.2989 | 0 | 12.0893 | 9540.43 | 4.66667 | 510.433 | 319.533 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 2 | CVF-AE | 30 | 1 | 300.661 | 3.27751 | 0 | 28.306 | 9551.6 | 4.6 | 511 | 315.267 | 10.6 | 7.9 | 0.107354 | 0.0207778 | 0 | 0 | 0 | 0.000777778 | 0.00555556 | 1 |
| 4 | Base-AE | 30 | 0 | 1643.73 | 199.403 | 7.50584 | 11.5176 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 4 | CVF-AE-w/o-Init | 30 | 0.466667 | 819.253 | 527.665 | 2.93426 | 15.101 | 9801.93 | 120.714 | 368.167 | 184.633 | 403.767 | 341.667 | 2.87427 | 0.713556 | 0 | 0 | 0 | 0 | 0 | 5 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 361.312 | 35.0403 | 0 | 26.1377 | 9321.83 | 0 | 219.367 | 125.033 | 72.4667 | 46.2667 | 0.750871 | 0.241 | 0 | 0 | 0 | 0 | 0.000555556 | 3 |
| 4 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 374.053 | 20.1817 | 0 | 9.61709 | 9119.93 | 0 | 0.0333333 | 0 | 89.9 | 58 | 1.11974 | 0.264778 | 0 | 0 | 0 | 0 | 0.0348889 | 4 |
| 4 | CVF-AE-w/o-CVF | 30 | 1 | 350.378 | 20.1849 | 0 | 13.2829 | 9276.7 | 0 | 246.7 | 164.4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 4 | CVF-AE | 30 | 1 | 348.586 | 21.8153 | 0 | 18.5575 | 9367.07 | 0 | 250.267 | 165.367 | 86.8 | 59.5333 | 1.05949 | 0.242667 | 0 | 0 | 0 | 0 | 0.0466667 | 1 |
