# CVF-AE CEC 测试集选型报告

更新时间：2026-06-24

## 1. 结论

路线 B 的通用数学优化补充实验选择：

> CEC2017 constrained single-objective real-parameter optimization，
> 使用测试集作者维护的 2024 年 9 月 MATLAB 修正版。

该套件包含 28 个连续实参数一般约束问题，显式覆盖不等式约束、
等式约束、混合约束、旋转问题以及不同可行域结构。它与“检验通用
CVF 约束压力引导是否有效”的目标直接匹配。

现有 `cec2017_framework/` 不复用为本实验框架。该目录接入的是
CEC2017 单目标 bound-constrained 套件，仅有变量上下界，不能用于
证明 CVF 对一般约束的处理能力。

## 2. 来源身份

| 材料 | 身份 | 本项目使用方式 |
|---|---|---|
| IEEE CEC 2017 竞赛/专题页 | IEEE 竞赛发布页面 | 核验竞赛名称和历史定位 |
| CEC2017 constrained 技术报告 | 测试集作者技术报告 | 协议和函数定义的主要依据 |
| `P-N-Suganthan/CEC2017` | 测试集作者维护仓库，不是 IEEE 官方仓库 | 获取 2024 MATLAB 修正版 |
| `P-N-Suganthan/2020-RW-Constrained-Optimisation` | 测试集作者维护仓库 | 核验 CEC2020 真实工程约束套件 |
| CEC2022 SO-BO 页面/仓库 | CEC2022 bound-constrained 竞赛材料 | 仅作为不适合 CVF 一般约束验证的对照 |
| CEC2022 HCLO 页面 | IEEE CEC 2022 特定应用约束竞赛 | 说明 2022 年存在特定应用约束竞赛，但不是同类通用 COP 套件 |

不得将作者个人或作者团队 GitHub 仓库写成“IEEE 官方代码仓库”。

## 3. 候选测试集比较

| 候选 | 一般约束 | 规模/维度 | 官方运行协议 | MATLAB 可用性 | CVF 匹配 | 主要风险 | 结论 |
|---|---|---|---|---|---|---|---|
| CEC2017 constrained real-parameter | 是；不等式、等式、混合约束 | 28 个函数；正式 10D、100D；作者代码另支持 30D、50D | 20 runs；`10000*D` FEs；等式容差 `1e-4` | 作者维护 2024 纯 MATLAB 修正版，接口统一 | 高：连续一般约束和可扩展维度直接检验约束压力引导 | 100D 正式预算很大；原包无明确开源许可证 | **选择** |
| CEC2020 real-world constrained | 是，约束类型丰富 | 57 个真实工程问题；D=2--158 | 25 runs；按维度为 `1e5`--`1e6` FEs | 作者维护 MATLAB 源码 | 中：真实约束强，但大量问题含整数、离散、混合变量 | 编码与离散处理会成为主要变量；问题异构；部分约束无显式方程；完整计算量更大 | 不作为本轮主套件，可作为后续少量外部验证 |
| CEC2022 constrained（通用套件） | 未核验到与 CEC2017 同定位的通用连续一般约束套件 | CEC2022 有 HCLO 等特定应用约束竞赛 | 依具体竞赛 | 特定应用代码可得 | 低至中 | 不是统一通用 COP 测试集，论文叙事会转向具体工程应用 | 不选择 |
| CEC2017 single-objective bound-constrained | 只有变量上下界 | 30 个函数，多维 | 常见为 30 runs、按维度预算 | 项目已有 MEX 框架 | 低 | 不能证明一般约束处理能力 | 明确排除 |
| CEC2022 single-objective bound-constrained | 只有变量上下界 | 12 个函数，常用 10D/20D | 按该竞赛技术报告 | 作者/竞赛材料可得 | 低 | 只能补充无约束/边界约束搜索能力 | 不作为 CVF 证据 |

## 4. 一手资料

- IEEE CEC 2017 competitions:
  <https://www.cec2017.org/Program/Competitions>
- CEC2017 constrained technical report（作者上传版本）:
  <https://www.researchgate.net/publication/317228117_Problem_Definitions_and_Evaluation_Criteria_for_the_CEC_2017_Competition_and_Special_Session_on_Constrained_Single_Objective_Real-Parameter_Optimization>
- CEC2017 benchmark-author-maintained repository:
  <https://github.com/P-N-Suganthan/CEC2017>
- CEC2020 benchmark-author-maintained repository:
  <https://github.com/P-N-Suganthan/2020-RW-Constrained-Optimisation>
- CEC2020 guidelines:
  <https://github.com/P-N-Suganthan/2020-RW-Constrained-Optimisation/blob/master/Guidelines_Real_World_Constrained.pdf>
- CEC2020 problem definitions:
  <https://github.com/P-N-Suganthan/2020-RW-Constrained-Optimisation/blob/master/Problem-Definitions.pdf>
- IEEE CEC 2022 HCLO competition:
  <https://sites.google.com/view/cec2022-hclo-competition/>
- CEC2022 single-objective bound-constrained repository:
  <https://github.com/P-N-Suganthan/2022-SO-BO>

## 5. CEC2017 constrained 官方协议

- 函数：C01--C28，不得隐藏失败函数。
- 维度：10D 和 100D 两个正式 track。
- 变量范围：所有维度均为 `[-100,100]`。
- 等式可行容差：`|h_j(x)| <= 1e-4`。
- 不等式：`g_i(x) <= 0`。
- 单次最大评价次数：`10000 * D`。
- 独立运行次数：20。
- 报告节点：`0.01, 0.1, 0.2, ..., 1.0` 倍最大 FEs。
- 解排序：
  1. 可行解优先；
  2. 可行解按目标值；
  3. 不可行解按平均约束违反度；
  4. 违反度相同时按目标值。
- 一次候选点的目标和全部约束联合计算记为 1 FE。
- CVF 候选、约束探测点或导数近似点只要实际调用测试函数，均计入 FEs。

技术报告的等式违反度统计在超过容差时使用 `|h_j|`；通用 CVF 内部方向
压力使用 `max(0, |h_j|-epsilon)`，但正式可行性和排名仍严格使用官方定义。

## 6. 通用 CVF 设计边界

UAV 版障碍物、禁飞区、风险场、高度场、曲率场和参考轨迹初始化不进入
CEC 框架。CEC 版采用统一随机初始化和统一边界投影。

CEC 版 CVF：

- 从当前已评价种群中寻找约束违反度更低的个体；
- 使用候选差分构造归一化约束压力方向；
- 不调用免费目标或约束评价；
- 稀疏触发 CVF 候选；
- CVF 候选每评价一次明确增加 1 FE；
- 所有算法使用相同 Deb 规则、等式容差、初始化分布和总 FEs。

正式报告同时保留：

- 官方平均违反度，用于可行性判断和排名；
- 归一化违反度，用于 CVF 方向压力和机制诊断。

## 7. 预计计算开销

若正式比较 5 个算法，完整协议候选评价量为：

- 10D：`28 * 20 * 100000 * 5 = 2.8e8` FEs；
- 100D：`28 * 20 * 1000000 * 5 = 2.8e9` FEs；
- 合计：`3.08e9` FEs。

因此必须先完成 Stage A、Stage B 和 Stage C，并根据实测单 FE 时间给出
墙钟时间估计。未经中等验证，不启动上述完整任务。正式运行需要分块、
断点续跑、单 run 保存和完整性检查。

## 8. 不选择其他套件的理由

CEC2020 的真实性和认可度很高，但本轮的核心问题是“连续一般约束上的
通用 CVF 是否有效”。57 个问题中的整数、离散和混合变量会引入独立的
编码、取整和离散修复机制，使 CVF 贡献难以隔离；同时完整协议更昂贵。
可在 CEC2017 结论稳定后，从 CEC2020 中预先固定少量纯连续问题作为补充，
但不得据此替代完整套件或宣称 CEC2020 全套结果。

CEC2022 single-objective benchmark 只有边界约束，不能支持一般约束结论。
CEC2022 HCLO 是具体 heat-current layout 应用竞赛，不是与 CEC2017
constrained 等价的通用测试集。

## 9. 论文定位

CEC2017 constrained 结果仅作为 UAV 主应用之外的补充验证：

- 用于说明 CVF-AE 是否能从 UAV 几何约束推广到一般数学约束；
- 不替代 UAV 主对比、消融和轨迹结果；
- 不修改已经冻结的 UAV 参数和正式结果；
- 若 CEC 表现一般或失败，按函数和约束类型如实报告；
- 不根据少量预检函数宣称通用最优；
- bound-constrained 结果不得描述为一般约束处理证据。

