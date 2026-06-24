# CVF-AE 论文补充图生成说明

生成日期：2026-06-24

本目录只复用已有正式结果，不重跑优化实验。

## 数据来源

- 参数敏感性：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_param_sensitivity_conservative_20260623_131249\cvf_ae_param_sensitivity_summary.csv`
- 正式主对比：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_main_comparison_formal_conservative_20260623_091132\uav_comparison_runs.csv`
- 近年改进算法：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_main_comparison_recent_improved_formal_20260623_161229\uav_comparison_runs.csv`

## 输出图

- `cvf_ae_parameter_sensitivity.png/.pdf`：三个关键参数在 Scene 2/4 上的均值和标准差。
- `cvf_ae_boxplots_strong_algorithms.png/.pdf`：六个强算法的线性坐标箱线图，建议正文使用。
- `cvf_ae_boxplots_all_algorithms_log.png/.pdf`：全部 11 个算法的对数坐标箱线图，建议补充材料使用。
- `cvf_ae_method_flowchart.png/.pdf`：CVF-AE 方法总体流程，建议方法章节使用。

## 解读边界

- 参数敏感性图中的默认参数不要求在每个场景逐项最优，应结合平均排名、评价次数和轨迹 sanity 解释。
- 箱线图使用每个算法每个场景 30 次正式运行的最终 BestFitness。
- 全算法箱线图采用对数纵轴，仅用于同时显示尺度差异较大的算法。
- 流程图强调 CVF 是稀疏候选分支，不是每个个体每代必定执行的重 repair。
