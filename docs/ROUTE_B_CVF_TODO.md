# 路线 B 待办清单：Constraint Viability Field 强创新路线

创建时间：2026-06-17 15:21:25 +08:00

## 0. 当前状态

- [x] 明确路线 B 总主题：低开销约束可行性场驱动进化搜索。
- [x] 明确路线 A 作为 fallback，不推倒已有项目。
- [x] 明确不再以 violation feedback 作为核心创新。
- [ ] 完成 CVF 数学机制推导。
- [ ] 完成 CVF 最小代码实现。
- [ ] 完成小规模门槛验证。
- [ ] 决定是否进入中等门槛验证。

## 1. 文档与理论设计

### 1.1 机制定义

- [ ] 新建 `docs/CVF_MECHANISM_DERIVATION.md`。
- [ ] 定义 constraint viability field 的数学符号。
- [ ] 定义路径采样点 `p_m` 与控制点 `q_k` 的关系。
- [ ] 定义采样点约束压力向控制点方向的映射。
- [ ] 定义 CVF 方向归一化与步长限制。
- [ ] 定义 CVF 与 AE 搜索方向的组合公式。
- [ ] 定义状态自适应权重 `alpha_s`、`beta_s`、`gamma_s`。
- [ ] 定义 Deb-better 接受准则在 CVF 候选中的使用方式。

### 1.2 各类约束场

- [ ] 障碍物排斥场 `F_obs`。
- [ ] 禁飞区排斥场 `F_nfz`。
- [ ] 风险场下降方向 `F_risk`。
- [ ] 高度边界回拉方向 `F_alt`。
- [ ] 曲率释放方向 `F_curv`。
- [ ] 边界/走廊约束方向 `F_boundary`，如需要。

### 1.3 复杂度分析草稿

- [ ] 写出基础 AE 更新复杂度。
- [ ] 写出路径采样和 fitness evaluation 复杂度。
- [ ] 写出 CVF 计算复杂度。
- [ ] 写出 sparse repair 额外复杂度。
- [ ] 写出总体复杂度表达。
- [ ] 说明低开销设计如何为多无人机扩展保留空间。

### 1.4 公平性说明

- [ ] 写明主对比采用完整规划器配置比较。
- [ ] 写明 `w/o-Init` 消融用于回应初始化公平性。
- [ ] 写明 runtime / nEvals / repair count / CVF count 必须同时报告。
- [ ] 写明 CVF 不能靠额外 evaluation 隐性取胜。

## 2. 代码实现

### 2.1 新增核心函数

- [ ] 新建 `buildConstraintViabilityField.m`。
- [ ] 输入：
  - [ ] candidate solution `X`；
  - [ ] `map`；
  - [ ] `params`；
  - [ ] optional `detail`；
  - [ ] current constraint state。
- [ ] 输出：
  - [ ] `fieldStep`；
  - [ ] `fieldInfo`；
  - [ ] 每类约束贡献；
  - [ ] 作用控制点数量；
  - [ ] 场强度范数。

### 2.2 新增 CVF 算子

- [ ] 新建 `applyOperator_COVE_AE_CVF.m`。
- [ ] 复用 AE backbone 搜索方向。
- [ ] 引入 CVF 方向：
  - [ ] formation 阶段 CVF 权重较高；
  - [ ] preservation 阶段 CVF 权重适中；
  - [ ] refinement 阶段 CVF 权重较低；
  - [ ] recovery 阶段增加探索但限制不可行扩散。
- [ ] 保证输出使用 `boundSolution`。
- [ ] 保证不直接调用重 repair。

### 2.3 新增优化器

- [ ] 新建 `optimizer_COVE_AE_CVF_uav.m`。
- [ ] 复用：
  - [ ] `init_COVE_AE.m`；
  - [ ] `identifyConstraintState.m`；
  - [ ] `debBetter.m`；
  - [ ] `repairPath.m`，但只作为稀疏辅助。
- [ ] 新增记录字段：
  - [ ] `viabilityFieldCount`；
  - [ ] `viabilityFieldSuccessCount`；
  - [ ] `viabilityFieldNormHistory`；
  - [ ] `viabilityFieldTypeHistory`；
  - [ ] `cvfOperatorHistory`。

### 2.4 配置入口

- [ ] 修改或扩展 `getUAVAlgorithmConfig.m`。
- [ ] 添加 `COVE-AE-CVF` 或 `CVF-AE`。
- [ ] 添加 ablation configs：
  - [ ] `COVE-AE-CVF-w/o-Init`；
  - [ ] `COVE-AE-CVF-w/o-StateAdaptiveCVF`；
  - [ ] `COVE-AE-CVF-w/o-SparsePreservation`；
  - [ ] `COVE-AE-CVF-w/o-CVF`。
- [ ] 保留 `COVE-AE-reset` 或当前 `COVE-AE` 作为 baseline。

### 2.5 诊断汇总

- [ ] 扩展 `summarize_cove_ae_diagnostics.m`。
- [ ] 添加 CVF 统计列：
  - [ ] `ViabilityFieldCount`；
  - [ ] `ViabilityFieldSuccessCount`；
  - [ ] `MeanViabilityFieldNorm`；
  - [ ] `CVFObstacleFrac`；
  - [ ] `CVFNFZFrac`；
  - [ ] `CVFRiskFrac`；
  - [ ] `CVFCurvatureFrac`；
  - [ ] `CVFAltitudeFrac`。

## 3. 小规模门槛实验

### 3.1 配置

- [ ] scenes: `[2, 4]`
- [ ] algorithms:
  - [ ] `COVE-AE-reset`
  - [ ] `COVE-AE-CVF`
  - [ ] `COVE-AE-CVF-w/o-CVF`
  - [ ] `COVE-AE-CVF-w/o-Init`
- [ ] `nRuns = 5`
- [ ] `popSize = 20`
- [ ] `maxIter = 80`
- [ ] 固定 `baseSeed`

### 3.2 指标

- [ ] feasible rate。
- [ ] mean best fitness。
- [ ] final violation。
- [ ] first feasible iter。
- [ ] runtime。
- [ ] nEvals。
- [ ] repair count/success。
- [ ] viability field count/success。
- [ ] state history。

### 3.3 通过条件

- [ ] CVF 不明显慢于 reset。
- [ ] CVF 在 Scene 2 或 Scene 4 至少一个场景改善 feasibility / first feasible iter / mean best fitness。
- [ ] CVF 不依赖大量额外 evaluations。
- [ ] 若 CVF 两个场景均明显变差，停止路线 B。

## 4. 中等门槛实验

### 4.1 配置

- [ ] scenes: `[1, 2, 4]`
- [ ] algorithms:
  - [ ] `Base-AE`
  - [ ] `COVE-AE-reset`
  - [ ] `COVE-AE-CVF-w/o-Init`
  - [ ] `COVE-AE-CVF-w/o-StateAdaptiveCVF`
  - [ ] `COVE-AE-CVF-w/o-SparsePreservation`
  - [ ] `COVE-AE-CVF`
- [ ] `nRuns = 10`
- [ ] `popSize = 30`
- [ ] `maxIter = 150`

### 4.2 通过条件

- [ ] `COVE-AE-CVF` 平均排名第一或接近第一。
- [ ] `COVE-AE-CVF` 相比 `COVE-AE-reset` 在 Scene 2/4 有明确收益。
- [ ] `w/o-StateAdaptiveCVF` 不稳定优于 full。
- [ ] `w/o-CVF` 不稳定优于 full。
- [ ] runtime 增加可控。

## 5. 正式实验准备

只有中等门槛通过后执行。

- [ ] 冻结默认参数。
- [ ] 写入 `docs/PROJECT_LOG.md`。
- [ ] Git commit。
- [ ] 正式消融 `nRuns = 30`。
- [ ] 主对比。
- [ ] 参数敏感性。
- [ ] 收敛曲线。
- [ ] 箱型图。
- [ ] 运行时间对比。
- [ ] Wilcoxon / Friedman 检验。
- [ ] 可选 CEC/约束优化补充实验。

## 6. 论文写作待办

- [ ] 重写摘要，突出 constraint viability field。
- [ ] 重写 Introduction 的问题动机。
- [ ] 重写贡献点，避免“多策略拼接”表述。
- [ ] 写 Method 公式。
- [ ] 写算法伪代码。
- [ ] 写复杂度分析。
- [ ] 写消融实验设计。
- [ ] 写效率分析。
- [ ] 写局限性：
  - [ ] CVF 依赖路径约束可解析；
  - [ ] 复杂动态障碍暂未考虑；
  - [ ] 多无人机协同为未来工作。

## 7. 暂停与回退

- [ ] 若小规模门槛失败，记录失败原因。
- [ ] 若中等门槛失败，停止路线 B，不进入正式实验。
- [ ] 若 CVF 只通过 Scene 1，不作为强创新。
- [ ] 若 CVF 明显增加 runtime，必须弱化低开销声明。
- [ ] 若路线 B 失败，回退路线 A reset COVE-AE。
