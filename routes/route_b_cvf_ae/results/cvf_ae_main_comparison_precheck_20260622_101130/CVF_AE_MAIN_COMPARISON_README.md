# CVF-AE 主对比实验记录

- 模式: `precheck`
- 场景: `[1 2 4]`
- 算法: `CVF-AE, AE, PSO, GWO, WOA, HHO, DBO, CPO`
- nRuns: `3`
- popSize: `20`
- maxIter: `80`
- baseSeed: `20260624`

本 runner 使用统一 UAV B-spline 编码、统一 `fitnessFAEAE` 评价函数、统一边界投影和 Deb 可行性优先准则。

主要输出:

- `uav_comparison_runs.csv`
- `uav_comparison_summary_long.csv`
- `uav_comparison_average_rank.csv`
- `run_records/`

## 平均排名

- `CVF-AE`: 1.3333
- `CPO`: 2.0000
- `DBO`: 3.0000
- `GWO`: 5.0000
- `WOA`: 5.0000
- `HHO`: 6.0000
- `PSO`: 6.3333
- `AE`: 7.3333
