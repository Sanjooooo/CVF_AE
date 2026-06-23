# CVF-AE 收敛曲线生成说明

生成时间：2026-06-23

## 数据来源

- `D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_main_comparison_formal_conservative_20260623_091132`

本阶段只复用正式主对比 run records，不重跑优化实验。

## 算法范围

- 主显示算法：`CVF-AE, CPO, DBO, GWO, AE`
- 补充显示算法：`PSO, HHO`

曲线使用各 run 中由 Deb 可行性优先规则维护的 best-so-far fitness，可视为 feasible-aware best fitness 轨迹。

## 汇总

| Scene | Algorithm | NumRuns | FeasibleRate | FinalMean | FinalStd |
|---:|---|---:|---:|---:|---:|
| 1 | CVF-AE | 30 | 1.00 | 298.1379 | 2.7821 |
| 1 | CPO | 30 | 1.00 | 298.3594 | 5.5794 |
| 1 | DBO | 30 | 1.00 | 344.8827 | 19.9703 |
| 1 | GWO | 30 | 0.93 | 345.3695 | 81.8962 |
| 1 | AE | 30 | 0.33 | 810.3258 | 328.2829 |
| 1 | PSO | 30 | 0.87 | 397.5087 | 183.8273 |
| 1 | HHO | 30 | 0.80 | 450.5575 | 198.3628 |
| 2 | CVF-AE | 30 | 1.00 | 301.2018 | 2.9019 |
| 2 | CPO | 30 | 1.00 | 278.1196 | 1.8768 |
| 2 | DBO | 30 | 1.00 | 337.7867 | 29.1340 |
| 2 | GWO | 30 | 1.00 | 341.1611 | 38.8516 |
| 2 | AE | 30 | 0.00 | 1668.4042 | 421.8461 |
| 2 | PSO | 30 | 0.43 | 729.9490 | 434.6311 |
| 2 | HHO | 30 | 0.90 | 395.8343 | 180.5172 |
| 4 | CVF-AE | 30 | 1.00 | 349.2270 | 19.8954 |
| 4 | CPO | 30 | 0.73 | 519.8797 | 313.2061 |
| 4 | DBO | 30 | 1.00 | 376.3041 | 15.9951 |
| 4 | GWO | 30 | 0.63 | 608.4571 | 333.1796 |
| 4 | AE | 30 | 0.00 | 1653.2705 | 200.9002 |
| 4 | PSO | 30 | 0.03 | 1295.4587 | 382.0206 |
| 4 | HHO | 30 | 0.37 | 898.3440 | 469.4671 |

## 输出文件

- `cvf_ae_convergence_curves.csv`
- `cvf_ae_convergence_summary.csv`
- `scene1_convergence_mean_std.png`
- `scene2_convergence_mean_std.png`
- `scene4_convergence_mean_std.png`
