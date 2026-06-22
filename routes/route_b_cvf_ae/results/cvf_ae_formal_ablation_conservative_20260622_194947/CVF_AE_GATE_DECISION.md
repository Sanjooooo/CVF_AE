# CVF-AE Formal Ablation Decision

- Scenes: `[1 2 4]`
- Algorithms: `Base-AE, CVF-AE-w/o-Init, CVF-AE-w/o-StateAdaptiveCVF, CVF-AE-w/o-SparsePreservation, CVF-AE-w/o-CVF, CVF-AE`
- nRuns: `30`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260629`

## Decision

**Enter formal experiments**

Medium gate passed: full CVF-AE is close to the best average rank, CVF and state-adaptive mechanisms have at least one scene of support, and overhead is controlled.

## Gate Notes

- Scene 1: full-vs-noCVF fitness 297.832 vs 306.198, full-vs-static 297.832 vs 298.304, evalRatio 1.010, runtimeRatio 1.067
- Scene 2: full-vs-noCVF fitness 300.661 vs 303.770, full-vs-static 300.661 vs 301.816, evalRatio 1.013, runtimeRatio 1.094
- Scene 4: full-vs-noCVF fitness 348.586 vs 355.835, full-vs-static 348.586 vs 361.312, evalRatio 1.012, runtimeRatio 0.768

## Average Rank

| Algorithm | AverageRank |
|---|---|
| CVF-AE | 1 |
| CVF-AE-w/o-StateAdaptiveCVF | 2.33333 |
| CVF-AE-w/o-CVF | 3 |
| CVF-AE-w/o-SparsePreservation | 3.66667 |
| CVF-AE-w/o-Init | 5 |
| Base-AE | 6 |

## Summary

| Scene | Algorithm | NumRuns | FeasibleRate | MeanBestFitness | StdBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanRepairSuccessCount | MeanViabilityFieldCount | MeanViabilityFieldSuccessCount | MeanViabilityFieldNorm | MeanCVFObstacleFrac | MeanCVFNFZFrac | MeanCVFRiskFrac | MeanCVFAltitudeFrac | MeanCVFCurvatureFrac | MeanCVFBoundaryFrac | Rank |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Base-AE | 30 | 0.633333 | 654.048 | 328.714 | 1.06667 | 4.37732 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 1 | CVF-AE-w/o-Init | 30 | 1 | 316.996 | 11.8481 | 0 | 5.7871 | 9587.57 | 21.1333 | 417.333 | 220.5 | 140.233 | 93.0667 | 1.32658 | 0.132222 | 0.005 | 0.167222 | 0.0101111 | 0.0263333 | 0.00377778 | 5 |
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 298.304 | 3.21609 | 0 | 24.5338 | 9565.97 | 1.73333 | 515.333 | 140.8 | 20.6333 | 19.6667 | 0.0695244 | 0.0392222 | 0 | 0.0231111 | 0 | 0 | 0.000666667 | 2 |
| 1 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 306.379 | 4.99732 | 0 | 20.6455 | 9140.13 | 6.2 | 0 | 0 | 110.133 | 90.6667 | 0.591894 | 0.156444 | 0.00388889 | 0.132667 | 0 | 0.00188889 | 0.0324444 | 4 |
| 1 | CVF-AE-w/o-CVF | 30 | 1 | 306.198 | 3.49174 | 0 | 25.6912 | 9471.83 | 1.46667 | 441.833 | 152.133 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 1 | CVF-AE | 30 | 1 | 297.832 | 3.1119 | 0 | 27.409 | 9566.37 | 1.93333 | 515.233 | 146.933 | 21.1333 | 19.1667 | 0.0698321 | 0.0361111 | 0 | 0.0266667 | 0 | 0 | 0.00122222 | 1 |
| 2 | Base-AE | 30 | 0 | 1597.48 | 342.479 | 7.13333 | 18.1764 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 2 | CVF-AE-w/o-Init | 30 | 1 | 313.219 | 18.3412 | 0 | 28.796 | 9592.43 | 33.0333 | 408.7 | 262.433 | 153.733 | 107.433 | 1.41424 | 0.346556 | 0.00433333 | 0 | 0.000222222 | 0.00488889 | 0.0121111 | 5 |
| 2 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 301.816 | 2.93322 | 0 | 28.8628 | 9560.87 | 10.1667 | 510.433 | 311.167 | 20.4333 | 14.5667 | 0.17261 | 0.0363333 | 0.000222222 | 0 | 0.001 | 0.000111111 | 0.00833333 | 2 |
| 2 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 303.311 | 6.07177 | 0 | 20.91 | 9107.83 | 5.63333 | 0 | 0 | 77.8333 | 51.5 | 0.976494 | 0.160111 | 0.00111111 | 0 | 0 | 0.0255556 | 0.0534444 | 3 |
| 2 | CVF-AE-w/o-CVF | 30 | 1 | 303.77 | 4.95649 | 0 | 25.8824 | 9432.47 | 5.36667 | 402.467 | 226.133 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 4 |
| 2 | CVF-AE | 30 | 1 | 300.661 | 3.27751 | 0 | 28.306 | 9551.6 | 4.6 | 511 | 315.267 | 10.6 | 7.9 | 0.107354 | 0.0207778 | 0 | 0 | 0 | 0.000777778 | 0.00555556 | 1 |
| 4 | Base-AE | 30 | 0 | 1643.73 | 199.403 | 7.50584 | 11.5176 | 9030 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 4 | CVF-AE-w/o-Init | 30 | 0.7 | 556.752 | 348.826 | 1.16667 | 32.5412 | 9802.7 | 129.19 | 354.8 | 191.867 | 417.9 | 336.467 | 2.65003 | 0.684111 | 0 | 0 | 0.00177778 | 0 | 0.00144444 | 5 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 30 | 1 | 361.312 | 35.0403 | 0 | 26.1377 | 9321.83 | 0 | 219.367 | 125.033 | 72.4667 | 46.2667 | 0.750871 | 0.241 | 0 | 0 | 0 | 0 | 0.000555556 | 3 |
| 4 | CVF-AE-w/o-SparsePreservation | 30 | 1 | 372.226 | 19.8216 | 0 | 20.7891 | 9118.7 | 0 | 0 | 0 | 88.7 | 56.6 | 1.06051 | 0.257333 | 0 | 0 | 0 | 0 | 0.0383333 | 4 |
| 4 | CVF-AE-w/o-CVF | 30 | 1 | 355.835 | 21.3086 | 0 | 24.1732 | 9258.5 | 0 | 228.5 | 154.4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 4 | CVF-AE | 30 | 1 | 348.586 | 21.8153 | 0 | 18.5575 | 9367.07 | 0 | 250.267 | 165.367 | 86.8 | 59.5333 | 1.05949 | 0.242667 | 0 | 0 | 0 | 0 | 0.0466667 | 1 |
