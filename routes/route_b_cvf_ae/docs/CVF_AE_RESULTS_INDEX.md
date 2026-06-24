# CVF-AE 正式结果位置总索引

最后更新：2026-06-24

## CEC 一般约束补充验证

测试集选型报告：

- [CVF_AE_CEC_BENCHMARK_SELECTION.md](CVF_AE_CEC_BENCHMARK_SELECTION.md)

独立框架：

- `cec2017_constrained_framework/`

Stage A：

- 28 个函数接口、参考点、容差、FE 计数、C18/C27 向量化修正和复现性测试；
- 结果：6/6 passed。
- 记录：
  `cec2017_constrained_framework/results/stage_a/TEST_RESULTS.md`

Stage B 首轮：

- `cec2017_constrained_framework/results/stage_b_precheck`

Stage B 保守修订：

- `cec2017_constrained_framework/results/stage_b_precheck_v2`
- 分析：
  `cec2017_constrained_framework/results/stage_b_precheck_v2/STAGE_B_PRECHECK_ANALYSIS.md`
- gate：
  `cec2017_constrained_framework/results/stage_b_precheck_v2/STAGE_B_GATE_DECISION.md`

当前结论：

- Stage B 未通过；
- 不进入 Stage C 或正式 CEC 运行；
- 上述预检结果不作为论文正式性能结果；
- UAV 正式结果及冻结参数未修改。

本文件是路线 B / CVF-AE 论文实验结果的固定查找入口。后续新增、替换或重生成正式结果时，必须同步更新本文件中的中文名称、目录、关键文件和更新时间。

## 1. 使用规则

- 项目根目录：`D:\MATLAB\Project\COVE_AE_matlab`
- 下表路径均相对于项目根目录，Markdown 文件链接可直接打开。
- 论文场景统一写为 `Scene 1`、`Scene 2`、`Scene 3`。
- 内部地图 ID 4 仅用于代码读取，对外论文结果统一显示为 `Scene 3`。
- 写论文时优先使用“论文结果总包”；检查计算过程或逐次运行数据时，再进入对应正式实验目录。
- `precheck`、`gate`、`medium_gate`、`scene2_v2_sanity` 等目录属于开发或预检过程，不作为论文最终数据来源。

## 2. 论文结果总包

总目录：

`routes/route_b_cvf_ae/results/cvf_ae_paper_results_package_20260624_from_formal_results`

| 结果中文名 | 位置 | 用途 |
|---|---|---|
| 论文结果总工作簿 | [CVF_AE_PAPER_RESULTS_PACKAGE.xlsx](../results/cvf_ae_paper_results_package_20260624_from_formal_results/CVF_AE_PAPER_RESULTS_PACKAGE.xlsx) | 汇总主对比、显著性、消融、参数敏感性、运行开销、轨迹检查和图索引 |
| 论文结果包说明 | [CVF_AE_PAPER_RESULTS_PACKAGE_README.md](../results/cvf_ae_paper_results_package_20260624_from_formal_results/CVF_AE_PAPER_RESULTS_PACKAGE_README.md) | 说明工作簿和 CSV 内容 |
| 结果分析写作初稿 | [CVF_AE_PAPER_RESULTS_WRITEUP_DRAFT.md](../results/cvf_ae_paper_results_package_20260624_from_formal_results/CVF_AE_PAPER_RESULTS_WRITEUP_DRAFT.md) | 论文结果章节文字基础 |
| 主对比精简表 | [paper_table_main_compact.csv](../results/cvf_ae_paper_results_package_20260624_from_formal_results/paper_table_main_compact.csv) | 正文主对比表优先版本 |
| 主对比完整长表 | [paper_table_main_extended_long.csv](../results/cvf_ae_paper_results_package_20260624_from_formal_results/paper_table_main_extended_long.csv) | 11 个算法、3 个场景的完整统计 |
| 主对比显著性表 | [paper_table_main_significance.csv](../results/cvf_ae_paper_results_package_20260624_from_formal_results/paper_table_main_significance.csv) | 秩和检验及 Holm 校正 |
| 正式消融表 | [paper_table_ablation.csv](../results/cvf_ae_paper_results_package_20260624_from_formal_results/paper_table_ablation.csv) | CVF-AE 及各删减版本结果 |
| 消融显著性表 | [paper_table_ablation_significance.csv](../results/cvf_ae_paper_results_package_20260624_from_formal_results/paper_table_ablation_significance.csv) | 消融版本显著性检验 |
| 参数敏感性表 | [paper_table_parameter_sensitivity.csv](../results/cvf_ae_paper_results_package_20260624_from_formal_results/paper_table_parameter_sensitivity.csv) | 三个关键参数的统计和排名 |
| 运行开销表 | [paper_table_overhead.csv](../results/cvf_ae_paper_results_package_20260624_from_formal_results/paper_table_overhead.csv) | runtime、评价次数和开销比 |
| 轨迹合理性检查表 | [paper_table_trajectory_sanity.csv](../results/cvf_ae_paper_results_package_20260624_from_formal_results/paper_table_trajectory_sanity.csv) | 可行性和轨迹异常检查 |
| 论文图位置索引 | [paper_figure_index.csv](../results/cvf_ae_paper_results_package_20260624_from_formal_results/paper_figure_index.csv) | 正文图和补充材料图位置 |

## 3. 主对比实验

### 3.1 合并后的完整主对比

目录：

`routes/route_b_cvf_ae/results/cvf_ae_extended_main_comparison_20260623_from_formal_and_recent`

| 结果中文名 | 位置 |
|---|---|
| 完整主对比结果分析 | [CVF_AE_EXTENDED_MAIN_COMPARISON_INTERPRETATION.md](../results/cvf_ae_extended_main_comparison_20260623_from_formal_and_recent/CVF_AE_EXTENDED_MAIN_COMPARISON_INTERPRETATION.md) |
| 完整主对比统计长表 | [extended_main_comparison_summary_long.csv](../results/cvf_ae_extended_main_comparison_20260623_from_formal_and_recent/extended_main_comparison_summary_long.csv) |
| 完整主对比平均排名 | [extended_main_comparison_average_rank.csv](../results/cvf_ae_extended_main_comparison_20260623_from_formal_and_recent/extended_main_comparison_average_rank.csv) |
| 完整主对比轨迹检查汇总 | [extended_main_comparison_trajectory_sanity_summary.csv](../results/cvf_ae_extended_main_comparison_20260623_from_formal_and_recent/extended_main_comparison_trajectory_sanity_summary.csv) |

### 3.2 经典算法正式主对比原始结果

目录：

`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`

| 结果中文名 | 位置 |
|---|---|
| 经典算法主对比分析 | [CVF_AE_MAIN_COMPARISON_CONSERVATIVE_INTERPRETATION.md](../results/cvf_ae_main_comparison_formal_conservative_20260623_091132/CVF_AE_MAIN_COMPARISON_CONSERVATIVE_INTERPRETATION.md) |
| 经典算法主对比汇总 | [uav_comparison_summary_long.csv](../results/cvf_ae_main_comparison_formal_conservative_20260623_091132/uav_comparison_summary_long.csv) |
| 经典算法平均排名 | [uav_comparison_average_rank.csv](../results/cvf_ae_main_comparison_formal_conservative_20260623_091132/uav_comparison_average_rank.csv) |
| 经典算法逐次运行结果 | [uav_comparison_runs.csv](../results/cvf_ae_main_comparison_formal_conservative_20260623_091132/uav_comparison_runs.csv) |
| 经典算法轨迹检查汇总 | [trajectory_sanity_summary.csv](../results/cvf_ae_main_comparison_formal_conservative_20260623_091132/trajectory_sanity_summary.csv) |

### 3.3 近年改进算法正式主对比原始结果

目录：

`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_recent_improved_formal_20260623_161229`

| 结果中文名 | 位置 |
|---|---|
| 近年改进算法主对比汇总 | [uav_comparison_summary_long.csv](../results/cvf_ae_main_comparison_recent_improved_formal_20260623_161229/uav_comparison_summary_long.csv) |
| 近年改进算法平均排名 | [uav_comparison_average_rank.csv](../results/cvf_ae_main_comparison_recent_improved_formal_20260623_161229/uav_comparison_average_rank.csv) |
| 近年改进算法逐次运行结果 | [uav_comparison_runs.csv](../results/cvf_ae_main_comparison_recent_improved_formal_20260623_161229/uav_comparison_runs.csv) |
| 近年改进算法轨迹检查汇总 | [trajectory_sanity_summary.csv](../results/cvf_ae_main_comparison_recent_improved_formal_20260623_161229/trajectory_sanity_summary.csv) |

该目录包含 `GDSAO`、`ERIME` 和 `MSCSO` 的正式比较结果。

## 4. 正式显著性检验

目录：

`routes/route_b_cvf_ae/results/cvf_ae_formal_significance_20260624_from_formal_results`

| 结果中文名 | 位置 |
|---|---|
| 显著性检验综合分析 | [CVF_AE_FORMAL_SIGNIFICANCE_INTERPRETATION.md](../results/cvf_ae_formal_significance_20260624_from_formal_results/CVF_AE_FORMAL_SIGNIFICANCE_INTERPRETATION.md) |
| 主对比两两秩和检验与 Holm 校正 | [cvf_ae_pairwise_rank_sum_holm.csv](../results/cvf_ae_formal_significance_20260624_from_formal_results/cvf_ae_pairwise_rank_sum_holm.csv) |
| 主对比胜平负汇总 | [cvf_ae_significance_wtl_summary.csv](../results/cvf_ae_formal_significance_20260624_from_formal_results/cvf_ae_significance_wtl_summary.csv) |
| 主对比 Kruskal-Wallis 总体检验 | [cvf_ae_kruskal_wallis_omnibus.csv](../results/cvf_ae_formal_significance_20260624_from_formal_results/cvf_ae_kruskal_wallis_omnibus.csv) |
| 消融两两秩和检验与 Holm 校正 | [cvf_ae_ablation_pairwise_rank_sum_holm.csv](../results/cvf_ae_formal_significance_20260624_from_formal_results/cvf_ae_ablation_pairwise_rank_sum_holm.csv) |
| 消融胜平负汇总 | [cvf_ae_ablation_significance_wtl_summary.csv](../results/cvf_ae_formal_significance_20260624_from_formal_results/cvf_ae_ablation_significance_wtl_summary.csv) |
| 消融 Kruskal-Wallis 总体检验 | [cvf_ae_ablation_kruskal_wallis_omnibus.csv](../results/cvf_ae_formal_significance_20260624_from_formal_results/cvf_ae_ablation_kruskal_wallis_omnibus.csv) |

## 5. 正式消融实验

目录：

`routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_conservative_20260622_194947`

| 结果中文名 | 位置 |
|---|---|
| 正式消融结果分析 | [CVF_AE_FORMAL_ABLATION_CONSERVATIVE_INTERPRETATION.md](../results/cvf_ae_formal_ablation_conservative_20260622_194947/CVF_AE_FORMAL_ABLATION_CONSERVATIVE_INTERPRETATION.md) |
| 正式消融汇总统计 | [cvf_ae_gate_summary.csv](../results/cvf_ae_formal_ablation_conservative_20260622_194947/cvf_ae_gate_summary.csv) |
| 正式消融平均排名 | [cvf_ae_gate_average_rank.csv](../results/cvf_ae_formal_ablation_conservative_20260622_194947/cvf_ae_gate_average_rank.csv) |
| 正式消融逐次运行结果 | [cvf_ae_gate_runs.csv](../results/cvf_ae_formal_ablation_conservative_20260622_194947/cvf_ae_gate_runs.csv) |
| 正式消融轨迹检查汇总 | [trajectory_sanity_summary.csv](../results/cvf_ae_formal_ablation_conservative_20260622_194947/trajectory_sanity_summary.csv) |

## 6. 参数敏感性实验

目录：

`routes/route_b_cvf_ae/results/cvf_ae_param_sensitivity_conservative_20260623_131249`

| 结果中文名 | 位置 |
|---|---|
| 参数敏感性分析 | [CVF_AE_PARAM_SENSITIVITY_INTERPRETATION.md](../results/cvf_ae_param_sensitivity_conservative_20260623_131249/CVF_AE_PARAM_SENSITIVITY_INTERPRETATION.md) |
| 参数敏感性汇总 | [cvf_ae_param_sensitivity_summary.csv](../results/cvf_ae_param_sensitivity_conservative_20260623_131249/cvf_ae_param_sensitivity_summary.csv) |
| 参数排名汇总 | [cvf_ae_param_sensitivity_rank_summary.csv](../results/cvf_ae_param_sensitivity_conservative_20260623_131249/cvf_ae_param_sensitivity_rank_summary.csv) |
| 参数敏感性逐次运行结果 | [cvf_ae_param_sensitivity_runs.csv](../results/cvf_ae_param_sensitivity_conservative_20260623_131249/cvf_ae_param_sensitivity_runs.csv) |
| 参数敏感性轨迹检查汇总 | [param_sensitivity_trajectory_sanity_summary.csv](../results/cvf_ae_param_sensitivity_conservative_20260623_131249/param_sensitivity_trajectory_sanity_summary.csv) |

## 7. 运行开销分析

目录：

`routes/route_b_cvf_ae/results/cvf_ae_runtime_overhead_analysis_20260623_from_existing_results`

| 结果中文名 | 位置 |
|---|---|
| 运行开销综合分析 | [CVF_AE_RUNTIME_OVERHEAD_INTERPRETATION.md](../results/cvf_ae_runtime_overhead_analysis_20260623_from_existing_results/CVF_AE_RUNTIME_OVERHEAD_INTERPRETATION.md) |
| 主对比运行开销 | [main_comparison_overhead.csv](../results/cvf_ae_runtime_overhead_analysis_20260623_from_existing_results/main_comparison_overhead.csv) |
| 相对无 CVF 版本的消融开销 | [ablation_overhead_vs_without_cvf.csv](../results/cvf_ae_runtime_overhead_analysis_20260623_from_existing_results/ablation_overhead_vs_without_cvf.csv) |

## 8. 收敛曲线

目录：

`routes/route_b_cvf_ae/results/cvf_ae_convergence_curves_20260623_from_main_comparison`

| 结果中文名 | 位置 |
|---|---|
| 收敛结果分析 | [CVF_AE_CONVERGENCE_INTERPRETATION.md](../results/cvf_ae_convergence_curves_20260623_from_main_comparison/CVF_AE_CONVERGENCE_INTERPRETATION.md) |
| 收敛曲线逐迭代数据 | [cvf_ae_convergence_curves.csv](../results/cvf_ae_convergence_curves_20260623_from_main_comparison/cvf_ae_convergence_curves.csv) |
| 收敛终值汇总 | [cvf_ae_convergence_summary.csv](../results/cvf_ae_convergence_curves_20260623_from_main_comparison/cvf_ae_convergence_summary.csv) |
| 场景 1 收敛图 | [scene1_convergence_mean_std.png](../results/cvf_ae_convergence_curves_20260623_from_main_comparison/scene1_convergence_mean_std.png) |
| 场景 2 收敛图 | [scene2_convergence_mean_std.png](../results/cvf_ae_convergence_curves_20260623_from_main_comparison/scene2_convergence_mean_std.png) |
| 场景 3 收敛图 | [scene3_convergence_mean_std.png](../results/cvf_ae_convergence_curves_20260623_from_main_comparison/scene3_convergence_mean_std.png) |

## 9. 代表轨迹图

总目录：

`routes/route_b_cvf_ae/results/cvf_ae_representative_paths_20260623_from_formal_results`

| 结果中文名 | 位置 |
|---|---|
| 代表轨迹选择与解释 | [CVF_AE_REPRESENTATIVE_PATHS_INTERPRETATION.md](../results/cvf_ae_representative_paths_20260623_from_formal_results/CVF_AE_REPRESENTATIVE_PATHS_INTERPRETATION.md) |
| 全部代表运行选择记录 | [representative_run_selection_all.csv](../results/cvf_ae_representative_paths_20260623_from_formal_results/representative_run_selection_all.csv) |
| 经典主对比代表轨迹图 | `routes/route_b_cvf_ae/results/cvf_ae_representative_paths_20260623_from_formal_results/main` |
| 完整主对比代表轨迹图 | `routes/route_b_cvf_ae/results/cvf_ae_representative_paths_20260623_from_formal_results/extended` |
| 消融实验代表轨迹图 | `routes/route_b_cvf_ae/results/cvf_ae_representative_paths_20260623_from_formal_results/ablation` |

每个子目录均包含 Scene 1、Scene 2、Scene 3 的俯视图、三维图和代表运行选择表。

## 10. 论文补充绘图

目录：

`routes/route_b_cvf_ae/results/cvf_ae_paper_completion_figures_20260624_from_formal_results`

| 结果中文名 | PNG 位置 | PDF 位置 |
|---|---|---|
| 强算法箱线图 | [PNG](../results/cvf_ae_paper_completion_figures_20260624_from_formal_results/cvf_ae_boxplots_strong_algorithms.png) | [PDF](../results/cvf_ae_paper_completion_figures_20260624_from_formal_results/cvf_ae_boxplots_strong_algorithms.pdf) |
| 全算法对数坐标箱线图 | [PNG](../results/cvf_ae_paper_completion_figures_20260624_from_formal_results/cvf_ae_boxplots_all_algorithms_log.png) | [PDF](../results/cvf_ae_paper_completion_figures_20260624_from_formal_results/cvf_ae_boxplots_all_algorithms_log.pdf) |
| 参数敏感性图 | [PNG](../results/cvf_ae_paper_completion_figures_20260624_from_formal_results/cvf_ae_parameter_sensitivity.png) | [PDF](../results/cvf_ae_paper_completion_figures_20260624_from_formal_results/cvf_ae_parameter_sensitivity.pdf) |
| CVF-AE 方法流程图 | [PNG](../results/cvf_ae_paper_completion_figures_20260624_from_formal_results/cvf_ae_method_flowchart.png) | [PDF](../results/cvf_ae_paper_completion_figures_20260624_from_formal_results/cvf_ae_method_flowchart.pdf) |
| 补充绘图说明 | [CVF_AE_PAPER_COMPLETION_FIGURES_INTERPRETATION.md](../results/cvf_ae_paper_completion_figures_20260624_from_formal_results/CVF_AE_PAPER_COMPLETION_FIGURES_INTERPRETATION.md) |  |
| 补充绘图索引 | [paper_completion_figure_index.csv](../results/cvf_ae_paper_completion_figures_20260624_from_formal_results/paper_completion_figure_index.csv) |  |

## 11. 结果生成与更新脚本

| 功能 | 脚本位置 |
|---|---|
| 导出论文结果总包 | `export_cvf_ae_paper_results_package.m` |
| 正式显著性检验 | `analyze_cvf_ae_formal_significance.m` |
| 收敛曲线生成 | `make_cvf_ae_convergence_curves.m` |
| 代表轨迹筛选与绘图 | `make_cvf_ae_representative_path_figures.m` |
| 箱线图、参数图和流程图 | `make_cvf_ae_paper_completion_figures.m` |
| 论文场景编号映射 | `cvfAePaperSceneId.m` |

## 12. 后续同步检查清单

每次正式结果更新后，至少检查以下内容：

1. 更新本文件顶部的“最后更新”日期。
2. 更新发生变化的结果目录名和关键文件名。
3. 检查所有链接指向的文件实际存在。
4. 检查论文结果总工作簿、CSV 表格和图索引是否同步。
5. 检查论文场景仍统一为 Scene 1、Scene 2、Scene 3。
6. 在 `CVF_AE_PROJECT_LOG.md` 中记录本次结果更新和索引同步情况。
