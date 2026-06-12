# COVE_AE_matlab Project Plan

## 1. 项目定位

本项目是在 `FAEAE_matlab` 基础上重构的新一版 UAV 低空复杂环境路径规划研究项目。重构目标不是简单润色原 FAEAE，而是解决原方法存在的“模块拼接式创新”问题，并为后续大论文中可能开展的多无人机协同规划章节保留算法接口和复杂度空间。

原 FAEAE 的主要问题是：算法叙事呈现为 `参考路径初始化 + UCB-AOS + 局部修复 + 停滞再生` 的模块堆叠，虽然实验效果较好，但在高水平期刊编辑初筛中容易被认为新颖性不足、技术质量不够集中。

新项目的核心方向是：

> 构建面向强约束低空 UAV 路径规划的轻量化约束状态驱动搜索框架，而不是继续堆叠多个独立增强模块。

## 2. 建议暂定算法方向

建议采用短名：

- COVE-AE: Constraint-state and Violation-feedback Evolution with an Alpha Evolution backbone

该名称强调两个核心机制：constraint-state guidance 和 violation feedback，同时保留 AE 作为搜索骨架。当前项目文件夹命名为 `COVE_AE_matlab`。

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

### 创新点 2：违反反馈驱动的轻量演化算子

原 UCB-AOS 不再作为独立创新点。新的算子选择应由约束状态和违反类型共同驱动。

违反类型可包括：

- 障碍物冲突；
- 禁飞区冲突；
- 高度越界；
- 风险场过高；
- 转角或平滑性违反；
- 路径长度或绕行成本过高。

算子不应只在决策向量层面扰动，而应尽量引入路径结构信息，例如局部绕障、风险远离、曲率释放、参考走廊收缩等。

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
- Proposed-w/o violation feedback；
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
- 设计轻量 violation-feedback operator；
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
