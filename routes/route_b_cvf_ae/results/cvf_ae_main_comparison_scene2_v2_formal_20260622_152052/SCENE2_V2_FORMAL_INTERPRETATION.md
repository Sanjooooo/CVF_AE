# Scene 2-v2 正式主对比结果解释

日期：2026-06-22

## 实验说明

本结果只针对冻结后的 Scene 2-v2 重新运行正式主对比。Scene 1 和 Scene 4 未修改，因此不在本目录中重复运行。

配置：

- scene: `2`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260624`
- resume: enabled

## Raw Fitness 结果

| Algorithm | Mean fitness | Rank | Feasible rate |
|---|---:|---:|---:|
| `CPO` | 278.94 | 1 | 1.00 |
| `CVF-AE` | 302.75 | 2 | 1.00 |
| `DBO` | 337.29 | 3 | 1.00 |
| `GWO` | 342.91 | 4 | 1.00 |
| `HHO` | 380.68 | 5 | 0.93 |
| `PSO` | 641.75 | 6 | 0.50 |
| `WOA` | 961.45 | 7 | 0.37 |
| `AE` | 1659.24 | 8 | 0.00 |

## 轨迹合理性结果

| Algorithm | MeanZ | MeanHighAltitudeFrac | MeanBoundaryHugFrac | VisualReviewFlagRate |
|---|---:|---:|---:|---:|
| `CVF-AE` | 15.99 | 0.00 | 0.12 | 0.00 |
| `CPO` | 28.22 | 0.88 | 0.00 | 1.00 |
| `GWO` | 15.12 | 0.08 | 0.82 | 1.00 |
| `DBO` | 20.78 | 0.44 | 0.56 | 0.93 |
| `HHO` | 20.33 | 0.40 | 0.40 | 0.80 |
| `WOA` | 26.23 | 0.75 | 0.39 | 0.97 |
| `PSO` | 23.58 | 0.49 | 0.16 | 0.60 |
| `AE` | 20.05 | 0.07 | 0.00 | 0.03 |

## 判断

`CPO` 在 Scene 2-v2 的 raw fitness 上排名第一，但其最优解和总体轨迹统计均表现出明显 high-altitude bypass 倾向。该结果应解释为 numerical fitness advantage with mission-semantics risk，而不是低空 UAV 路径规划意义下的全面优势。

`CVF-AE` 在 raw fitness 上排名第二，但保持 `100%` 可行率，并且 `MeanZ` 接近参考巡航高度，`MeanHighAltitudeFrac = 0`，`VisualReviewFlagRate = 0`。这说明 `CVF-AE` 更符合本文强调的 low-altitude, mission-consistent trajectory 目标。

论文中建议保留 `CPO` 作为强 baseline，但必须同时报告轨迹合理性指标，避免只用 scalar objective value 解释算法优劣。
