# 路线 B 拟定论文目录：结合算法改进型论文结构

创建时间：2026-06-17 15:21:25 +08:00

## 论文暂定题目

中文：

> 面向强约束低空无人机路径规划的低开销约束可行性场驱动进化算法

英文：

> A Low-Overhead Constraint Viability Field Driven Evolutionary Algorithm for Strongly Constrained Low-Altitude UAV Path Planning

## 摘要写作主线

摘要应按以下逻辑展开：

1. 强约束低空 UAV 路径规划中，可行域稀疏、约束类型复杂、随机搜索难以稳定形成可行路径。
2. 传统元启发式算法主要依赖 penalty、随机扰动或事后 repair，缺少显式可行性提升方向。
3. 本文提出低开销约束可行性场驱动进化算法，构建由障碍物、禁飞区、风险场、高度边界和曲率约束共同形成的控制点可行性场。
4. 算法将 AE 搜索方向、约束可行性场方向和路径质量优化方向进行状态自适应融合。
5. 通过稀疏可行性保持机制限制额外运行时间和评价次数。
6. 多个强约束 UAV 场景和消融实验验证算法在可行率、首次可行迭代、路径质量和运行效率上的优势。

## 1. 引言

### 1.1 研究背景

- 低空 UAV 路径规划的重要性；
- 城市低空环境中的复杂约束；
- 强约束场景下可行路径形成困难；
- 多无人机扩展对运行时间和复杂度提出更高要求。

### 1.2 现有方法不足

可从三类方法切入：

- 经典路径规划方法：
  - A*、RRT、RRT*、APF 等；
  - 优点是结构清晰；
  - 不足是处理多目标、多连续约束和复杂风险场时灵活性不足。
- 群智能/元启发式方法：
  - PSO、GWO、HHO、WOA、AE 等；
  - 优点是全局搜索能力强；
  - 不足是强约束场景下容易产生大量不可行解。
- 约束处理方法：
  - penalty；
  - repair；
  - feasibility rule；
  - reference initialization；
  - 不足是缺少统一的可行性方向建模，或者运行开销较高。

### 1.3 问题缺口

重点提出：

> 现有方法往往把约束信息作为评价惩罚或事后修复，而没有将多源约束转化为可直接参与进化更新的可行性引导场。

### 1.4 本文贡献

建议写成三点：

1. 提出一种约束可行性场构建方法，将障碍物、禁飞区、风险、高度和曲率等 UAV 约束统一为路径控制点层面的可行性提升方向。
2. 提出状态自适应可行性场驱动进化机制，将 AE 搜索方向、CVF 可行性方向和路径质量方向按约束状态动态融合。
3. 设计低开销稀疏可行性保持机制，通过关键个体和关键控制点选择限制额外评价次数，并在多强约束 UAV 场景中验证其有效性。

### 1.5 文章结构

简述各章节安排。

## 2. UAV 路径规划问题建模与基础算法

对应师兄目录中的“基础算法简介”和应用问题建模，但更适合本项目。

### 2.1 三维 UAV 路径表示

- 起点与终点；
- B-spline 控制点编码；
- 决策变量定义；
- 路径采样点。

### 2.2 优化目标

建议包括：

- 路径长度；
- 能耗；
- 风险代价；
- 平滑性；
- 高度偏好；
- 边界代价。

### 2.3 约束条件

- 障碍物碰撞约束；
- 禁飞区约束；
- 高度约束；
- 曲率/转角约束；
- 地图边界约束。

### 2.4 约束优化准则

- penalty 函数；
- Deb feasibility rule；
- 可行率、违反量定义。

### 2.5 Alpha Evolution 基础算法

- AE 的基本搜索框架；
- AE 在连续优化中的更新思想；
- AE 用于 UAV 路径规划时的问题：
  - 随机初始化可行率低；
  - 缺少可行性方向；
  - 对强约束状态变化响应不足。

## 3. 所提 COVE-AE-CVF 算法

对应师兄目录中的“改进策略”章节，是全文核心。

### 3.1 总体框架

- 方法总览图；
- 输入输出；
- 三个核心机制；
- 与原 AE 的区别；
- 与旧 COVE-AE reset 的关系。

### 3.2 约束状态识别

状态指标：

- feasible ratio；
- mean violation；
- diversity；
- recent improvement；
- whether feasible solution exists。

状态类型：

- Feasibility formation；
- Feasibility preservation；
- Quality refinement；
- Stagnation recovery。

需要说明：

- 状态不是单独创新模块，而是调节 CVF 和 AE 搜索权重的控制变量。

### 3.3 约束可行性场构建

本节是强创新核心。

### 3.3.1 障碍物可行性场

- 对箱体障碍物构建排斥方向；
- 根据穿透深度或距离设置强度；
- 映射到最近或相关控制点。

### 3.3.2 禁飞区可行性场

- 对圆柱禁飞区构建径向外推方向；
- 考虑高度范围；
- 与障碍物场统一归一化。

### 3.3.3 风险可行性场

- 风险热点产生风险下降方向；
- 可使用风险场梯度或近似梯度；
- 控制风险回避强度，避免过度绕行。

### 3.3.4 高度可行性场

- 高度越界回拉；
- 高度参考层回归；
- 与水平避障方向解耦。

### 3.3.5 曲率可行性场

- 对转角超限位置进行曲率释放；
- 调整局部控制点，使路径更平滑；
- 避免全局平滑破坏绕障结构。

### 3.3.6 综合可行性场

给出综合公式：

```text
F_v(q_k) = Σ_c λ_c(s, V_c) F_c(q_k)
```

说明：

- `c` 表示约束类型；
- `λ_c` 与当前状态和约束违反强度有关；
- 综合场需要归一化和步长限制。

### 3.4 状态自适应 CVF-AE 更新策略

给出核心更新公式：

```text
X_i(t+1) = X_i(t)
         + alpha_s D_AE
         + beta_s D_CVF
         + gamma_s D_Q
```

分别说明：

- `D_AE`：基础 AE 搜索方向；
- `D_CVF`：约束可行性场方向；
- `D_Q`：质量优化方向；
- `alpha_s`、`beta_s`、`gamma_s`：状态自适应权重。

按状态说明：

- formation：强化 CVF；
- preservation：平衡 AE 和 CVF；
- refinement：减弱 CVF，增强质量搜索；
- recovery：增加探索，避免被 CVF 过度收缩。

### 3.5 低开销稀疏可行性保持

说明：

- 关键个体选择；
- near-feasible 触发条件；
- 关键控制点选择；
- 每代最大 CVF 次数；
- 每代最大 repair 次数；
- Deb-better 接受。

### 3.6 算法伪代码

可放一个完整伪代码：

```text
Algorithm 1: COVE-AE-CVF
Input: map, start, goal, population size, max iteration
Output: best feasible UAV path
1. Generate state-guided initial population
2. Evaluate population
3. for t = 1 to T do
4.     Identify constraint state
5.     Construct CVF statistics
6.     for each individual do
7.         Generate AE search direction
8.         If selected, compute sparse CVF direction
9.         Fuse AE, CVF, and quality directions
10.        Evaluate candidate
11.        Apply sparse feasibility preservation if needed
12.        Accept by Deb rule
13.    end for
14.    Update best solution and histories
15. end for
```

### 3.7 复杂度分析

对应师兄目录中的“算法复杂度分析”。

应分析：

- 初始化复杂度；
- AE 更新复杂度；
- fitness evaluation 复杂度；
- CVF 计算复杂度；
- sparse repair 复杂度；
- 总复杂度。

建议结论：

> CVF 引入的额外计算由稀疏触发和关键控制点选择限制，其额外开销相对于完整路径评价是可控的。

### 3.8 收敛性讨论，可选

师兄目录中提到 Markov 链收敛性分析可写可不写。

建议当前阶段：

- 不强写严格全局收敛证明；
- 可以写“收敛性讨论”或“搜索稳定性分析”；
- 若目标期刊要求理论，可后续补 Markov 链形式。

## 4. 改进策略有效性分析

对应师兄目录中的“策略有效性分析（消融实验）”。

### 4.1 消融实验设计

建议版本：

- `Base-AE`
- `COVE-AE-reset`
- `COVE-AE-CVF-w/o-Init`
- `COVE-AE-CVF-w/o-StateAdaptiveCVF`
- `COVE-AE-CVF-w/o-SparsePreservation`
- `COVE-AE-CVF`

### 4.2 单机制贡献分析

分析：

- 初始化贡献；
- CVF 贡献；
- 状态自适应权重贡献；
- 稀疏可行性保持贡献。

### 4.3 组合机制贡献分析

如果单一机制效果不明显，但组合后有效，需要解释：

- 初始化解决早期可行路径形成；
- CVF 提供局部可行性方向；
- 状态自适应避免 CVF 在质量优化阶段过度干预；
- sparse preservation 控制额外开销。

### 4.4 失败或负贡献场景分析

必须诚实分析：

- CVF 是否在简单场景中不如静态策略；
- CVF 是否增加 runtime；
- repair 是否在某些场景收益不明显；
- 哪些场景主要由初始化贡献。

## 5. 定性分析

对应师兄目录中的“定性分析（现在流行）”。

建议不要只做 CEC 图，而是做 UAV 场景相关定性图。

### 5.1 搜索历史图

- 每代 best fitness；
- feasible ratio；
- mean violation。

### 5.2 路径演化图

- 初始路径；
- 中期路径；
- 最终路径；
- 对比 CVF 与 no-CVF。

### 5.3 可行性场示意图

- 在 2D top-view 中显示障碍物/禁飞区和局部可行性方向；
- 展示控制点如何被 CVF 引导。

### 5.4 探索-开发平衡图

- 可用 diversity；
- state fraction；
- operator usage；
- CVF trigger count。

### 5.5 first feasible iter 分析

- 展示 CVF 是否更早形成可行解。

## 6. 实验结果与分析

对应师兄目录中的“实验结果与分析”。

### 6.1 参数设置及实验安排

必须写：

- 计算机配置；
- MATLAB 版本；
- CPU / RAM；
- `popSize`；
- `maxIter`；
- `nRuns`；
- `baseSeed` 说明；
- 终止条件；
- 评价指标。

评价指标：

- best / mean / std；
- feasible rate；
- first feasible iter；
- runtime；
- nEvals；
- repair count；
- CVF count；
- Friedman average rank；
- Wilcoxon signed-rank test。

### 6.2 UAV 场景设置

当前主场景：

- Scene 1：基础城市走廊；
- Scene 2：密集障碍 / 窄通道；
- Scene 4：城市配送走廊，旧论文 Paper Scene 3。

注意：

- 不恢复真实 code Scene 3；
- Scene 4 不优先改地图；
- 每个场景要说明对应挑战。

### 6.3 与经典算法对比

建议包括：

- AE；
- PSO；
- GWO；
- HHO；
- WOA；
- 可选 DE。

### 6.4 与改进型算法对比

结合师兄建议，增加强基线：

- IPSO；
- IGWO / QGWO / HGWO；
- IHHO；
- IWOA / IDE；
- 或近年 UAV 路径规划算法。

选择标准：

- 能复现；
- 与连续路径规划适配；
- 参数可公平设置；
- 不引入过多额外工程成本。

### 6.5 主结果表

每个场景给：

- mean best fitness；
- std；
- feasible rate；
- average rank。

### 6.6 收敛曲线

建议：

- 使用平均收敛曲线；
- 或报告代表性最优 run，但需说明；
- 不要只挑最好一条曲线误导。

### 6.7 箱型图

展示稳定性。

### 6.8 运行时间和评价次数对比

路线 B 必须重点写。

展示：

- runtime；
- nEvals；
- repair count；
- CVF count；
- first feasible time。

### 6.9 统计检验

- Wilcoxon signed-rank test；
- Friedman mean rank；
- 显著性水平 `p < 0.05`。

## 7. 工程应用讨论

对应师兄目录中的“算法应用”。

### 7.1 UAV 路径可视化

- 3D 路径；
- top-view；
- 风险场/禁飞区/障碍物显示；
- 对比路径质量。

### 7.2 强约束场景适用性

讨论：

- 稀疏可行域；
- 窄通道；
- 多禁飞区；
- 风险规避；
- 强曲率约束。

### 7.3 多无人机扩展潜力

重点围绕：

- 低开销；
- 有界额外 evaluation；
- sparse CVF；
- 可扩展到多无人机时空冲突约束。

### 7.4 局限性

必须写：

- 当前仍是静态环境；
- 未考虑实时动态障碍；
- CVF 依赖可解析或可采样的约束结构；
- 多无人机协同尚未正式实现；
- 强创新机制仍主要围绕 UAV 结构约束，不宣称通用最优。

## 8. 总结与展望

总结：

- 提出 CVF；
- 提出状态自适应 CVF-AE；
- 低开销可行性保持；
- UAV 场景验证。

展望：

- 动态障碍；
- 多无人机协同；
- 真实地图；
- 更强理论分析；
- 通用约束优化扩展。

## 附录或补充材料

### A. 参数敏感性

建议参数：

- CVF strength；
- CVF trigger ratio；
- guided initialization ratio；
- repair quota；
- state thresholds。

### B. CEC 或通用约束优化补充

如果路线 B 机制可以抽象到一般约束优化，可做小规模补充。

但不建议作为主线，除非 CVF 被重新定义成通用约束场。

### C. 更多路径图

放每个场景的典型路径。

### D. 复杂度推导细节

放完整符号推导。

## 与师兄推荐目录的对应关系

| 师兄推荐目录 | 本论文对应章节 |
|---|---|
| 1. 引言 | 第 1 章 |
| 2. DBO 改进策略 | 第 3 章 COVE-AE-CVF 算法 |
| 2.1 DBO 简介 | 第 2.5 节 AE 基础算法 |
| 2.2 改进策略 | 第 3.2-3.5 节 |
| 2.3 策略有效性分析 | 第 4 章消融实验 |
| 2.4 定性分析 | 第 5 章 |
| 2.5 流程图/伪代码 | 第 3.6 节 |
| 2.6 复杂度分析 | 第 3.7 节 |
| 2.7 收敛性分析 | 第 3.8 节，可选 |
| 3. 实验结果与分析 | 第 6 章 |
| 3.1 参数设置及实验安排 | 第 6.1 节 |
| CEC 测试 | 可选补充材料 |
| 收敛曲线/秩和检验/箱型图 | 第 6.6-6.9 节 |
| 4. 算法应用 | 第 7 章 UAV 工程应用讨论 |
| 5. 总结 | 第 8 章 |

## 写作禁忌

- 不要写成“多策略改进 AE”。
- 不要把 CVF 写成普通 repair。
- 不要继续强调 violation feedback。
- 不要说算法是通用最强优化器。
- 不要只报告 fitness，必须报告效率指标。
- 不要隐藏 Scene 1 中某些 ablation 可能更优的事实，应从效率和强约束场景解释。
