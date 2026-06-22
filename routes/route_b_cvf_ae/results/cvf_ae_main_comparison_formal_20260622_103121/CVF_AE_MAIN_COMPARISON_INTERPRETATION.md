# CVF-AE 正式主对比结果解释

日期：2026-06-22

结果目录：

`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_20260622_103121`

## 1. 配置

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- `nRuns = 30`
- `popSize = 30`
- `maxIter = 300`
- `baseSeed = 20260624`

完成情况：

- completed runs: `720 / 720`
- 每个 run 均有独立 `run_records/*.mat` 断点记录；
- 中断续跑机制已在正式目录中生效。

## 2. 平均排名

| Algorithm | Average rank |
|---|---:|
| `CVF-AE` | 1.67 |
| `CPO` | 1.67 |
| `DBO` | 3.00 |
| `GWO` | 3.67 |
| `HHO` | 5.33 |
| `PSO` | 5.67 |
| `WOA` | 7.00 |
| `AE` | 8.00 |

## 3. 分场景结果

| Scene | Best rank | `CVF-AE` rank | `CVF-AE` mean fitness | `CVF-AE` feasible rate | 主要强基线 |
|---:|---|---:|---:|---:|---|
| 1 | `CPO` | 2 | 305.77 | 1.00 | `CPO` mean fitness 299.35 |
| 2 | `CPO` | 2 | 321.08 | 1.00 | `CPO` mean fitness 301.87 |
| 4 | `CVF-AE` | 1 | 352.57 | 1.00 | `DBO` mean fitness 377.99 |

## 4. 主要结论

正式主对比支持 `CVF-AE` 进入论文主方法，但结论必须写得保守。

支持证据：

- `CVF-AE` 与 `CPO` 并列平均排名第一；
- `CVF-AE` 在三个场景均达到 `100%` feasible rate；
- `CVF-AE` 在 Scene 4 明确排名第一，适合作为强约束场景的主要证据；
- `CVF-AE` 明显优于基础 `AE`，也明显优于 `PSO`、`WOA`、`HHO`；
- `DBO` 在 Scene 4 达到 `100%` feasible rate，但 mean fitness 仍弱于 `CVF-AE`。

边界与风险：

- `CPO` 在 Scene 1 和 Scene 2 均优于 `CVF-AE`，且平均排名与 `CVF-AE` 并列第一；
- 因此不能写成 `CVF-AE` 全面优于所有近年来新算法；
- 更稳妥的表述是：`CVF-AE` 在强约束 Scene 4 中表现最优，并在总体排名上达到与强近年算法 `CPO` 并列第一；
- `CVF-AE` 的 runtime 和 nEvals 高于普通 baseline，需要在论文中解释为由初始化、CVF 和 sparse repair 带来的可控成本。

## 5. 成本观察

`CVF-AE` 平均 evaluation 数：

- Scene 1: `9554.97`
- Scene 2: `9492.23`
- Scene 4: `9345.53`

普通群智能 baseline 多数为 `9030` evaluations；`HHO` 因 rapid dives 约为 `11440` 至 `11492` evaluations。

`CVF-AE` 平均 runtime：

- Scene 1: `8.14s`
- Scene 2: `8.73s`
- Scene 4: `7.72s`

该成本高于 `DBO/CPO/GWO/PSO/WOA`，但低于或接近部分 `HHO` 场景。论文应同时报告质量、可行率和成本，而不是只报告 fitness。

## 6. 下一步建议

建议进入结果分析与论文表格阶段，而不是继续调参。

优先工作：

- 生成主对比正式表格；
- 生成收敛曲线与箱线图；
- 对 `CVF-AE` vs `CPO` 做 Wilcoxon signed-rank test；
- 对 Scene 4 做重点路径可视化；
- 在论文中明确 `CPO` 是最强外部 baseline，避免过度声称。

不建议：

- 不为了超过 `CPO` 继续调整 `CVF-AE`；
- 不修改 Scene 4；
- 不恢复 code Scene 3；
- 不把 CEC 作为当前主线。
