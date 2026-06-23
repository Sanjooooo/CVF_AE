# CVF-AE 保守状态自适应正式主对比结果解释

## 实验目的

本次实验基于新的默认 `CVF-AE`，即保守状态自适应 CVF 调度版本，重新生成正式主对比结果。

本目录结果应替代旧版完整 `CVF-AE` 的主对比结果，作为后续论文主表和轨迹 sanity 讨论的主要依据。

## 实验配置

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260630`
- resume: enabled

## 执行情况

- run records: `720 / 720`
- 已生成 `uav_comparison_runs.csv`
- 已生成 `uav_comparison_summary_long.csv`
- 已生成 `uav_comparison_average_rank.csv`
- 已生成 `trajectory_sanity_runs.csv`
- 已生成 `trajectory_sanity_summary.csv`
- 已生成 `trajectory_sanity_flags.csv`

执行备注：

- 本次主对比曾在个别 baseline run 上出现长时间无新 run record 且 MATLAB CPU 基本不增长的停滞；
- 已使用同一结果目录和 `resumeExisting=true` 断点续跑；
- 已完成的 run records 被成功复用，没有重跑已完成部分；
- 最终 summary 和 trajectory sanity 均正常生成。

## 核心数值结果

平均排名：

- `CVF-AE`: `1.33`
- `CPO`: `2.00`
- `DBO`: `2.67`
- `GWO`: `4.00`
- `HHO`: `5.33`
- `PSO`: `5.67`
- `WOA`: `7.00`
- `AE`: `8.00`

分场景排名：

- Scene 1: `CVF-AE` rank 1, `CPO` rank 2, `DBO` rank 3
- Scene 2-v2: `CPO` rank 1, `CVF-AE` rank 2, `DBO` rank 3
- Scene 4: `CVF-AE` rank 1, `DBO` rank 2, `CPO` rank 3

分场景 mean best fitness：

- Scene 1:
  - `CVF-AE`: `298.14`
  - `CPO`: `298.36`
  - `DBO`: `344.88`
  - `GWO`: `345.37`
- Scene 2-v2:
  - `CPO`: `278.12`
  - `CVF-AE`: `301.20`
  - `DBO`: `337.79`
  - `GWO`: `341.16`
- Scene 4:
  - `CVF-AE`: `349.23`
  - `DBO`: `376.30`
  - `CPO`: `519.88`
  - `GWO`: `608.46`

## 轨迹 sanity

完整 `CVF-AE`：

- Scene 1:
  - feasible rate: `1.00`
  - mean high-altitude fraction: `0`
  - visual review flag rate: `0`
- Scene 2-v2:
  - feasible rate: `1.00`
  - mean high-altitude fraction: `0`
  - visual review flag rate: `0`
- Scene 4:
  - feasible rate: `1.00`
  - mean high-altitude fraction: `0.0009`
  - mean boundary-hug fraction: `0.249`
  - visual review flag rate: `0.20`

`CPO` 的解释重点：

- Scene 2-v2 中 `CPO` raw fitness 最低，rank 1；
- 但 `CPO` 的 mean high-altitude fraction 为 `0.882`，visual review flag rate 为 `1.00`；
- Scene 1 中 `CPO` 的 mean high-altitude fraction 为 `0.663`，visual review flag rate 为 `0.80`；
- Scene 4 中 `CPO` feasible rate 仅 `0.733`，visual review flag rate 为 `1.00`；
- 因此，`CPO` 应保留在主对比表中作为强 baseline，但论文中必须说明其低 scalar fitness 很大程度来自 mission-inconsistent high-altitude / boundary-hugging behavior，不应被解释为低空 UAV 任务质量最优。

## 论文表述建议

- 主表可以报告 raw fitness、feasible rate、平均排名；
- 同时需要配套 trajectory sanity 表或图，说明 `CVF-AE` 的优势不是单纯压低 scalar fitness，而是在可行性、低空一致性和轨迹合理性之间取得更稳的平衡；
- Scene 2-v2 中不应声称 `CVF-AE` raw fitness 第一，应表述为 `CVF-AE` 在保持低空任务一致性的算法中表现最佳或最稳；
- Scene 4 是最能体现 `CVF-AE` 优势的主场景：`CVF-AE` 同时取得 rank 1、feasible rate 1.00 和较低 visual review flag。

## 阶段判断

新的默认 `CVF-AE` 正式主对比通过。

后续建议：

- 使用本目录作为论文正式主对比结果来源；
- 下一步生成论文表格和主对比轨迹图；
- 对 `CPO` 单独标注 trajectory sanity 风险，避免读者只看 Scene 2-v2 raw fitness 得出误判。
