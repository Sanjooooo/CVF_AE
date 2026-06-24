# CVF-AE 正式显著性检验说明

生成日期：2026-06-24

## 数据来源

- 正式主对比：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_main_comparison_formal_conservative_20260623_091132`
- 近年改进算法补充：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_main_comparison_recent_improved_formal_20260623_161229`

- 正式消融：`D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\results\cvf_ae_formal_ablation_conservative_20260622_194947`

两批实验中，不同算法的随机种子均包含算法序号偏移，因此算法之间不是严格配对样本。本分析统一采用双侧 Wilcoxon rank-sum 检验（Mann-Whitney U），不使用配对 signed-rank 检验。

## 检验规则

- 显著性水平：`alpha = 0.05`。
- 每个场景包含 10 个 `CVF-AE` 对基线比较，论文主结论使用场景内 Holm 校正 p 值。
- 同时输出跨 30 个比较的全局 Holm 校正值，作为更保守的补充结果。
- `+`：CVF-AE 显著更优；`=`：差异不显著；`-`：CVF-AE 显著更差。
- Cliff's delta 按最小化问题定义，正值表示 CVF-AE 更优。
- Kruskal-Wallis 用于检验每个场景下 11 个算法的总体分布差异。

## 总体检验

| Scene | Chi-square | p-value | Significant |
|---:|---:|---:|:---:|
| 1 | 242.9602 | 1.637e-46 | yes |
| 2 | 235.0465 | 7.507e-45 | yes |
| 4 | 225.9334 | 6.114e-43 | yes |

## Holm 校正胜/平/负

| Group | Scope | Comparisons | Win | Tie | Loss | Median delta |
|---|---|---:|---:|---:|---:|---:|
| formal-main | all-scenes | 21 | 18 | 2 | 1 | 0.867 |
| formal-main | Scene 1 | 7 | 6 | 1 | 0 | 1.000 |
| formal-main | Scene 2 | 7 | 6 | 0 | 1 | 0.589 |
| formal-main | Scene 4 | 7 | 6 | 1 | 0 | 0.867 |
| recent-improved | all-scenes | 9 | 3 | 5 | 1 | 0.158 |
| recent-improved | Scene 1 | 3 | 3 | 0 | 0 | 0.971 |
| recent-improved | Scene 2 | 3 | 0 | 2 | 1 | -0.076 |
| recent-improved | Scene 4 | 3 | 0 | 3 | 0 | 0.153 |
| all | all-scenes | 30 | 21 | 7 | 2 | 0.779 |
| all | Scene 1 | 10 | 9 | 1 | 0 | 0.977 |
| all | Scene 2 | 10 | 6 | 2 | 2 | 0.551 |
| all | Scene 4 | 10 | 6 | 4 | 0 | 0.681 |

## 分场景关键结果

### Scene 1

| Baseline | Source | CVF mean | Baseline mean | Raw p | Holm p | Result | Delta | Effect |
|---|---|---:|---:|---:|---:|:---:|---:|---|
| AE | formal-main | 298.1379 | 810.3258 | 3.02e-11 | 3.02e-10 | + | 1.000 | large |
| PSO | formal-main | 298.1379 | 397.5087 | 6.528e-08 | 1.958e-07 | + | 0.813 | large |
| GWO | formal-main | 298.1379 | 345.3695 | 3.02e-11 | 3.02e-10 | + | 1.000 | large |
| WOA | formal-main | 298.1379 | 611.0975 | 3.02e-11 | 3.02e-10 | + | 1.000 | large |
| HHO | formal-main | 298.1379 | 450.5575 | 2.61e-10 | 1.044e-09 | + | 0.951 | large |
| DBO | formal-main | 298.1379 | 344.8827 | 3.02e-11 | 3.02e-10 | + | 1.000 | large |
| CPO | formal-main | 298.1379 | 298.3594 | 0.7731 | 0.7731 | = | 0.044 | negligible |
| GDSAO | recent-improved | 298.1379 | 315.7542 | 1.094e-10 | 5.468e-10 | + | 0.971 | large |
| ERIME | recent-improved | 298.1379 | 322.9893 | 6.696e-11 | 4.017e-10 | + | 0.982 | large |
| MSCSO | recent-improved | 298.1379 | 314.3453 | 2.377e-07 | 4.754e-07 | + | 0.778 | large |

### Scene 2

| Baseline | Source | CVF mean | Baseline mean | Raw p | Holm p | Result | Delta | Effect |
|---|---|---:|---:|---:|---:|:---:|---:|---|
| AE | formal-main | 301.2018 | 1668.4042 | 3.02e-11 | 3.02e-10 | + | 1.000 | large |
| PSO | formal-main | 301.2018 | 729.9490 | 9.211e-05 | 0.0005527 | + | 0.589 | large |
| GWO | formal-main | 301.2018 | 341.1611 | 0.0002388 | 0.001194 | + | 0.553 | large |
| WOA | formal-main | 301.2018 | 915.9034 | 3.02e-11 | 3.02e-10 | + | 1.000 | large |
| HHO | formal-main | 301.2018 | 395.8343 | 0.0002681 | 0.001194 | + | 0.549 | large |
| DBO | formal-main | 301.2018 | 337.7867 | 2.196e-07 | 1.537e-06 | + | 0.780 | large |
| CPO | formal-main | 301.2018 | 278.1196 | 3.02e-11 | 3.02e-10 | - | -1.000 | large |
| GDSAO | recent-improved | 301.2018 | 307.0675 | 0.6204 | 0.6204 | = | -0.076 | negligible |
| ERIME | recent-improved | 301.2018 | 316.1932 | 0.2973 | 0.5945 | = | 0.158 | small |
| MSCSO | recent-improved | 301.2018 | 291.1680 | 0.0006549 | 0.001965 | - | -0.513 | large |

### Scene 4

| Baseline | Source | CVF mean | Baseline mean | Raw p | Holm p | Result | Delta | Effect |
|---|---|---:|---:|---:|---:|:---:|---:|---|
| AE | formal-main | 349.2270 | 1653.2705 | 3.02e-11 | 3.02e-10 | + | 1.000 | large |
| PSO | formal-main | 349.2270 | 1295.4587 | 3.02e-11 | 3.02e-10 | + | 1.000 | large |
| GWO | formal-main | 349.2270 | 608.4571 | 3.571e-06 | 2.142e-05 | + | 0.698 | large |
| WOA | formal-main | 349.2270 | 1485.6743 | 3.02e-11 | 3.02e-10 | + | 1.000 | large |
| HHO | formal-main | 349.2270 | 898.3440 | 8.485e-09 | 5.939e-08 | + | 0.867 | large |
| DBO | formal-main | 349.2270 | 376.3041 | 1.019e-05 | 5.094e-05 | + | 0.664 | large |
| CPO | formal-main | 349.2270 | 519.8797 | 0.3632 | 0.9336 | = | 0.138 | negligible |
| GDSAO | recent-improved | 349.2270 | 346.8474 | 0.3112 | 0.9336 | = | 0.153 | small |
| ERIME | recent-improved | 349.2270 | 360.2347 | 0.02416 | 0.09663 | = | 0.340 | medium |
| MSCSO | recent-improved | 349.2270 | 402.2712 | 0.4035 | 0.9336 | = | 0.127 | negligible |

## 正式消融显著性

### 总体检验

| Scene | Chi-square | p-value | Significant |
|---:|---:|---:|:---:|
| 1 | 132.8720 | 5.847e-27 | yes |
| 2 | 98.4784 | 1.106e-19 | yes |
| 4 | 81.4919 | 4.089e-16 | yes |

### Holm 校正胜/平/负

| Scope | Comparisons | Win | Tie | Loss | Median delta |
|---|---:|---:|---:|---:|---:|
| all-scenes | 15 | 9 | 6 | 0 | 0.582 |
| Scene 1 | 5 | 4 | 1 | 0 | 0.860 |
| Scene 2 | 5 | 3 | 2 | 0 | 0.393 |
| Scene 4 | 5 | 2 | 3 | 0 | 0.224 |

### 分场景结果

#### Scene 1

| Variant | CVF mean | Variant mean | Raw p | Holm p | Result | Delta | Effect |
|---|---:|---:|---:|---:|:---:|---:|---|
| Base-AE | 297.8318 | 654.0475 | 3.02e-11 | 1.51e-10 | + | 1.000 | large |
| CVF-AE-w/o-Init | 297.8318 | 316.9964 | 6.722e-10 | 2.689e-09 | + | 0.929 | large |
| CVF-AE-w/o-StateAdaptiveCVF | 297.8318 | 298.3037 | 0.5997 | 0.5997 | = | 0.080 | negligible |
| CVF-AE-w/o-SparsePreservation | 297.8318 | 306.3793 | 7.695e-08 | 1.539e-07 | + | 0.809 | large |
| CVF-AE-w/o-CVF | 297.8318 | 306.1985 | 1.102e-08 | 3.307e-08 | + | 0.860 | large |

#### Scene 2

| Variant | CVF mean | Variant mean | Raw p | Holm p | Result | Delta | Effect |
|---|---:|---:|---:|---:|:---:|---:|---|
| Base-AE | 300.6612 | 1597.4829 | 3.02e-11 | 1.51e-10 | + | 1.000 | large |
| CVF-AE-w/o-Init | 300.6612 | 313.2191 | 1.729e-06 | 6.916e-06 | + | 0.720 | large |
| CVF-AE-w/o-StateAdaptiveCVF | 300.6612 | 301.8164 | 0.2581 | 0.2581 | = | 0.171 | small |
| CVF-AE-w/o-SparsePreservation | 300.6612 | 303.3114 | 0.09926 | 0.1985 | = | 0.249 | small |
| CVF-AE-w/o-CVF | 300.6612 | 303.7697 | 0.009069 | 0.02721 | + | 0.393 | medium |

#### Scene 4

| Variant | CVF mean | Variant mean | Raw p | Holm p | Result | Delta | Effect |
|---|---:|---:|---:|---:|:---:|---:|---|
| Base-AE | 348.5856 | 1643.7320 | 3.02e-11 | 1.51e-10 | + | 1.000 | large |
| CVF-AE-w/o-Init | 348.5856 | 556.7515 | 0.8534 | 0.8534 | = | -0.029 | negligible |
| CVF-AE-w/o-StateAdaptiveCVF | 348.5856 | 361.3123 | 0.3555 | 0.7109 | = | 0.140 | negligible |
| CVF-AE-w/o-SparsePreservation | 348.5856 | 372.2255 | 0.0001106 | 0.0004423 | + | 0.582 | large |
| CVF-AE-w/o-CVF | 348.5856 | 355.8347 | 0.1373 | 0.412 | = | 0.224 | small |

## 写作边界

- 不应将不同算法视为配对样本，也不应把本结果写成 paired Wilcoxon signed-rank test。
- 显著性只说明最终 `BestFitness` 分布差异，不能替代 feasible rate 和 trajectory sanity 分析。
- 对 CPO、GDSAO、ERIME 和 MSCSO 的结论必须继续结合高空绕行、边界贴靠和可行率解释。
- 论文主表建议报告 Holm 校正结果；原始 p 值可放补充材料。
