# CVF-AE 轨迹合理性审查

日期：2026-06-22

结果目录：

`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_20260622_103121`

## 1. 审查动机

正式主对比不能只看 `fitness`、`feasible rate` 和平均排名。

对于低空 UAV 路径规划，以下轨迹即使数值上可行，也不应直接作为强证据：

- 长时间从高空绕过障碍物；
- 沿地图边界大范围绕行；
- 虽然满足硬约束，但明显偏离低空巡航任务语义；
- 依靠场景边界或高度上限获得低成本路径。

因此，本次新增轨迹合理性审查，作为正式主对比后的补充分析。

## 2. 审查指标

新增脚本：

`analyze_cvf_ae_trajectory_sanity.m`

输出文件：

- `trajectory_sanity_runs.csv`
- `trajectory_sanity_summary.csv`
- `trajectory_sanity_flags.csv`

主要指标：

- `MeanZ`
- `MaxZ`
- `HighAltitudeFrac`
- `VeryHighAltitudeFrac`
- `DetourRatio`
- `MeanBoundaryDist`
- `BoundaryHugFrac`
- `ControlPointBoundaryHugFrac`

当前阈值：

- high altitude: `refCruiseZ + 8`
- very high altitude: `refCruiseZ + 16`
- boundary band: `min(boundaryMargin, 8)`

这些阈值不是新的优化目标，而是用于识别需要人工看图的可疑轨迹。

## 3. 关键发现

### 3.1 CVF-AE 没有明显高空绕行

`CVF-AE` 的平均高度：

| Scene | MeanZ | MeanMaxZ | HighAltitudeFrac | VeryHighAltitudeFrac |
|---:|---:|---:|---:|---:|
| 1 | 14.95 | 18.00 | 0.00 | 0.00 |
| 2 | 15.96 | 19.26 | 0.04 | 0.01 |
| 4 | 15.40 | 19.24 | 0.00 | 0.00 |

结论：

- `CVF-AE` 的正式主对比结果不是靠高空绕行获得；
- 该结果更符合低空巡航叙事；
- Scene 4 的 top-view 轨迹经过廊道内部，而不是完全沿边界绕行。

### 3.2 CPO 的数值优势存在轨迹语义风险

`CPO` 的平均高度：

| Scene | MeanZ | MeanMaxZ | HighAltitudeFrac | VeryHighAltitudeFrac |
|---:|---:|---:|---:|---:|
| 1 | 26.12 | 28.98 | 0.67 | 0.14 |
| 2 | 33.41 | 36.51 | 0.92 | 0.76 |
| 4 | 21.13 | 23.22 | 0.29 | 0.23 |

图像抽查：

- Scene 2 的 `CPO` 最佳轨迹明显抬高，通过高空越过复杂障碍区域；
- Scene 4 的 `CPO` top-view 最佳轨迹明显沿地图下边界和右边界绕行。

结论：

- `CPO` 在 Scene 1/2 的 fitness 优势不能直接解释为更好的低空路径规划能力；
- 如果论文强调“低空强约束廊道规划”，必须把 `CPO` 的高空绕行作为重要边界讨论；
- 不能只用平均排名得出 `CPO` 与 `CVF-AE` 完全等价的结论。

### 3.3 DBO/GWO 等算法存在贴边绕行倾向

在 Scene 4 中：

- `DBO` 虽然 feasible rate 为 `1.00`，但 `BoundaryHugFlagRate = 0.90`；
- `GWO` 的 `BoundaryHugFlagRate = 0.97`；
- `WOA` 和 `HHO` 也有明显边界贴行风险。

结论：

- 这些算法在强约束场景中可能依赖地图边界绕行；
- 需要在路径图和 sanity table 中补充说明；
- Scene 4 的视觉证据对 `CVF-AE` 更有利。

## 4. 对正式主对比结论的修正

原始排名结论：

- `CVF-AE` 与 `CPO` 并列平均排名第一；
- `CPO` 在 Scene 1/2 排名第一；
- `CVF-AE` 在 Scene 4 排名第一。

加入轨迹合理性审查后的结论应改为：

- `CVF-AE` 在数值排名上与最强近年 baseline `CPO` 并列第一；
- `CVF-AE` 的轨迹高度更接近低空巡航参考层；
- `CPO` 的 Scene 1/2 优势伴随明显高空绕行风险；
- `DBO/GWO` 等强 baseline 在 Scene 4 存在贴边绕行倾向；
- 因此，`CVF-AE` 的优势应表述为“在保持低空轨迹语义和强约束可行性的同时取得并列最优综合排名”，而不是单纯声称 fitness 全面最好。

## 5. 后续建议

建议下一阶段进入图表与统计分析：

- 正式表格保留原始主对比排名；
- 新增轨迹合理性表；
- 论文主图中至少展示：
  - Scene 2: `CVF-AE` vs `CPO` 3D path；
  - Scene 4: `CVF-AE` vs `CPO` top-view path；
  - Scene 4: `CVF-AE` vs `DBO` top-view path；
- 对 `CPO` 的高空绕行和 `DBO/GWO` 的贴边绕行做边界讨论；
- 暂不为了压过 `CPO` 继续调参。

如果后续目标期刊要求更严格的低空定义，可以新增一个“严格低空偏好”补充场景或补充指标，但不建议现在改动已冻结的正式主对比配置。
