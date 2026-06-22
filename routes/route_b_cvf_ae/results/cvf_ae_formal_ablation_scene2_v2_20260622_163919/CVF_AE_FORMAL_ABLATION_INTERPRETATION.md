# CVF-AE 正式消融实验结果解释

日期：2026-06-22

## 实验配置

本次实验用于验证 CVF-AE 各机制的贡献。

- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260626`
- resume: enabled

运行记录：

- run records: `540 / 540`
- 主汇总：`cvf_ae_gate_summary.csv`
- 平均排名：`cvf_ae_gate_average_rank.csv`
- 轨迹合理性：`trajectory_sanity_summary.csv`

## 平均排名

| Variant | Average rank |
|---|---:|
| `CVF-AE-w/o-StateAdaptiveCVF` | 1.67 |
| `CVF-AE` | 2.00 |
| `CVF-AE-w/o-CVF` | 3.00 |
| `CVF-AE-w/o-SparsePreservation` | 3.33 |
| `CVF-AE-w/o-Init` | 5.00 |
| `Base-AE` | 6.00 |

## 分场景结果

### Scene 1

| Variant | Mean fitness | Feasible rate | Rank |
|---|---:|---:|---:|
| `CVF-AE-w/o-StateAdaptiveCVF` | 298.13 | 1.00 | 1 |
| `CVF-AE` | 305.85 | 1.00 | 2 |
| `CVF-AE-w/o-CVF` | 306.35 | 1.00 | 3 |
| `CVF-AE-w/o-SparsePreservation` | 307.04 | 1.00 | 4 |
| `CVF-AE-w/o-Init` | 316.79 | 1.00 | 5 |
| `Base-AE` | 711.51 | 0.57 | 6 |

Scene 1 中，`w/o-StateAdaptiveCVF` 的 scalar fitness 明显优于 full `CVF-AE`，且轨迹 sanity 同样稳定。这说明当前状态自适应 CVF 权重在简单场景中可能引入了不必要扰动。

### Scene 2-v2

| Variant | Mean fitness | Feasible rate | Rank |
|---|---:|---:|---:|
| `CVF-AE-w/o-StateAdaptiveCVF` | 301.51 | 1.00 | 1 |
| `CVF-AE-w/o-SparsePreservation` | 302.67 | 1.00 | 2 |
| `CVF-AE` | 303.21 | 1.00 | 3 |
| `CVF-AE-w/o-CVF` | 303.22 | 1.00 | 4 |
| `CVF-AE-w/o-Init` | 312.33 | 1.00 | 5 |
| `Base-AE` | 1586.51 | 0.00 | 6 |

Scene 2-v2 中，full `CVF-AE` 与 `w/o-CVF` 的 mean fitness 几乎相同，说明在中等难度场景中 CVF 的边际收益不强；`w/o-StateAdaptiveCVF` 仍然最优。

### Scene 4

| Variant | Mean fitness | Feasible rate | Rank |
|---|---:|---:|---:|
| `CVF-AE` | 349.34 | 1.00 | 1 |
| `CVF-AE-w/o-CVF` | 355.41 | 1.00 | 2 |
| `CVF-AE-w/o-StateAdaptiveCVF` | 359.23 | 1.00 | 3 |
| `CVF-AE-w/o-SparsePreservation` | 369.71 | 1.00 | 4 |
| `CVF-AE-w/o-Init` | 587.23 | 0.67 | 5 |
| `Base-AE` | 1646.41 | 0.00 | 6 |

Scene 4 是最能体现 full `CVF-AE` 价值的场景。相比 `w/o-CVF` 和 `w/o-StateAdaptiveCVF`，full 版本获得最低 mean fitness，并保持 `100%` 可行率。

## 轨迹合理性

关键轨迹 sanity 结论：

- `CVF-AE` 在三个场景中均没有 high-altitude bypass：
  - Scene 1: `MeanHighAltitudeFrac = 0`
  - Scene 2-v2: `MeanHighAltitudeFrac = 0`
  - Scene 4: `MeanHighAltitudeFrac = 0`
- `w/o-StateAdaptiveCVF` 在 Scene 1/2-v2 也没有 high-altitude bypass，且 fitness 更好。
- Scene 4 中所有 CVF-AE 相关可行变体都存在一定边界靠近倾向，但 full `CVF-AE` 的 `VisualReviewFlagRate = 0.27`，低于 `w/o-StateAdaptiveCVF` 的 `0.50` 和 `w/o-SparsePreservation` 的 `0.53`。

## 机制判断

### 明确成立

1. `Constraint-aware initialization` 是必要机制。
   - `w/o-Init` 在 Scene 4 可行率降至 `0.67`，mean fitness 从 full 的 `349.34` 恶化到 `587.23`。
   - 说明初始化对强约束场景的可行性和稳定性非常关键。

2. CVF 机制在强约束 Scene 4 中有正贡献。
   - full `CVF-AE`: `349.34`
   - `w/o-CVF`: `355.41`
   - 差距不巨大，但方向正确，并且 full 版本轨迹风险略低。

3. Sparse preservation / sparse repair 机制有必要保留。
   - `w/o-SparsePreservation` 在 Scene 4 退化到 `369.71`，且 `VisualReviewFlagRate = 0.53`。

### 需要谨慎表述

`StateAdaptiveCVF` 当前不能作为稳定正贡献来强讲。

- 它在 Scene 4 中有帮助；
- 但在 Scene 1 和 Scene 2-v2 中，关闭状态自适应后的 `w/o-StateAdaptiveCVF` 反而取得更好 scalar fitness；
- 平均排名上，`w/o-StateAdaptiveCVF` 为 `1.67`，full `CVF-AE` 为 `2.00`。

因此论文中不宜把 state-adaptive weighting 写成核心创新点。更合适的处理是：

- 将其表述为增强强约束场景鲁棒性的辅助策略；
- 或在下一轮考虑将状态自适应权重弱化、只在强约束状态触发；
- 核心叙事应回到 CVF direction、constraint-aware initialization 和 low-overhead feasibility-guided evolution。

## 论文叙事建议

正式消融支持以下结论：

> CVF-AE 的主要收益来自约束感知初始化、低开销 CVF 方向引导以及稀疏约束保持机制。完整版本在强约束 Scene 4 中取得最佳结果，并在所有场景保持 100% 可行率和低空轨迹合理性。

但必须避免以下过强表述：

> 每一个模块在所有场景中都带来单调改进。

更稳妥的英文表述：

> The ablation study shows that the initialization and sparse constraint-preserving mechanisms are essential for maintaining feasibility under strong constraints. The CVF component provides its clearest benefit in the most constrained scene, while state-adaptive weighting improves robustness in difficult cases but is not uniformly beneficial across all scene complexities.

## 下一步建议

不建议继续增加消融变体。下一步更有价值的是：

1. 针对 `StateAdaptiveCVF` 做一次小规模机制修正或参数敏感性；
2. 如果不调整代码，则在论文中弱化 state-adaptive weighting 的创新地位；
3. 继续进行统计检验，分别检验 raw fitness 和 trajectory sanity 指标。
