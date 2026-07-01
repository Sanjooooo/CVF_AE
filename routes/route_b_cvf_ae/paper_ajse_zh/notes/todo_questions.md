# 待确认问题

## 已确认

- 中文稿要求最终能在 Overleaf 直接中文编译。
- 编译器只要求能编译中文和参考文献；当前骨架采用 `ctexart`，建议 XeLaTeX。
- 中文初稿先用 `ctexart/article` 风格，后续英文稿再按 AJSE/Springer 模板调整。
- 允许保留中文章节名、中文图题、中文表题。
- 允许创建和修改 `routes/route_b_cvf_ae/paper_ajse_zh/`。
- 作者、单位、通讯作者、邮箱已确定，但正文中仍需用户提供具体文本。
- 基金、致谢、利益冲突、数据可用性声明已有固定内容，但正文中仍需用户提供具体文本。
- 实验环境：Intel(R) Core(TM) i5-14600KF (3.50 GHz)，32 GB 内存，64 位系统，MATLAB R2022b，无并行。
- CEC 内容在本文中完全不写，除非后期刚需。
- 不补真实地图、DEM 或城市障碍案例，先按现有三场景写 AJSE 中文初稿。
- 当前没有 Zotero/BibTeX，允许后续联网建立候选文献库。
- 图表复制到 LaTeX 项目的 `figures/` 目录。
- `evaluatePath.m` 不存在，评价函数来源改用 `fitnessFAEAE.m`。
- 需要核验 AJSE/Springer 官方要求。
- 采用“强约束三维/低空 UAV 路径规划 + Constraint Viability Field”的工程应用主线。
- 检查代码后确认：项目中有用于参考路径生成的 3D A*，没有 RRT/RRT* 正式对比实现；首稿不加入 A*/RRT*。

## 必须补充具体文本

- TODO: 作者姓名、单位、通讯作者、邮箱。
- TODO: 基金项目、致谢、利益冲突、数据可用性声明的固定内容。

## 后续写作前复核

- TODO: 是否需要在中文稿中加入“AI 辅助写作/编辑声明”。AJSE/Springer 指南要求生成式写作使用需按政策披露，单纯 copy editing 不需要声明。
- TODO: 投稿前通过学校数据库复核 AJSE 的 MJL Active、JCR Q 区、中科院 2025 分区和费用。
