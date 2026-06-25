# CVF-AE 目标 SCI 期刊系统调研

核验日期：2026 年 6 月 25 日
适用稿件：Constraint Viability Field guided Alpha Evolution（CVF-AE）用于强约束三维 UAV 路径规划

## 1. 执行结论

当前稿件最适合采用“UAV 路径规划工程应用型叙事”，而不是“通用约束优化器型叙事”。

原因：

- UAV 正式实验已经包括 11 个算法、3 个强约束场景、30 次独立运行、消融、参数敏感性、显著性、收敛、轨迹合理性和运行开销；
- CVF 的主要创新与障碍物、禁飞区、风险、高度和曲率等 UAV 结构化约束直接相关；
- CEC2017 一般约束补充验证的 Stage B 未通过，不能声称 CVF-AE 是稳定优于基线的通用约束优化算法；
- 现有实验仍是静态合成场景，尚无真实地形、动态障碍和实机飞行，投稿过强的通用优化或高端机器人期刊风险较高。

建议投稿顺序：

1. **Arabian Journal for Science and Engineering**
2. **International Journal of Aeronautical and Space Sciences**
3. **International Journal of Control, Automation and Systems**
4. **Evolving Systems**
5. **Journal of Systems Science and Systems Engineering**
6. 保底：**The Journal of Supercomputing**

三个指定期刊的结论：

- **Cluster Computing：不建议作为当前首轮目标。** 近年确实大量接收元启发式和路径规划论文，但期刊核心范围是集群、云边端、并行与分布式系统；CVF-AE 缺少计算系统贡献。2025 年发文约 1006 篇，样本接收周期中位数约 11.7 个月，存在高发文量、专题密集和范围漂移风险。
- **Evolving Systems：B 档备选。** 方向匹配度高，持续接收改进元启发式、进化优化和 UAV 规划；但样本接收周期中位数约 13.2 个月，明显慢于目标。
- **Journal of Systems Science and Systems Engineering：B 档备选。** 已发表增强型群智能算法及工程应用，分区和费用路径合适；但年发文量较低、系统工程叙事要求更强，样本接收周期中位数约 11.3 个月。

## 2. 数据口径与访问限制

### 2.1 中科院分区

中国科学院文献情报中心于 2025 年 3 月 20 日发布 2025 年期刊分区表，并宣布自 2026 年起不再更新。故本报告采用的“最后官方版本”是 **2025 年中科院期刊分区表**。

分区表完整详情需要机构订阅。本次通过分区表官方入口、出版商资料和多个公开镜像交叉核验；表中所有中科院大类/小类分区均应在投稿前由用户通过学校数据库再次复核。公开来源存在冲突时，不据此虚构唯一结果。

- 官方入口：[中国科学院期刊分区表](https://www.fenqubiao.com/)
- 官方停止更新说明：[2025 年期刊分区表发布通知](https://www.fenqubiao.com/)

### 2.2 SCIE 与 JCR

Clarivate Master Journal List（MJL）是动态交互站点，当前环境可以访问入口，但无法稳定导出完整检索记录；JCR 分类与分区需要机构权限。因此：

- SCIE 状态由 MJL ISSN 检索入口、出版商 JIF 页面和公开 WoS 目录交叉核验；
- 所有入选期刊在 2026 年 6 月 25 日均未发现明确的 Suppressed 记录；
- **Soft Computing** 的出版商页面不再显示 JIF，且公开 JCR 镜像显示 On Hold，按高风险排除；
- JCR 学科与 Q 区为公开镜像交叉结果，投稿当天必须由学校 JCR 复核。

MJL 检索模板：

`https://mjl.clarivate.com/search-results?issn=ISSN`

### 2.3 审稿周期

“Submission to first decision”可能包含编辑初筛，不等同于完整外审。本报告分别记录：

- 出版商公布的首次决定中位数；
- 2024—2026 年 Springer 论文页面的 Received / Accepted / Published 日期；
- 投稿至接收的保守区间；
- 接收到在线发表的时间。

三个指定期刊各抽取 10 篇；主要候选各抽取 6 篇。样本不是全体稿件统计，也可能混入专题文章，因此仅用于估计保守区间。

### 2.4 发文量

2025 年发文量使用 Crossref 按 ISSN 和出版日期查询的 journal-article 记录数。该数可能与 WoS citable items 略有差异，适合判断量级，不作为 JCR 精确分母。

## 3. 候选期刊总表

评分满分 100：方向匹配 30、稳定性 20、速度 15、中科院 3/4 区稳定性 15、非 OA 免费路线 10、发文量 5、办刊声誉 5。带否决项的期刊不参与排序。

| 期刊 | ISSN / eISSN | 2025 中科院分区 | 2025 JIF | JCR 分类/Q 区 | 出版/费用 | 官方首次决定 | 实测投稿至接收 | 2025 发文量 | 匹配度 | 分数 | 结论 |
|---|---|---|---:|---|---|---:|---|---:|---:|---:|---|
| Arabian Journal for Science and Engineering | 2191-4281 / 2193-567X | 工程技术 3/4 区；待学校复核 | 3.1 | Engineering, Multidisciplinary；Q 区待 JCR 复核 | Springer Hybrid；非 OA 通常无 APC | 4 天 | 样本 6 篇，中位 220 天，81–430 天 | 1108 | 4.5/5 | 86 | A |
| International Journal of Aeronautical and Space Sciences | 2093-274X / 2093-2480 | 工程技术 4 区 | 1.9 | Engineering, Aerospace；约 Q3，待复核 | Springer Hybrid；非 OA 通常无 APC | 17 天 | 样本 6 篇，中位 125 天，73–296 天 | 218 | 4.8/5 | 85 | A |
| International Journal of Control, Automation and Systems | 1598-6446 / 2005-4092 | 工程技术 3/4 区；公开源有差异 | 2.8 | Automation & Control Systems；Q 区待复核 | Springer Hybrid；非 OA 通常无 APC | 25 天 | 样本 6 篇，中位 236 天，131–307 天 | 309 | 4.3/5 | 80 | A |
| Evolving Systems | 1868-6478 / 1868-6486 | 计算机科学 4 区 | 2.5 | Computer Science, AI；约 Q3 | Springer Hybrid；非 OA 通常无 APC | 7 天 | 样本 10 篇，中位 403 天，190–690 天 | 128 | 4.7/5 | 74 | B |
| Journal of Systems Science and Systems Engineering | 1004-3756 / 1861-9576 | 管理学 4 区；小类待复核 | 1.2 | Operations Research & Management Science；约 Q4 | Springer Hybrid；非 OA 通常无 APC | 14 天 | 样本 10 篇，中位 345 天，38–614 天 | 66 | 4.2/5 | 72 | B |
| Applied Intelligence | 0924-669X / 1573-7497 | 计算机科学 3 区 | 3.5 | Computer Science, AI；约 Q2 | Springer Hybrid；非 OA 通常无 APC | 45 天 | 样本 6 篇，中位 214 天，170–385 天 | 922 | 4.4/5 | 71 | B |
| The Journal of Supercomputing | 0920-8542 / 1573-0484 | 计算机科学 3/4 区；待复核 | 3.5 | Computer Science, Hardware/Theory；Q 区待复核 | Springer Hybrid；非 OA 通常无 APC | 38 天 | 样本 6 篇，中位 214 天，39–480 天 | 1333 | 3.7/5 | 69 | B/保底 |
| Optimization and Engineering | 1389-4420 / 1573-2924 | 工程技术 3 区 | 2.3 | Engineering/Operations Research；约 Q3 | Springer Hybrid；非 OA 通常无 APC | 40 天 | 样本 6 篇，中位 333 天，9–611 天 | 118 | 4.0/5 | 67 | C |
| International Journal of Machine Learning and Cybernetics | 1868-8071 / 1868-808X | 计算机科学 4 区 | 2.9 | Computer Science, AI；约 Q3 | Springer Hybrid；非 OA 通常无 APC | 4 天 | 样本 6 篇，中位 292 天，202–431 天 | 317 | 4.1/5 | 66 | C |
| Computing | 0010-485X / 1436-5057 | 计算机科学 4 区 | 3.6 | Computer Science, Theory/Software；Q 区待复核 | Springer Hybrid；非 OA 通常无 APC | 6 天 | 样本 6 篇，中位 208 天，40–366 天 | 206 | 3.1/5 | 61 | C |
| Cluster Computing | 1386-7857 / 1573-7543 | 计算机科学 4 区；部分公开源标 3 区 | 5.5 | CS Theory/Information Systems；约 Q1/Q2 | Springer Hybrid；非 OA 通常无 APC | 25 天 | 样本 10 篇，中位 355 天，71–449 天 | 1006 | 3.0/5 | 60 | C/不建议 |
| Journal of Intelligent & Robotic Systems | 0921-0296 / 1573-0409 | 计算机科学 4 区 | 2025 页面值待复核 | Robotics；Q 区待复核 | **2024-09 起完全 OA，强制 APC** | — | 未纳入排序 | 136 | 4.8/5 | 否决 | 不推荐 |
| Soft Computing | 1432-7643 / 1433-7479 | 计算机科学 4 区 | 出版商当前未显示 | JCR 状态需复核 | Hybrid，但索引风险优先 | **275 天** | 未继续抽样 | 447 | 4.5/5 | 否决 | 不推荐 |

说明：

- Hybrid 期刊选择传统订阅发表路径时，通常不收取 OA APC；这不等于一定不存在超页、彩色印刷、语言编辑或其他可选费用。
- 本次未在上述 Springer 投稿指南中发现统一的强制版面费声明；应在投稿系统和接收通知阶段再次检查。
- JCR Q 区和 2025 中科院小类分区需要学校订阅数据库复核。

## 4. 三个指定期刊深查

### 4.1 Cluster Computing

官方主页：[Cluster Computing](https://link.springer.com/journal/10586)
MJL：[ISSN 1573-7543](https://mjl.clarivate.com/search-results?issn=1573-7543)

核验结果：

- 出版社：Springer Nature；
- SCIE：公开证据支持仍在 SCIE；投稿当天需在 MJL 复核 Active / On Hold；
- 2025 JIF：5.5；
- 2025 中科院：公开镜像存在 3 区/4 区差异，本报告按较保守的 4 区处理；
- 官方首次决定中位数：25 天；
- 2025 Crossref 发文量：约 1006；
- 出版模式：Hybrid，非 OA 路线通常无强制 APC；
- 样本 10 篇投稿至接收：中位 355 天，范围 71–449 天；
- 接收到在线发表：通常约 2–4 周；
- 实际风险：官方 25 天更接近编辑首轮动作，不能解释为完整外审速度。

近年相关文章：

1. [Adaptive sand cat swarm optimization algorithm for unmanned ground vehicle path planning](https://doi.org/10.1007/s10586-026-05962-9), 2026。改进群智能 + 路径规划，与 CVF-AE 叙事相近。
2. [Multi-strategy gorilla troops optimizer for global optimization and 3D UAV path planning](https://doi.org/10.1007/s10586-025-05427-5), 2025。直接证明该刊接收“改进算法 + 3D UAV”。
3. [An improved beluga whale optimization algorithm for mobile robot path planning](https://doi.org/10.1007/s10586-026-06152-3), 2026。改进元启发式 + 机器人路径规划。
4. [Integrated task offloading scheduling and trajectory optimization for UAV-MEC using SAC-UTO](https://doi.org/10.1007/s10586-025-05393-y), 2025。UAV 轨迹与边缘计算结合。
5. [Empowering multi-UAV networks: task offloading and trajectory optimization](https://doi.org/10.1007/s10586-025-05912-x), 2026。多 UAV 网络系统。

匹配判断：

- 表面主题匹配，但多数 UAV 文章与 MEC、网络、云边端或系统计算结合；
- CVF-AE 当前没有并行计算、调度、集群或云边端贡献；
- 若按纯路径规划投稿，编辑可能质疑与期刊核心范围的关系。

风险判断：

- 2025 年约千篇发文，且主页可见大量 collection；
- 高发文量并不自动等于预警，但会放大专题质量、审稿一致性和未来指标波动风险；
- 本次未找到 Clarivate 明确 On Hold/Suppressed 的直接证据；
- 不应因 IF 较高而忽略范围错配和近一年真实接收周期。

结论：**C 档，有条件备选；当前不建议优先投稿。**

### 4.2 Evolving Systems

官方主页：[Evolving Systems](https://link.springer.com/journal/12530)
MJL：[ISSN 1868-6486](https://mjl.clarivate.com/search-results?issn=1868-6486)

核验结果：

- 出版社：Springer Nature；
- SCIE：公开证据支持仍在 SCIE；
- 2025 JIF：2.5；
- 2025 中科院：计算机科学 4 区；
- 官方首次决定中位数：7 天；
- 2025 发文量：约 128；
- Hybrid；非 OA 路线通常无强制 APC；
- 样本 10 篇投稿至接收：中位 403 天，范围 190–690 天；
- 该刊官方 7 天不能当成外审周期。

近年相关文章：

1. [A modified sand cat swarm optimization algorithm incorporating gold exploration strategy and sparrow alert mechanism](https://doi.org/10.1007/s12530-026-09827-9), 2026。
2. [Multi-objective optimization for multi-UAV rendezvous planning in urban environments](https://doi.org/10.1007/s12530-026-09832-y), 2026。
3. [MOMEVO: a modular surrogate-assisted evolutionary framework for efficient multi-objective optimization](https://doi.org/10.1007/s12530-026-09814-0), 2026。
4. [An accelerated particle swarm optimization algorithm based on velocity attenuation](https://doi.org/10.1007/s12530-024-09641-1), 2024/2025。
5. [Block based ensemble learning using enhanced particle swarm optimization](https://doi.org/10.1007/s12530-026-09816-y), 2026。

匹配判断：

- 真实、持续接收改进进化算法和群智能算法，不只是偶发综述；
- 可接受“算法机制 + 工程应用”；
- CVF-AE 的状态自适应和演化系统叙事匹配；
- 主要问题不是范围，而是周期。

结论：**B 档。方向很合适，但不符合半年内录用优先目标。**

### 4.3 Journal of Systems Science and Systems Engineering

官方主页：[JSSSE](https://link.springer.com/journal/11518)
MJL：[ISSN 1861-9576](https://mjl.clarivate.com/search-results?issn=1861-9576)

核验结果：

- 出版社：Systems Engineering Society of China 与 Springer；
- SCIE：公开证据支持仍在 SCIE；
- 2025 JIF：1.2；
- 2025 中科院：管理学 4 区，具体小类待学校复核；
- 官方首次决定中位数：14 天；
- 2025 发文量：约 66，约双月刊量级；
- Hybrid；非 OA 路线通常无强制 APC；
- 样本 10 篇投稿至接收：中位 345 天，范围 38–614 天。

近年相关文章：

1. [An Enhanced Beluga Whale Optimization Algorithm for Engineering Optimization Problems](https://doi.org/10.1007/s11518-024-5608-x), 2024。
2. [Multi-Strategy Grey Wolf Optimization Algorithm for Global Optimization and Engineering Applications](https://doi.org/10.1007/s11518-024-5622-z), 2024。
3. [Comprehensive Evaluation Method for Traffic Flow Data Quality Based on Grey Correlation Analysis and Particle Swarm Optimization](https://doi.org/10.1007/s11518-023-5585-5), 2023。

匹配判断：

- 已明确接收“改进群智能算法 + 工程优化应用”；
- 年发文量约 66，满足至少约两个月一期，但远低于高容量期刊；
- CVF-AE 必须强调系统级约束建模、可行性形成机制和工程决策意义，不能只呈现算法排行榜；
- CEC Stage B 失败并非绝对否决，但会削弱“通用工程优化算法”叙事。

结论：**B 档偏后。比 Cluster 更匹配，但审稿慢、发文量小。**

## 5. 其他候选深查摘要

### 5.1 Arabian Journal for Science and Engineering

官方主页：[AJSE](https://link.springer.com/journal/13369)

代表论文：

- [Deep Reinforcement Learning-Enhanced Whale Optimization Algorithm in 3D UAV Path Planning](https://doi.org/10.1007/s13369-025-11048-2), 2026；
- [Optimization of UAV Flight Paths in Multi-UAV Networks](https://doi.org/10.1007/s13369-024-09369-9), 2024；
- [A New Adaptive Differential Evolution Algorithm Fused with Multiple Strategies for Robot Path Planning](https://doi.org/10.1007/s13369-023-08380-w), 2023；
- [UAV Path Planning and Trajectory Optimization: A Comprehensive Survey](https://doi.org/10.1007/s13369-025-10971-8), 2025。

判断：广泛接收工程优化与 UAV 应用，容量大，样本周期约 7.2 个月。应突出 CVF 如何统一多源约束及其低开销，而不是强调 AE 名称。

### 5.2 International Journal of Aeronautical and Space Sciences

官方主页：[IJASS](https://link.springer.com/journal/42405)

代表论文：

- [Trajectory Planning for Quadrotor UAV with Suspended Payload via PSO-Tuned Hybrid Polynomial Optimization](https://doi.org/10.1007/s42405-026-01212-9), 2026；
- [Phased Trajectory Planning for UAV Swarm Cooperation in Complex Dynamic Environments](https://doi.org/10.1007/s42405-026-01194-8), 2026；
- [Energy-Aware Adaptive Obstacle Avoidance for UAV Trajectory Planning](https://doi.org/10.1007/s42405-025-00950-6), 2025；
- [Incorporating Airspace Constraints in Multi-phase 4D Trajectory Optimization](https://doi.org/10.1007/s42405-024-00768-8), 2024。

判断：主题最直接，样本接收中位数约 4.1 个月；需要补强航空任务语境、航迹约束物理意义和路径可执行性。

### 5.3 International Journal of Control, Automation and Systems

官方主页：[IJCAS](https://link.springer.com/journal/12555)

代表论文：

- [Coordinated Task Assignment and Path Planning with Trajectory Optimization for Multi-agent Systems](https://doi.org/10.1007/s12555-026-00068-9), 2026；
- [A Spraying Path Planning Algorithm Based on Point Cloud Segmentation and Trajectory Sequence Optimization](https://doi.org/10.1007/s12555-022-0203-8), 2024；
- [Global and Local Moth-flame Optimization Algorithm for UAV Formation Path Planning Under Multi-constraints](https://doi.org/10.1007/s12555-020-0979-3), 2023；
- [Trajectory Planning of Rail Inspection Robot Based on an Improved Penalty Function SA-PSO](https://doi.org/10.1007/s12555-022-0163-z), 2023。

判断：接受多约束 UAV 路径规划，但控制系统贡献通常比纯优化期刊要求更高。建议增加曲率、航向变化、可执行性或闭环跟踪讨论。

### 5.4 Applied Intelligence

官方主页：[Applied Intelligence](https://link.springer.com/journal/10489)

代表论文：

- [Time optimal trajectory planning of robotic arm based on improved sand cat swarm optimization](https://doi.org/10.1007/s10489-024-06124-3), 2025；
- [Hybrid differential evolution and particle swarm optimization](https://doi.org/10.1007/s10489-024-06051-3), 2025；
- [MQSF-AC for robot path planning](https://doi.org/10.1007/s10489-026-07090-8), 2026；
- [Surrogate-assisted multitask evolutionary optimization](https://doi.org/10.1007/s10489-026-07226-w), 2026。

判断：方向匹配但竞争较强。当前 CVF-AE 只有 3 个合成场景，可能被质疑验证广度和方法新颖性；建议在 CEC 通用机制未修复前不要采用“通用 AI 优化”叙事。

### 5.5 The Journal of Supercomputing

官方主页：[The Journal of Supercomputing](https://link.springer.com/journal/11227)

代表论文：

- [MSPSO for collaborative multi-UAV path planning in complex 3D environments](https://doi.org/10.1007/s11227-026-08640-0), 2026；
- [Multi-strategy quantum PSO for mobile robot path planning](https://doi.org/10.1007/s11227-025-07901-8), 2025；
- [Multi-classifier-assisted constrained optimization for robotic arm obstacle avoidance](https://doi.org/10.1007/s11227-025-07785-8), 2025；
- [Dung beetle optimization with multi-strategy fusion for multi-UAV path planning](https://doi.org/10.1007/s11227-025-07978-1), 2025。

判断：近年相关论文非常多，容量大，可作为保底；但期刊核心仍偏高性能/超级计算，最好增加计算复杂度、并行潜力或实时性实验。

### 5.6 Optimization and Engineering

官方主页：[Optimization and Engineering](https://link.springer.com/journal/11081)

代表论文：

- [Trajectory optimization of unmanned aerial vehicles in the electromagnetic environment](https://doi.org/10.1007/s11081-024-09893-5), 2024；
- [A real-time optimization path planner for parking in dynamic environments](https://doi.org/10.1007/s11081-025-10065-2), 2026；
- [Cooperative trajectory optimization using direct collocation](https://doi.org/10.1007/s11081-025-09996-7), 2025；
- [Hybrid PSO and variable neighborhood search](https://doi.org/10.1007/s11081-025-09972-1), 2025。

判断：研究方向匹配，但更重优化建模、理论严谨性和工程普适性；样本周期约 11 个月。当前 CEC 结果不支持优先投稿。

### 5.7 International Journal of Machine Learning and Cybernetics

官方主页：[IJMLC](https://link.springer.com/journal/13042)

代表论文：

- [Augmented Harris hawks optimization for engineering design and UAV path planning](https://doi.org/10.1007/s13042-025-02624-x), 2025；
- [Evolutionary multiobjective optimization and aircraft trajectory planning](https://doi.org/10.1007/s13042-024-02481-0), 2024；
- [UAV path planning and flight control under wind disturbance](https://doi.org/10.1007/s13042-026-03071-y), 2026。

判断：可以接收，但机器学习/控制融合趋势明显；CVF-AE 当前没有学习模块，创新门槛可能高于 AJSE、IJASS 和 Evolving Systems。

### 5.8 Computing

官方主页：[Computing](https://link.springer.com/journal/607)

代表论文：

- [Evaluation of mobile autonomous robot in trajectory optimization](https://doi.org/10.1007/s00607-023-01205-6), 2023；
- [An advanced parallel hybrid metaheuristic approach for multi-objective cloud task scheduling](https://doi.org/10.1007/s00607-025-01556-2), 2025；
- [A bio-inspired IVY metaheuristic for optimizing LSTM models](https://doi.org/10.1007/s00607-026-01623-2), 2026。

判断：有元启发式论文，但纯 UAV 路径规划不是稳定主线；方向弱于其他候选。

## 6. 排除项

### Journal of Intelligent & Robotic Systems

- 方向非常匹配；
- Springer 官方说明该刊自 2024 年 9 月起转为 fully open access；
- 选择该刊通常需要支付 OA APC，不符合本任务硬条件；
- 结论：**费用否决，不推荐。**

### Soft Computing

- 方向匹配，近年有 [adaptive Q-learning PSO for multi-UAV path planning](https://doi.org/10.1007/s00500-024-09691-2) 等论文；
- 但 Springer 主页在 2026 年 6 月 25 日未显示 JIF，官方首次决定中位数高达 275 天；
- 公开 JCR 镜像存在 On Hold 提示，索引状态必须经 MJL 复核；
- 同时期刊存在较多撤稿记录，办刊和完整性风险高于候选池；
- 结论：**索引/周期否决，不推荐。**

## 7. 分档与投稿顺序

### A 档：优先投稿

1. Arabian Journal for Science and Engineering
2. International Journal of Aeronautical and Space Sciences
3. International Journal of Control, Automation and Systems

### B 档：稳妥备选

1. Evolving Systems
2. Journal of Systems Science and Systems Engineering
3. Applied Intelligence
4. The Journal of Supercomputing

### C 档：有条件备选

- Optimization and Engineering：理论和工程普适性要求较高，周期慢；
- International Journal of Machine Learning and Cybernetics：学习/智能系统要求偏高；
- Computing：UAV 主题不是主线；
- Cluster Computing：范围偏集群和分布式系统，且高发文量、样本周期慢。

### 不推荐

- Journal of Intelligent & Robotic Systems：完全 OA、强制 APC；
- Soft Computing：On Hold/索引风险和极慢首次决定。

## 8. 针对不同期刊的稿件调整

### 第一选择：Arabian Journal for Science and Engineering

- 标题建议：突出“constraint viability field”和“strongly constrained 3D UAV path planning”，弱化 Alpha Evolution 品牌；
- 摘要重点：多源约束统一建模、可行路径形成、低开销、工程可执行性；
- CEC：不作为正文主证据；可在局限性中说明通用约束扩展仍需研究；
- 投稿前补强：增加约束权重与实际任务含义、至少一个真实高程/城市地图案例；
- 最可能质疑：场景数量有限、地图合成、与 APF/repair 的差异、CVF 额外评价是否公平。

### 第二选择：International Journal of Aeronautical and Space Sciences

- 采用 UAV 应用型叙事；
- 增加航迹可执行性指标：最大转角/曲率、爬升率近似、最小安全间隔；
- 最好补一个公开 DEM 或真实城市障碍数据；
- 动态障碍不是强制，但加入小型动态场景可显著提高说服力；
- 不应把 CEC 作为必要条件。

### 第三选择：International Journal of Control, Automation and Systems

- 强调约束状态识别和状态自适应融合；
- 增加路径跟踪或简化飞行动力学可行性验证；
- 把 CVF 解释为可参与更新的约束引导向量场，不是 penalty 或事后 repair；
- 若不补控制/跟踪实验，编辑可能认为稿件只是离线优化。

### Evolving Systems

- 强调 evolving search states、状态切换和机制消融；
- 必须清楚解释状态识别不是规则堆叠；
- 可保留较强的算法机制叙事；
- CEC 不是硬要求，但审稿人可能要求更多非 UAV 问题验证。

### Journal of Systems Science and Systems Engineering

- 强调系统工程框架、多约束协同、决策过程和工程意义；
- 不要只写“改进 AE 击败若干算法”；
- 最好加入系统级敏感性、场景复杂度和部署讨论；
- CEC 可以不放正文，但需要避免“通用优化器”声明。

## 9. 两种投稿叙事的选择

### UAV 路径规划应用型叙事

当前更合适。

证据链完整：

- 多类结构化 UAV 约束；
- 3 个强约束场景；
- 可行率、首次可行迭代、轨迹合理性、运行开销；
- 与经典和近年算法比较；
- 正式消融和统计检验。

适用：AJSE、IJASS、IJCAS、JSSSE、Journal of Supercomputing。

### 通用约束优化算法型叙事

当前不建议。

原因：

- CEC2017 constrained Stage B 为 1 胜/1 平/3 负；
- 通用 CVF 方向对等式约束和狭窄可行域不稳定；
- 当前核心优势依赖 UAV 可解析几何约束。

适用前提：重新设计计入 FE 的通用约束探测方向，并通过固定 Stage B 后再考虑 Applied Intelligence、Optimization and Engineering 等更偏通用算法的叙事。

## 10. 投稿前必须完成

优先级从高到低：

1. 增加至少一个真实地图或公开 DEM/城市障碍数据案例；
2. 明确 CVF 与人工势场、repair、penalty、可行性规则的数学差异；
3. 将轨迹 sanity 指标转化为正文可报告的安全间隔、边界贴靠和曲率指标；
4. 补充公平预算说明：CVF 额外评价、总 nEvals、runtime 和触发次数；
5. 在题目、摘要和贡献中避免“通用最优”“全面优于”等过度声明；
6. 投稿当天通过学校数据库复核 MJL Active、JCR 2025 Q 区和 2025 中科院分区；
7. 检查投稿系统中的超页、彩色印刷和可选 OA 费用。

## 11. 主要来源

核验日期均为 2026 年 6 月 25 日。

- [Clarivate Master Journal List](https://mjl.clarivate.com/)
- [中国科学院期刊分区表](https://www.fenqubiao.com/)
- [Springer Nature hybrid open access](https://www.springernature.com/gp/open-research/policies/journal-policies)
- [Cluster Computing](https://link.springer.com/journal/10586)
- [Evolving Systems](https://link.springer.com/journal/12530)
- [Journal of Systems Science and Systems Engineering](https://link.springer.com/journal/11518)
- [Applied Intelligence](https://link.springer.com/journal/10489)
- [Optimization and Engineering](https://link.springer.com/journal/11081)
- [The Journal of Supercomputing](https://link.springer.com/journal/11227)
- [Computing](https://link.springer.com/journal/607)
- [International Journal of Machine Learning and Cybernetics](https://link.springer.com/journal/13042)
- [International Journal of Aeronautical and Space Sciences](https://link.springer.com/journal/42405)
- [Arabian Journal for Science and Engineering](https://link.springer.com/journal/13369)
- [International Journal of Control, Automation and Systems](https://link.springer.com/journal/12555)
- [Journal of Intelligent & Robotic Systems](https://link.springer.com/journal/10846)
- [Soft Computing](https://link.springer.com/journal/500)
- [Crossref REST API](https://api.crossref.org/)
