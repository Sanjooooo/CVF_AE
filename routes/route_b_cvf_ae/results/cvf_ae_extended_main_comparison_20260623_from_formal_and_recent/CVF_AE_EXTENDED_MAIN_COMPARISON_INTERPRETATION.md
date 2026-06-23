# CVF-AE 扩展主对比结果说明

生成时间：2026-06-23

## 数据来源

- 正式主对比：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_main_comparison_formal_conservative_20260623_091132`
- 近年改进算法补充：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_main_comparison_recent_improved_formal_20260623_161229`

本目录只合并既有正式结果，不重跑优化实验。

## 扩展平均排名

| Algorithm | AverageRank | AvgFitness | FeasibleRate | AvgNEvals | AvgRuntime |
|---|---:|---:|---:|---:|---:|
| CVF-AE | 2.0000 | 316.1889 | 1.0000 | 9492.8 | 6.8487 |
| CPO | 3.0000 | 365.4529 | 0.9111 | 9030.0 | 5.2475 |
| GDSAO | 3.0000 | 323.2230 | 1.0000 | 17955.0 | 11.1597 |
| MSCSO | 3.3333 | 335.9282 | 0.9778 | 21451.9 | 14.0345 |
| ERIME | 4.3333 | 333.1391 | 1.0000 | 9483.2 | 6.7209 |
| DBO | 5.3333 | 352.9912 | 1.0000 | 9030.0 | 5.8768 |
| GWO | 7.0000 | 431.6626 | 0.8556 | 9030.0 | 5.3525 |
| HHO | 8.3333 | 581.5786 | 0.6889 | 11470.3 | 6.9015 |
| PSO | 8.6667 | 807.6388 | 0.4444 | 9030.0 | 4.9471 |
| WOA | 10.0000 | 1004.2251 | 0.4333 | 9030.0 | 5.2672 |
| AE | 11.0000 | 1377.3335 | 0.1111 | 9030.0 | 5.3931 |

## 分场景关键观察

- Scene 1: fitness 前三为 `CVF-AE`、`CPO`、`MSCSO`。
- Scene 2: fitness 前三为 `CPO`、`MSCSO`、`CVF-AE`。
- Scene 4: fitness 前三为 `GDSAO`、`CVF-AE`、`ERIME`。

## 轨迹 sanity 边界

- Scene 1 `ERIME`: feasible rate 1.00, visual review flag rate 0.70, high-altitude flag rate 0.33, boundary-hug flag rate 0.27。
- Scene 1 `GDSAO`: feasible rate 1.00, visual review flag rate 0.33, high-altitude flag rate 0.10, boundary-hug flag rate 0.03。
- Scene 1 `MSCSO`: feasible rate 1.00, visual review flag rate 0.53, high-altitude flag rate 0.33, boundary-hug flag rate 0.13。
- Scene 2 `ERIME`: feasible rate 1.00, visual review flag rate 0.67, high-altitude flag rate 0.23, boundary-hug flag rate 0.37。
- Scene 2 `GDSAO`: feasible rate 1.00, visual review flag rate 0.93, high-altitude flag rate 0.53, boundary-hug flag rate 0.17。
- Scene 2 `MSCSO`: feasible rate 1.00, visual review flag rate 0.63, high-altitude flag rate 0.50, boundary-hug flag rate 0.03。
- Scene 4 `ERIME`: feasible rate 1.00, visual review flag rate 0.97, high-altitude flag rate 0.03, boundary-hug flag rate 0.97。
- Scene 4 `GDSAO`: feasible rate 1.00, visual review flag rate 1.00, high-altitude flag rate 0.00, boundary-hug flag rate 0.97。
- Scene 4 `MSCSO`: feasible rate 0.93, visual review flag rate 0.67, high-altitude flag rate 0.00, boundary-hug flag rate 0.60。

写作建议：扩展主表可以增强 baseline 说服力，但新增近年改进算法存在较高 trajectory sanity 复核比例；论文解释应把 scalar fitness、feasible rate 和 trajectory sanity 联合呈现，不能只按 fitness 排名下结论。
