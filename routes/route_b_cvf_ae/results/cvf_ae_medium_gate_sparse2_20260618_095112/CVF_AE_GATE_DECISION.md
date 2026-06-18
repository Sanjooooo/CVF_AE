# CVF-AE Medium Gate Sparse2 Decision

- Scenes: `[1 2 4]`
- Algorithms: `Base-AE, CVF-AE-w/o-Init, CVF-AE-w/o-StateAdaptiveCVF, CVF-AE-w/o-SparsePreservation, CVF-AE-w/o-CVF, CVF-AE`
- nRuns: `10`
- popSize: `30`
- maxIter: `150`
- baseSeed: `20260622`

## Decision

**Enter formal experiments**

Medium gate passed: full CVF-AE is close to the best average rank, CVF and state-adaptive mechanisms have at least one scene of support, and overhead is controlled.

## Gate Notes

- Scene 1: full-vs-noCVF fitness 306.923 vs 306.891, full-vs-static 306.923 vs 302.509, evalRatio 1.010, runtimeRatio 0.939
- Scene 2: full-vs-noCVF fitness 322.140 vs 329.681, full-vs-static 322.140 vs 489.210, evalRatio 1.026, runtimeRatio 1.111
- Scene 4: full-vs-noCVF fitness 365.307 vs 382.541, full-vs-static 365.307 vs 387.452, evalRatio 1.011, runtimeRatio 1.050

## Average Rank

| Algorithm | AverageRank |
|---|---|
| CVF-AE | 1.66667 |
| CVF-AE-w/o-SparsePreservation | 2.66667 |
| CVF-AE-w/o-CVF | 2.66667 |
| CVF-AE-w/o-StateAdaptiveCVF | 3 |
| CVF-AE-w/o-Init | 5 |
| Base-AE | 6 |

## Summary

| Scene | Algorithm | NumRuns | FeasibleRate | MeanBestFitness | StdBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanRepairSuccessCount | MeanViabilityFieldCount | MeanViabilityFieldSuccessCount | MeanViabilityFieldNorm | MeanCVFObstacleFrac | MeanCVFNFZFrac | MeanCVFRiskFrac | MeanCVFAltitudeFrac | MeanCVFCurvatureFrac | MeanCVFBoundaryFrac | Rank |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Base-AE | 10 | 0.3 | 1099.9 | 550.917 | 3.2 | 3.59267 | 4530 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 1 | CVF-AE-w/o-Init | 10 | 1 | 321.487 | 9.57847 | 0 | 4.63108 | 4828.1 | 17.1 | 210.3 | 109.3 | 87.8 | 57.7 | 1.57372 | 0.144 | 0.002 | 0.180667 | 0.026 | 0.0173333 | 0 | 5 |
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 10 | 1 | 302.509 | 2.48333 | 0 | 4.69639 | 4809.3 | 1.7 | 259.1 | 69.5 | 20.2 | 19.1 | 0.103481 | 0.0666667 | 0 | 0.05 | 0 | 0 | 0.00666667 | 1 |
| 1 | CVF-AE-w/o-SparsePreservation | 10 | 1 | 308.592 | 2.30671 | 0 | 3.87797 | 4590.6 | 4 | 0 | 0 | 60.6 | 52.3 | 0.525324 | 0.182 | 0 | 0.161333 | 0 | 0 | 0.00733333 | 4 |
| 1 | CVF-AE-w/o-CVF | 10 | 1 | 306.891 | 1.89045 | 0 | 3.80616 | 4763.2 | 4 | 233.2 | 69.7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 1 | CVF-AE | 10 | 1 | 306.923 | 2.28982 | 0 | 3.57449 | 4811.5 | 0.9 | 229.1 | 70.4 | 52.4 | 43.2 | 0.410774 | 0.178667 | 0 | 0.124667 | 0 | 0 | 0.034 | 3 |
| 2 | Base-AE | 10 | 0 | 2419.2 | 330.727 | 12.0752 | 3.49939 | 4530 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 2 | CVF-AE-w/o-Init | 10 | 0.9 | 492.812 | 512.775 | 1 | 3.65054 | 4728.3 | 49.5556 | 128.3 | 102.8 | 70 | 48.4 | 1.61736 | 0.366 | 0 | 0 | 0.002 | 0 | 0.0133333 | 5 |
| 2 | CVF-AE-w/o-StateAdaptiveCVF | 10 | 0.9 | 489.21 | 448.872 | 0.9 | 3.66702 | 4771.6 | 35.4444 | 195.9 | 66.1 | 45.7 | 33.9 | 0.850721 | 0.204 | 0 | 0 | 0 | 0 | 0.014 | 4 |
| 2 | CVF-AE-w/o-SparsePreservation | 10 | 1 | 329.033 | 10.5688 | 0 | 2.98483 | 4616.3 | 28.1 | 0 | 0 | 86.3 | 70.6 | 1.47984 | 0.284 | 0 | 0 | 0.000666667 | 0 | 0.0806667 | 2 |
| 2 | CVF-AE-w/o-CVF | 10 | 1 | 329.681 | 9.77608 | 0 | 3.39654 | 4697.1 | 36.8 | 167.1 | 89.7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 2 | CVF-AE | 10 | 1 | 322.14 | 9.71071 | 0 | 3.77433 | 4817.7 | 30.1 | 197.1 | 129 | 90.6 | 71 | 1.50445 | 0.259333 | 0 | 0 | 0 | 0 | 0.096 | 1 |
| 4 | Base-AE | 10 | 0 | 1791.4 | 235.244 | 8.11159 | 2.76773 | 4530 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 4 | CVF-AE-w/o-Init | 10 | 0.3 | 982.648 | 522.394 | 3.71207 | 4.25633 | 4996.2 | 94 | 176.1 | 87.4 | 290.1 | 236 | 3.32607 | 0.83 | 0 | 0 | 0 | 0 | 0 | 5 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 10 | 1 | 387.452 | 24.6171 | 0 | 3.2324 | 4628.3 | 0 | 64.1 | 34.4 | 34.2 | 21.9 | 0.719702 | 0.228 | 0 | 0 | 0 | 0 | 0 | 4 |
| 4 | CVF-AE-w/o-SparsePreservation | 10 | 1 | 379.958 | 22.8159 | 0 | 2.87932 | 4568 | 0 | 0 | 0 | 38 | 25.5 | 0.830173 | 0.222667 | 0 | 0 | 0 | 0 | 0.0306667 | 2 |
| 4 | CVF-AE-w/o-CVF | 10 | 1 | 382.541 | 19.4194 | 0 | 3.1798 | 4616.6 | 0 | 86.6 | 59.5 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 4 | CVF-AE | 10 | 1 | 365.307 | 28.2533 | 0 | 3.33833 | 4665.5 | 0 | 91.7 | 56 | 43.8 | 29.4 | 0.952031 | 0.292 | 0 | 0 | 0 | 0 | 0 | 1 |
