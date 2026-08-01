# Internal template-initialization ablation summary

This output is for internal review only. No paper figures or LaTeX tables are generated.

## Aggregate results

| Condition | N | Mean fitness | Std | Median | Feasible rate | Mean violation | Mean evaluations | Mean CVF triggers |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| template_on | 30 | 344.242892 | 18.806494 | 341.417588 | 1.0000 | 0.000000 | 9362.67 | 88.87 |
| template_off | 30 | 477.179717 | 280.629706 | 342.471549 | 0.7333 | 0.866667 | 9680.97 | 355.03 |

## Distribution comparison

- Two-sided Mann--Whitney U / rank-sum p: 0.652044
- Reject at 0.05: 0
- Cliff's delta (template-on lower-is-better): 0.008889
- Feasible runs, template on / off: 30 / 22
- Two-sided Fisher exact p for feasible rate: 0.00457506
- Mean paired seed difference, off minus on: 132.936825

Positive off-minus-on fitness means templates reduced the final scalar fitness under the matched seed list.
