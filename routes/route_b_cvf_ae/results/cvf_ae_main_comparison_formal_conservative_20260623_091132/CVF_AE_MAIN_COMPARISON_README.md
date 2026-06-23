# CVF-AE 正式主对比实验记录

- 模式: `formal`
- 场景: `[1 2 4]`
- 算法: `CVF-AE, AE, PSO, GWO, WOA, HHO, DBO, CPO`
- nRuns: `30`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260630`

本次实验使用统一 UAV B-spline 编码、统一 `fitnessFAEAE` 评价函数、统一边界投影和 Deb 可行性优先准则。

主要输出：

- `uav_comparison_runs.csv`
- `uav_comparison_summary_long.csv`
- `uav_comparison_average_rank.csv`
- `trajectory_sanity_runs.csv`
- `trajectory_sanity_summary.csv`
- `trajectory_sanity_flags.csv`
- `run_records/`

## 平均排名

- `CVF-AE`: `1.3333`
- `CPO`: `2.0000`
- `DBO`: `2.6667`
- `GWO`: `4.0000`
- `HHO`: `5.3333`
- `PSO`: `5.6667`
- `WOA`: `7.0000`
- `AE`: `8.0000`

## 备注

本目录使用新的默认 `CVF-AE`，即保守状态自适应 CVF 调度版本。论文主表和轨迹 sanity 讨论应优先使用本目录结果。
