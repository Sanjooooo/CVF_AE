# CVF-AE Medium Gate Decision

- Scenes: `[1 2 4]`
- Algorithms: `Base-AE, CVF-AE-w/o-Init, CVF-AE-w/o-StateAdaptiveCVF, CVF-AE-w/o-SparsePreservation, CVF-AE-w/o-CVF, CVF-AE`
- nRuns: `10`
- popSize: `30`
- maxIter: `150`
- baseSeed: `20260621`

## Decision

**Do not enter formal experiments**

Medium gate did not pass strongly enough for formal experiments. Inspect whether w/o-CVF or w/o-StateAdaptiveCVF dominates Scene 2/4 or whether overhead is too high.

## Gate Notes

- Scene 1: full-vs-noCVF fitness 306.619 vs 306.072, full-vs-static 306.619 vs 301.785, evalRatio 1.126, runtimeRatio 1.938
- Scene 2: full-vs-noCVF fitness 321.173 vs 328.930, full-vs-static 321.173 vs 470.078, evalRatio 1.120, runtimeRatio 1.507
- Scene 4: full-vs-noCVF fitness 367.277 vs 388.389, full-vs-static 367.277 vs 384.362, evalRatio 1.132, runtimeRatio 1.635

## Average Rank

| Algorithm | AverageRank |
|---|---|
| CVF-AE | 1.66667 |
| CVF-AE-w/o-StateAdaptiveCVF | 2.33333 |
| CVF-AE-w/o-CVF | 2.33333 |
| CVF-AE-w/o-SparsePreservation | 3.66667 |
| CVF-AE-w/o-Init | 5 |
| Base-AE | 6 |

## Summary

| Scene | Algorithm | NumRuns | FeasibleRate | MeanBestFitness | StdBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanRepairSuccessCount | MeanViabilityFieldCount | MeanViabilityFieldSuccessCount | MeanViabilityFieldNorm | MeanCVFObstacleFrac | MeanCVFNFZFrac | MeanCVFRiskFrac | MeanCVFAltitudeFrac | MeanCVFCurvatureFrac | MeanCVFBoundaryFrac | Rank |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Base-AE | 10 | 0.3 | 1068.48 | 560.715 | 3 | 2.34461 | 4530 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 1 | CVF-AE-w/o-Init | 10 | 1 | 322.469 | 7.38937 | 0 | 3.93907 | 5323.7 | 18.7 | 213.5 | 114.9 | 580.2 | 416.2 | 3.23658 | 0.391333 | 0.00266667 | 0.487333 | 0.0853333 | 0.0333333 | 0 | 5 |
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 10 | 1 | 301.785 | 2.85358 | 0 | 4.07298 | 5390 | 1.7 | 260 | 65.8 | 600 | 572.9 | 1.11456 | 0.331333 | 0 | 0.668667 | 0 | 0 | 0 | 1 |
| 1 | CVF-AE-w/o-SparsePreservation | 10 | 1 | 307.714 | 3.52705 | 0 | 3.33338 | 5119.4 | 6.4 | 0 | 0 | 589.4 | 497.5 | 1.32195 | 0.571333 | 0 | 0.428667 | 0 | 0 | 0 | 4 |
| 1 | CVF-AE-w/o-CVF | 10 | 1 | 306.072 | 3.00562 | 0 | 3.14166 | 4758.4 | 6.6 | 228.4 | 67.2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 1 | CVF-AE | 10 | 1 | 306.619 | 2.62458 | 0 | 6.08883 | 5360 | 0.9 | 230.4 | 71.6 | 599.6 | 505.3 | 1.2021 | 0.552 | 0 | 0.431333 | 0 | 0 | 0.0166667 | 3 |
| 2 | Base-AE | 10 | 0 | 2481.9 | 250.454 | 12.4 | 4.27276 | 4530 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 2 | CVF-AE-w/o-Init | 10 | 0.9 | 489.35 | 513.841 | 1 | 7.95739 | 5076.3 | 46 | 133.8 | 104.6 | 412.5 | 291 | 2.73972 | 0.728667 | 0 | 0 | 0.0326667 | 0 | 0.0553333 | 5 |
| 2 | CVF-AE-w/o-StateAdaptiveCVF | 10 | 0.9 | 470.078 | 404.529 | 0.8 | 8.95352 | 5197.9 | 34.6667 | 204.6 | 65.3 | 463.3 | 347.9 | 3.12762 | 0.773333 | 0 | 0 | 0 | 0 | 0.036 | 4 |
| 2 | CVF-AE-w/o-SparsePreservation | 10 | 1 | 332.872 | 8.6809 | 0 | 7.63836 | 5083.9 | 26.2 | 0 | 0 | 553.9 | 422.3 | 3.49386 | 0.815333 | 0 | 0 | 0 | 0 | 0.133333 | 3 |
| 2 | CVF-AE-w/o-CVF | 10 | 1 | 328.93 | 9.20081 | 0 | 6.12021 | 4698.7 | 35.1 | 168.7 | 99.6 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 2 | CVF-AE | 10 | 1 | 321.173 | 8.64083 | 0 | 9.22053 | 5261.5 | 28 | 201 | 143.7 | 530.5 | 398.2 | 3.01178 | 0.833333 | 0 | 0 | 0.014 | 0 | 0.096 | 1 |
| 4 | Base-AE | 10 | 0 | 1789.57 | 235.944 | 8.1 | 2.96502 | 4530 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 6 |
| 4 | CVF-AE-w/o-Init | 10 | 0.5 | 771.68 | 469.538 | 2.4 | 6.64816 | 5217.8 | 95.6 | 186.3 | 90.1 | 501.5 | 412.7 | 3.4953 | 0.904667 | 0 | 0 | 0.00733333 | 0 | 0 | 5 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 10 | 1 | 384.362 | 27.9034 | 0 | 6.93084 | 5197.7 | 0 | 67.7 | 36 | 600 | 259.6 | 3.8702 | 0.0513333 | 0 | 0 | 0 | 0 | 0.948667 | 2 |
| 4 | CVF-AE-w/o-SparsePreservation | 10 | 1 | 392.614 | 6.02655 | 0 | 6.4112 | 5130 | 0 | 0 | 0 | 600 | 303 | 3.45861 | 0 | 0 | 0 | 0 | 0 | 1 | 4 |
| 4 | CVF-AE-w/o-CVF | 10 | 1 | 388.389 | 13.195 | 0 | 3.65975 | 4615.5 | 0 | 85.5 | 58.1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 |
| 4 | CVF-AE | 10 | 1 | 367.277 | 29.5101 | 0 | 5.98449 | 5224.6 | 0 | 94.6 | 59.9 | 600 | 296 | 3.52348 | 0.036 | 0 | 0 | 0 | 0 | 0.964 | 1 |
