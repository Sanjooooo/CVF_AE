# CVF-AE 论文结果材料包

生成日期：2026-06-24

本目录只整理已有正式实验，不重跑优化算法。

- `CVF_AE_PAPER_RESULTS_PACKAGE.xlsx`：集中审阅全部结果表和图索引的格式化工作簿。

## 正文建议表格

- `paper_table_main_compact.csv`：扩展主对比紧凑表，正文主表首选。
- `paper_table_main_significance.csv`：正式显著性检验，正文可报告 Holm 结果，完整 p 值放补充材料。
- `paper_table_ablation.csv`：正式消融结果。
- `paper_table_overhead.csv`：运行时间、评价次数和 CVF 触发开销。

## 补充材料表格

- `paper_table_main_extended_long.csv`：扩展主对比完整长表。
- `paper_table_ablation_significance.csv`：消融显著性检验。
- `paper_table_parameter_sensitivity.csv`：参数敏感性完整结果。
- `paper_table_trajectory_sanity.csv`：轨迹 sanity 指标。

## 图索引

- `paper_figure_index.csv`：共 21 张 PNG，其中正文建议 8 张，补充材料建议 13 张。

## 数据来源

- 扩展主对比：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_extended_main_comparison_20260623_from_formal_and_recent`
- 正式显著性：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_formal_significance_20260624_from_formal_results`
- 正式消融：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_formal_ablation_conservative_20260622_194947`
- 参数敏感性：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_param_sensitivity_conservative_20260623_131249`
- 开销分析：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_runtime_overhead_analysis_20260623_from_existing_results`
- 收敛曲线：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_convergence_curves_20260623_from_main_comparison`
- 代表轨迹：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_representative_paths_20260623_from_formal_results`

## 使用边界

- `MeanPlusMinusStd` 采用纯 ASCII `+/-`，最终排版时替换为数学符号。
- `AverageRank` 是三个 UAV 场景的平均场景名次；Kruskal-Wallis 和 rank-sum 结果另表报告。
- runtime 受 MATLAB 会话和批处理环境影响，应优先解释同批次比值与 `NEvals`。
- scalar fitness 必须与可行率和 trajectory sanity 联合解释。
