# Writing Plan

## 当前目标

创建可在 Overleaf 中文编译的 CVF-AE 中文论文初稿工程。当前阶段先完成骨架、来源映射、AJSE 官方要求记录和图表资产整理，不大规模撰写正文。

## AJSE 叙事策略

- 主线：强约束三维/低空 UAV 路径规划的工程应用。
- 方法核心：Constraint Viability Field 将障碍物、禁飞区、风险、高度、曲率和边界压力转化为有界、稀疏、可参与进化更新的可行性方向。
- 结果解读：强调综合竞争力、完整可行率、平均排名、受控评价开销和轨迹合理性；不得声称所有场景 scalar fitness 均最优。
- CEC：不写入本文。
- 真实地图/DEM：当前不补，作为局限性和后续工作。

## 章节结构

1. 摘要与关键词
2. 引言
3. 相关工作
4. 问题建模
5. CVF-AE 方法
6. 实验设计
7. 结果与讨论
8. 局限性
9. 结论

## 每章数据来源

- 问题建模：`fitnessFAEAE.m`、`defaultParams.m`、`createMap.m`、`applyUAVSceneOverrides.m`、`debBetter.m`。
- 方法：`CVF_MECHANISM_DERIVATION.md`、`buildConstraintViabilityField.m`、`applyOperator_CVF_AE.m`、`optimizer_CVF_AE_uav.m`、`identifyConstraintState.m`、`init_COVE_AE.m`、`repairPath.m`。
- 实验设计：`CVF_AE_MAIN_COMPARISON_PROTOCOL.md`、`getUAVAlgorithmConfig.m`、用户确认的硬件环境。
- 结果：`CVF_AE_RESULTS_INDEX.md` 和 `cvf_ae_paper_results_package_20260624_from_formal_results/` 下的 CSV/XLSX。
- 投稿要求：AJSE 官方 submission guidelines 和 Springer Nature LaTeX Author Support。

## 写作顺序

1. 完成 LaTeX 骨架、notes 和 figure 复制。
2. 将 CSV 表格转换为 LaTeX 表格。
3. 先写第 3 章问题建模和第 4 章方法。
4. 再写实验设计和结果讨论。
5. 最后写引言、摘要、局限性、结论和参考文献。

## 风险清单

- 不得写 Scene 4；internal map ID 4 只能作为 paper Scene 3。
- 不得写 paired signed-rank；正式显著性为 Wilcoxon rank-sum / Mann-Whitney U。
- 不得将 CEC Stage B 写成正式正结果。
- 不得编造参考文献。
- 不得使用本机绝对路径写入最终 LaTeX。
- 不得声称通用最优或所有场景全面最优。
- `evaluatePath.m` 不存在，评价函数映射为 `fitnessFAEAE.m`。
