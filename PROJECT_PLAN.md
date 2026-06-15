# COVE_AE_matlab Project Plan

## 1. 项目定位

本项目是在 `FAEAE_matlab` 基础上重构的新一版 UAV 低空复杂环境路径规划研究项目。重构目标不是简单润色原 FAEAE，而是解决原方法存在的“模块拼接式创新”问题，并为后续大论文中可能开展的多无人机协同规划章节保留算法接口和复杂度空间。

原 FAEAE 的主要问题是：算法叙事呈现为 `参考路径初始化 + UCB-AOS + 局部修复 + 停滞再生` 的模块堆叠，虽然实验效果较好，但在高水平期刊编辑初筛中容易被认为新颖性不足、技术质量不够集中。

新项目的核心方向是：

> 构建面向强约束低空 UAV 路径规划的轻量化约束状态驱动搜索框架，而不是继续堆叠多个独立增强模块。

## 2. 建议暂定算法方向

建议采用短名：

- COVE-AE: Constraint-Oriented Viability Evolution with an Alpha Evolution backbone

该名称强调两个核心机制：constraint-state guidance 和 viability preservation，同时保留 AE 作为搜索骨架。当前项目文件夹命名为 `COVE_AE_matlab`。

## 3. 与原 FAEAE 的关系

原项目不应被完全推倒。它可以作为：

- 问题建模基础；
- UAV 场景与路径编码基础；
- 适应度函数和约束评估基础；
- 初始实验平台；
- 新算法的 baseline 或 legacy version；
- 大论文前后章节衔接材料。

但原 FAEAE 的创新叙事需要重构。新项目不再采用“四个模块并列”的表达，而是将初始化、算子选择、修复、再生统一到约束状态驱动的搜索逻辑中。

## 4. 可以复用的代码与内容

### 4.1 可直接复用

- 三维 UAV 场景建模：障碍物、禁飞区、高度限制、风险场、平滑性约束；
- B-spline 控制点路径表示；
- 轨迹采样与复合目标函数；
- 可行性优先选择准则；
- UAV baseline 优化器；
- 参数敏感性、主对比、消融、运行时间统计等实验框架；
- CEC2017 框架，作为补充性通用优化验证。

### 4.2 需要重构

- `optimizer_FAEAE_lite_v2_uav.m`
- `applyOperator_FAEAE_lite_v2.m`
- `getUAVAlgorithmConfig.m`
- `run_uav_comparison_lite_v2_batch.m`
- `run_uav_ablation_lite_v2_batch.m`

这些文件可作为起点，但新算法应重新组织核心决策逻辑。

### 4.3 不建议直接继承

- 旧论文图表导出结果；
- 多版本历史结果文件夹；
- 以旧 FAEAE 四模块为中心的消融设计；
- 旧 pipeline 中可能存在的过期函数调用；
- 旧 LaTeX 论文结构。

## 5. 三个核心创新点

新论文建议压缩为三个创新点，避免显得臃肿。

### 创新点 1：约束状态驱动的初始化与搜索阶段转移

将参考路径初始化纳入统一的约束状态驱动框架中，而不是把它作为独立模块堆叠。

算法根据以下指标识别搜索状态：

- 种群可行率；
- 平均约束违反量；
- 路径风险分布；
- 种群多样性；
- 最近窗口内的最优值改进。

可定义若干搜索状态：

- Feasibility formation：可行解稀缺，优先形成可行路径；
- Feasibility preservation：已有可行解，优先保持可行域内搜索；
- Quality refinement：可行率稳定，重点降低路径成本；
- Stagnation recovery：改进停滞，进行轻量结构化恢复。

### 创新点 2：约束状态转移驱动的轻量演化算子

原 UCB-AOS 不再作为独立创新点。新的算子选择应由约束状态驱动，并服务于 feasibility formation、feasibility preservation、quality refinement 和 stagnation recovery 之间的搜索阶段转移。

违反类型统计可作为诊断信息保留，但不再作为默认 proposed method 的强扰动核心。诊断类型可包括：

- 障碍物冲突；
- 禁飞区冲突；
- 高度越界；
- 风险场过高；
- 转角或平滑性违反；
- 路径长度或绕行成本过高。

算子不应表现为多个独立模块的机械叠加，而应体现不同约束状态下搜索重心的变化，例如可行性形成阶段更偏向参考走廊和精英收缩，可行性保持阶段更偏向近可行域搜索，质量优化阶段减少额外修复和强扰动。

### 创新点 3：面向效率的稀疏修复与经验复用机制

运行时间和复杂度应作为新算法的重要目标，因为后续可能扩展到多无人机协同规划。

建议设计：

- 只对 elite-side near-feasible 个体触发 sparse repair；
- 限制每轮最大修复次数；
- 记录修复成功率和修复方向；
- 将局部修复经验反馈给后续搜索算子；
- 避免大规模 regeneration 和频繁额外适应度评估。

论文中应明确强调：

> The proposed planner is designed as a lightweight constrained evolutionary planner for future extension to cooperative multi-UAV planning.

## 6. 主对比实验与公平性实验策略

如果参考路径初始化是新算法的创新组成部分，主对比实验不应强行给所有算法统一初始化。否则会人为剥离新算法优势。

建议：

- 主实验采用自然设置：各算法使用其合理默认初始化，新算法使用自己的约束状态初始化；
- 不把统一初始化实验作为主实验；
- 如需回应公平性质疑，可将统一初始化实验放入补充材料或鲁棒性分析；
- 在消融实验中保留 `Proposed-w/o state initialization`，证明初始化贡献但不是唯一贡献。

更重要的是主文要说清楚：

> The comparison evaluates each planner under its complete recommended configuration, because initialization is part of the proposed constrained planning strategy.

## 7. 对比算法体系

对比算法应分为三类，保证完整性。

### 7.1 经典基线

建议选择 4-5 个：

- PSO
- GWO
- HHO
- WOA
- DE 或 AE

这些用于证明新算法不只是优于弱基线。

### 7.2 近年 UAV 路径规划算法基线

建议选择 2-3 个近年 UAV 3D 路径规划方法，例如：

- PPSwarm 或类似混合 PSO UAV 路径规划方法；
- 近年 UAV 3D 路径规划中的改进群智能方法；
- GWO-A*、APF-IGWO、RRT*/PSO 等混合路径规划方法。

选择标准：

- 与三维 UAV 路径规划相关；
- 可复现或容易按论文实现；
- 约束条件与本项目场景可适配；
- 近三年文献优先。

### 7.3 基线改进算法

这里指其他经典算法的改进版本，不是 AE 的改进版本。

建议选择 3-4 个：

- IPSO：改进粒子群；
- IGWO、QGWO 或 HGWO：改进灰狼；
- IHHO：改进哈里斯鹰；
- IWOA 或 IDE：改进鲸鱼或差分进化。

这一类用于证明新方法不是只赢了原始 PSO/GWO/HHO/WOA，而是在改进型元启发式面前仍有竞争力。

## 8. 消融实验设计

消融实验应与三个创新点对应，而不是继续采用 `AE+Init+AOS+Repair` 的堆叠式消融。

建议：

- Base-AE 或 Legacy-FAEAE；
- Proposed-w/o constraint-state initialization；
- Proposed-w/o state transition；
- Proposed-w/o sparse repair and reuse；
- Full proposed method。

关键指标：

- 平均路径成本；
- 标准差；
- 可行率；
- 首次可行解出现迭代数；
- 平均运行时间；
- 总适应度评估次数；
- 修复触发次数；
- 修复成功率；
- 状态转移轨迹。

## 9. 运行时间与复杂度指标

新项目必须把效率作为主线之一。

建议在代码中显式记录：

- `nEvals`
- `runTime`
- `firstFeasibleIter`
- `firstFeasibleTime`
- `repairCount`
- `repairSuccessCount`
- `stateHistory`
- `operatorHistory`
- `feasibleRatioHistory`
- `meanViolationHistory`
- `diversityHistory`

复杂度分析应区分：

- 基础适应度评估复杂度；
- 状态识别复杂度；
- 违反反馈统计复杂度；
- 稀疏修复额外复杂度；
- 多无人机扩展时的潜在复杂度。

目标是证明新算法相对原 FAEAE 更适合向多无人机协同扩展。

## 10. 场景设计

原有三个场景可复用，但建议新增 1-2 个更难场景。

建议场景类型：

- 基础障碍绕行场景；
- 窄通道稀疏可行域场景；
- 多禁飞区与高风险场叠加场景；
- 强平滑约束场景；
- 为后续多无人机预留的拥挤通道或交叉通道场景。

每个场景都应明确对应一个规划挑战，避免场景只是随机堆障碍。

## 11. 投稿策略

不建议在原 FAEAE 稿件上小修后直接改投同级 AI 期刊。

建议顺序：

1. 完成新算法机制重构；
2. 更新主对比、强基线、消融和效率实验；
3. 重新组织论文主线；
4. 将 CEC2017 降级为补充性验证；
5. 优先投应用型 UAV、智能优化、机器人路径规划或工程应用方向期刊；
6. 如目标仍是高门槛 AI 期刊，需要进一步强化理论动机和机制统一性。

## 12. 第一阶段任务清单

### 代码层面

- 新建约束状态识别函数；
- 新建违反类型统计函数；
- 重构 FAEAE optimizer 为 state-driven 主循环；
- 设计轻量 state-transition operator；
- 重构 sparse repair，减少额外评估；
- 增加运行时间、首次可行解、修复次数、状态历史记录。

### 实验层面

- 清理旧结果依赖；
- 先跑 smoke experiment；
- 固定 3 个原始场景；
- 新增至少 1 个高难场景；
- 实现 2-3 个改进基线算法；
- 设计三创新点对应消融。

### 论文层面

- 重写 Introduction 的问题动机；
- 将创新点压缩为三个；
- 将公平性讨论从“统一初始化”转向“完整规划器配置比较”；
- 将效率和未来多无人机扩展写入方法动机；
- 重新设计实验章节结构。

## 13. 当前已复制的主要资产

本项目已从 `D:\MATLAB\Project\FAEAE_matlab` 复制以下类型文件：

- UAV 建模与适应度函数；
- B-spline 路径表示与编码；
- FAEAE lite-v2 相关实现；
- AE、PSO、GWO、HHO、WOA 基线；
- UAV 主对比、消融、参数敏感性脚本；
- 表格与绘图辅助脚本；
- CEC2017 框架；
- 原项目 README 备份到 `legacy_docs/FAEAE_README.md`。

旧实验结果、论文 PDF、LaTeX 文件和多版本历史图表没有复制进新项目，避免污染新研究路线。

## 14. 2026-06-14 18:17:25 +08:00 机制重构与中等门槛实验计划

### 14.1 决策背景

根据与学长的讨论和其提供的算法改进型论文目录，当前论文路线确定为：

> 以算法改进为主，UAV 路径规划作为强约束工程应用验证。

不再把论文写成“做了若干 UAV 地图”的应用创新，也不回到旧 FAEAE 的“四模块拼接式”叙事。论文主体应按算法改进型论文组织：基础算法不足、改进策略、消融验证、定性/效率分析、应用验证。

已有正式消融结果显示：

- 约束状态初始化贡献明确，尤其 Scene 4；
- sparse repair/reuse 有一定趋势，但还不够强，应重构为效率导向的辅助机制；
- violation feedback 在正式消融中未获支持，`COVE-AE-w/o-Feedback` 平均排名优于 full `COVE-AE`；
- 当前 full `COVE-AE` 不能直接进入主对比、参数敏感性、CEC 或正式论文实验。

因此，下一阶段不是继续微调 violation feedback 参数，也不是立刻重开全新论文项目，而是先做一次机制重构。

### 14.2 重构目标

重构后的 COVE-AE 应围绕三个更稳的创新点组织：

1. 约束状态识别与搜索阶段转移；
2. 约束状态引导初始化；
3. 约束状态自适应可行性保持机制。

原 violation feedback 不再作为强创新点。它应被降级为状态触发、接受过滤的轻量辅助机制，或被替换为更稳定的状态自适应选择/修复触发逻辑。full 方法不能依赖一个会破坏 Scene 2/4 质量的强扰动算子。

### 14.3 本阶段代码原则

- 保留 COVE-AE 项目和现有 UAV 建模、场景、实验框架；
- 不新增臃肿模块，不恢复旧 FAEAE 四模块叙事；
- 不修改 Scene 4 地图作为优先手段；
- 将 direct violation-feedback step 从主算子中弱化或移除；
- 将 sparse repair/reuse 改为状态自适应、有限额、近可行优先、接受过滤的可行性保持机制；
- 保持运行时间和额外评价次数可控；
- 保留用于消融的删减版本，使 full 与各机制删减版本可比较。

### 14.4 中等规模门槛实验

机制重构后先运行中等规模门槛实验，而不是直接跑正式消融：

- scenes: `[1, 2, 4]`
- variants: `Base-AE`, `COVE-AE-w/o-Init`, `COVE-AE-w/o-Feedback`, `COVE-AE-w/o-RepairReuse`, `COVE-AE`
- `nRuns = 10`
- `popSize = 30`
- `maxIter = 150`
- 记录 feasible rate、mean best fitness、first feasible iter、repair count/success、runtime、nEvals、state/operator history。

判断标准：

- full `COVE-AE` 的平均排名应优于主要删减版本；
- full 至少不能再被 `COVE-AE-w/o-Feedback` 稳定反超；
- 约束状态初始化贡献必须继续存在；
- 可行性保持机制不能明显增加无效运行时间；
- 若门槛实验仍不支持 full 方法，则暂停算法创新主线，考虑转向 UAV 应用/建模论文，或进一步重定义算法贡献。

### 14.5 停止条件

本阶段完成以下事项后停止：

1. 机制重构代码完成；
2. 中等规模门槛实验完成；
3. 结果写入 `docs/PROJECT_LOG.md`；
4. 根据证据给出是否继续算法创新路线的判断。

本阶段不开展正式消融、主对比、参数敏感性、CEC 或新增地图设计。

## 15. 2026-06-15 14:51:59 +08:00 Proposed Method Reset

### 15.1 决策

上一阶段两轮中等门槛实验已经提供足够证据：violation feedback 不能继续作为 COVE-AE 的命名核心创新点。当前更稳的候选主算法是原 `COVE-AE-w/o-Feedback` 逻辑，即：

- 保留 constraint-state initialization；
- 保留 constraint-state transition；
- 保留 sparse repair/reuse；
- 默认关闭 violation-feedback direct step 和 response candidate。

因此，后续 `COVE-AE` 默认配置调整为 no-feedback proposed method。`useViolationFeedback` 仅作为历史兼容和后续研究开关保留，不再作为默认 proposed 的组成部分。

### 15.2 新消融结构

新的中等门槛消融不再使用 `COVE-AE-w/o-Feedback` 作为核心对照，而改为：

- `Base-AE`
- `COVE-AE-w/o-Init`
- `COVE-AE-w/o-StateTransition`
- `COVE-AE-w/o-RepairReuse`
- `COVE-AE`

其中 `COVE-AE-w/o-StateTransition` 使用固定的静态可行性保持状态，保留初始化和修复复用，但不允许根据种群约束状态在 formation / preservation / refinement / recovery 之间动态切换。

### 15.3 判断标准

新 proposed method 进入后续正式实验前必须先通过中等规模门槛实验：

- scenes: `[1, 2, 4]`
- `nRuns = 10`
- `popSize = 30`
- `maxIter = 150`

通过标准：

- `COVE-AE` 平均排名应优于三个机制删减版本；
- `COVE-AE-w/o-Init` 应继续显著弱于 proposed，证明初始化贡献；
- `COVE-AE-w/o-StateTransition` 不应稳定优于 proposed，否则状态转移创新不成立；
- `COVE-AE-w/o-RepairReuse` 若与 proposed 接近，应将 repair/reuse 写成辅助效率机制，而不是主要性能创新；
- 若 proposed 仍无法优于删减版本，则应暂停算法创新路线，转向应用/建模型论文或进一步重定义算法贡献。
