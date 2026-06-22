# CVF-AE 主对比合并结果解释（Scene 2-v2）

日期：2026-06-22

## 结果来源

本目录用于论文主表和结果分析，采用如下来源合并：

- Scene 1：沿用 `cvf_ae_main_comparison_formal_20260622_103121`
- Scene 2：使用重新运行后的 `cvf_ae_main_comparison_scene2_v2_formal_20260622_152052`
- Scene 4：沿用 `cvf_ae_main_comparison_formal_20260622_103121`

这样处理的原因是本轮只修改了 Scene 2 的地图和高度参数，Scene 1 和 Scene 4 未发生变化。

## 合并后的平均排名

| Algorithm | Average rank |
|---|---:|
| `CPO` | 1.67 |
| `CVF-AE` | 1.67 |
| `DBO` | 3.00 |
| `GWO` | 3.67 |
| `HHO` | 5.33 |
| `PSO` | 5.67 |
| `WOA` | 7.00 |
| `AE` | 8.00 |

合并后，`CVF-AE` 与 `CPO` 仍为平均排名并列第一。

## Scene 2-v2 的关键解释

在 Scene 2-v2 中，`CPO` 的 raw fitness 排名第一，`CVF-AE` 排名第二。但轨迹 sanity 指标显示：

- `CVF-AE`
  - feasible rate: `1.00`
  - MeanZ: `15.99`
  - MeanHighAltitudeFrac: `0.00`
  - VisualReviewFlagRate: `0.00`
- `CPO`
  - feasible rate: `1.00`
  - MeanZ: `28.22`
  - MeanHighAltitudeFrac: `0.88`
  - VisualReviewFlagRate: `1.00`

因此，`CPO` 的 Scene 2-v2 数值优势应解释为 raw objective advantage with high-altitude bypass risk。它是强 baseline，应该保留在主表中；但不能只根据 fitness 判断其轨迹质量优于 `CVF-AE`。

## 论文表述建议

建议在正文中采用如下逻辑：

1. 先报告主对比 fitness / feasible rate / rank，承认 `CPO` 是强 baseline；
2. 再报告 trajectory sanity 指标，说明部分 baseline 会利用 high-altitude bypass 或 boundary-hugging detour；
3. 强调 `CVF-AE` 的优势不只是 scalar objective，而是 low-altitude mission-consistent trajectory quality；
4. 在代表性轨迹图中并列展示 `CVF-AE` 与 `CPO`，避免只凭表格解释。

推荐英文表述：

> Although CPO achieves the lowest scalar fitness in Scene 2-v2, its solutions frequently rely on high-altitude bypasses over the obstacle layer. This indicates an objective-semantics mismatch under the low-altitude UAV planning setting. In contrast, CVF-AE maintains competitive fitness while producing trajectories closer to the intended low-altitude corridor-following behavior.
