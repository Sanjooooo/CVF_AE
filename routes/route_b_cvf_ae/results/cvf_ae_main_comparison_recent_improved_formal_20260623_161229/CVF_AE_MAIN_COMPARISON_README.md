# CVF-AE 主对比实验记录

- 模式: `recent_improved_formal`
- 场景: `[1 2 4]`
- 算法: `GDSAO, ERIME, MSCSO`
- nRuns: `30`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260701`

本 runner 使用统一 UAV B-spline 编码、统一 `fitnessFAEAE` 评价函数、统一边界投影和 Deb 可行性优先准则。

主要输出:

- `uav_comparison_runs.csv`
- `uav_comparison_summary_long.csv`
- `uav_comparison_average_rank.csv`
- `trajectory_sanity_runs.csv`
- `trajectory_sanity_summary.csv`
- `trajectory_sanity_flags.csv`
- `run_records/`

## 平均排名

- `GDSAO`: 1.6667
- `MSCSO`: 1.6667
- `ERIME`: 2.6667
