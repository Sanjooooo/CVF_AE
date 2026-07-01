# AJSE / Springer Requirements

核验日期：2026-06-27。

官方来源：

- AJSE submission guidelines: <https://link.springer.com/journal/13369/submission-guidelines>
- Springer Nature LaTeX Author Support: <https://www.springernature.com/gp/authors/campaigns/latex-author-support>

## 已核验要点

- AJSE 投稿稿件应使用英文；当前中文稿仅作为内部中文初稿，后续英文稿需翻译并改成 AJSE/Springer 适配格式。
- AJSE 是 Hybrid publishing model。
- Research Article 应包含 Abstract、Introduction、Experimental Methods、Results and Discussion、Acknowledgments、References、Figure Captions、Tables。
- 投稿和修订时必须提供完整可编辑源文件；LaTeX 源文件、样式文件、图片和编译 PDF 后续都要保留。
- Title Page 需要标题、作者、单位、通讯作者邮箱，如有 ORCID 也应提供。
- Abstract 要求 150--250 words；中文初稿可先写中文摘要，但后续英文稿需控制字数。
- Keywords 要求 4--6 个。
- References 在正文中使用方括号数字引用；参考文献列表按引用顺序编号；可用 DOI 时应使用完整 DOI 链接。
- 表和图均需按正文出现顺序编号并在正文中引用。
- 图像文件不应使用本机绝对路径；Springer LaTeX 支持页面明确提示应使用本地相对路径。
- Springer Nature 建议 journal authors 使用 Springer Nature LaTeX authoring template；官方模板偏 content-first，后续英文稿阶段再迁移。
- Springer Nature 页面提示提交前应本地编译并修复错误。

## 中文草稿阶段决策

- 采用 `ctexart` 骨架，目标是 Overleaf 中文编译和便于章节拆分。
- 参考文献暂用 `natbib` + TeX Live 标准 `unsrtnat` 数字制；后续英文稿迁移到 Springer 模板时再按模板 `.bst` 调整。
- 图像先复制到 `figures/` 并使用相对路径。

## 投稿前待复核

- 投稿当天复核 AJSE 官方指南是否更新。
- 学校数据库复核 MJL Active、JCR Q 区、中科院 2025 分区。
- 投稿系统确认是否有超页费、彩色印刷费或其他非 OA 费用。
- 若改用 Springer Nature 官方模板，确认 `sn-jnl` 选项和参考文献样式。
