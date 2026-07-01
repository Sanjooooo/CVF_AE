# Source Mapping

## Project Sources

| 内容 | 来源 |
|---|---|
| 正式结果索引 | `routes/route_b_cvf_ae/docs/CVF_AE_RESULTS_INDEX.md` |
| AJSE 投稿策略 | `routes/route_b_cvf_ae/docs/CVF_AE_TARGET_JOURNAL_RESEARCH.md` |
| 期刊精简表 | `routes/route_b_cvf_ae/docs/CVF_AE_JOURNAL_SHORTLIST.md` |
| 论文提纲 | `routes/route_b_cvf_ae/docs/ROUTE_B_CVF_PAPER_OUTLINE.md` |
| CVF 机制推导 | `routes/route_b_cvf_ae/docs/CVF_MECHANISM_DERIVATION.md` |
| 项目日志 | `routes/route_b_cvf_ae/docs/CVF_AE_PROJECT_LOG.md` |
| 主对比协议 | `routes/route_b_cvf_ae/docs/CVF_AE_MAIN_COMPARISON_PROTOCOL.md` |
| 评价函数 | `fitnessFAEAE.m` |
| CVF 构建 | `buildConstraintViabilityField.m` |
| CVF-AE 候选生成 | `applyOperator_CVF_AE.m` |
| CVF-AE 主循环 | `optimizer_CVF_AE_uav.m` |
| 状态识别 | `identifyConstraintState.m` |
| Deb 规则 | `debBetter.m` |
| 初始化 | `init_COVE_AE.m` |
| 稀疏 repair | `repairPath.m` |
| 参数 | `defaultParams.m`、`applyUAVSceneOverrides.m` |

## Result Tables

| LaTeX 表 | 数据源 |
|---|---|
| `table_main_comparison.tex` | `paper_table_main_compact.csv` |
| `table_ablation.tex` | `paper_table_ablation.csv` |
| `table_significance.tex` | `paper_table_main_significance.csv` |
| `table_runtime.tex` | `paper_table_overhead.csv` |

转换状态：

- 2026-06-29：以上 LaTeX 表已由正式 CSV 机械转换生成。
- 主对比表保留 11 个算法、3 个场景的 fitness、feasible rate、rank、average rank 和 visual flag rate。
- 消融表使用跨栏 `tabular`；显著性表使用单栏纵向明细表；运行开销表使用主文摘要表。
- 表格 caption 已恢复为标准中文描述型标题，表头保留必要英文缩写以节省宽度。
- 2026-06-30：参数敏感性表已从主文删除，关键结论并入“评价开销与参数稳健性”小节；完整逐场景明细保留在 `paper_table_parameter_sensitivity.csv`。
- 2026-06-30：显著性表已改为单栏逐场景明细表；完整 p 值、效应量和逐算法开销明细仍保留在正式 CSV。
- 2026-06-29：运行开销表避免把不同 batch 的绝对 runtime 直接横向比较；主文只报告主对比触发规模和同批次消融 ratio。

## Figure Sources

完整复制清单见 `notes/figure_asset_manifest.csv`。

复制结果：

- 从 `paper_figure_index.csv` 中复制 ready PNG 共 25 张。
- 同名 PDF 存在时一并复制，共 4 个 PDF。
- 所有 LaTeX 图像引用后续必须使用 `figures/` 下相对文件名。
