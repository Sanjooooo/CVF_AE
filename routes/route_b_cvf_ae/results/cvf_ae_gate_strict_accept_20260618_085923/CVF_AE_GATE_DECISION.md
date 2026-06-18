# CVF-AE Small Gate Decision

- Scenes: `[2 4]`
- Algorithms: `Base-AE, CVF-AE, CVF-AE-w/o-CVF, CVF-AE-w/o-Init`
- nRuns: `5`
- popSize: `20`
- maxIter: `80`
- baseSeed: `20260618`

## Decision

**Enter medium gate**

CVF-AE improved at least one gate metric on Scene 2 or 4 without excessive evaluation/runtime overhead. Do not run medium gate automatically.

## Gate Notes

- Scene 2: evidence=1, evalRatio=1.092, runtimeRatio=1.271
- Scene 4: evidence=1, evalRatio=1.099, runtimeRatio=1.325

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
| 2 | Base-AE | 5 | 0.2 | 2661.47 | 1367.47 | 12.2 | 0.850751 | 1620 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 4 |
| 2 | CVF-AE | 5 | 1 | 331.596 | 11.7298 | 0 | 1.46859 | 1859.6 | 15.8 | 97.4 | 65.4 | 142.2 | 104 | 3.36216 | 0.555 | 0 | 0 | 0.025 | 0.025 | 0.295 | 2 |
| 2 | CVF-AE-w/o-CVF | 5 | 1 | 323.539 | 12.49 | 0 | 1.15546 | 1703.6 | 16.2 | 83.6 | 48.4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| 2 | CVF-AE-w/o-Init | 5 | 0.6 | 755.568 | 623.897 | 2 | 1.13093 | 1730.8 | 41.6667 | 31 | 19.8 | 79.8 | 61 | 2.0192 | 0.5575 | 0 | 0 | 0.025 | 0.0125 | 0 | 3 |
| 4 | Base-AE | 5 | 0 | 1899.18 | 168.717 | 9.2 | 0.868702 | 1620 | NaN | NaN | NaN | 0 | 0 | NaN | 0 | 0 | 0 | 0 | 0 | 0 | 4 |
| 4 | CVF-AE | 5 | 1 | 385.777 | 23.7562 | 0 | 1.33152 | 1814 | 0 | 34 | 23.8 | 160 | 80.8 | 4.2093 | 0.0925 | 0 | 0 | 0 | 0 | 0.9075 | 1 |
| 4 | CVF-AE-w/o-CVF | 5 | 1 | 400.58 | 6.42352 | 0 | 1.00466 | 1650.2 | 0 | 30.2 | 24.4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 |
| 4 | CVF-AE-w/o-Init | 5 | 0.2 | 1466.28 | 699.158 | 6.8 | 1.39567 | 1804.4 | 51 | 76 | 31 | 108.4 | 90.8 | 3.01645 | 0.76 | 0 | 0 | 0 | 0 | 0 | 3 |
