# CVF-AE 主对比预检解释

日期：2026-06-22

结果目录：

`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_precheck_20260622_101130`

## 1. 配置

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- `nRuns = 3`
- `popSize = 20`
- `maxIter = 80`
- `baseSeed = 20260624`

完成情况：

- completed runs: `72 / 72`
- 所有算法均完成统一 CSV 输出；
- `DBO` 和 `CPO` 的接口、边界投影、Deb 规则和结果字段均通过 runner 预检。

## 2. 平均排名

| Algorithm | Average rank |
|---|---:|
| `CVF-AE` | 1.33 |
| `CPO` | 2.00 |
| `DBO` | 3.00 |
| `GWO` | 5.00 |
| `WOA` | 5.00 |
| `HHO` | 6.00 |
| `PSO` | 6.33 |
| `AE` | 7.33 |

## 3. 场景观察

Scene 1:

- `CVF-AE` rank 1，mean best fitness 为 `308.16`；
- `CPO` rank 2，mean best fitness 为 `318.37`；
- `DBO`、`GWO`、`PSO` 均达到 `100%` feasible rate，但 fitness 不如 `CVF-AE`。

Scene 2:

- `CPO` rank 1，mean best fitness 为 `324.19`；
- `CVF-AE` rank 2，mean best fitness 为 `325.70`；
- `CVF-AE`、`CPO`、`DBO`、`WOA` 均达到 `100%` feasible rate；
- 该场景显示 `CPO` 是需要认真对待的强 baseline。

Scene 4:

- `CVF-AE` rank 1，mean best fitness 为 `390.73`；
- `DBO` rank 2，mean best fitness 为 `415.14`；
- `AE`、`PSO`、`GWO`、`WOA`、`HHO` 在该预检配置下 feasible rate 均为 `0`；
- 该场景仍明显支持 `CVF-AE` 在强约束布局中的优势。

## 4. 成本观察

`CVF-AE` 因初始化、CVF 和 repair 机制产生额外 evaluation：

- Scene 1: `1765.0` vs 普通群智能 baseline 的 `1620.0`
- Scene 2: `1729.7` vs `1620.0`
- Scene 4: `1658.7` vs `1620.0`

该开销在预检规模下是可控的。正式实验仍需重点报告 `runtime`、`nEvals`、`repairCount` 和 `viabilityFieldCount`。

## 5. 判断

判断：主对比预检通过，可以进入正式主对比。

依据：

- 所有 8 个算法均完成三场景预检；
- `CVF-AE` 平均排名第一；
- 新增 `DBO`、`CPO` baseline 能稳定输出；
- 结果表已包含主对比所需的 runtime、nEvals、repair 和 CVF 计数。

注意：

- 本结果仅用于验证实验链路，不作为论文正式结论；
- `CPO` 在 Scene 2 与 `CVF-AE` 非常接近甚至略优，正式实验需要重点关注；
- 不建议为消除 Scene 2 的强 baseline 压力继续调整 `CVF-AE` 参数。
