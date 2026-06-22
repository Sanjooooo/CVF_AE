# CVF-AE 主对比实验方案

日期：2026-06-22

## 1. 实验定位

主对比用于验证 `CVF-AE` 在强约束低空 UAV 路径规划中的综合竞争力。该阶段不再继续调参，不修改 Scene 4，不恢复 code Scene 3，也不引入路线 A 叙事。

本阶段核心问题：

- `CVF-AE` 相比经典群智能算法是否有更稳定的可行路径形成能力；
- `CVF-AE` 相比高被引和近年强基线是否仍能保持路径质量优势；
- `CVF-AE` 的额外开销是否被 `runtime`、`nEvals`、`repairCount`、`CVFCount` 约束在可解释范围内。

## 2. 算法分组

### 2.1 主排名组

主排名组使用同一 B-spline 控制点编码、同一 `fitnessFAEAE` 评价函数、同一边界投影和 Deb 可行性优先准则。

| 类别 | 算法 | 用途 |
|---|---|---|
| 本文方法 | `CVF-AE` | 主方法 |
| 骨架基线 | `AE` | 验证相对基础 AE 的收益 |
| 经典高被引 | `PSO` | 经典连续群智能基线 |
| 经典高被引 | `GWO` | UAV 路径规划常见基线 |
| 经典高被引 | `WOA` | 常见群智能路径规划基线 |
| 近年来强基线 | `HHO` | 2019 后常用强基线 |
| 近年来新算法 | `DBO` | 2022 新型群智能算法 |
| 近年来新算法 | `CPO` | 2024 新型群智能算法 |

### 2.2 工程参考组

`A*` 和 `RRT*` 暂不纳入同一 Friedman 平均排名。原因是它们的搜索范式、离散化方式和路径表示不同。后续如需加入，应单独作为工程参考表，报告可行性、路径长度、运行时间和路径平滑后质量。

## 3. 复现完整性要求

每个群智能 baseline 必须满足：

- 独立实现其核心更新公式或核心行为机制；
- 使用相同 `popSize`、`maxIter`、`nRuns` 和随机种子派生规则；
- 不调用 `CVF-AE` 的 CVF 场、状态自适应 CVF 权重或稀疏可行性保持机制；
- 不使用 `CVF-AE` 的专有约束状态初始化，除非作为单独公平初始化补充实验；
- 统一使用 Deb 可行性优先准则更新个体最优或全局最优；
- 统一报告 `runtime`、`nEvals`、可行率和最终违反量。

已接入的 baseline：

- `optimizer_PSO_uav.m`
- `optimizer_GWO_uav.m`
- `optimizer_WOA_uav.m`
- `optimizer_HHO_uav.m`
- `optimizer_DBO_uav.m`
- `optimizer_CPO_uav.m`

## 4. 实验配置

预检配置：

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- `nRuns = 3`
- `popSize = 20`
- `maxIter = 80`
- `baseSeed = 20260624`

正式配置：

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- `nRuns = 30`
- `popSize = 30`
- `maxIter = 300`
- `baseSeed = 20260624`

## 5. 指标

主表指标：

- `FeasibleRate`
- `MeanBestFitness`
- `StdBestFitness`
- `MeanFinalViolation`
- `MeanRuntime`
- `MeanNEvals`
- `MeanFirstFeasibleIter`
- `MeanRepairCount`
- `MeanRepairSuccessCount`
- `Friedman average rank`

`CVF-AE` 额外报告：

- `MeanViabilityFieldCount`
- `MeanViabilityFieldSuccessCount`

统计检验：

- Friedman 平均排名；
- `CVF-AE` 对每个 baseline 的 Wilcoxon signed-rank test；
- 显著性阈值暂定为 `p < 0.05`。

## 6. 执行顺序

1. 完成主对比 runner 接口预检；
2. 运行 `run_cvf_ae_main_comparison('smoke')`，确认新增算法无语法和接口错误；
3. 运行 `run_cvf_ae_main_comparison('precheck')`，检查所有算法在三场景下都能输出统计表；
4. 若预检通过，再显式运行 `run_cvf_ae_main_comparison('formal')`；
5. 正式结果完成后再决定是否增加工程参考组或 CEC 补充实验。

## 7. 断点续跑

主对比 runner 会为每个 `(scene, algorithm, run)` 保存独立记录：

- `run_records/scene{sceneId}_{ALG}_run{runId}.mat`

当 `cfg.resumeExisting = true` 时，runner 会先检查对应 `.mat` 文件：

- 已存在且包含 `result` 字段：直接加载并进入汇总；
- 不存在：正常运行并保存；
- 文件存在但缺少 `result` 字段：重新计算该 run。

正式主对比如果中断，可运行：

```matlab
run_cvf_ae_main_comparison('resume-formal')
```

该模式会自动寻找最新的 `cvf_ae_main_comparison_formal_*` 结果目录，并只补跑缺失的 run。

## 8. 当前边界

- 不做 CEC 主线实验；
- 不把 `A*`、`RRT*` 和群智能算法混排为同一平均排名；
- 不修改 Scene 4 地图；
- 不恢复 code Scene 3；
- 不为了提升 `CVF-AE` 排名继续调参。
