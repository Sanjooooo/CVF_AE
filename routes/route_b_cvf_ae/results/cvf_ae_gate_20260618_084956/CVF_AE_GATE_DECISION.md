# CVF-AE Small Gate Decision

- Scenes: `[2 4]`
- Algorithms: `Base-AE, CVF-AE, CVF-AE-w/o-CVF, CVF-AE-w/o-Init`
- nRuns: `5`
- popSize: `20`
- maxIter: `80`
- baseSeed: `20260618`

## Decision

**Do not enter medium gate**

Small gate did not justify medium validation. Either CVF evidence was absent on both scenes or overhead was too high.

## Gate Notes

- Scene 2: evidence=0, evalRatio=1.252, runtimeRatio=1.721
- Scene 4: evidence=1, evalRatio=1.248, runtimeRatio=1.804

## Average Rank

| Algorithm | AverageRank |
|---|---|
| CVF-AE | 1.5 |
| CVF-AE-w/o-CVF | 1.5 |
| CVF-AE-w/o-Init | 3 |
| Base-AE | 4 |

## Summary

| Scene | Algorithm | NumRuns | FeasibleRate | MeanBestFitness | StdBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanRepairSuccessCount | MeanViabilityFieldCount | MeanViabilityFieldSuccessCount | MeanViabilityFieldNorm | MeanCVFObstacleFrac | MeanCVFNFZFrac | MeanCVFRiskFrac | MeanCVFAltitudeFrac | MeanCVFCurvatureFrac | MeanCVFBoundaryFrac | Rank |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2 | Base-AE | 5 | 0.2 | 2661.47 | 1367.47 | 12.2 | 0.899536 | 1620 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 4 |
| 2 | CVF-AE | 5 | 1 | 343.904 | 12.0441 | 0 | 2.04666 | 2133.4 | 19.6 | 113.4 | 74.2 | 400 | 262.4 | 4.78073 | 0.635 | 0 | 0 | 0 | 0 | 0.365 | 2 |
| 2 | CVF-AE-w/o-CVF | 5 | 1 | 323.539 | 12.49 | 0 | 1.18905 | 1703.6 | 16.2 | 83.6 | 48.4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| 2 | CVF-AE-w/o-Init | 5 | 0.6 | 1077.8 | 1005.19 | 4.6 | 1.74514 | 2047.4 | 37 | 27.4 | 17.2 | 400 | 257.4 | 5.94509 | 0.995 | 0 | 0 | 0.005 | 0 | 0 | 3 |
| 4 | Base-AE | 5 | 0 | 1899.18 | 168.717 | 9.2 | 0.879372 | 1620 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 4 |
| 4 | CVF-AE | 5 | 1 | 393.875 | 5.83732 | 0 | 1.82085 | 2059.4 | 0 | 39.4 | 28.6 | 400 | 173.2 | 4.84602 | 0 | 0 | 0 | 0 | 0 | 1 | 1 |
| 4 | CVF-AE-w/o-CVF | 5 | 1 | 400.58 | 6.42352 | 0 | 1.0094 | 1650.2 | 0 | 30.2 | 24.4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 4 | CVF-AE-w/o-Init | 5 | 0 | 1865.61 | 405.673 | 9.2 | 1.95867 | 2094 | NaN | 74 | 24 | 400 | 266.8 | 5.80383 | 1 | 0 | 0 | 0 | 0 | 0 | 3 |
