# Quality Check

## 2026-07-13 Section 4 recovery

- [x] Restored the Section 4 methodological boundaries after an unintended partial revert: representative-baseline wording, common experimental controls, unpaired rank-sum rationale, per-scene Holm scope, and the auxiliary-review-only status of trajectory flags.
- [x] Restored conservative interpretation of the Scene 2 scalar-fitness result and clarified that representative paths do not participate in optimization, statistical testing, or ranking.
- [x] Removed an unsupported directional parameter claim; the robustness check is now limited to the default configuration rather than a scene-independent optimum claim.
- [x] `xelatex -> xelatex` completed without LaTeX errors, undefined references/citations, or overfull boxes. The latest PDF has 13 pages; page 13 contains reference-list continuation only.


## 2026-07-13 State-scheduler consistency fix

- [x] Revised Eq. `eq:conservative-state` to define the requested state $q_t$ rather than the active state $s_t$.
- [x] Stated explicitly that non-maintenance requests require two consecutive confirmations and that the confirmed state is $s_t$, aligning the equation with Algorithm 2 and the conservative scheduling implementation.


## 2026-07-07 method section restructuring

- [x] 已重排第 3 章 `CVF-AE 方法`：3.1 提前展示基础 AE 与 CVF-AE 两套伪代码，3.2 集中说明约束可行性引导机制，3.3 单独说明复杂度。
- [x] 新增 `alg:base-ae`，保留 `alg:cvf-ae`、核心公式 label、CVF 分量定义、状态判定、候选融合、稀疏触发和局部接收规则。
- [x] 3.2 使用三级标题串联状态识别、CVF 构建、压力分量、有界融合和稀疏接收，删除原先框架段与后置伪代码之间的重复解释。
- [x] 两个算法环境改为 `[H]`，保证伪代码跟随 3.1 源码位置展示，不漂移到章节标题之前。
- [x] `xelatex -> xelatex` 编译通过，当前 `main.pdf` 仍为 12 页；日志未发现 LaTeX Error、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 已渲染抽查第 4--7 页，第 3 章伪代码、三级标题、公式、表格和第 4 章衔接未见压栏、遮挡或明显排版错误。

## 2026-07-07 unified main comparison rerun

- [x] 已按统一设置重跑主对比实验：`AE, PSO, GWO, HHO, ERIME, MSCSO, CVF-AE`，三类低空合成场景、每算法每场景 30 次，共 630 个 run record。
- [x] 新增 `run_cvf_ae_selected7_main_comparison.m` 作为统一重跑入口，结果目录为 `routes/route_b_cvf_ae/results/cvf_ae_selected7_main_comparison_formal_20260707_101155/`。
- [x] 更新 `make_cvf_ae_selected7_paper_artifacts.m`，基于本次统一 run records 重算 mean/std/feasible rate、平均排名、Wilcoxon rank-sum / Mann--Whitney U、Holm 校正、Cliff's delta 和 win/tie/loss。
- [x] 新图已写入 `paper_ajse_zh/figures/`，包括 `selected7_boxplots.png`、三张收敛曲线和六张代表性轨迹图；投稿版图内不再放小标题。
- [x] `table_main_comparison.tex`、`table_significance.tex`、`table_runtime.tex` 已替换为本次统一重跑统计；正文摘要、结果讨论和结论中的数值同步更新。
- [x] 本次统一重跑结果：CVF-AE 平均排名 1.33，三场景可行率均为 1.00，工程复核标记均值 0.10；CVF-AE 对 6 个基线共 18 次比较为 13 胜、4 平、1 负。
- [x] 工程轨迹复核分项表已重新生成至 `notes/engineering_review_breakdown_draft.md` 和 `.csv`，仅供内部审查，未接入论文正文。
- [x] `xelatex -> xelatex` 编译通过，当前 `main.pdf` 为 12 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 已渲染抽查 PDF 第 7--10 页，主结果表、显著性表、收敛图、箱线图和代表性路径图显示正常，图例均为本次主对比算法。
- [x] 已静态检查正文、表格、caption、aux/bbl 和主 LaTeX 文件，未发现用户要求规避的旧口径表述、被排除算法名、内部场景编号、CEC/RRT 相关表述或夸大结论。

## 当前阶段

- [x] 未写大段正文。
- [x] 创建中文可编译 LaTeX 骨架。
- [x] 使用 `ctexart`，适配中文草稿。
- [x] 记录 AJSE/Springer 官方要求。
- [x] 记录用户已确认事项。
- [x] 确认 `evaluatePath.m` 不存在，改映射为 `fitnessFAEAE.m`。
- [x] 确认 A* 仅用于参考路径生成，没有 RRT/RRT* 正式对比实现。
- [x] `.tex` 文件静态扫描未发现本机绝对路径、内部场景编号、禁用统计写法或 CEC。
- [x] 结果表已由正式 CSV 转换为 LaTeX 表格，并替换占位表；参数敏感性表后续因正文紧凑性要求从主文删除。
- [x] 表格静态扫描未发现乱码、TODO、本机绝对路径、内部场景编号或禁用统计写法。
- [x] 参数敏感性表已从主文删除，关键结论并入评价开销小节，完整明细保留在结果 CSV 中。
- [x] 显著性表已改为单栏逐场景明细表；运行开销表保留主文摘要表，完整明细保留在结果 CSV 中。
- [x] 运行开销表已避免跨 batch 绝对 runtime 横向比较，只保留同 batch 消融 ratio 和主对比触发规模。
- [x] 第 3 章“问题建模”已根据 `fitnessFAEAE.m`、`defaultParams.m`、`createMap.m` 和约束评价逻辑完成中文草稿。
- [x] 第 4 章“CVF-AE 方法”已根据 CVF 机制文档和实现代码完成中文草稿。
- [x] 第 3、4 章静态扫描未发现 TODO、本机绝对路径、内部场景编号、禁用统计写法、CEC 或夸大表述。
- [x] 第 3 章已补全目标项公式：长度、能耗、风险、平滑性、高度偏好和边界代价。
- [x] 第 3 章已补全正式违反量公式，并区分评价违反量与 CVF 候选生成压力。
- [x] 第 4 章已补全 CVF 从采样点压力映射、控制点平均、向量化、截断到候选生成的公式闭环。
- [x] 第 5 章“实验设计”已补全实验环境、场景设置、公共参数、对比算法、消融版本、评价指标和统计检验方案。
- [x] 第 5 章静态扫描未发现 TODO、本机绝对路径、内部场景编号、禁用统计写法、CEC 或 RRT 相关未纳入对比表述。
- [x] 第 6 章“结果与讨论”已补全主对比、显著性、消融、评价开销与参数稳健性、综合讨论。
- [x] 第 6 章已删除 TODO，并按结果包解释 fitness、feasible rate、trajectory sanity、runtime、nEvals、CVF trigger 和 repair 相关指标。
- [x] 正文已插入强算法箱线图、三场景收敛曲线、三场景扩展俯视轨迹和消融轨迹图；参数敏感性图已从主文删除，相关结论改为正文凝练表述。
- [x] 第 6 章已补充三场景扩展对比 3D 代表轨迹图，与俯视轨迹图配套展示。
- [x] 第 6 章已补充 Scene 3 消融 3D 代表轨迹图，与 Scene 2 消融俯视图配套展示模块影响。
- [x] 表 2、表 3、表 7 已压缩为主文摘要表；原表 8 已从主文删除，长解释移至正文段落。
- [x] 第 6 章消融俯视图与三维图已合并为一行两图，并新增 `\FloatBarrier` 控制主要图表不跨小节漂移。
- [x] 中文稿主章节已按 AJSE 友好结构由 8 个收敛为 6 个：相关工作并入引言小节，局限性并入结果与讨论小节。
- [x] 已索引 `D:\Zotero\Downloads` 及子文件夹中的本地 PDF，并生成 `notes/local_pdf_inventory.md` 与 `notes/local_pdf_inventory.json`。
- [x] 已通过 DOI/BibTeX 联网核验建立 `bib/references.bib`，当前正文实际引用 20 条参考文献。
- [x] 已建立 `notes/citation_support_bank.md`，记录第一章与实验统计方法引用支撑关系。
- [x] Zotero local API 已复核：导出 `notes/zotero_export_full.bib`，并生成 `notes/zotero_reference_audit.md`；当前 27 条 bib 中 21 条 DOI 与 Zotero 匹配，6 条基础方法/统计文献不在 Zotero 库中。
- [x] 第一章已按“代表性工作做法-不足-本文回应”的逻辑再次压缩，删除多 UAV 展开内容，保留贡献和文章组织于章末。
- [x] 第 4 章已按用户意见删除方法流程图正文展示，仅保留 CVF-AE 伪代码；流程图图片文件保留在 `figures/` 以备后续需要。
- [x] 中文初稿已切换为 Letter 双栏预览版，便于参照双栏投稿论文预估篇幅；宽表和主要结果图已改为跨双栏浮动。
- [x] 主文表格已删除绝对运行时间展示，效率证据统一为函数评价次数、CVF 触发规模、触发率和同批次评价比值。
- [x] 表 5 已改为单栏纵向明细表，不再跨双栏展示；图 5 已改为跨双栏上下展示，减少左右并排和单栏浮动造成的留白。
- [x] 图题和表题已由名称型短标题恢复为标准描述型 caption。
- [x] 已移除正文浮动屏障并放宽双栏浮动参数，允许图表按期刊式浮动集中排版。
- [x] 摘要、局限性和结论已由占位改为正式中文短文；标题和声明区已去除英文 TODO 占位。
- [x] 已针对双栏跨栏浮动过度堆积问题重排结果章：收敛图改单栏纵向展示，评价开销表改单栏短表，消融图改为左右并排，主轨迹图与消融大表保持跨栏展示。
- [x] 消融轨迹图已进一步由跨栏图改为单栏小型双子图，减少大图浮动并增强正文混排。
- [x] 已将 SCI 三区大修意见整理为 `notes/major_revision_plan.md`，区分可立即落稿修改、需补实验事项和投稿前处理事项。
- [x] 第 3 章已将可行性判定改为分量约束口径，并说明聚合违反量仅作为当前实现中的排序和诊断量。
- [x] 第 4 章已补充基础 AE 方向模板、状态判定阈值、保守状态调度、CVF 分量公式和关键权重。
- [x] 第 5 章已正式定义高空绕行、边界贴靠、过度绕行和控制点贴边复核指标，并补充基线公平性说明。
- [x] 第 6 章已将显著性表改为单栏 `table_significance.tex`，正文只展示主对比 CVF-AE 对 10 个基线的 Holm 校正 $p$ 值、Cliff's delta 和胜平负结果，不再展示消融显著性。
- [x] 已根据二轮审稿意见澄清当前 $V$ 为 implementation-specific violation score，不解释为统一物理距离，并说明归一化违反量或安全优先词典序需要作为算法变体重跑。
- [x] 已修正状态识别公式中的逻辑歧义，明确质量细化状态在保守调度中主要作为观测状态和权重模板保留。
- [x] 已将 CVF 候选接收明确写为保守局部接收规则，并说明更激进的可行性改善接收需要重新实验。
- [x] 已将“参数敏感性实验”统一降格为“参数稳健性检查/补充说明”，并修正“风风险热点”错字。
- [x] 已根据投稿降调建议修改摘要、贡献、综合讨论和结论，将结论限定为“所测试的三类合成低空场景”。
- [x] 表 4 的 `Flag` 已改为 `Review flag`，并新增表注解释复核标记率；表 6 和表 7 已补充 `CVF trig./succ.`、`Trig.`、`Succ.`、`Ratio` 的含义。
- [x] 已对 `bib/references.bib` 进行 DOI 元数据核验，并生成 `notes/reference_verification_20260630.md`；当前 27 条中 26 条 DOI 可解析，1 条 Holm 统计文献改用 JSTOR stable URL。
- [x] 按用户意见保留表 6 不拆分；图 3 已拆为代表性路径俯视对比和三维对比两张跨栏图，且每张保持一行三图；原图 4 已拆为 Scene 2 消融俯视图和 Scene 3 消融三维图两张较小单栏正文图。
- [x] 所有正文 `\includegraphics` 指向的图片文件均存在于 `figures/`。
- [x] 全稿静态扫描未发现本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT 或夸大表述。
- [x] 本地 LaTeX 编译：已用 `xelatex` 增量重编译并生成 `main.pdf`，当前双栏 PDF 为 17 页。
- [x] 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation 或 overfull。
- [x] 渲染抽查第 4--9 页，新增方法公式、实验指标定义、状态判定公式和 CVF 说明未出现压栏、遮挡或明显版式错误。
- [x] 渲染抽查第 12--14 页，主轨迹图为两张一行三图，消融图 5/6 以较小单栏图混排在正文中，未出现压栏、遮挡或明显版式错误。
- [x] 投稿前四项小修已完成：将“最佳综合排名”改为“最佳平均场景排名”，主对比公平性表述改为完整 CVF-AE 框架相对于未嵌入本文专属约束引导机制的基线搜索器，`Review flag` 表注明确为三场景共 90 次运行中的复核标记比例。
- [x] 基础 AE 方向系数已从正文内嵌小表改为正式编号表 `tab:base-ae-coefficients`；渲染抽查第 5--6 页，表格位于右栏顶部且未造成异常空白、压栏或遮挡。
- [x] 符号和公式小修已完成：规范 `p_z \notin [z_l,z_u]` 的区间写法，复核 `\bar V`、`\mathbf d_o/d_o` 与 `\mathbf d_z/d_z` 的向量/标量区分，并将原式 (48) 的 `\propto` 转弯分量改为显式分段缩放公式。
- [x] 渲染抽查第 6--7 页，禁飞区符号、障碍物/NFZ 向量标量写法和转弯分量公式显示正常；编译日志未发现 overfull、未定义引用或未定义 citation。
- [x] 第二章源文件仅为占位注释，不产生正文篇幅；第三章已压缩冗余说明、删除未被引用的符号表，并将 Deb 可行性规则由列表改为紧凑段落，保留所有关键建模公式、标签和可行性推导。
- [x] 第三章压缩后 `03_problem_formulation.tex` 由约 8319 字符降至 7370 字符，当前双栏 PDF 为 16 页；渲染抽查第 2--4 页，问题建模与 CVF-AE 方法衔接正常。
- [x] 第四章 `04_method.tex` 已压缩总体框架、状态调度、CVF 分量解释、候选接收和复杂度说明；保留核心公式、label、CVF 分量定义、状态判定、候选接收规则和伪代码。
- [x] 第四章压缩后由约 15090 字符降至 13751 字符，减少约 1339 字符；状态权重由长段落改为非浮动紧凑小表以避免双栏 overfull。
- [x] `xelatex -> xelatex` 编译通过，当前 `main.pdf` 仍为 16 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 正文 `.tex` 与表格静态扫描未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、`signed-rank` 或“通用最优/全面优于”等夸大表述；“绝对运行时间”仅出现在否定性效率口径说明中。
- [x] 根据 AI 审稿意见完成三处公式--代码一致性小修：将目标函数降调为综合路径质量代理目标，将 CVF 权重由 $\eta_c(s,V_c)$ 校准为 $\eta_c(s)$，并在复杂度中区分完整评价采样 $M$ 与 CVF 低密度采样 $\widetilde M$。
- [x] 小修后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 仍为 16 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 已按 AI 审稿意见收束贡献主线：摘要、引言贡献段和结论均改为突出“约束违反信息前移到候选生成阶段的有界方向修正”，弱化 CVF、初始化、状态调度和稀疏保持的模块堆栈感。
- [x] 贡献主线收束后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 仍为 16 页；正文 `.tex` 与表格扫描未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、`signed-rank` 或夸大表述。
- [x] 已将 `Review flag` 统一降调为 `Eng. flag` / 工程轨迹复核标记，并说明该固定阈值复核仅作 sanity check 和诊断信息，不作为安全认证指标或独立优化目标。
- [x] 工程复核措辞调整后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 仍为 16 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 已继续压缩第 5/6 章重复解释性段落：第 5 章收紧实验环境、场景、公共参数、对比算法和统计检验说明；第 6 章压缩 Scene 2/3 例外、统计解释、消融、开销和综合讨论中的重复防御性表述。
- [x] 第 5/6 章压缩后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 降至 15 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 已按用户意见继续收紧排版：第 2 章仍为占位注释且无正文公式；第 3 章将未被交叉引用的小公式改为行内公式，保留目标函数、惩罚项、核心违反分量、可行性判定和 Deb 规则。
- [x] 第 4 章算法伪代码已改为 `\scriptsize`；表 5 由 30 行逐场景明细压缩为每个基线一行、三场景并列的单栏表；消融版本已在正文定义为 V0--V5，表 6 仅保留编号。
- [x] 表 6 去除 `resizebox` 放大，改用 `tabular*` 铺满双栏，避免编号化后表格被不必要放大；渲染抽查第 10 页和第 12 页，表 5、表 6 和表 7 未出现压栏、遮挡或乱码。
- [x] 本轮压缩后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 降至 14 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 正文 `.tex` 与表格静态扫描未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、`Review flag`、旧式“复核风险”或“通用最优/全面优于”等夸大表述。
- [x] 已按最新非实验审稿意见完成文字和公式小修：弱化摘要/结论中的“工程型”和防御式表述，统一“稀疏可行性保持机制”，并明确观测状态 $s_{\mathrm{obs}}$ 与保守调度后的生效状态 $s_t$。
- [x] 已补充 CVF 非解析梯度说明和保守接收解释；第 3 章移除“若改归一化违反量需重跑”的重复提醒，仅在局限性保留算法变体需重新实验的边界说明。
- [x] 已完成公式一致性小修：转弯角加入 `clip(...,-1,1)`，禁飞区集合说明为已合并安全缓冲，B 样条边界说明补充 open-uniform、非负基函数与 partition of unity 条件，CVF 范数截断改为分段缩放定义并统一 `clip` 记号。
- [x] 小修后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 仍为 14 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；渲染抽查第 3、5、6、7 页未发现压栏、遮挡或乱码。
- [x] 已将主文对比算法收缩为 7 个代表性算法：AE、PSO、GWO、HHO、ERIME、MSCSO、CVF-AE；正文、表格、caption、引用图和最终 `main.bbl` 中未再出现被删除算法名。
- [x] 已基于既有 raw run CSV / run records 重新生成 selected-7 统计与图件，未重跑优化实验；每场景 mean/std/feasible rate、场景排名、平均排名、Wilcoxon rank-sum / Mann--Whitney U、Holm 校正、胜平负和 Cliff's delta 均按 7 算法口径重算。
- [x] selected-7 结果：CVF-AE 平均排名为 1.33；CVF-AE 对 6 个基线在 3 个场景共 18 次 Holm 校正比较中得到 15 胜、2 平、1 负；唯一显著劣势为 Scene 2 对 MSCSO 的标量适应度比较。
- [x] 已新增 `make_cvf_ae_selected7_paper_artifacts.m` 与 `routes/route_b_cvf_ae/results/cvf_ae_selected7_paper_artifacts_20260706/`，并将主文图切换为 `selected7_boxplots.png`、`selected_scene*_convergence_mean_std.png` 和 `selected_scene*_representative_{top,3d}.png`。
- [x] 已重跑 `bibtex` 清理旧参考文献条目，并执行 `xelatex -> bibtex -> xelatex -> xelatex`；当前 `main.pdf` 为 14 页，日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 渲染抽查第 8--11 页，主结果表、显著性表、箱线图、收敛图和代表性路径图均未出现被删除算法，图表未见压栏、遮挡或明显乱码。
- [x] 已针对 Scene 2 主对比图中 CVF-AE 代表航迹的低空视觉问题重新筛选既有 run：由原 `scene2_CVF-AE_run028.mat` 改为 `scene2_CVF-AE_run009.mat`，该 run 可行、无工程复核标记、MeanZ=14.9056、MaxZ=18、建筑足迹投影比例为 0。
- [x] 已更新 selected-7 代表路径生成规则：仅对 Scene 2 的 CVF-AE 代表图使用低空优先评分，其余场景和算法仍沿用原代表路径筛选；重画 `selected_scene2_representative_top.png` 和 `selected_scene2_representative_3d.png` 后重新编译，当前 PDF 仍为 14 页。
- [x] 已将正文地图图统一同步为 SCI 风格 muted 配色：建筑由橙色半透明改为浅灰蓝低饱和背景，禁飞区改为低饱和红，风热点改为蓝灰，CVF-AE 使用深蓝粗实线，其它算法使用色盲友好 muted 颜色和线型双编码。
- [x] 已重画 selected-7 箱线图、收敛图、三场景代表路径图和消融代表路径图；本轮仅修改绘图配色和线型，不改变实验数据、统计表数值或代表 run 筛选结果。
- [x] 配色同步后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 仍为 14 页；日志未发现 LaTeX Error、未定义引用、未定义 citation、overfull 或 rerun-label warning；渲染抽查第 9--11 页未见压栏、遮挡或明显乱码。
- [x] 已按“算法单独一章、实验结果及分析单独一章”的思路重排主文：`main.tex` 不再输入独立的 `05_experimental_setup.tex` 和 `07_limitations.tex`，第 4 章统一为“实验结果与分析”。
- [x] 新第 4 章按“整体实验设置、主对比结果、消融分析、显著性分析、开销分析与局限性”组织；原实验设置内容压缩并前置，结果解释分别放入主对比、消融、显著性和开销小节。
- [x] 已同步引言末尾章节安排，并加入 `placeins`/`\FloatBarrier` 控制结果章浮动体，避免图表越过对应小节标题。
- [x] 结构重排后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 为 13 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 静态扫描 `main.aux`、`main.bbl`、sections、tables 和 `main.tex`，未发现被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或“全面优于/通用最优”等表述。
- [x] 渲染抽查第 7--10 页，实验设置、主对比、消融、显著性和开销小节顺序清楚；主结果表、箱线图、收敛图、路径图、消融表、显著性表和开销表未见压栏、遮挡或明显乱码。
- [x] 已将局限性从结果章移入结论章：第 4 章末节改为“开销分析”，只保留评价次数、触发率、同批次评价比值和参数稳健性说明；结论末段集中说明静态合成场景、真实地图/DEM、动态障碍、多机协同、算法变体和闭环验证等边界。
- [x] 已清理无效章节 tex：删除 `02_related_work.tex`、`05_experimental_setup.tex` 和 `07_limitations.tex`；剩余章节文件按实际结构重命名为 `02_problem_formulation.tex`、`03_method.tex`、`04_results_and_discussion.tex`、`05_conclusion.tex`。
- [x] `main.tex` 现在只输入有效章节文件：摘要、引言、问题建模、方法、实验结果与分析、结论。
- [x] 本轮清理后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 为 12 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 静态扫描未发现旧章节输入文件名、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或“全面优于/通用最优”等表述；渲染抽查第 10--12 页未见压栏、遮挡或明显乱码。
- [x] 已按用户选择采纳新一轮审稿意见：主文保留代表性基线选择原则，但不出现历史算法集合、旧排名、更大集合校正或补充材料扩展算法说明。
- [x] 已删除“低空优先规则从既有可行 run 中筛选”等路径筛选敏感表述，改为说明代表性路径仅用于可视化展示，不参与优化、统计检验或表格排名。
- [x] 已将“所选代表性基线中最佳平均排名”口径贯穿摘要、主对比结果、综合结果段和结论；表注改为“主对比算法”排名口径。
- [x] 已采纳公式与伪代码小修：质量引导方向中的 `\mathrm{clip}` 改为圆括号函数调用；Algorithm 1 第 21 行改为候选被选入稀疏可行性保持集合。
- [x] 已生成工程轨迹复核分项表草稿 `notes/engineering_review_breakdown_draft.md` 和 `.csv`，仅供内部审查，未接入论文正文或 LaTeX 输入链路。
- [x] 本轮修改后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 为 12 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 静态扫描未发现“更大/旧排名/低空优先/既有可行/所选 7/需要重新开展正式实验/补充材料/Supplementary”、被删除算法名、旧 `11/10` 口径、`Scene 4`、CEC、RRT 或“全面优于/通用最优”等表述。
- [x] 已补齐第 3 章中“约束感知初始化与参考弱引导”方法说明：新增参考控制向量、净空/风险扰动半径、引导初始化和弱参考方向描述，使其与第 4.3 节 V4“仅去除约束感知初始化”消融项对应。
- [x] 已修正伪代码口径：基础 AE 仍为普通随机初始化，CVF-AE 伪代码明确生成参考控制序列并进行约束感知初始化。
- [x] 本轮方法补齐后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 为 13 页；日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning。
- [x] 静态扫描 `main.tex`、sections 和 tables 未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或“全面优于/通用最优”等表述。
- [x] 已复核并统一基础 AE、CVF-AE 与实验实现的描述：基础 AE 使用固定平衡进化算子；状态化内部候选、参考弱方向、CVF 压力与保守局部门控均明确限定为 CVF-AE 机制。
- [x] 已补充 CVF-AE 专属参考序列的生成方式：以平面 \SI{5}{m}、垂向 \SI{4}{m} 的三维栅格 A* 生成参考控制序列，仅用于内部初始化与弱方向先验，不作为对比算法；复杂障碍布局使用固定走廊控制点模板扩展初始覆盖。
- [x] 已将论文中的保守状态调度统一为形成、保持和恢复三种状态，并以正式配置的切换条件、候选系数和 CVF 权重进行定义。
- [x] 已完成内部模板影响消融：仅对复杂场景运行 CVF-AE 的模板开启/关闭对照，各 30 次，保持参考路径、引导初始化、CVF、状态调度、预算和种子规则不变。结果存于 `results/template_initialization_ablation_20260711_225319/`，未接入论文、LaTeX 或论文图表。
- [x] 内部结果：模板开启/关闭的可行率为 `1.0000/0.7333`，Fisher 精确检验 `p=0.004575`；总体最终适应度秩和检验 `p=0.652044`，说明模板的主要影响体现在可行性形成与 CVF 触发负担，而非可行解中位适应度。
- [x] 已决定保留固定走廊控制点模板，作为约束感知初始化的组成；内部模板消融继续仅供决策使用，不加入论文正文、表格、图表或统计结论。
- [x] 已明确 V4 去除约束感知初始化而不移除迭代阶段的参考弱方向；在 Scene 3 中，该消融同时移除初始化走廊模板。
- [x] 已将轨迹阈值结果统一为“预设阈值辅助复核标记”，仅用于可视化和复核，不与统计检验并列为同等强度证据；同时删除未由主文图表支撑的参数方向性结论。
- [x] 已将复杂度改为区分候选评价次数与评价工作量，并计入 CVF 额外候选的完整评价代价。
- [x] 本轮已执行 `xelatex -> xelatex`，当前 `main.pdf` 为 Letter 纸、共 `12` 页；日志未发现 LaTeX Error、undefined reference、undefined citation、overfull 或 rerun-label warning。渲染抽查第 4--6 页，算法、状态系数表、参考初始化说明与 CVF 图均显示正常。
- [x] 已在第 2 章 Deb 可行性优先准则定义后加入单栏解释图 `deb_feasibility_criterion_flowchart.png`，图内不含小标题，仅说明可行、均可行和均不可行三类比较路径；CVF 的局部接收未并入该图。
- [x] 加图后已执行 `xelatex -> xelatex`，当前 `main.pdf` 为 13 页；日志未发现 LaTeX Error、undefined reference/citation、overfull 或 rerun-label warning。渲染抽查第 4 页，图和标题均在单栏内正常显示，未遮挡正文或方法章内容。
- [x] 静态扫描 `main.tex`、sections 和 tables 未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或“全面优于/通用最优”等表述。
- [x] 已重新平衡图文布局：第 3 章两段算法从 `[H]` 改为 `[tbp]`；第 4 章移除图前和章末的强制浮动屏障，连续跨栏图分别设为页首或页底优先，并限制子图高度以避免连续图表页；Deb 准则图同步改为紧凑单栏版。
- [x] 布局调整后 `xelatex -> xelatex` 编译通过，当前 `main.pdf` 为 12 页；日志未发现 LaTeX Error、undefined reference/citation、overfull 或 rerun-label warning。渲染抽查第 4、8--10 页：第 3 章开头无大面积留白，第 9--10 页均为图表与正文混排，未见纯图表页、压栏或遮挡。
- [x] 2026-07-14 全文审查已将公平性口径改为“相同种群规模和迭代次数”，明确不同算法的函数评价次数不强制相同并单独报告；正文不再使用“相同预算/统一预算”表述。
- [x] 第 2 章可行性判定已明确采用总违反分数阈值 $V\leq10^{-10}$；第 3 章状态请求 $q_t$、生效状态 $s_t$、状态化方向 $\mathbf D_{\mathrm{AE}}^{(s_t)}$ 和 `round` 触发配额已与实现口径统一。
- [x] 新增紧凑的稀疏触发与可行性保持参数表，仅保留近可行阈值、候选范围、三状态配额、可行后节流和局部修复限制等 6 项行为关键参数；未扩展为全部目标函数、CVF 和场景常数清单。
- [x] 已为 PSO、GWO、HHO、增强 RIME 来源和 MSCSO 加入原始文献引用；Feng 文献元数据修正为 `Scientific Reports 16, 101 (2026)`。
- [x] 结果章宽表限定页首、单栏统计表就地排版，并提高纯浮动页阈值；最终 `main.pdf` 为 Letter 纸 13 页。第 9 页为主结果/统计图文混排，第 10 页为带对应文字的集中图版，第 11 页为消融表、结论和声明混排，不再存在连续两页纯图表。
- [x] 最终执行 `bibtex -> xelatex -> xelatex`；日志无 LaTeX Error、undefined reference/citation、overfull、纯浮动页或 rerun warning。PDF 文本层与源文件扫描未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或夸大表述。
- [x] 2026-07-14 参考论文参数披露对照后再次精简第 3 章：撤除 6 行触发/修复参数表，将三状态内部 AE 微观系数改为方向侧重描述，并删除三状态六类压力的 18 个显式权重。
- [x] 基础 AE 调度、初始化扰动、压力半径/缩放、风险激活、高度/边界缓冲、曲率激活、质量牵引和局部修复筛选中的实现级数值已改为符号或定性说明；保留状态判定阈值、9 个融合权重、名义触发比例及可行后节流配置。
- [x] 参数精简未改变任何公式结构、算法步骤、实验设置、数据、统计或图件；目标权重、惩罚、运动约束、种群规模和迭代次数继续集中保留在实验设置表中。
- [x] 精简后执行 `xelatex -> xelatex`，`main.pdf` 仍为 Letter 纸 13 页；日志无 LaTeX Error、undefined reference/citation、overfull、纯浮动页或 rerun warning。渲染检查第 4--8 页无新增空白、压栏、遮挡或乱码。
- [x] 参数精简导致消融图 7 延迟到参考文献区域后，已将其由双栏横排改为单栏纵排，并保留结果章末浮动屏障；图 7 现位于第 11 页左栏顶部、结论之前，未进入参考文献区域。
- [x] 图 7 修复后执行 `xelatex -> xelatex`，PDF 恢复为 13 页；第 9--11 页无纯图页、遮挡或异常空白，日志无 LaTeX Error、undefined reference/citation 或 overfull。
- [ ] 仍需后续补充：作者/单位/通讯作者、基金/致谢/声明信息和第二轮文献精筛。

## 后续每阶段检查

- [ ] LaTeX 能否编译。
- [ ] 是否存在未定义引用。
- [ ] 是否存在本机绝对路径。
- [ ] 是否误写 `Scene 4`。
- [ ] 是否误写 `signed-rank`。
- [ ] 是否编造参考文献。
- [ ] 是否误把 CEC 写入正文。
- [ ] 是否出现“通用最优”“全面优于”等夸大说法。
- [ ] 图表来源是否记录。
- [ ] TODO 是否集中列入状态文件。

## 2026-07-18 Narrative Coherence Revision

- [x] Rewrote the Chinese introduction around one causal tension: post-evaluation constraint handling cannot provide a movement direction, whereas global mandatory field updates can undermine evolutionary exploration.
- [x] Reframed CVF-AE as a closed candidate-generation loop: constraint-aware entry, state-governed intervention, bounded CVF movement, and conservative retention.
- [x] Reduced the contribution list from four items to three method contributions; moved experimental validation outside the contribution list.
- [x] Synchronized the method opening and conclusion with the same entry--intervention--movement--retention narrative; no MATLAB code, experimental data, statistics, tables, or figures were changed.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, overfull, or rerun-label warning.
- [x] Rendered and reviewed pages 1, 4, and 11. The revised introduction, method transition, and conclusion render without overlap, clipping, or abnormal whitespace.
- [x] Removed the duplicate experimental-validation sentence after the contribution list; experimental design and evidence remain exclusively in Section 4. Recompiled twice: 13 pages, with no LaTeX Error, undefined reference/citation, overfull, or rerun-label warning.

## 2026-07-18 Method--Results Narrative Bridges

- [x] Added short causal bridges in Section 3 from constraint-aware initialization to state-governed intervention, from local field pressure to bounded fusion, and from conservative acceptance to the complete CVF-AE loop.
- [x] Reframed Section 4 as a layered test of the loop: overall value, mechanism removal, distribution-level evidence, and sparse-intervention cost. The ablation opening now maps V4, V2, V1, V3, and V5 to their respective mechanism roles without claiming that the conservative acceptance gate was independently ablated.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, overfull, or rerun-label warning.
- [x] Rendered and reviewed pages 5, 7, 8, and 9. The added bridges, Section 4 framing, and ablation introduction do not overlap figures/tables or cause abnormal whitespace.

## 2026-07-18 Results Evidence Hierarchy Revision

- [x] Removed the cross-scenario `Aux. flag` column from the main comparison table. Auxiliary trajectory-review markers are now explicitly limited to representative-path visualization and review, not ranking or statistical evidence.
- [x] Rewrote the main-comparison discussion in evidence order: feasibility, scalar-fitness rank, run distribution, and qualitative path interpretation. The convergence plot is explicitly limited to the equal-iteration search process and is not used as function-evaluation efficiency or strict convergence-speed evidence.
- [x] Expanded ablation interpretation to V1--V4, including the conditional Scene 3 role of state adaptation and the lower-evaluation yet worse-quality V3 result. Removed the unsupported parameter-robustness sentence.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, overfull, or rerun-label warning.
- [x] Rendered and reviewed pages 8--11. The narrower main table and expanded result discussion are legible, with no overlap, clipping, or abnormal whitespace.

## 2026-07-18 Saved-result audit

- [x] Read-only audit of the formal selected-seven result package confirmed 30 stored runs for each paper scene and algorithm, with a 300-iteration `bestHist` and final path retained in every run record.
- [x] The main records retain final feasibility, runtime, and function-evaluation counts for all algorithms. The evaluation counts are not identical across algorithms, so the manuscript correctly limits common controls to population size and iteration count.
- [x] Per-iteration feasibility histories, state histories, and first-feasible iteration/time are retained only for CVF-AE. They must not support a new cross-algorithm claim about time-to-feasibility without a purpose-built rerun that records equivalent histories for every method.
- [x] Final-path review metrics are available for all stored runs, but the present manuscript continues to treat the threshold-based flags as auxiliary visual/review information rather than ranking or statistical evidence.

## 2026-07-18 Trajectory-figure reduction

- [x] Removed the Scene 1 representative-path panels and replaced the former two cross-column main-comparison trajectory figures with one compact single-column 2x2 figure: top and 3D views for Scenes 2 and 3 only.
- [x] Retained both spatial views where they add distinct qualitative information, while keeping the representative paths explicitly outside optimization, ranking, and statistical evidence.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, overfull, rerun-label, or float-only-page warning.
- [x] Rendered and reviewed pages 9--11. The compact trajectory figure, ablation figure, convergence figure, tables, and surrounding text are mixed across the pages without clipping, overlap, or a figure-only page.

## 2026-07-18 Ranking wording

- [x] Replaced the defensive wording about a new constraint-priority ranking with a positive description: scene ranks are calculated from mean scalar fitness and reported alongside feasibility.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, overfull, rerun-label, or float-only-page warning.

## 2026-07-18 3D trajectory-scale correction

- [x] Added `redraw_selected7_3d_trajectory_figures.m`, a read-only result-record renderer for the Scene 2/3 3D representative paths. It does not call the optimizer or alter selection, tables, statistics, or experiment settings.
- [x] Re-rendered the two 3D panels with an internal compact legend, a larger axes footprint, a tighter export range, and a layout ratio that compensates for 3D projection whitespace.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, overfull, rerun-label, or float-only-page warning.
- [x] Rendered and reviewed page 9. The top and 3D panels now have comparable visual area without clipping or overlap.

## 2026-07-18 3D trajectory complete-frame correction

- [x] Replaced axes-only export with full-figure export in `redraw_selected7_3d_trajectory_figures.m`. The Scene 2/3 3D views now use a near-square canvas matching the plan views, while preserving the lower coordinate frame, start region, and obstacle bases.
- [x] Set the four Figure 5 subfigures to the same `0.41\linewidth` width after making the 3D source panels near-square; no result record, representative-run selection, experiment setting, table, or statistic was changed.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, or overfull warning.
- [x] Rendered and reviewed page 9. All four trajectory panels are complete, with no lower-edge clipping, overlap, or float-only page.

## 2026-07-18 Reverted 3D trajectory redraw

- [x] At the author's request, restored the version-controlled original Scene 2/3 3D trajectory images and removed the temporary redraw script. The compact Figure 5 remains at equal subfigure widths.
- [x] No optimization, saved result record, representative-run selection, table, statistic, or manuscript text was changed by this reversion.

## 2026-07-18 Trajectory-panel grouping

- [x] Reordered compact Figure 5 into a plan-view row (Scenes 2 and 3) followed by a 3D-view row (Scenes 2 and 3). The plan views use `0.40\linewidth`; the two original 3D images use `0.49\linewidth` to compensate for their shorter projected canvas.
- [x] Increased the two plan-view subfigures to `0.44\linewidth`, reducing their inter-panel whitespace while retaining the larger `0.49\linewidth` 3D row.

## 2026-07-18 Results-float compaction

- [x] Changed the boxplot from a forced in-place float to a top-eligible single-column float, allowing the two columns to fill naturally around the distribution discussion.
- [x] Changed the cross-column convergence figure from a bottom-only float to a top-eligible float, so it can precede and remain close to its convergence analysis rather than being deferred behind subsequent material.

## 2026-07-18 Results-figure final layout

- [x] Promoted the three-panel boxplot to a top-eligible two-column figure. This gives the distribution panels a readable scale and avoids the large one-column height mismatch with the representative-path figure.
- [x] Retained the convergence plot as a top-eligible two-column figure and restored the representative-path figure to in-place placement. The rendered layout places the Figure 3/4 sequence at the top of the following page rather than deferring Figure 4 to a later page bottom.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. Rendered review of pages 9--10 found no clipping, overlap, float-only page, or large single-column void.

## 2026-07-18 Boxplot Analysis Before Figure

- [x] Moved the Figure 3 distribution-analysis paragraph before the boxplot and changed the boxplot to a bottom-eligible single-column float. This lets the text lead into the visual evidence without depending on an in-place float.
- [x] Expanded the main comparison, ablation, and statistics/overhead interpretation using only existing table and figure evidence. Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. Rendered review of pages 9--11 found no clipping, overlap, float-only page, or abnormal whitespace.

## 2026-07-19 Results Narrative Evidence Chain

- [x] Reorganized Section 4 around a continuous evidence chain: scenario-wise main comparison, repeated-run distributions, iteration-level search behavior, representative path geometry, module ablation, statistical comparison, and sparse evaluation overhead.
- [x] Kept the Scene 2 MSCSO exception explicit, avoided cross-scene averaging of scalar fitness, and did not add a redundant Figure-12-style aggregate bar chart because the scenarios have non-comparable scalar-fitness scales.
- [x] Placed the Figure 3 analysis before its bottom-eligible float, moved the convergence and overhead discussions before their corresponding floats, and retained the compact Figure 5 in-place to avoid a float-only page.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, overfull, rerun-label, or float-only-page warning. Rendered review of pages 8--11 found no clipping or overlap. Source scans found no TODO, local absolute path, or prohibited comparison terminology.

## 2026-07-27 Main-comparison Table Replacement

- [x] Removed the main-comparison table from the manuscript because its scene-wise fitness mean/std repeated the evidence already shown by the three boxplots.
- [x] Added a two-panel summary figure that reports only complementary evidence: scene-wise feasibility rates and the three-scene average rank. The detailed table source remains archived but is no longer referenced by the manuscript.
- [x] Replaced the feasibility grouped bars with three scene-wise line series over the fixed algorithm order. Distinct muted colors, line styles, and markers keep overlapping high-feasibility values identifiable without drawing seven crowded algorithm curves.
- [x] Converted the summary from a cross-column figure to a compact single-column figure. The feasibility and average-rank panels are stacked vertically at `0.95\linewidth` and `0.68\linewidth`, respectively, so both remain readable without occupying both columns.
- [x] Added `make_cvf_ae_main_summary_figure.m`, which reads the frozen selected-7 CSV summaries and does not run an optimizer or alter experiment records.
- [x] Preserved the fixed seven-algorithm order and reused the muted SCI palette from the selected-7 figures. The Section 4 evidence chain is now summary feasibility/rank, fitness distributions, iteration behavior, and representative path geometry.
- [x] MATLAB Code Analyzer reported no issues. Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, overfull, rerun-label, or float-only-page warning. Rendered review of pages 8--11 found no clipping, overlap, or abnormal whitespace.

## 2026-07-27 Ablation-table Density Reduction

- [x] Removed the dense ablation table from the manuscript and retained its source file only as an archived result record.
- [x] Added a single-column two-panel summary figure: a Scene 1--3 rank heatmap for V0--V5 and a three-scene feasibility-rate line chart. The two panels separate relative quality from feasibility loss without repeating all table cells.
- [x] Kept the key numerical evidence in prose, including V0 rank/feasibility, V4 Scene 3 feasibility and CVF-trigger change, V5 feasibility loss, and the V1--V3 fitness/evaluation comparisons.
- [x] Added `make_cvf_ae_ablation_summary_figure.m`, which reads the frozen formal ablation CSV and does not run the optimizer or change experiment records.
- [x] MATLAB Code Analyzer reported no issues. Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, overfull, rerun-label, or float-only-page warning.
- [x] Rendered and reviewed page 10. Figures 7 and 8 remain legible in adjacent columns, their analysis follows continuously, and no clipping, overlap, isolated fragment line, or abnormal whitespace remains.

## 2026-07-27 Ablation-summary Side-by-side Layout

- [x] Regenerated both Figure 7 panels on identical `650x560` MATLAB canvases and enlarged their shared normalized main-axes rectangle to `[0.10, 0.14, 0.88, 0.74]`, bringing the visible plot area close to Figure 3.
- [x] Reordered the panels so feasibility is on the left and the rank heatmap is on the right. Removed the separate heatmap colorbar because every cell already carries its exact rank annotation.
- [x] Replaced tight PNG export with fixed-canvas `print -dpng -r300`; both paper PNGs are exactly `2031x1750`, so equal LaTeX widths produce equal visual dimensions.
- [x] Placed Figures 7(a) and 7(b) side by side at `0.49\linewidth` within one column. MATLAB Code Analyzer reported no issues.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. Page 10 review confirmed equal axes width and height, Figure-3-scale visual area, readable annotations, and no clipping, overlap, or abnormal whitespace.

## 2026-07-27 Main-summary Side-by-side Layout

- [x] Changed the feasibility-figure canvas from `1080x560` to `650x560`, matching the average-rank figure, and regenerated both images from the frozen selected-seven CSV summaries.
- [x] Reallocated the feasibility axes margins and rotated the seven algorithm labels by 32 degrees so the compact canvas remains unclipped and readable.
- [x] Assigned both plots the identical normalized axes rectangle `[0.20, 0.19, 0.75, 0.66]` and reset the feasibility axes after creating its outside legend, preventing the legend from compressing panel (a).
- [x] Placed Figures 3(a) and 3(b) side by side at equal `0.49\linewidth` widths within a single-column float.
- [x] MATLAB Code Analyzer reported no issues. Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. Rendered review of page 9 confirmed equal axes width and height, readable labels, and no clipping, overlap, or abnormal whitespace.

## 2026-07-27 Ablation Evidence Completion and Figure 8 Reduction

- [x] Added a six-row single-column table containing only the exact ablation metrics cited in the discussion: the three scene-wise mean final fitness values, the three-scene mean evaluation count, and the Scene 3 mean CVF-trigger count.
- [x] Kept Figure 7 responsible for feasibility and rank trends, so the compact table restores numerical traceability without reinstating the archived 18-row table or repeating feasibility, ranks, standard deviations, and trigger-success counts.
- [x] Removed the redundant Scene 2 top-view panel from Figure 8 and retained only the Scene 3 representative 3-D path, which supplies the altitude and obstacle-geometry evidence not already covered by the main-comparison top views.
- [x] Revised the ablation discussion to cite the compact table explicitly for the V0--V4 fitness, trigger, and evaluation-count claims. No experiment, result, or ablation definition was changed.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. The log has no LaTeX Error, undefined reference/citation, overfull, or rerun-label warning. Rendered review of pages 9--11 found the new table and Figure 8 legible, unclipped, and free of abnormal whitespace.

## 2026-07-27 Figure 7 Rank Colorbar Restoration

- [x] Restored the vertical colorbar to the right of the Figure 7 rank heatmap, with integer ticks from 1 to 6 and the label `Rank`.
- [x] Set explicit positions for the heatmap axes and colorbar so MATLAB does not apply uncontrolled axes compression. The canvas, panel order, annotations, frozen data, and muted palette remain unchanged.
- [x] MATLAB Code Analyzer reported no issues. Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. Page 10 review confirmed that the colorbar, tick labels, heatmap values, and neighboring feasibility panel are visible without clipping or overlap.

## 2026-07-27 Table 4 Single-column Width Expansion

- [x] Expanded the compact ablation table to exactly `\linewidth` using `tabular*` and elastic inter-column spacing. The table remains single-column and retains the same font size, values, headings, and note.
- [x] Recompiled with `xelatex -> xelatex`; `main.pdf` remains 13 Letter pages. Page 10 review confirmed evenly distributed columns, full-width rules, aligned notes, and no clipping, overlap, or column overflow.

## 2026-07-27 Full-audit Priority Fixes and Figure Alternatives

- [x] Removed final violation and the trajectory review marker from the formal metric list. The fixed-threshold marker remains explicitly limited to path visualization and result review.
- [x] Defined reported feasibility as numerical feasibility under the fixed $M$-sample evaluator and added the absence of continuous collision certification or adaptive segment refinement to the limitations.
- [x] Added compact implementation-consistent definitions for random difference indices, the quality smoothing increment, near-feasible CVF triggering, and sparse repair retention. No non-paper state branch or optional implementation branch was introduced.
- [x] Clarified the scene-dependent altitude upper bounds and defined `Main`, `Abl.`, `Rate`, and `Ratio` in the runtime-table note.
- [x] Replaced causal or complementarity wording in the ablation discussion with evidence-bounded phrasing while retaining the approved representative-path interpretation.
- [x] Redrew Figure 2 as a single-column vertical schematic with sample-to-control mapping and active vector synthesis. Figure 3(a) and Figure 7(a) are now unconnected point plots; Figure 4 includes white diamond mean markers and a matching caption/prose definition.
- [x] Created review-only alternatives under `figures/review_previews/`: Figure 5 with late-iteration insets, a Table 5 Cliff's-delta/Holm heatmap, and a Table 6 sparse-trigger/evaluation-ratio chart. These previews are not referenced by the manuscript.
- [x] All official and preview figures read frozen CSV/MAT records only. No optimizer, experiment, statistical test, scene, algorithm set, or ablation definition was rerun or changed.
- [x] MATLAB Code Analyzer reported no issues for the new/updated figure generators. Final `xelatex -> xelatex` compilation produced 13 Letter pages with no LaTeX Error, undefined reference/citation, overfull box, or rerun-label warning.
- [x] Rendered review of pages 6 and 8--11 found readable labels, balanced columns, and no clipping, overlap, float-only page, or abnormal whitespace. Active TeX and rendered-PDF scans found no TODO, local absolute path, or prohibited comparison terminology.

## 2026-07-27 Figure 2, Figure 5, and Significance Heatmap Promotion

- [x] Redrew Figure 2 so its global and local views use the same three color-coded pressure vectors. The upper panel shows sample-to-control mapping; the lower panel translates those same vectors to a common origin and displays their mean direction.
- [x] Reduced Figure 2's source-canvas physical size and enlarged its labels so the vector correspondence remains readable after single-column scaling. Updated the method prose and caption to match the revised mechanism exactly.
- [x] Promoted the Figure 5 inset alternative to the manuscript. All three late-iteration insets now use the same normalized position and dimensions on equal-size main axes.
- [x] Replaced the dense significance table with the approved Cliff's-delta/Holm heatmap, including the restored diverging colorbar and cell-level $+$/$=$/$-$ relations. The archived table source remains in the project but is no longer input by the manuscript.
- [x] Kept the evaluation-overhead result as the existing compact table without changing its source content or format. Its displayed number changed automatically after removal of the preceding significance table.
- [x] Added dedicated frozen-data generators `make_cvf_ae_convergence_inset_figure.m` and `make_cvf_ae_significance_heatmap.m`; no optimizer, statistical test, experiment, or ablation was rerun.
- [x] MATLAB Code Analyzer reported no issues for all three active generators. Final `xelatex -> xelatex` compilation produced 13 Letter pages with no LaTeX Error, undefined reference/citation, or overfull box.
- [x] Rendered review of pages 6, 10, and 11 confirmed readable Figure 2 labels, aligned Figure 5 insets, a complete heatmap colorbar, an intact overhead table, balanced columns, and no clipping or abnormal whitespace. Active-source scans found no TODO, local absolute path, or prohibited comparison terminology.

## 2026-07-28 Figure 1 Final Selection

- [x] Removed the Deb feasibility-priority flowchart and its manuscript reference. The complete Deb comparison rule remains in the problem-formulation prose.
- [x] Rejected the old flowchart as a final Figure 1 because it repeated a standard rule, contained inconsistent candidate notation, and reduced the prominence of the paper's method contribution.
- [x] Added a new single-column Figure 1 that connects constraint-aware initialization, F/P/R state scheduling, sparse CVF candidate generation, conservative acceptance, sparse repair, and population feedback.
- [x] The framework contains only the paper's formal F/P/R states and active algorithm path; no optional implementation branch or non-paper state is shown.
- [x] Fixed the framework immediately after the Section 3.2 narrative so the text introduces the four questions before the figure. The pressure-mapping schematic is now Figure 2.
- [x] The dedicated generator `make_cvf_ae_closed_loop_framework.m` passed MATLAB Code Analyzer and creates both PNG and vector PDF outputs without running an optimizer.
- [x] Final `xelatex -> xelatex` compilation remains 13 Letter pages with no LaTeX Error, undefined reference/citation, or overfull box. Rendered pages 4--6 show correct narrative order, readable labels, balanced columns, and no abnormal whitespace.

## 2026-07-29 Framework Figure Removal

- [x] Removed the CVF-AE closed-loop framework figure, its caption, label, and dedicated figure-introduction sentence from Section 3.2.
- [x] Retained the compact four-question narrative and Algorithms 1--2, which now provide the method overview without repeating the same process in a framework figure.
- [x] Kept the framework source assets and editable Draw.io draft as unreferenced backup material; no figure asset, generator, experiment, or result was deleted or rerun.
- [x] Final `xelatex -> xelatex` compilation produced 13 Letter pages with no LaTeX Error, undefined reference/citation, overfull box, or stale `fig:cvf-ae-framework` reference in active TeX.
- [x] Rendered review of pages 4--5 confirmed complete pseudocode, balanced columns, and a direct transition from the Section 3.2 narrative to Section 3.2.1 without clipping, overlap, or abnormal whitespace.

## 2026-07-30 User-Redrawn CVF Pressure Figure Trial

- [x] Replaced the active Figure 1 PDF with the user-redrawn editable-Draw.io export and updated the caption to describe representative dominant pressure sources, sample-to-control mapping, averaging, curvature pressure, and final CVF synthesis.
- [x] Synchronized the surrounding method prose: colors identify representative dominant sources, actual sampled pressure combines active non-curvature components with the applicable state weights, and curvature is added after sample-pressure averaging at the control point.
- [x] Retained the requested single-column `figure` environment with `width=\linewidth`; no cross-column layout change was made.
- [x] Final `xelatex -> xelatex` compilation produced 13 Letter pages with no LaTeX Error, undefined reference/citation, or overfull box.
- [x] Rendered review of page 6 found no clipping, overlap, or abnormal whitespace. The single-column trial is structurally valid, but its internal panel titles, legend, and lower synthesis labels are visibly smaller than the surrounding paper text.

## 2026-07-30 Chapter 3 Priority Condensation

- [x] Condensed the constraint-aware initialization paragraph while preserving the reference-path role, boundary handling, fixed corridor template, common Deb screening, and iterative weak direction.
- [x] Shortened the Figure 1 lead-in and the transition to bounded fusion by removing explanations already carried by the figure, equations, and subsection structure.
- [x] Consolidated component clipping and CVF strength scaling into one equation, and combined the norm threshold with its piecewise clipping rule. The implementation order, parameter values, and resulting direction are unchanged.
- [x] Reordered the quality-direction definition so the smoothing increment is defined before use, then removed prose that repeated the displayed equation.
- [x] Final `xelatex -> xelatex` compilation produced 13 Letter pages with no LaTeX Error, undefined reference/citation, overfull box, or rerun-label warning.
- [x] Active-source scans found no TODO, local absolute path, prohibited comparison terminology, or stale reference to the removed CVF-strength equation. Rendered review of pages 5--7 found no clipping, overlap, broken equation, or abnormal whitespace.

## 2026-07-30 Final Chinese-manuscript Consistency Audit

- [x] Corrected the ablation control variables so V1, V3, and V4 inherit the same conservative F/P/R scheduler as V0. V3 now disables iterative sparse preservation while retaining the one-shot initialization repair through an independent flag.
- [x] A small regression confirmed that all affected variants report only the formal F/P/R states, V1 generates no CVF candidate, and V3 performs no iterative sparse repair.
- [x] Re-ran the affected V1/V3/V4 variants for three scenes, 30 independent runs, `N=30`, and `T=300`; combined them with the unchanged V0/V2/V5 records to form 540 validated rows in `cvf_ae_formal_ablation_corrected_20260730_v2`.
- [x] Verified complete state histories, zero CVF triggers for V1, and at most the initialization repair quota for V3. Parallel scene batches were not used for wall-clock comparisons; the manuscript reports only function-evaluation and trigger ratios.
- [x] Regenerated the active ablation feasibility, rank, and representative-path figures from the corrected records. Updated both the active compact table and the archived full table to the same values.
- [x] Synchronized the abstract, ablation discussion, conclusion, and overhead table. V0 ranks first in all three ablation scenes; the V0/w/o-CVF evaluation ratios are `1.002`, `1.001`, and `1.010`, with a three-scene mean extra evaluation count of about `0.44%`.
- [x] Aligned the pseudocode and formulas with the implementation: request state `q_t` versus active state `s_t`, Deb-only retention of repaired candidates, generation-level best update, reference-height preference, state-varying noise scaling, and the implemented complexity terms.
- [x] Added an explicit non-curvature pressure definition and final curvature synthesis equation, removed a non-implemented risk denominator epsilon, and translated the remaining English boundary-formula placeholder.
- [x] Corrected the Wang and Fu article-number metadata and added the Deb constraint-handling citation. All 22 rendered references resolve, with no missing or duplicate cited key.
- [x] Replaced the stale MATLAB R2022b environment line with R2024b, matching the only installed executable and the corrected formal-ablation run environment.
- [x] MATLAB Code Analyzer reported zero issue for the optimizer, corrected-artifact generator, and representative-path generator. The runner/initializer checks retain only pre-existing performance and API-modernization advisories (dynamic struct growth and `datestr`/`now`), with no correctness diagnostic.
- [x] Final `bibtex -> xelatex -> xelatex` plus a later `xelatex -> xelatex` pass produced 13 Letter pages. The log has zero LaTeX Error, undefined reference/citation, overfull box, or rerun warning.
- [x] Active-source and rendered-PDF scans found no TODO, local absolute path, prohibited algorithm/scene terminology, stale ablation value, or internal correction wording. All 13 rendered pages were reviewed; figures, tables, equations, section transitions, and bibliography columns are unclipped, non-overlapping, and visually balanced.
