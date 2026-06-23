# CVF-AE 代表轨迹图筛选说明

生成时间：2026-06-23

## 筛选规则

1. 优先选择 feasible 且 `VisualReviewFlag = false` 的 run，并取 fitness 最接近 feasible 中位数者；
2. 若无无复核风险 run，则选择 feasible run 中 fitness 最接近 feasible 中位数者；
3. 若无 feasible run，则选择 violation 最小且 fitness 接近中位数者；
4. 所有选择写入 `representative_run_selection_all.csv`，避免人工挑选。

## 图集

- `main`: Main comparison
- `extended`: Extended comparison
- `ablation`: Ablation

## 筛选层级统计

- `feasible_clean_median`: 38
- `feasible_flagged_median`: 9
- `infeasible_min_violation_median`: 4

## 注意

带有 `feasible_flagged_median` 或 `infeasible_min_violation_median` 的轨迹需要在论文中明确解释其复核风险，不能作为无风险代表路径呈现。
