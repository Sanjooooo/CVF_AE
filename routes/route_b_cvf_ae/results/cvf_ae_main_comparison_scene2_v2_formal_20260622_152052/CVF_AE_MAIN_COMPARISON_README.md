# CVF-AE 主对比实验记录

- 模式: `scene2_v2_formal`
- 场景: `2`
- 算法: `CVF-AE, AE, PSO, GWO, WOA, HHO, DBO, CPO`
- nRuns: `30`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260624`

本 runner 使用统一 UAV B-spline 编码、统一 `fitnessFAEAE` 评价函数、统一边界投影和 Deb 可行性优先准则。

主要输出:

- `uav_comparison_runs.csv`
- `uav_comparison_summary_long.csv`
- `uav_comparison_average_rank.csv`
- `run_records/`

## 平均排名

- `CPO`: 1.0000
- `CVF-AE`: 2.0000
- `DBO`: 3.0000
- `GWO`: 4.0000
- `HHO`: 5.0000
- `PSO`: 6.0000
- `WOA`: 7.0000
- `AE`: 8.0000
