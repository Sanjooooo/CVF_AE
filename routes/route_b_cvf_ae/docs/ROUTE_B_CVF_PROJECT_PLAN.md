# 路线 B 项目开展计划：CVF-AE 低开销约束可行性场驱动进化搜索

创建时间：2026-06-17 15:21:25 +08:00

## 1. 项目背景

本项目当前聚焦路线 B：围绕约束可行性场构建新的核心算法机制，并以 `CVF-AE` 作为统一算法名。后续文档、代码配置和实验命名均应服务于 `CVF-AE`。

路线 B 的目标是在现有 UAV 建模、路径编码、场景、评价函数和实验框架基础上，设计一个具有明确数学表达和可验证机制贡献的强算法创新。

## 2. 总主题

路线 B 的总主题确定为：

> 面向强约束低空 UAV 路径规划的低开销约束可行性场驱动进化算法。

英文暂定：

> A Low-Overhead Constraint Viability Field Driven Evolutionary Search for Strongly Constrained UAV Path Planning.

核心思想：

> 在强约束 UAV 路径规划中，搜索困难的本质不是单纯缺少随机扰动，而是候选路径缺少明确的可行性提升方向。因此，算法显式构建由障碍物、禁飞区、风险场、高度边界和曲率约束共同形成的约束可行性场，引导路径控制点在保持 AE 全局搜索能力的同时，向更高可行性区域移动。

## 3. 研究定位

本路线仍然以算法改进为主，但不定位为完全通用的泛优化算法。更准确的定位是：

> 面向强约束 UAV 路径规划的领域约束驱动进化算法。

这意味着：

- UAV 路径规划是主要验证对象，不只是最后的附加应用；
- 新机制要有明确数学表达，而不是经验模块堆叠；
- 复杂约束信息应进入搜索方向，而不只是进入 penalty 或后处理 repair；
- 运行时间、评价次数和修复次数必须作为算法设计目标，而不是事后补充指标；
- CEC 或通用约束优化测试可作为补充，而不是主线。

## 4. 拟定算法短名

统一使用：

> CVF-AE: Constraint Viability Field guided Alpha Evolution.

含义：

- `CVF` 强调 constraint viability field，即约束可行性场；
- `AE` 表示保留 Alpha Evolution 作为基础进化搜索骨架；
- 项目代码目录可暂时沿用 `COVE_AE_matlab`，但论文、规划文档和后续实验命名统一使用 `CVF-AE`；
- 算法名、实验名和论文方法名统一使用 `CVF-AE` 及其消融变体。

## 5. 核心创新点设计

### 5.1 创新点 1：约束可行性场构建

目标：

将 UAV 路径规划中的多类约束统一为控制点层面的可行性压力场。

约束来源：

- 障碍物约束；
- 禁飞区约束；
- 风险场约束；
- 高度边界约束；
- 曲率/平滑性约束；
- 边界/走廊约束。

基本思想：

对路径采样点计算局部约束压力，再映射回影响该采样点的控制点，得到控制点的可行性提升方向。

概念公式：

```text
F_v(q_k) = w_obs F_obs(q_k)
         + w_nfz F_nfz(q_k)
         + w_risk F_risk(q_k)
         + w_alt F_alt(q_k)
         + w_curv F_curv(q_k)
```

其中：

- `q_k` 表示路径控制点；
- `F_v(q_k)` 表示控制点的综合可行性场方向；
- `F_obs`、`F_nfz`、`F_risk`、`F_alt`、`F_curv` 分别表示不同约束产生的可行性压力方向；
- 权重应与约束状态和违反程度相关，而不是固定经验常数。

需要避免：

- 不能只是旧 repairPath 的重复包装；
- 不能只是 penalty 的另一种写法；
- 不能对所有个体和所有控制点做重计算；
- 不能依赖大量额外 fitness evaluation 才有效。

### 5.2 创新点 2：状态自适应可行性场驱动进化

目标：

将 AE 的全局搜索方向和可行性场方向统一到一个更新公式中。

概念公式：

```text
X_i(t+1) = X_i(t)
         + alpha_s D_AE
         + beta_s D_CVF
         + gamma_s D_Q
```

其中：

- `D_AE` 是 AE backbone 提供的全局/精英/差分搜索方向；
- `D_CVF` 是 constraint viability field 提供的可行性提升方向；
- `D_Q` 是质量优化方向，例如路径长度、平滑性、风险降低方向；
- `alpha_s`、`beta_s`、`gamma_s` 由约束状态 `s` 决定。

状态设计：

- Feasibility formation：提高 `beta_s`，优先形成可行解；
- Feasibility preservation：保持适中 `beta_s`，避免离开可行区域；
- Quality refinement：降低 `beta_s`，提高 `gamma_s`，重点优化路径质量；
- Stagnation recovery：提高探索比例，限制可行性场过度收缩。

创新要求：

- 状态转移必须影响更新公式，而不是只影响日志标签；
- 可行性场必须参与生成 offspring，而不是事后修复；
- 接受准则仍使用 Deb feasibility rule，保证约束优化逻辑一致。

### 5.3 创新点 3：低开销稀疏可行性保持

目标：

控制可行性场和修复机制带来的额外运行时间，使算法适合后续扩展到多无人机协同规划。

设计原则：

- 只对 elite-side 或 near-feasible 个体启用完整可行性场；
- 只更新关键控制点，而不是整条路径全部控制点；
- 每代可行性场引导次数有上界；
- 每代 repair 次数有上界；
- 尽量复用 fitness evaluation 中已经得到的路径采样和违反信息；
- 如果可行性场候选没有 Deb-better，则保留原 AE offspring。

关键指标：

- `nEvals`
- `runTime`
- `repairCount`
- `repairSuccessCount`
- `firstFeasibleIter`
- `firstFeasibleTime`
- `viabilityFieldCount`
- `viabilityFieldSuccessCount`
- `feasibleRatioHistory`
- `meanViolationHistory`

## 6. 技术路线

### 阶段 0：确立 CVF-AE 主线与工程隔离

目标：

在不破坏现有工程文件的前提下，建立 `CVF-AE` 的独立实现入口，使后续实验和论文叙事全部围绕 `CVF-AE` 展开。

动作：

- 新增或隔离 `CVF-AE` 算法入口；
- 后续消融、门槛实验和论文目录均使用 `CVF-AE` 命名；
- 历史算法和历史实验只作为项目背景，不进入路线 B 的正式对比设计。

### 阶段 1：数学机制设计

目标：

先把可行性场机制写成公式和伪代码，再写代码。

任务：

- 明确定义路径采样点到控制点的映射；
- 明确定义 obstacle / NFZ / risk / altitude / curvature 的场方向；
- 明确定义状态自适应权重；
- 明确定义 CVF 候选生成和接受准则；
- 明确额外复杂度上界。

阶段产出：

- `docs/CVF_MECHANISM_DERIVATION.md`
- 算法伪代码；
- 复杂度草稿。

### 阶段 2：最小代码实现

目标：

实现一个最小可运行 CVF prototype，不追求一次到位。

建议新增文件：

- `buildConstraintViabilityField.m`
- `applyOperator_COVE_AE_CVF.m`
- `optimizer_COVE_AE_CVF_uav.m`
- `run_cove_ae_cvf_gate_diagnostics.m`

实现原则：

- 不直接覆盖已有稳定文件，优先通过新文件或新配置隔离 CVF-AE；
- 先复用 `fitnessFAEAE.m`、`repairPath.m`、`identifyConstraintState.m`；
- CVF 候选每次最多增加 1 次 evaluation；
- 所有新增指标进入 result struct。

### 阶段 3：最小门槛验证

目标：

先证明 CVF 机制没有明显负贡献。

配置：

- scenes: `[2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE-w/o-Init`
- `nRuns = 5`
- `popSize = 20`
- `maxIter = 80`

通过标准：

- `CVF-AE` 不能依赖大量额外评价次数或运行时间换取表面收益；
- CVF 版本在 Scene 2 或 Scene 4 至少一个场景表现出可行率、首次可行迭代或 mean best fitness 改善；
- 若 CVF 在两个场景都变差，立即停止，不进行参数大调。

### 阶段 4：中等门槛验证

配置：

- scenes: `[1, 2, 4]`
- `nRuns = 10`
- `popSize = 30`
- `maxIter = 150`

算法：

- `Base-AE`
- `CVF-AE-w/o-Init`
- `CVF-AE-w/o-StateAdaptiveCVF`
- `CVF-AE-w/o-SparsePreservation`
- `CVF-AE-w/o-CVF`
- `CVF-AE`

通过标准：

- `CVF-AE` 平均排名第一或与第一非常接近；
- `CVF-AE` 至少在 Scene 2/4 展示出相对删减版本的明确收益；
- CVF 机制不能只靠大量 repair 或大量额外 `nEvals` 取胜；
- `w/o-StateAdaptiveCVF` 不能稳定优于 full。

### 阶段 5：正式实验

只有阶段 4 通过后才进入正式实验。

正式实验包括：

- 正式消融；
- 主对比；
- 参数敏感性；
- 收敛曲线；
- 箱型图；
- 运行时间分析；
- Wilcoxon / Friedman 统计检验；
- 可选补充：CEC 或通用约束优化小规模验证。

## 7. 公平性原则

### 7.1 主对比公平性

主对比采用完整规划器配置比较：

- CVF-AE 使用自己的约束状态初始化和 CVF 机制；
- 其他算法使用各自合理默认初始化；
- 不强制所有算法使用 CVF-AE 初始化，否则会剥离 proposed method 的组成部分。

但需要补充：

- `w/o-Init` 消融；
- 可选统一初始化鲁棒性实验；
- 运行时间和评价次数对比。

### 7.2 消融公平性

每个消融版本只移除一个明确机制。

禁止：

- 给某个 ablation 人为设置明显不合理参数；
- 让 full 和 ablation 使用不同 `popSize` 或 `maxIter`；
- 用额外 evaluation 隐性帮助 full；
- 只报告 fitness 不报告 runtime 和 nEvals。

### 7.3 复杂度公平性

必须报告：

- `MeanRuntime`
- `MeanNEvals`
- `MeanRepairCount`
- `MeanCVFCount`
- `MeanFirstFeasibleIter`

如果 CVF 明显增加运行时间，需要证明收益足以覆盖成本。

## 8. 风险与停止条件

### 8.1 主要风险

- CVF 变成 repairPath 的重复包装；
- CVF 增加运行时间但效果不稳定；
- 可行性场方向过强，损害路径质量；
- 只在 Scene 2/4 某个场景有效，泛化不足；
- 数学公式看起来强，但消融不支持。

### 8.2 停止条件

满足任一条件应暂停路线 B：

- 小规模门槛中 CVF 在 Scene 2 和 Scene 4 都明显差于无 CVF 删减版本；
- 需要大量增加 evaluation 才能带来收益；
- full CVF 反复输给 `w/o-CVF`；
- 机制解释无法和公式、代码、实验结果对应；
- 连续两轮小范围重构仍无法通过中等门槛。

## 9. 预期论文定位

推荐定位：

> 面向强约束低空 UAV 路径规划的约束可行性场驱动进化算法。

不推荐定位：

- 通用元启发式优化算法；
- 多策略改进 AE；
- 违反反馈增强算法；
- 单纯 UAV 多场景应用论文。

目标期刊方向：

- UAV 路径规划；
- 机器人路径规划；
- 智能优化应用；
- 工程优化；
- 复杂约束规划。

## 10. 与现有工程的关系

现有工程的价值在于提供：

- UAV 建模；
- B-spline 路径编码；
- 场景与评价函数；
- 实验批处理框架；
- 日志和结果汇总工具。

后续论文和正式实验均围绕 `CVF-AE` 展开。历史算法只作为开发过程记录，不进入核心贡献和默认消融结构。
