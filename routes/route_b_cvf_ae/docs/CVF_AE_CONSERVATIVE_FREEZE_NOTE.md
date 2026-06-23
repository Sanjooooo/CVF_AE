# CVF-AE 保守状态自适应版本冻结说明

创建时间：2026-06-23

## 冻结对象

当前路线 B 的默认主方法冻结为：

> `CVF-AE = Constraint Viability Field guided Alpha Evolution`
>
> 保守状态自适应 CVF 调度版本的 CVF-AE。

该版本以约束可行性场为核心引导机制，保留约束感知初始化、保守状态自适应 CVF 调度和稀疏可行性保持。旧版激进状态自适应结果仅作为机制诊断历史，不作为论文正式主方法。

## 冻结依据

正式消融结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_conservative_20260622_194947`

正式主对比结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`

关键判断：

- 正式消融中，完整 `CVF-AE` 平均排名为 `1.00`，优于 `w/o-StateAdaptiveCVF`、`w/o-CVF`、`w/o-SparsePreservation`、`w/o-Init` 和 `Base-AE`。
- 正式主对比中，`CVF-AE` 平均排名为 `1.33`，在 Scene 1 和 Scene 4 raw fitness 排名第一，在 Scene 2-v2 排名第二。
- `CVF-AE` 在三个正式主对比场景中 feasible rate 均为 `1.00`。
- 轨迹 sanity 显示 `CVF-AE` 在 Scene 1 和 Scene 2-v2 的 `VisualReviewFlagRate = 0`，Scene 4 为 `0.20`。
- `CPO` 是强 baseline，Scene 2-v2 raw fitness 最优，但伴随明显 high-altitude bypass 风险，不能据此反向调整主方法去追逐单一 scalar fitness。

## 后续参数敏感性原则

后续参数敏感性实验只用于验证默认参数的鲁棒性，不作为常规调参循环。

除非某个参数变体同时满足以下条件，否则不再反向修改当前默认主方法：

- 在 Scene 2-v2 和 Scene 4 等关键强约束场景中全面优于默认版本；
- 在不同 run 上表现稳定，而不是少数随机种子的偶然优势；
- 相对默认版本具有清晰、显著且可解释的收益；
- 不引入明显更高 runtime、`nEvals` 或 trajectory sanity 风险；
- 不破坏当前论文叙事中“低开销约束可行性场驱动搜索”的核心定位。

如果参数敏感性结果显示默认参数不是每项第一，但始终处于稳定前列，则保持当前默认版本不变，并将结论写为“默认 CVF-AE 对关键 CVF 参数具有鲁棒性”。

## 写作边界

- 论文和路线 B 文档统一使用 `CVF-AE`。
- 不再使用 `COVE-AE-CVF`、`COVE-AE-reset`、路线 A 对比、`fallback`、`CSFAEAE` 等叙事。
- 不再把 violation feedback 写成核心创新。
- 保守状态自适应只作为 CVF 调度机制的一部分，不单独夸大为唯一核心贡献。
- 主贡献应围绕 constraint viability field、状态调度下的可行性场引导和低开销稀疏可行性保持展开。
