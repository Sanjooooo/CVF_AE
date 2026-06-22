# CVF-AE 保守状态自适应正式消融结果解释

## 实验目的

本次实验用于重新验证默认 `CVF-AE` 在切换到保守状态自适应 CVF 后，各关键模块是否仍然具有稳定正贡献。

本次结果替代旧版激进状态自适应 `CVF-AE` 的正式消融结果。旧版结果只能作为机制调整前的诊断依据，不应继续作为论文最终消融表格。

## 实验配置

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
- base seed: `20260629`
- resume: enabled

## 执行情况

- run records: `540 / 540`
- 已生成 `cvf_ae_gate_runs.csv`
- 已生成 `cvf_ae_gate_summary.csv`
- 已生成 `cvf_ae_gate_average_rank.csv`
- 已生成 `trajectory_sanity_runs.csv`
- 已生成 `trajectory_sanity_summary.csv`
- 已生成 `trajectory_sanity_flags.csv`

执行备注：

- 第一次前台 batch 在 2 小时工具超时后，MATLAB 子进程停留在 Scene 4 `Base-AE` 第 30 个 run 附近，且一段时间内没有继续写入 run record；
- 已终止该 batch 子进程，并使用同一结果目录、`resumeExisting=true` 续跑；
- 续跑成功跳过已完成记录，最终生成完整 540 条 run records、summary 和 trajectory sanity；
- 该中断不影响已保存的 run records 和最终汇总结果。

## 核心结果

平均排名：

- `CVF-AE`: `1.00`
- `CVF-AE-w/o-StateAdaptiveCVF`: `2.33`
- `CVF-AE-w/o-CVF`: `3.00`
- `CVF-AE-w/o-SparsePreservation`: `3.67`
- `CVF-AE-w/o-Init`: `5.00`
- `Base-AE`: `6.00`

分场景 mean best fitness：

- Scene 1:
  - `CVF-AE`: `297.83`
  - `CVF-AE-w/o-StateAdaptiveCVF`: `298.30`
  - `CVF-AE-w/o-CVF`: `306.20`
  - `CVF-AE-w/o-SparsePreservation`: `306.38`
  - `CVF-AE-w/o-Init`: `317.00`
  - `Base-AE`: `654.05`
- Scene 2-v2:
  - `CVF-AE`: `300.66`
  - `CVF-AE-w/o-StateAdaptiveCVF`: `301.82`
  - `CVF-AE-w/o-SparsePreservation`: `303.31`
  - `CVF-AE-w/o-CVF`: `303.77`
  - `CVF-AE-w/o-Init`: `313.22`
  - `Base-AE`: `1597.48`
- Scene 4:
  - `CVF-AE`: `348.59`
  - `CVF-AE-w/o-CVF`: `355.83`
  - `CVF-AE-w/o-StateAdaptiveCVF`: `361.31`
  - `CVF-AE-w/o-SparsePreservation`: `372.23`
  - `CVF-AE-w/o-Init`: `556.75`
  - `Base-AE`: `1643.73`

## 模块贡献判断

保守状态自适应 CVF：

- 新默认 `CVF-AE` 在三个场景中均优于 `CVF-AE-w/o-StateAdaptiveCVF`；
- Scene 1 提升较小，但方向正确；
- Scene 2-v2 和 Scene 4 提升更清晰；
- 说明保守状态调度可以作为稳定正贡献机制保留。

CVF 本体：

- 新默认 `CVF-AE` 在三个场景中均优于 `CVF-AE-w/o-CVF`；
- Scene 4 中提升约 `7.25` fitness，说明 CVF 在强约束场景中仍有明确贡献；
- 评估开销可控，自动 gate note 中 full/no-CVF 的 eval ratio 约为 `1.01`。

约束感知初始化：

- `w/o-Init` 在 Scene 4 feasible rate 降至 `0.70`，mean best fitness 恶化到 `556.75`；
- Base-AE 在 Scene 2-v2 和 Scene 4 feasible rate 为 `0`；
- 初始化仍是保证强约束低空 UAV 场景可行性的必要模块。

稀疏保留：

- `w/o-SparsePreservation` 在三个场景中均弱于完整 `CVF-AE`；
- Scene 4 中 mean best fitness 为 `372.23`，明显弱于完整 `CVF-AE = 348.59`；
- 该模块应继续保留。

## 轨迹 sanity

完整 `CVF-AE`：

- 三个场景 feasible rate 均为 `1.00`；
- 三个场景 mean high-altitude fraction 均为 `0`；
- Scene 1 和 Scene 2-v2 的 `VisualReviewFlagRate = 0`；
- Scene 4 的 `VisualReviewFlagRate = 0.20`。

Scene 4 对比：

- `CVF-AE`: `VisualReviewFlagRate = 0.20`, `MeanBoundaryHugFrac = 0.269`
- `CVF-AE-w/o-CVF`: `VisualReviewFlagRate = 0.30`, `MeanBoundaryHugFrac = 0.380`
- `CVF-AE-w/o-StateAdaptiveCVF`: `VisualReviewFlagRate = 0.533`, `MeanBoundaryHugFrac = 0.543`
- `CVF-AE-w/o-SparsePreservation`: `VisualReviewFlagRate = 0.60`, `MeanBoundaryHugFrac = 0.636`

因此，本次正式消融不仅支持 scalar fitness 排名，也支持轨迹合理性维度上的完整方法优势。

## 阶段判断

本次正式消融通过，可以将新的保守状态自适应 `CVF-AE` 作为论文主方法默认版本。

下一步建议：

- 基于新默认 `CVF-AE` 重跑或补跑正式主对比结果；
- 如果节省时间，可优先只重跑 `CVF-AE` 主对比行并与已有 baseline 合并，但最终论文表格更稳妥的做法是全量重跑主对比；
- 后续所有论文消融叙事应使用本目录结果，不再使用旧版激进状态自适应消融结果。
