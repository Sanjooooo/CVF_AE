# CVF-AE 保守状态自适应机制验证说明

## 实验目的

本次实验用于检查 `StateAdaptiveCVF` 的机制修正是否能从“不稳定正贡献”调整为“稳定或至少更可靠的正贡献”。

此前正式消融结果显示，旧版完整 `CVF-AE` 在 Scene 1 和 Scene 2-v2 上弱于 `CVF-AE-w/o-StateAdaptiveCVF`，说明原状态自适应权重过于激进，不适合直接作为核心正贡献机制写入论文。

## 机制调整

新增 `CVF-AE-SA-lite`，作为保守状态自适应版本：

- 默认进入 preservation 状态，避免频繁改变 CVF 引导强度；
- 只有在可行解缺失、可行率偏低或约束违反偏高时，才连续确认后切换到 formation；
- 只有在停滞且可行率不足、平均违反仍明显存在时，才连续确认后切换到 recovery；
- 降低 formation/recovery/refinement 每代候选比例，限制额外评估开销；
- 降低 conservative 状态下的 CVF 步长权重，避免过强场方向造成绕边或高空规避。

## 验证配置

- scenes: `[1, 2, 4]`
- algorithms:
  - `CVF-AE-SA-lite`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE`
- runs: `10`
- population size: `30`
- max iterations: `300`
- base seed: `20260627`

## 结果摘要

平均排名：

- `CVF-AE-SA-lite`: `1.00`
- `CVF-AE-w/o-StateAdaptiveCVF`: `2.33`
- `CVF-AE`: `2.67`

分场景 mean best fitness：

- Scene 1:
  - `CVF-AE-SA-lite`: `299.10`
  - `CVF-AE-w/o-StateAdaptiveCVF`: `299.33`
  - old `CVF-AE`: `308.20`
- Scene 2-v2:
  - `CVF-AE-SA-lite`: `302.03`
  - `CVF-AE-w/o-StateAdaptiveCVF`: `302.08`
  - old `CVF-AE`: `304.39`
- Scene 4:
  - `CVF-AE-SA-lite`: `351.83`
  - `CVF-AE-w/o-StateAdaptiveCVF`: `368.53`
  - old `CVF-AE`: `352.26`

轨迹 sanity：

- 三个场景中 `CVF-AE-SA-lite` feasible rate 均为 `1.00`；
- `CVF-AE-SA-lite` 没有出现 high-altitude bypass；
- Scene 4 中 `CVF-AE-SA-lite` 的 `VisualReviewFlagRate = 0.30`，低于 `w/o-StateAdaptiveCVF = 0.60`，但略高于旧 `CVF-AE = 0.20`；
- Scene 4 的边界风险仍需在最终轨迹图中保留人工 sanity check，不应只看 scalar fitness。

## 判断

本次小规模验证支持将 `CVF-AE-SA-lite` 的保守状态自适应策略提升为默认 `CVF-AE` 实现。

论文叙事建议：

- 不再强调“激进状态切换”；
- 将 state-adaptive CVF 写成“conservative state-conditioned CVF scheduling”；
- 强调它的作用是避免 CVF 在低风险阶段过度干预，同时在不可行或停滞阶段提供有限的方向性修正；
- 后续正式主对比和正式消融表格需要基于新的默认 `CVF-AE` 重新生成，旧版完整 `CVF-AE` 结果不能再作为最终论文表格。
