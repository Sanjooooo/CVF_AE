# CVF-AE 运行开销分析

生成时间：2026-06-23

## 数据来源

- 正式主对比：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_main_comparison_formal_conservative_20260623_091132`
- 正式消融：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_formal_ablation_conservative_20260622_194947`

本分析只复用现有正式结果，不重跑任何优化实验。

## 正式消融：相对 w/o-CVF 的开销

| Scene | Algorithm | runtime | nEvals | CVF count | CVF success | runtime ratio vs w/o-CVF | nEvals ratio vs w/o-CVF |
|---:|---|---:|---:|---:|---:|---:|---:|
| 1 | CVF-AE-w/o-CVF | 25.691 | 9471.8 | 0.0 | 0.0 | 1.000 | 1.000 |
| 2 | CVF-AE-w/o-CVF | 25.882 | 9432.5 | 0.0 | 0.0 | 1.000 | 1.000 |
| 4 | CVF-AE-w/o-CVF | 24.173 | 9258.5 | 0.0 | 0.0 | 1.000 | 1.000 |
| 1 | CVF-AE | 27.409 | 9566.4 | 21.1 | 19.2 | 1.067 | 1.010 |
| 2 | CVF-AE | 28.306 | 9551.6 | 10.6 | 7.9 | 1.094 | 1.013 |
| 4 | CVF-AE | 18.557 | 9367.1 | 86.8 | 59.5 | 0.768 | 1.012 |

## 正式主对比：CVF-AE 实测开销

| Scene | runtime | nEvals | CVF count | CVF success | feasible rate | rank |
|---:|---:|---:|---:|---:|---:|---:|
| 1 | 5.939 | 9568.9 | 23.9 | 21.8 | 1.00 | 1 |
| 2 | 6.791 | 9554.2 | 13.1 | 9.8 | 1.00 | 2 |
| 4 | 7.816 | 9355.2 | 88.6 | 60.1 | 1.00 | 1 |

## 解释结论

- 在正式消融中，完整 `CVF-AE` 相对 `CVF-AE-w/o-CVF` 的平均 runtime ratio 为 `0.976`，平均 nEvals ratio 为 `1.011`。
- 分场景 runtime ratio 范围为 `0.768` 到 `1.094`，受 repair 次数、可行解形成速度和 MATLAB 运行波动共同影响，因此不应把该结果写成稳定加速。
- 完整 `CVF-AE` 的平均 CVF 触发次数为 `39.5`，平均 CVF 成功次数为 `28.9`，说明 CVF 以稀疏触发方式参与搜索，而不是每个个体、每代全量重算。
- 额外 `nEvals` 相对 `w/o-CVF` 约为 `1.1%`，支持“低评价次数开销”的表述。
- 正式写作中应表述为低额外评价次数和受控运行时间开销，不应写成无开销或稳定加速。
- 正式主对比中，`CVF-AE` 三个场景均保持 `1.00` feasible rate；开销分析应与主对比性能、消融贡献和 trajectory sanity 共同解释。
