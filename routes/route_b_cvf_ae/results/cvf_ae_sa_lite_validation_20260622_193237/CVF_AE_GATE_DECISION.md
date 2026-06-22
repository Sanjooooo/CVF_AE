# CVF-AE SA-lite Validation Decision

- Scenes: `[1 2 4]`
- Algorithms: `CVF-AE-SA-lite, CVF-AE-w/o-StateAdaptiveCVF, CVF-AE`
- nRuns: `10`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260627`

## Decision

**Do not enter medium gate**

Required full and w/o-CVF rows are missing.

## Average Rank

| Algorithm | AverageRank |
|---|---|
| CVF-AE-SA-lite | 1 |
| CVF-AE-w/o-StateAdaptiveCVF | 2.33333 |
| CVF-AE | 2.66667 |

## Summary

| Scene | Algorithm | NumRuns | FeasibleRate | MeanBestFitness | StdBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanRepairSuccessCount | MeanViabilityFieldCount | MeanViabilityFieldSuccessCount | MeanViabilityFieldNorm | MeanCVFObstacleFrac | MeanCVFNFZFrac | MeanCVFRiskFrac | MeanCVFAltitudeFrac | MeanCVFCurvatureFrac | MeanCVFBoundaryFrac | Rank |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | CVF-AE-SA-lite | 10 | 1 | 299.095 | 3.85757 | 0 | 6.28011 | 9575.2 | 5.8 | 514.3 | 142.9 | 30.9 | 27.7 | 0.134768 | 0.0473333 | 0 | 0.03 | 0 | 0.00633333 | 0 | 1 |
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 10 | 1 | 299.334 | 2.74319 | 0 | 6.13214 | 9572.4 | 4.5 | 515.5 | 144.3 | 26.9 | 25.6 | 0.0675298 | 0.0546667 | 0 | 0.019 | 0 | 0 | 0.001 | 2 |
| 1 | CVF-AE | 10 | 1 | 308.203 | 2.32094 | 0 | 6.07971 | 9583.3 | 1.4 | 449.8 | 154.7 | 103.5 | 85.1 | 0.57562 | 0.213 | 0 | 0.0903333 | 0 | 0.00733333 | 0.025 | 3 |
| 2 | CVF-AE-SA-lite | 10 | 1 | 302.033 | 3.95845 | 0 | 6.20813 | 9557.8 | 6.6 | 511.4 | 317.9 | 16.4 | 12.2 | 0.1582 | 0.033 | 0 | 0 | 0 | 0.000333333 | 0.00666667 | 1 |
| 2 | CVF-AE-w/o-StateAdaptiveCVF | 10 | 1 | 302.075 | 3.40387 | 0 | 6.27348 | 9573.8 | 19.9 | 501.4 | 320.9 | 42.4 | 25.6 | 0.322705 | 0.0746667 | 0 | 0 | 0 | 0.00233333 | 0.00633333 | 2 |
| 2 | CVF-AE | 10 | 1 | 304.387 | 7.33067 | 0 | 6.04472 | 9501.1 | 5.1 | 393 | 227 | 78.1 | 53.3 | 0.894844 | 0.186667 | 0.00933333 | 0 | 0 | 0.02 | 0.024 | 3 |
| 4 | CVF-AE-SA-lite | 10 | 1 | 351.827 | 21.5609 | 0 | 5.91587 | 9347.3 | 0 | 227.1 | 148.5 | 90.2 | 62 | 1.1875 | 0.260333 | 0 | 0 | 0 | 0 | 0.0403333 | 1 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 10 | 1 | 368.528 | 35.4686 | 0 | 5.73482 | 9292.1 | 0 | 181.2 | 102.1 | 80.9 | 52.8 | 0.797194 | 0.269667 | 0 | 0 | 0 | 0 | 0 | 3 |
| 4 | CVF-AE | 10 | 1 | 352.26 | 20.6507 | 0 | 5.88047 | 9336.4 | 0 | 219.1 | 149 | 87.3 | 58.5 | 0.999459 | 0.285333 | 0.00366667 | 0 | 0 | 0 | 0.002 | 2 |
