# CVF-AE 主对比合并结果（Scene 2-v2）

本目录是论文主对比的推荐结果源。

## 来源

- Scene 1: `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_20260622_103121`
- Scene 2: `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_scene2_v2_formal_20260622_152052`
- Scene 4: `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_20260622_103121`

只替换 Scene 2 的原因：本轮只修改 Scene 2-v2，Scene 1 和 Scene 4 未修改。

## 文件

- `uav_comparison_runs.csv`: 合并后的逐 run 结果
- `uav_comparison_summary_long.csv`: 合并后的场景级主指标
- `uav_comparison_average_rank.csv`: 合并后的平均排名
- `trajectory_sanity_runs.csv`: 合并后的逐 run 轨迹合理性指标
- `trajectory_sanity_summary.csv`: 合并后的轨迹合理性汇总
- `trajectory_sanity_flags.csv`: 合并后的轨迹风险标记
- `CVF_AE_MAIN_COMPARISON_SCENE2_V2_MERGED_INTERPRETATION.md`: 中文解释和论文表述建议

原始 `.mat`、`run_records/` 和轨迹图片保留在各自来源目录中，不在本合并目录重复复制。
