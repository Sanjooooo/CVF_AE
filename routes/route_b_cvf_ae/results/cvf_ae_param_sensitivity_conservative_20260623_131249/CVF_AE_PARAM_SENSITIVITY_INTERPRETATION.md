# CVF-AE 参数敏感性实验解释

生成时间：2026-06-23

## 配置

- 场景：`[2 4]`
- nRuns：`10`
- popSize：`30`
- maxIter：`300`
- baseSeed：`20260631`
- resumeExisting：`1`

## 参数组

- `quota_scale`：CVF candidate quota scale
- `step_strength`：CVF step strength
- `state_switch_threshold`：Conservative state switching threshold

## 平均排名摘要

| Parameter | Level | Average rank | Average mean fitness | Feasible rate | nEvals | CVF count |
|---|---|---:|---:|---:|---:|---:|
| quota_scale | low | 3.00 | 328.7971 | 1.00 | 9446.5 | 49.0 |
| quota_scale | default | 2.00 | 322.2325 | 1.00 | 9444.7 | 47.5 |
| quota_scale | high | 1.00 | 320.7300 | 1.00 | 9464.1 | 53.0 |
| step_strength | weak | 2.00 | 324.5811 | 1.00 | 9457.6 | 49.5 |
| step_strength | default | 2.00 | 327.9686 | 1.00 | 9457.8 | 51.5 |
| step_strength | strong | 2.00 | 326.6824 | 1.00 | 9447.5 | 49.1 |
| state_switch_threshold | strict | 2.50 | 328.8987 | 1.00 | 9464.9 | 46.1 |
| state_switch_threshold | default | 1.50 | 326.1410 | 1.00 | 9447.3 | 49.2 |
| state_switch_threshold | loose | 2.00 | 328.8289 | 1.00 | 9470.5 | 54.2 |

## 初步判读规则

- 默认参数不要求在每个场景和每个参数组中都排名第一，但应保持稳定前列。
- 只有某个非默认参数在 Scene 2-v2 和 Scene 4 中都全面、稳定、显著优于默认，且没有增加明显 `nEvals`、runtime 或轨迹风险，才考虑重新打开主方法冻结。
- 如果非默认参数只在单场景或单指标上更好，则作为鲁棒性观察，不反向修改默认主方法。

## 结果判读

### CVF candidate quota scale

`high` 在 Scene 2-v2 和 Scene 4 的 mean best fitness 均略优于 `default`：

- Scene 2-v2：`high = 300.89`，`default = 302.07`；
- Scene 4：`high = 340.57`，`default = 342.40`。

但该收益幅度较小，同时平均 `nEvals` 从 `9444.7` 增加到 `9464.1`，平均 CVF 触发次数从 `47.5` 增加到 `53.1`。因此 `high` 可记录为一个有潜力的稳健性观察，但不足以推翻当前默认参数。

`low` 在两个场景均弱于 `default`，尤其 Scene 4 的 mean best fitness 从 `342.40` 恶化到 `354.88`，说明过低 CVF quota 会削弱强约束场景中的可行性场贡献。

### CVF step strength

三档平均排名均为 `2.00`，没有形成稳定排序：

- Scene 2-v2 中 `default` 最好；
- Scene 4 中 `weak` 最好；
- `strong` 没有在两个场景中稳定优于 `default`。

因此默认 step strength 可保持不变。当前结果说明 CVF-AE 对 CVF field strength 具有一定鲁棒性，而不是需要向更强或更弱方向调整。

### conservative state switching threshold

`default` 的平均排名为 `1.50`，优于 `loose = 2.00` 和 `strict = 2.50`：

- Scene 2-v2 中 `loose` 略优于 `default`；
- Scene 4 中 `default` 明显优于 `loose` 和 `strict`。

由于 Scene 4 是关键强约束场景，且 `default` 综合排名最好，因此保守状态切换阈值继续保持默认。

## 轨迹 sanity 补充

已额外生成参数敏感性轨迹 sanity 文件：

- `param_sensitivity_trajectory_sanity_runs.csv`
- `param_sensitivity_trajectory_sanity_summary.csv`
- `param_sensitivity_trajectory_sanity_flags.csv`

关键观察：

- Scene 2-v2 所有参数组和档位的 `VisualReviewFlagRate = 0`；
- Scene 4 的风险主要来自 boundary-hugging，而不是 high-altitude bypass；
- `quota_scale = high` 在 Scene 4 的 `VisualReviewFlagRate = 0`，但其额外 CVF 触发和 `nEvals` 更高；
- `state_switch_threshold = default` 在 Scene 4 的 `VisualReviewFlagRate = 0.4`，需要在后续代表轨迹图阶段继续人工筛选 median / best run，不影响本阶段参数冻结判断。

## 阶段结论

本阶段不建议修改主方法默认参数。

理由：

- 没有任何非默认参数在 fitness、`nEvals`、CVF 触发次数和 trajectory sanity 上同时全面、稳定、显著优于默认；
- `quota_scale = high` 虽然 fitness 略优且 Scene 4 sanity 更好，但收益幅度有限，并引入更高 CVF 触发和 `nEvals`；
- step strength 的三档表现接近，说明默认值不是脆弱点；
- state switching threshold 的默认值综合排名最好。

因此，当前“保守状态自适应 CVF 调度版本的 CVF-AE”保持冻结。参数敏感性结果应写作“默认参数处于稳定前列，CVF-AE 对关键 CVF 参数具有鲁棒性”，而不是作为重新调参依据。
