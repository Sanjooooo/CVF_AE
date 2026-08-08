# CVF-AE Route B Project Log

## 2026-08-08 - Two-column float spacing compacted

Scope:

- enabled ragged-bottom two-column composition so LaTeX no longer stretches vertical glue between a column-top float and the following body text to force equal column bottoms;
- reduced the normal text-to-float separation from 9 pt to 7 pt while retaining a small stretch/shrink tolerance;
- retained the existing top-float placement for Figure 3 and all scientific content, data, tables, and figures.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; the former page-level underfull-vbox diagnostics are absent after the ragged-bottom change, while pre-existing underfull-hbox diagnostics remain;
- rendered and visually checked the affected Chapter 4 page: Figure~3 now has normal compact separation from the following body text, and the adjacent Figure~2, Table~3, and Section~4.2 content remain legible and free of clipping or overlap.

## 2026-08-08 - Conclusion evidence paragraph condensed

Scope:

- condensed the second conclusion paragraph to report only the experimental evidence that directly supports the proposed closed-loop design: overall feasibility/rank, dense-scene quality, ablation dependencies, and sparse-evaluation overhead;
- removed the detailed per-method distribution comparison and scene-specific exception from the conclusion while retaining them in the results chapter;
- did not modify MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
- rendered and visually checked the condensed conclusion page: the shortened evidence paragraph, future-work paragraph, and subsequent declarations remain legible and free of clipping or overlap.

## 2026-08-08 - Conclusion rewritten around method contribution and evidence

Scope:

- rewrote the conclusion to foreground the CVF-AE closed-loop innovation: constraint-aware initialization, state-conditioned intervention, bounded CVF correction, and conservative local acceptance;
- strengthened the result summary using only reported evidence: three-scene feasibility, average rank, the dense Scene 3 comparison, distribution-test summary, ablation outcomes, and sparse-evaluation overhead;
- condensed the future-work discussion to a short statement of the main external-validity and deployment directions;
- did not modify MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
- rendered and visually checked the conclusion page: the three-paragraph conclusion, its transition to acknowledgments and declarations, and the adjacent reference column are legible and free of clipping or overlap.

## 2026-08-07 - Complexity heading and equation numbering adjusted

Scope:

- restored the Section 3.3 heading to ``算法复杂度'';
- converted the initialization-cost and final dominant-complexity expressions to numbered display equations, without changing their content;
- synchronized the Chapter 3 study-guide heading;
- did not modify MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
- rendered and visually checked the revised Section 3.3: the restored heading and the consecutively numbered equations (54)--(57) are legible, with no clipping, overlap, or abnormal section transition.

## 2026-08-07 - Dominant-evaluation complexity clarified

Scope:

- renamed Section 3.3 to specify that it reports dominant path-evaluation complexity rather than every implementation-level operation;
- retained the existing base-search and sparse-CVF formulas, added the missing initial-population evaluation cost, and stated the resulting dominant asymptotic term;
- separated reference-path grid construction $O(QG)$ from the array-scanned A* core search $O(Q^2)$, and noted that sorting, state statistics, and candidate-vector operations are outside this evaluation-cost accounting;
- synchronized the Chapter 3 study guide with the revised complexity account;
- did not modify MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
- rendered and visually checked the revised Section 3.3: all three displayed complexity expressions, the Section 3.3 heading, and the transition to Chapter 4 are legible and free of clipping or overlap.

## 2026-08-07 - Reference-path boundary-margin detail removed

Scope:

- removed the reference-path boundary preference margin $m_b$, its fixed value, and its quadratic-cost trigger from the manuscript method text and parameter table;
- retained the high-level statement that the A* reference path uses a boundary preference, and retained $b_b$ because it directly parameterizes CVF boundary pressure;
- did not modify MATLAB code, frozen experimental data, result values, figures, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
- rendered and visually checked the revised Section 3.2.1 and Table~3 pages: no undefined $m_b$ reference, clipping, overlap, or abnormal spacing remains.

## 2026-08-07 - Boundary-margin wording clarified

Scope:

- replaced the abstract description of $m_b$ with the explicit A* reference-path condition: a quadratic boundary-preference cost is added only when a grid point lies within $m_b$ of a horizontal boundary;
- removed the now-redundant reminder in the CVF boundary-pressure paragraph that $b_b$ differs from $m_b$, while retaining the definition of $b_b$ and the projection-based hard-boundary statement;
- did not modify MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
- rendered and visually checked the revised Section 3.2.1 page: the explicit $m_b$ condition is legible, fits the two-column layout, and does not introduce clipping or overlap.

## 2026-08-07 - Method-text consolidation and reference-margin definition

Scope:

- removed five repetitive implementation-boundary explanations from Section 3.2, while retaining the corresponding formulas and candidate-generation rules;
- revised the Figure 1 lead-in to describe the visible mapping, averaging, and curvature-synthesis process without naming an unlabelled final increment;
- stated explicitly that obstacle pressure is zero outside its buffer; distinguished the averaged path-pressure increment from the final increment only through the retained equations;
- moved the first formal introduction of the reference-path boundary preference margin $m_b$ to Section 3.2.1 and defined it as the horizontal distance at which its quadratic reference-path cost begins, with $m_b=\SI{12}{m}$;
- did not modify MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
- rendered and visually checked the revised Section 3.2 pages: the $m_b$ definition, Figure~1 lead-in, obstacle-buffer condition, and subsequent risk/height/curvature transition are legible and free of clipping or overlap.

## 2026-08-06 - Cross-reference added for scene setup

Scope:

- added a formal cross-reference to Table~2 in the paragraph that introduces the three-dimensional planning space and the progressive scene constraints;
- did not modify MATLAB code, frozen experimental data, result values, tables, figures, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
- rendered and visually checked the Chapter 4 opening page: the new Table~2 reference resolves correctly, with normal line wrapping and no clipping or overlap.

## 2026-08-06 - Chapter 4 opening condensed

Scope:

- condensed the opening paragraph of the results-and-discussion chapter while retaining the evidence sequence, primary outcomes, supporting analyses, statistical/overhead roles, and the limited purpose of representative-path review markers;
- did not modify MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

  - ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page two-column PDF;
  - the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
  - rendered and visually checked the Chapter 4 opening pages: the condensed introduction, Section 4.1 heading, both setup tables, and the transition to the main comparison remain legible and free of clipping or overlap.

## 2026-08-06 - State-conditioned internal base candidate displayed separately

Scope:

- converted the state-conditioned internal base-candidate definition $\mathbf X_{\mathrm{AE}}^{(s_t)}$ in Section 3.2.2 from inline mathematics to a numbered display equation, without changing its definition or use;
- did not modify MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page Letter two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
- rendered and visually checked the page containing the new display equation: it is legible, balanced with the preceding state-direction equation, and does not cause clipping, overlap, or an abnormal section transition.

## 2026-08-06 - Section 3.2 transition and wording compression

Scope:

- added a concise opening transition to Section 3.2.4: local CVF pressures must be step-limited, blended with quality guidance, and conservatively accepted so that they do not overtake the base search;
- condensed the long closing explanation of Section 3.2.1 and the parameter/implementation-detail-heavy closing paragraphs of Section 3.2.4, while retaining the definitions, trigger thresholds, repair conditions, and acceptance rules required to reproduce the stated method;
- did not modify MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page Letter two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout;
- rendered and visually checked the Chapter 3 pages containing the revised Section 3.2.1 and the full Section 3.2.4, including its transition to Section 3.3 and Chapter 4: formulas, headings, line breaks, table/figure placement, and two-column balance are normal, with no clipping or overlap.

## 2026-08-06 - Initialization-index definition and stateful base-candidate notation

Scope:

- defined the initialization superscript and the individual/control-point indices in $\mathbf q^{(0)}_{i,k}$, and stated that the $K$ initialized control points are concatenated into $\mathbf X_i^{(0)}\in\mathbb R^{3K}$;
- retained $\mathbf X_{\mathrm{AE}}$ for the fixed balanced candidate of the standalone base AE, and renamed the distinct CVF-AE state-dependent internal base candidate to $\mathbf X_{\mathrm{AE}}^{(s_t)}$ throughout Algorithm 2, its definition, candidate comparison, and the Chapter 3 study note;
- did not alter the corresponding MATLAB variable names, candidate-generation logic, frozen experimental data, results, or experimental settings.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page Letter two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout.

## 2026-08-05 - Differential-index sampling wording clarification

Scope:

- replaced the set-difference notation in the Section 3 base-AE direction definition with a direct Chinese description: four different indices $a,b,c,d$ are selected uniformly without replacement from the $N-1$ population members other than the current individual $i$;
- synchronized the same wording in `paper_ajse_zh/notes/chapter3_study_guide.md`;
- did not change the sampling rule, formula, MATLAB code, frozen experimental data, result values, or any experimental setting.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page Letter two-column PDF;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout.

## 2026-08-04 - Chapter 3 Markdown learning notes synchronized to current manuscript

Scope:

- replaced `paper_ajse_zh/notes/chapter3_study_guide.md` with a beginner-oriented guide that preserves its former chapter-by-chapter learning structure while synchronizing all definitions with the current Section 3 manuscript;
- updated the request-state formation condition, two-generation confirmation rule, state-specific internal AE direction, pressure aggregation and control-point averaging, distinct CVF and objective risk fields, bounded fusion, sparse CVF qualification/quota, local repair, and full complexity expression including one-off A* and initialization costs;
- retained the explicit distinction between reference/pressure soft guidance, hard constraints, and the formal objective, and clarified that CVF is a bounded piecewise candidate-direction mechanism rather than an analytic gradient;
- did not modify manuscript source, MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- checked the updated Markdown headings against the previous learning-note structure and checked its formulas and numerical thresholds against the current `sections/03_method.tex`;
- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page Letter two-column PDF; the Markdown note is not imported into the manuscript, so the compilation preserves manuscript content;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout.

## 2026-08-04 - Chapter 2 Markdown learning notes

Scope:

- created `paper_ajse_zh/notes/chapter2_study_guide.md`, a beginner-oriented Markdown companion to Chapter 2;
- explained every Chapter 2 formula in sequence, including symbol meanings, modelling derivations, parameter roles, numerical examples, the distinction between objective $J$ and feasibility score $V$, and the Deb comparison order;
- made explicit that $z_{\mathrm{ref}}$ and $m_b$ are soft guidance only and are neither independent objective terms nor hard constraints; distinguished $m_b$ from the method-layer CVF buffer width $b_b$;
- did not modify the manuscript source, MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- checked the Markdown source for its title, all 18 Chapter 2 equation tags, key parameter values, and the absence of a claim that reference guidance enters the formal objective;
- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully and overwrote `paper_ajse_zh/main.pdf` with the resulting 13-page Letter two-column PDF, as required by the project workflow; the Markdown note is not imported into the manuscript, so this compilation does not alter manuscript content;
- the compile log contains no LaTeX Error, undefined reference/citation, rerun-label, or overfull warning; existing underfull box diagnostics remain in the unchanged manuscript layout.

## 2026-08-04 - Chapter 2--3 learning notes document

Scope:

- created `docs/CVF_AE_Chapter2_3_Study_Notes.docx`, a beginner-oriented learning note for Chapters 2 and 3 that explains the modelling purpose, symbols, objective and constraint formulas, parameter roles, and CVF-AE iteration flow;
- did not modify the manuscript source, MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- checked the generated DOCX structure: its headings, 86 paragraphs, and 15 explanatory tables were successfully read back from the output file;
- attempted visual rendering. LibreOffice is unavailable on this computer, and a read-only headless Word PDF export timed out without producing an output file; therefore, visual raster verification was not completed.

## 2026-08-04 - Base-candidate convex-coefficient condition

Scope:

- stated explicitly that the time-varying base-candidate coefficients satisfy $\eta_t,\mu_t\geq0$ and $\eta_t+\mu_t\leq1$, completing the stated convex-combination condition;
- did not modify MATLAB code, frozen experimental data, result values, figures, tables, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked the revised base-candidate formula explanation; line flow and mathematical notation are normal;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output.

## 2026-08-03 - Statistical-term line-break cleanup

Scope:

- bound the English statistical term ``Cliff's delta'' and its citation as one nonbreaking phrase, preventing the trailing word and citation from being separated from the preceding sentence by a floating figure;
- did not modify method content, parameters, MATLAB code, frozen experimental data, result values, figures, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked the experimental-setup and main-comparison transition pages; the statistical sentence and floating figure placement are normal;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output.

## 2026-08-03 - Consolidated experimental and CVF-AE parameter presentation

Scope:

- removed the detailed stand-alone CVF-AE parameter table from the method section, retaining Table 1 solely for the three-state candidate-fusion mechanism;
- expanded the experimental-configuration table into a compact joint presentation of public experimental settings and key fixed CVF-AE parameters, while omitting duplicated explanatory prose from the energy, reference, and boundary entries;
- clarified in the surrounding text which entries are shared by all algorithms and which are CVF-AE-specific, so that the combined table does not imply that baselines use CVF-AE mechanisms;
- did not modify MATLAB code, frozen experimental data, result values, figures, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked the method transition and combined parameter table; table hierarchy, line wrapping, and two-column flow are normal;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output.

## 2026-08-03 - Localized parameter-definition placement and curvature display

Scope:

- removed the consolidated reference-height and boundary-preference explanation from the objective subsection, leaving those parameters to be introduced where they are used;
- defined the reference-height symbol $z_{\mathrm{ref}}$ in the altitude-constraint paragraph, removed the premature CVF boundary-width mention from the spatial-boundary paragraph, and retained the separate $m_b$ explanation only as a reference-path soft preference;
- converted the curvature-violation sum to a displayed equation and aligned its wording with the numerical feasibility rule by identifying excess turning as infeasibility rather than an alternative low-quality status;
- did not alter MATLAB code, frozen experimental data, result values, figures, tables, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked the revised objective, boundary, altitude, and turning-constraint pages; formula placement and two-column flow are normal;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output.

## 2026-08-03 - Formula and parameter-definition completeness revision

Scope:

- corrected the initialization-radius denominator to use the defined evaluator risk density $r_{\mathrm{obj}}$, and specified the roles of its net-clearance, risk-shrink, and minimum-radius coefficients;
- defined the decision set $\Omega$ and its single-control-point bounds, corrected the problem statement so that height and boundary requirements are not presented as formal objective terms, and separated the reference-path boundary preference $m_b$ from the CVF boundary-pressure width $b_b$;
- added explicit multi-element aggregation for obstacle, no-fly-zone, and risk pressures; defined the nonzero pressure hit count; made altitude and boundary pressures explicit three-dimensional vectors; and removed the overloaded individual no-fly-zone and altitude-limit notation;
- defined $J_t^*$ for the state-improvement equation and added a CVF-AE key-parameter table covering initialization, state scheduling, low-density sampling, clipping, geometry/risk/turning pressures, and state component weights;
- did not modify MATLAB code, frozen experimental data, result values, figures, statistical tests, or experimental execution.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked the revised problem-formulation and method pages, including the new parameter table; formulas, table layout, and two-column flow are normal;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output.

## 2026-08-03 - Contribution-claim wording refinement

Scope:

- refined the first contribution to distinguish local constraint information from risk and turning-quality information, avoiding the inaccurate implication that every CVF component is a constraint violation;
- refined the third contribution so that the limited scope of sparse feasibility preservation is stated as a conservative design intention rather than an independently established causal effect;
- did not alter the CVF-AE method, equations, frozen experimental data, results, figures, tables, or MATLAB code.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked the contribution list and its transition to Section 2; text flow and list layout are normal;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output.

## 2026-08-03 - Introduction three-stage narrative restructuring

Scope:

- restructured the introduction into a three-stage narrative: concise problem framing, named peer-work and study-pain-point discussion, then the CVF-AE response and contributions;
- paired the literature discussion with the concrete mechanisms of Darlan, Niu, Chen, Wang, Meng, Khatib, and Liu, replacing broad grouped descriptions with “author--method” statements;
- clarified the methodological need as pre-evaluation local constraint direction, sparse state-based intervention, and conservative replacement, then connected these needs directly to the CVF-AE design;
- removed a residual duplicate transition before the contribution list; no method equation, frozen experimental data, result, table, figure, or MATLAB code was changed.

Verification:

- ran `xelatex -> bibtex -> xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked the title/abstract/introduction pages; the three-stage introduction flow, citation numbering, contribution transition, and two-column layout are normal;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output.

## 2026-08-03 - Literature-claim audit and mechanism-level positioning

Scope:

- verified the identity and mechanism relevance of the recent UAV path-planning references used in the introduction, prioritizing publisher or DOI records for the two surveys, domain-specific evolutionary operators, continuous ant-colony optimization with waypoint repair, biased sampling/candidate evaluation/path reconfiguration, evolutionary multitasking, recent swarm optimizers, and rotation artificial potential fields;
- replaced the introduction's broad grouping of recent work with mechanism-level positioning: domain-specific operators, waypoint repair, biased sampling/candidate evaluation/path reconfiguration, and adaptive operator selection/knowledge fusion now correspond directly to their respective citations;
- revised the potential-field comparison to state the different problem addressed by CVF-AE rather than making a broad negative claim about all existing potential-field methods;
- added `paper_ajse_zh/notes/citation_claim_map.md`, an internal claim--reference--difference map for future English rewriting and citation additions;
- retained all existing cited references and did not alter the method, experimental design, frozen data, tables, figures, or statistical results.

Verification:

- checked the revised introduction against the cited publication records and verified that its mechanism descriptions match the cited works;
- ran `xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked the abstract, introduction, and Section 2 transition pages; citation numbering, column flow, and equation layout are normal;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output.

## 2026-08-03 - Figure-caption evidence alignment

Scope:

- audited each formal result figure and table against its in-text interpretation, with emphasis on the distinction among aggregate comparison, distributional comparison, representative-path visualization, ablation attribution, statistical comparison, and evaluation overhead;
- revised the main-summary caption to state that its average scene rank is based on final fitness, consistent with the frozen selected-seven summary records;
- revised the main-comparison and ablation representative-path captions to state that the displayed runs are selected by a uniform rule and are used only for geometric-form review;
- revised the ablation-summary caption to state directly that its two panels report three-scene feasibility and per-scene rank;
- did not modify any figure asset, table value, ranking, statistical result, MATLAB code, or experimental data.

Verification:

- verified the frozen `selected7_summary_long.csv` ordering: the displayed scene ranks are ordered by final mean fitness;
- ran `xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked the main-comparison, ablation, statistical, and evaluation-overhead pages; captions, figures, tables, and column balance are readable, with no clipping or overlap;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output.

## 2026-08-03 - Contribution-evidence narrative alignment

Scope:

- reviewed the abstract, introduction, results discussion, and conclusion as a single contribution-evidence chain; the three stated contribution lines, main-comparison claims, ablation attribution, statistical qualification, and evaluation-overhead statement are mutually consistent with the frozen evidence;
- revised the abstract to characterize the CVF output as a local constraint-aware direction, which covers both feasibility-oriented and quality-related pressure components without narrowing the claim to feasibility alone;
- aligned the conclusion with the method definition: CVF encodes local constraint information into bounded, piecewise control-point candidate-correction directions and does not require an analytic gradient or continuously differentiable potential-function assumption;
- replaced the remaining process-oriented phrase “当前任务” with “所考虑任务”; no numerical result, method equation, ablation definition, or experimental claim was changed.

Verification:

- ran `xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked the abstract/introduction page and the conclusion continuation page; no clipping, overlap, broken equation, or abnormal whitespace was observed;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output;
- no MATLAB code, frozen experimental records, figures, tables, or statistical results were modified.

## 2026-08-03 - Manuscript formulation clarification and display-equation update

Scope:

- revised the CVF construction statement in `paper_ajse_zh/sections/03_method.tex` to describe CVF as a bounded, piecewise candidate-correction direction that does not require analytic gradients or a continuously differentiable potential-function assumption;
- retained the method claim at the implemented level: local constraint information is encoded in control-point space for candidate generation, without changing the CVF equations, parameters, MATLAB implementation, experimental data, or reported results;
- converted the definitions of the path-length, energy, risk, smoothness, and penalty terms in Section 2.2 into clear display equations; added labels for the newly separated length, risk, and smoothness equations;
- revised the feasibility wording to distinguish fixed-sampling numerical feasibility from continuous collision certification, and clarified that the aggregate violation score is used only for infeasible-candidate ranking and thresholding;
- replaced process-oriented wording such as “正式评价” and “本文报告的正式适应度” with manuscript-oriented terms such as “目标函数权重” and “适应度函数”.

Verification:

- ran `xelatex -> xelatex` successfully; the Chinese manuscript remains a 13-page Letter two-column document;
- rendered and visually checked pages 2--3 for the display equations and page 5 for the revised CVF statement; no clipping, overlap, broken equation, or abnormal whitespace was observed;
- overwrote `paper_ajse_zh/main.pdf` with the verified compilation output;
- no MATLAB code, frozen experimental records, figures, tables, or statistical results were modified.

## 2026-08-01 - Route B active-chain cleanup and historical migration

- Reduced the statically required Route B MATLAB chain from 58 files to 40 files, plus the optional closed-loop framework figure generator.
- Restricted the main comparison dispatcher and algorithm configuration to the formal seven algorithms: AE, PSO, GWO, HHO, ERIME, MSCSO, and CVF-AE.
- Replaced the corrected-ablation artifact dependency on historical comparison packages with a focused six-variant Scene 3 representative-path generator.
- Moved 54 obsolete Route B MATLAB files to `archive/cleanup_20260801/route_b_old_code/`; no files were deleted.
- Moved 27 historical Route B result directories and the obsolete mixed representative-path subtree to `archive/cleanup_20260801/route_b_historical_results/`.
- Retained only the five current result directories: the selected-seven formal run, its paper artifacts, corrected ablation formal run and paper artifacts, and the internal template-initialization ablation.
- Kept the external formal MAT backup at `D:/MATLAB/Project/COVE_AE_matlab_formal_mat_backup_20260801` with a verified SHA-256 manifest.
- Verified that the active dependency graph has no missing files, old algorithm symbols are absent from the active chain, all active paper figures exist, and the current LaTeX log has no errors, undefined references/citations, or overfull boxes.

## 2026-07-07 Method section restructuring

Scope:

- reorganized `paper_ajse_zh/sections/03_method.tex`;
- moved algorithm presentation to the beginning of the method section;
- added `Algorithm 1` for the base AE path-search flow and retained `Algorithm 2` for CVF-AE;
- restructured the method section into `3.1` base/CVF-AE pseudocode and framework, `3.2` constraint-viability guidance mechanisms, and `3.3` complexity;
- grouped the innovation details under subsubsections for state scheduling, CVF construction and pressure components, bounded fusion, sparse triggering, and local acceptance;
- preserved the existing core equations, labels, CVF component definitions, state decision rule, candidate fusion rule, local acceptance rule, and complexity formulas;
- changed both algorithm environments to `[H]` so the pseudocode stays with the 3.1 source position instead of floating ahead of the subsection heading;
- did not modify MATLAB algorithm code, experimental data, tables, or figures.

Verification:

- ran `xelatex -> xelatex`; current `paper_ajse_zh/main.pdf` remains 12 pages;
- log scan found no LaTeX Error, fatal stop, emergency stop, undefined citation, undefined reference, overfull warning, or rerun-label warning;
- rendered and visually checked pages 4--7, covering the reorganized method section and the transition into the results section;
- static scans of manuscript source, tables, captions, `main.aux`, and `main.bbl` found no disallowed comparison wording, excluded algorithm names, internal scene numbering, CEC/RRT wording, or overclaiming phrases.

## 2026-07-07 Unified seven-algorithm main comparison rerun

Scope:

- added `run_cvf_ae_selected7_main_comparison.m` as the formal unified rerun entry point;
- reran the main comparison with `AE, PSO, GWO, HHO, ERIME, MSCSO, CVF-AE` under common scene, population, iteration, and seed settings;
- completed 630 run records: three low-altitude synthetic scenes, seven algorithms, thirty independent runs per algorithm and scene;
- wrote formal rerun outputs to `routes/route_b_cvf_ae/results/cvf_ae_selected7_main_comparison_formal_20260707_101155/`;
- regenerated paper artifacts under `routes/route_b_cvf_ae/results/cvf_ae_selected7_paper_artifacts_rerun_20260707_101155/`;
- updated `make_cvf_ae_selected7_paper_artifacts.m` so the paper tables and figures are produced from the unified rerun directory;
- removed internal figure titles from paper figures; scene and metric information is carried by file names and LaTeX captions;
- replaced the paper main comparison table, significance table, runtime/evaluation-overhead rows, boxplot, convergence curves, and representative trajectory figures;
- regenerated `paper_ajse_zh/notes/engineering_review_breakdown_draft.md` and `.csv` as an internal trajectory review breakdown, without adding it to the manuscript.

Recomputed statistics:

- CVF-AE average rank: `1.33`;
- average ranks of the nearest representative baselines: MSCSO `2.00`, ERIME `2.67`;
- CVF-AE feasible rate: `1.00` in all three scenes;
- CVF-AE engineering-review flag mean: `0.10`;
- CVF-AE pairwise summary over 18 baseline comparisons: `13` wins, `4` ties, `1` loss after per-scene Holm correction;
- the single significant scalar-fitness loss is the Scene 2 comparison against MSCSO;
- main CVF-AE evaluation-overhead rows were updated from the unified rerun: Scene 1 mean evaluations `9569.5`, trigger rate `0.28%`; Scene 2 mean evaluations `9552.7`, trigger rate `0.14%`; Scene 3 mean evaluations `9362.5`, trigger rate `0.93%`.

Paper updates:

- `paper_ajse_zh/tables/table_main_comparison.tex`
- `paper_ajse_zh/tables/table_significance.tex`
- `paper_ajse_zh/tables/table_runtime.tex`
- `paper_ajse_zh/sections/00_abstract.tex`
- `paper_ajse_zh/sections/04_results_and_discussion.tex`
- `paper_ajse_zh/sections/05_conclusion.tex`
- selected paper figures under `paper_ajse_zh/figures/`

Verification:

- ran `xelatex -> xelatex`; current `paper_ajse_zh/main.pdf` has 12 pages;
- log scan found no LaTeX Error, fatal stop, emergency stop, undefined citation, undefined reference, overfull warning, or rerun-label warning;
- rendered and visually checked pages 7--10, covering setup, main table, significance table, convergence curves, boxplot, and representative trajectories;
- static scans of manuscript source, tables, captions, `main.aux`, and `main.bbl` found no disallowed legacy-comparison wording, excluded algorithm names, internal scene numbering, CEC/RRT wording, or overclaiming phrases;
- no MATLAB algorithm implementation code or raw experimental data files were edited.

## 2026-06-27 AJSE Chinese draft scaffold

Scope:

- created `routes/route_b_cvf_ae/paper_ajse_zh/` as a Chinese LaTeX draft scaffold for the AJSE-first UAV engineering narrative;
- created `main.tex`, split section files, table placeholders, `bib/`, `figures/`, and `notes/`;
- recorded confirmed user decisions in `notes/todo_questions.md`;
- recorded writing strategy in `notes/writing_plan.md`;
- recorded AJSE/Springer official requirement checks in `notes/ajse_requirements.md`;
- copied 25 indexed PNG figures and 4 available PDF figures into `figures/`;
- generated `notes/figure_asset_manifest.csv`;
- confirmed `evaluatePath.m` does not exist and mapped evaluation to `fitnessFAEAE.m`;
- confirmed code has 3D A* reference-path generation but no RRT/RRT* formal comparison implementation;
- did not write full manuscript body and did not rerun any formal UAV experiments.

Verification:

- `.tex` static scan found no local absolute path, internal scene-number label, forbidden statistical-test wording, or CEC mention;
- local LaTeX compile was not run because no `xelatex`, `lualatex`, `pdflatex`, or `bibtex` command was available in this environment.

## 2026-06-29 Paper table conversion

Scope:

- converted the formal paper CSV tables into LaTeX tables under `routes/route_b_cvf_ae/paper_ajse_zh/tables/`;
- replaced placeholder tables for main comparison, ablation, significance, runtime overhead, and parameter sensitivity;
- added `longtable` to `main.tex` for multipage result tables;
- updated `notes/source_mapping.md` and `notes/quality_check.md`.

Sources:

- `paper_table_main_compact.csv`
- `paper_table_ablation.csv`
- `paper_table_main_significance.csv`
- `paper_table_overhead.csv`
- `paper_table_parameter_sensitivity.csv`

Verification:

- table files were scanned for mojibake, TODO placeholders, local absolute paths, internal scene-number labels, and forbidden statistical-test wording;
- no formal UAV experiments were rerun.

Follow-up adjustment:

- `table_parameters.tex` was compressed from the full per-scene parameter table into a main-text summary table with one row per key parameter;
- the complete parameter sensitivity details remain in `paper_table_parameter_sensitivity.csv` for supplementary use or audit.
- `table_significance.tex` was compressed into a win/tie/loss summary with key exceptions;
- `table_runtime.tex` was compressed into a compact CVF-AE overhead summary;
- complete p-values, effect sizes, and per-algorithm overhead records remain in the formal CSV files.
- runtime presentation was revised again to avoid direct comparison of absolute runtimes across different batches; the main-text table now emphasizes evaluation counts, CVF trigger scale, and same-batch ablation ratios.

## 2026-06-29 Chinese draft Sections 3 and 4

Scope:

- drafted Section 3, `问题建模`, in the AJSE Chinese LaTeX manuscript;
- drafted Section 4, `CVF-AE 方法`, in the AJSE Chinese LaTeX manuscript;
- grounded the formulation in the implemented B-spline control-point encoding, objective terms, constraint violation terms, Deb feasibility rule, CVF field construction, sparse trigger, local candidate acceptance, repair boundary, and complexity accounting;
- did not add fabricated citations and did not rerun any optimization experiments.

Verification:

- scanned the two section files for TODO placeholders, local absolute paths, internal scene-number labels, forbidden statistical-test wording, CEC mentions, and overclaiming phrases;
- no matches were found in the two drafted section files;
- compiled the Chinese draft with `xelatex -interaction=nonstopmode -halt-on-error main.tex` twice and generated `main.pdf`;
- the final log scan found no LaTeX errors, fatal stops, emergency stops, or undefined references;
- remaining warnings are limited to table layout overfull/underfull messages and the currently empty bibliography.

Follow-up formula audit:

- completed the mathematical definitions for the implemented objective terms: segment length, wind-alignment energy, risk exposure, second-difference smoothness, height preference, and horizontal boundary margin penalty;
- corrected the constraint-violation exposition so obstacle and no-fly-zone violations are stated as sampled-point entry counts, matching `fitnessFAEAE.m`;
- added explicit turning-angle and altitude-violation formulas;
- completed the CVF derivation from low-density sampled-path pressure to nearest-control-point averaging, vectorized field step, component clipping, strength scaling, norm clipping, quality step, elite anchoring, and per-generation sparse trigger quota;
- reran `xelatex` twice after the formula audit; the final log scan again found no LaTeX errors or undefined references;
- no optimization experiments were rerun.

## 2026-06-29 Chinese draft Section 5

Scope:

- drafted Section 5, `实验设计`, in the AJSE Chinese LaTeX manuscript;
- covered the confirmed hardware/software environment, three paper scenes, core public optimization parameters, evaluation metrics, comparison algorithms, ablation variants, and statistical testing protocol;
- used the final formal statistical protocol: two-sided Wilcoxon rank-sum / Mann-Whitney U tests, Holm correction, Kruskal-Wallis omnibus tests, and Cliff's delta;
- added `sec:results-discussion` label to the results section for forward reference;
- did not rerun any optimization experiments and did not add new result claims.

Verification:

- scanned the Section 5 file for TODO placeholders, local absolute paths, internal scene-number labels, forbidden statistical-test wording, CEC mentions, overclaiming phrases, and RRT references;
- scanned all manuscript `.tex` files for local absolute paths, internal scene-number labels, forbidden statistical-test wording, CEC mentions, overclaiming phrases, and RRT references;
- no matches were found for those forbidden patterns;
- compiled the Chinese draft with `xelatex -interaction=nonstopmode -halt-on-error main.tex` twice and generated `main.pdf`;
- the final log scan found no LaTeX errors, fatal stops, emergency stops, citation warnings, or undefined references;
- remaining warnings are table/layout warnings and the currently empty bibliography.

## 2026-06-29 Chinese draft Section 6

Scope:

- drafted Section 6, `结果与讨论`, in the AJSE Chinese LaTeX manuscript;
- interpreted the main comparison, nonparametric significance summary, ablation table, runtime/evaluation overhead table, parameter sensitivity table, and trajectory sanity signals;
- kept the conclusion bounded: CVF-AE is described as having balanced engineering performance rather than per-scene scalar-fitness dominance;
- explicitly noted the Scene 2 scalar-fitness losses to CPO and MSCSO, and the Scene 3 GDSAO scalar-fitness mean edge with high boundary-hugging risk;
- did not rerun any optimization experiments and did not add new result tables.

Verification:

- removed the Section 6 TODO placeholders;
- scanned all manuscript `.tex` files for local absolute paths, internal scene-number labels, forbidden statistical-test wording, CEC mentions, RRT references, and overclaiming phrases;
- no matches were found for those forbidden patterns;
- compiled the Chinese draft with `xelatex -interaction=nonstopmode -halt-on-error main.tex` twice and generated `main.pdf`;
- the final log scan found no LaTeX errors, fatal stops, emergency stops, citation warnings, undefined references, or rerun-label warnings;
- remaining warnings are table/layout warnings and the currently empty bibliography.

## 2026-06-29 Main-text figure insertion

Scope:

- inserted the main-text figures that had already been copied into the Chinese LaTeX project;
- added the CVF-AE method flowchart to Section 4;
- added strong-algorithm boxplots, three convergence curves, three extended top-view representative path figures, the Scene 2 ablation top-view figure, and the parameter sensitivity figure to Section 6;
- added Chinese captions and local explanatory paragraphs tied to the existing result discussion;
- did not create or rerun any experiments.

Verification:

- checked every new `\includegraphics` target against `paper_ajse_zh/figures/`;
- all referenced figure files exist;
- scanned all manuscript `.tex` files for local absolute paths, internal scene-number labels, forbidden statistical-test wording, CEC mentions, RRT references, and overclaiming phrases;
- no matches were found for those forbidden patterns;
- compiled the Chinese draft with `xelatex -interaction=nonstopmode -halt-on-error main.tex` twice and generated `main.pdf`;
- the final log scan found no LaTeX errors, fatal stops, emergency stops, missing-figure errors, citation warnings, undefined references, or rerun-label warnings;
- remaining warnings are table/layout warnings and the currently empty bibliography.

Follow-up 3D figure insertion:

- added a three-panel 3D representative trajectory figure for Scene 1, Scene 2, and Scene 3 using:
  - `extended_scene1_representative_3d.png`
  - `extended_scene2_representative_3d.png`
  - `extended_scene3_representative_3d.png`
- revised the trajectory discussion so the 3D and top-view figures are interpreted as complementary evidence;
- checked all referenced figure files exist under `paper_ajse_zh/figures/`;
- reran `xelatex` twice; the final log scan found no LaTeX errors, missing figures, undefined references, or rerun-label warnings.

Follow-up ablation 3D figure insertion:

- added `ablation_scene3_representative_3d.png` as a main-text ablation figure;
- kept the existing Scene 2 ablation top-view figure and added Scene 3 3D evidence to cover height and spatial feasibility effects;
- checked all referenced figure files exist under `paper_ajse_zh/figures/`;
- reran `xelatex` twice; the final log scan found no LaTeX errors, missing figures, undefined references, or rerun-label warnings.

## 2026-06-25 Target journal research

Scope:

- inspect the current CVF-AE mechanism, formal UAV evidence, paper outline,
  and failed generic CEC Stage B gate;
- verify the three required journals: `Cluster Computing`, `Evolving Systems`,
  and `Journal of Systems Science and Systems Engineering`;
- screen ten additional SCIE candidates;
- separate publisher first-decision metrics from article-history
  submission-to-acceptance time;
- enforce the non-mandatory-APC requirement.

Added:

- `routes/route_b_cvf_ae/docs/CVF_AE_TARGET_JOURNAL_RESEARCH.md`
- `routes/route_b_cvf_ae/docs/CVF_AE_JOURNAL_SHORTLIST.md`

Evidence date:

- 2026-06-25.

Important indexing note:

- the Chinese Academy of Sciences released the 2025 journal partition table
  on 2025-03-20 and announced that it would stop updating the table from 2026;
- this research therefore uses the 2025 partition as the final available
  official edition;
- subscription-only CAS subcategories and JCR quartiles remain marked for
  final verification through the university databases.

Review-time findings:

- `Cluster Computing`: official first decision 25 days, but 10 recent article
  histories give a submission-to-acceptance median of about 355 days;
- `Evolving Systems`: official first decision 7 days, but the 10-article median
  is about 403 days;
- `Journal of Systems Science and Systems Engineering`: official first
  decision 14 days, but the 10-article median is about 345 days;
- publisher first-decision values must not be described as full peer-review
  duration.

Recommendation:

1. `Arabian Journal for Science and Engineering`
2. `International Journal of Aeronautical and Space Sciences`
3. `International Journal of Control, Automation and Systems`
4. `Evolving Systems`
5. `Journal of Systems Science and Systems Engineering`
6. fallback: `The Journal of Supercomputing`

Required-journal decisions:

- `Cluster Computing`: conditional C / not recommended as an early target
  because the paper lacks a cluster/cloud/distributed-computing contribution,
  the 2025 publication volume is about 1006 Crossref records, and sampled
  acceptance time is slow;
- `Evolving Systems`: B, strong topic fit but slow sampled acceptance;
- `Journal of Systems Science and Systems Engineering`: B, genuine precedent
  for improved metaheuristics and engineering applications, but low volume and
  slow sampled acceptance.

Hard exclusions:

- `Journal of Intelligent & Robotic Systems`: converted to fully open access
  in September 2024, so the mandatory APC route violates the task requirement;
- `Soft Computing`: publisher first-decision median is 275 days and its
  current JCR/MJL status presents an unacceptable indexing-risk signal.

Writing strategy:

- use the UAV engineering-application narrative;
- do not present CVF-AE as a validated generic constrained optimizer while the
  CEC2017 constrained Stage B gate remains failed;
- add a real map/DEM case and explicit path-executability metrics before the
  first submission.

## 2026-06-24 CEC constrained benchmark selection and precheck

Scope:

- preserve all frozen UAV parameters and formal results;
- select a genuine general constrained benchmark;
- build an independent framework instead of re-labeling the existing
  bound-constrained `cec2017_framework`;
- stop before Stage C/formal execution if the generic CVF mechanism gate fails.

### Selection

Selected:

- CEC2017 constrained single-objective real-parameter optimization;
- 28 functions;
- official dimensions 10D and 100D;
- 20 independent runs;
- `10000 * D` FEs;
- equality tolerance `1e-4`.

Selection report:

- `routes/route_b_cvf_ae/docs/CVF_AE_CEC_BENCHMARK_SELECTION.md`

Source identity:

- the competition and technical report are IEEE CEC materials;
- the downloaded September 2024 MATLAB package is from the benchmark-author-
  maintained `P-N-Suganthan/CEC2017` repository;
- it is not described as an IEEE official code repository.

Source archive SHA-256:

- `5188E0C57A221BEC82C7326B0E22CF1524C997E59D5291A04FF309C9F609D8DD`

### Independent framework

Created:

- `cec2017_constrained_framework/`

Key design:

- author source retained unmodified under `third_party`;
- counted objective/constraint adapter;
- official violation and separate normalized CVF pressure;
- common uniform initialization, boundary projection, Deb rules, and FE budget;
- generic population-difference CVF with no UAV geometry or reference
  initialization;
- AE, CVF-AE, CVF-AE-w/o-CVF, DE, and PSO;
- resumable one-run MAT records and CSV summaries.

### Stage A

MATLAB tests:

- 6 passed / 0 failed.

Coverage:

- all 28 function interfaces;
- C01 known reference point;
- equality tolerance;
- FE accounting and over-budget rejection;
- C18/C27 vectorized correction consistency;
- fixed-seed reproducibility.

MATLAB Code Analyzer:

- new framework code passed;
- the adapter reports one expected warning for the author package's required
  `global initial_flag`.

### Stage B, first implementation

Result:

- `cec2017_constrained_framework/results/stage_b_precheck`

Protocol:

- functions `[1,3,6,14,18]`;
- 10D;
- 3 runs;
- population 20;
- 3000 FEs;
- 5 algorithms.

Outcome:

- CVF reduced violation on C03 and C06;
- CVF worsened C14 and C18;
- gate not passed.

### Stage B, conservative revision

Changes:

- trigger only Deb-ranked infeasible candidates;
- reduce trigger quota from 10% to 5%;
- apply the field increment to the already constructed AE candidate;
- retain all original functions, seeds, and budgets.

Result:

- `cec2017_constrained_framework/results/stage_b_precheck_v2`

CVF-AE versus AE:

- C01: better feasible objective;
- C03: tie in violation;
- C06: worse violation;
- C14: worse violation;
- C18: worse violation;
- total: 1 win / 1 tie / 3 losses.

Accounting:

- all 75 runs completed;
- every run used exactly 3000 FEs;
- CVF extra FEs: `602 / 45000 = 1.34%`;
- CVF local successes: 297;
- feasible CVF-AE runs: 3/15, equal to AE.

### Gate decision

Stage B failed. Do not run Stage C or formal CEC experiments with the current
generic CVF.

Reason:

- population differences do not provide a sufficiently reliable constraint
  direction for equality manifolds and narrow mixed feasible regions;
- local CVF candidate success does not translate into net algorithm-level
  benefit under the same total FE budget.

Formal readiness:

- source and framework: ready;
- interface/accounting: ready;
- generic CVF mechanism: not ready;
- full CEC run: blocked by the documented Stage B gate.

Next technically defensible step:

- design a counted low-dimensional constraint probe or finite-difference field;
- charge all probes to FEs;
- rerun the same fixed Stage B protocol before considering Stage C.

## 2026-06-18 Small Gate Handoff Execution

Scope:

- Route: Route B / CVF-AE.
- Algorithm name: `CVF-AE = Constraint Viability Field guided Alpha Evolution`.
- Stop boundary: complete the small-scale gate and decide whether to enter the medium gate; do not run the medium gate.

### Phase 1: Mechanism Derivation

Added:

- `routes/route_b_cvf_ae/docs/CVF_MECHANISM_DERIVATION.md`

The derivation defines:

- control-point and sampled-path notation;
- sampled point to nearest interior control-point mapping;
- obstacle, no-fly-zone, wind-risk, altitude, curvature, and boundary field directions;
- field normalization and step clipping;
- state-adaptive `alpha_s`, `beta_s`, and `gamma_s` weights;
- CVF-AE candidate generation from AE and CVF directions;
- Deb-better acceptance for the CVF candidate and the population update;
- low-overhead complexity bounds and gate interpretation.

### Phase 2: Minimal Code Implementation

Added:

- `buildConstraintViabilityField.m`
- `applyOperator_CVF_AE.m`
- `optimizer_CVF_AE_uav.m`
- `run_cvf_ae_gate_diagnostics.m`

Updated:

- `getUAVAlgorithmConfig.m`
- `run_single_uav_algorithm_case.m`

Implementation notes:

- The prototype reuses `fitnessFAEAE`, `defaultParams`, `createMap`, `init_COVE_AE`, `identifyConstraintState`, `repairPath`, `debBetter`, `boundSolution`, `decodeSolution`, and `bsplinePath`.
- `CVF-AE` first evaluates the ordinary AE offspring.
- For sparse selected individuals, it builds a bounded CVF candidate and spends at most one additional fitness evaluation.
- The CVF candidate replaces the AE offspring only when it is Deb-better.
- New metrics include `viabilityFieldCount`, `viabilityFieldSuccessCount`, `viabilityFieldNormHistory`, `viabilityFieldTypeHistory`, `cvfOperatorHistory`, `nEvals`, runtime, first feasible iteration, and repair counts.

Verification:

- MATLAB Code Analyzer passed for the new CVF files.
- Analyzer reported only existing-style `datestr/now` informational notes in the new runner.
- A smoke run passed and wrote CSV, MAT, run records, and a decision markdown file. The temporary smoke result directory was removed after verification.

### Phase 3: Small-Scale Gate

Result directory:

- `routes/route_b_cvf_ae/results/cvf_ae_gate_20260618_084956`

Configuration:

- scenes: `[2, 4]`
- algorithms: `Base-AE`, `CVF-AE`, `CVF-AE-w/o-CVF`, `CVF-AE-w/o-Init`
- `nRuns = 5`
- `popSize = 20`
- `maxIter = 80`
- `baseSeed = 20260618`

Key aggregate results:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanCVFCount | MeanCVFSuccess |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | Base-AE | 0.20 | 2661.47 | 12.20 | 0.900 | 1620.0 | NaN | NaN | 0.0 | 0.0 |
| 2 | CVF-AE | 1.00 | 343.90 | 0.00 | 2.047 | 2133.4 | 19.6 | 113.4 | 400.0 | 262.4 |
| 2 | CVF-AE-w/o-CVF | 1.00 | 323.54 | 0.00 | 1.189 | 1703.6 | 16.2 | 83.6 | 0.0 | 0.0 |
| 2 | CVF-AE-w/o-Init | 0.60 | 1077.80 | 4.60 | 1.745 | 2047.4 | 37.0 | 27.4 | 400.0 | 257.4 |
| 4 | Base-AE | 0.00 | 1899.18 | 9.20 | 0.879 | 1620.0 | NaN | NaN | 0.0 | 0.0 |
| 4 | CVF-AE | 1.00 | 393.88 | 0.00 | 1.821 | 2059.4 | 0.0 | 39.4 | 400.0 | 173.2 |
| 4 | CVF-AE-w/o-CVF | 1.00 | 400.58 | 0.00 | 1.009 | 1650.2 | 0.0 | 30.2 | 0.0 | 0.0 |
| 4 | CVF-AE-w/o-Init | 0.00 | 1865.61 | 9.20 | 1.959 | 2094.0 | NaN | 74.0 | 400.0 | 266.8 |

Average rank:

| Algorithm | AverageRank |
|---|---:|
| CVF-AE | 1.5 |
| CVF-AE-w/o-CVF | 1.5 |
| CVF-AE-w/o-Init | 3.0 |
| Base-AE | 4.0 |

### Decision

Do not enter the medium gate yet.

Rationale:

- `CVF-AE` improves Scene 4 mean best fitness over `CVF-AE-w/o-CVF` (`393.88` vs `400.58`), with the same feasibility rate and first feasible iteration.
- `CVF-AE` is worse than `CVF-AE-w/o-CVF` on Scene 2 mean best fitness (`343.90` vs `323.54`) and first feasible iteration (`19.6` vs `16.2`).
- The CVF mechanism adds bounded but nontrivial overhead: evaluation ratios are about `1.25x`, while runtime ratios are about `1.72x` on Scene 2 and `1.80x` on Scene 4.
- Full `CVF-AE` and `CVF-AE-w/o-CVF` tie on average rank, so the current CVF field is not yet strong enough to justify medium validation.
- `CVF-AE-w/o-Init` is weak on Scene 4, confirming that initialization remains important, but that does not establish the CVF field contribution.

Next recommended work, if Route B continues:

- Reduce CVF trigger count or cache field components to lower runtime overhead.
- Rebalance CVF strength so Scene 2 does not lose quality or first feasible iteration relative to `w/o-CVF`.
- Re-run the same small gate only after the mechanism changes; do not proceed directly to medium gate from this result.

## 2026-06-18 Conservative CVF Revision Loop

Goal:

- Reduce the CVF runtime/evaluation overhead observed in the first small gate.
- Prevent CVF from degrading Scene 2 quality after feasibility formation.
- Re-run the same small gate only; do not run the medium gate in this step.

### Mechanism Changes

Updated:

- `optimizer_CVF_AE_uav.m`
- `buildConstraintViabilityField.m`
- `applyOperator_CVF_AE.m`

Changes:

- Reduced the per-iteration CVF trigger budget from `25%` to `12%` of the population.
- Reduced the CVF step strength and clipping bounds:
  - `strength: 0.85 -> 0.65`
  - `maxStepRatio: 0.055 -> 0.040`
  - `maxNormRatio: 0.12 -> 0.085`
- Reduced state-adaptive CVF fusion weights:
  - formation `beta_s: 1.00 -> 0.55`
  - preservation `beta_s: 0.70 -> 0.45`
  - refinement `beta_s: 0.25 -> 0.12`
  - recovery `beta_s: 0.55 -> 0.35`
- Restricted formation-state CVF to near-feasible candidates instead of all rank-eligible candidates.
- Reduced the near-feasible threshold from `V <= 25` to `V <= 15`.
- Added a stricter CVF candidate acceptance rule:
  - CVF candidate must be Deb-better than the AE candidate;
  - and its total fitness must not be worse than the AE candidate.

### Iteration Notes

- First conservative run reduced CVF count from about `400` to `160` per run and lowered overhead, but Scene 2 remained worse than `w/o-CVF`.
- A near-feasible-only trigger reduced some unnecessary CVF activity but still did not give a stable enough result.
- The strict acceptance rule produced the best balance in this loop and was kept as the current Route B prototype.

Intermediate temporary result folders were removed after review. The final retained result folder is:

- `routes/route_b_cvf_ae/results/cvf_ae_gate_strict_accept_20260618_085923`

### Final Small-Gate Recheck

Configuration:

- scenes: `[2, 4]`
- algorithms: `Base-AE`, `CVF-AE`, `CVF-AE-w/o-CVF`, `CVF-AE-w/o-Init`
- `nRuns = 5`
- `popSize = 20`
- `maxIter = 80`
- `baseSeed = 20260618`

Key aggregate results:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanCVFCount | MeanCVFSuccess |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | Base-AE | 0.20 | 2661.47 | 12.20 | 0.851 | 1620.0 | NaN | NaN | 0.0 | 0.0 |
| 2 | CVF-AE | 1.00 | 331.60 | 0.00 | 1.469 | 1859.6 | 15.8 | 97.4 | 142.2 | 104.0 |
| 2 | CVF-AE-w/o-CVF | 1.00 | 323.54 | 0.00 | 1.155 | 1703.6 | 16.2 | 83.6 | 0.0 | 0.0 |
| 2 | CVF-AE-w/o-Init | 0.60 | 755.57 | 2.00 | 1.131 | 1730.8 | 41.67 | 31.0 | 79.8 | 61.0 |
| 4 | Base-AE | 0.00 | 1899.18 | 9.20 | 0.869 | 1620.0 | NaN | NaN | 0.0 | 0.0 |
| 4 | CVF-AE | 1.00 | 385.78 | 0.00 | 1.332 | 1814.0 | 0.0 | 34.0 | 160.0 | 80.8 |
| 4 | CVF-AE-w/o-CVF | 1.00 | 400.58 | 0.00 | 1.005 | 1650.2 | 0.0 | 30.2 | 0.0 | 0.0 |
| 4 | CVF-AE-w/o-Init | 0.20 | 1466.28 | 6.80 | 1.396 | 1804.4 | 51.0 | 76.0 | 108.4 | 90.8 |

Average rank:

| Algorithm | AverageRank |
|---|---:|
| CVF-AE | 1.5 |
| CVF-AE-w/o-CVF | 1.5 |
| CVF-AE-w/o-Init | 3.0 |
| Base-AE | 4.0 |

### Decision After Revision

The revised prototype is now acceptable for a medium-gate check, but the medium gate has not been run.

Rationale:

- CVF overhead is now controlled:
  - Scene 2 evaluation ratio vs `w/o-CVF`: `1.092`
  - Scene 2 runtime ratio vs `w/o-CVF`: `1.271`
  - Scene 4 evaluation ratio vs `w/o-CVF`: `1.099`
  - Scene 4 runtime ratio vs `w/o-CVF`: `1.325`
- Scene 4 shows a clear mean-fitness improvement from CVF:
  - `CVF-AE`: `385.78`
  - `CVF-AE-w/o-CVF`: `400.58`
- Scene 2 still has a small mean-fitness disadvantage:
  - `CVF-AE`: `331.60`
  - `CVF-AE-w/o-CVF`: `323.54`
  - but first feasible iteration is slightly better for full CVF-AE (`15.8` vs `16.2`) and feasibility is tied.
- `CVF-AE-w/o-Init` remains weak, especially on Scene 4, confirming that initialization is still necessary.

Recommended next action:

- Run the medium gate exactly once with the planned medium configuration.
- Treat the medium gate as a risk check, not as a guaranteed pass: if `w/o-CVF` dominates full `CVF-AE` across Scene 2 and Scene 4, stop and redesign the field again rather than proceeding to formal ablation.

## 2026-06-18 Medium Gate Validation

Goal:

- Run one medium-gate validation after the strict-accept small gate.
- Stop after deciding whether the current `CVF-AE` prototype is ready for formal experiments.
- Do not run formal ablation, main comparison, parameter sensitivity, or CEC.

Implementation updates before running:

- Added `CVF-AE-w/o-StateAdaptiveCVF` to the Route B gate runner.
  - This variant keeps initialization, CVF, and sparse preservation.
  - It replaces the state-adaptive CVF state with a static preservation state.
- Added `CVF-AE-w/o-SparsePreservation`.
  - This variant keeps initialization and CVF.
  - It disables sparse repair / preservation.
- Added medium-gate decision mode to `run_cvf_ae_gate_diagnostics.m`.

Verification:

- MATLAB Code Analyzer passed for `optimizer_CVF_AE_uav.m`.
- MATLAB Code Analyzer passed for `run_cvf_ae_gate_diagnostics.m` except existing-style informational `datestr/now` notes.
- A short medium-gate smoke run passed for all six algorithm names. The smoke result directory was removed.

Execution note:

- The first MATLAB MCP call timed out after writing partial run records.
- The same result directory was resumed with `resumeExisting = true` through `matlab -batch`, completing all run records.

Result directory:

- `routes/route_b_cvf_ae/results/cvf_ae_medium_gate_20260618_090607`

Configuration:

- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- `nRuns = 10`
- `popSize = 30`
- `maxIter = 150`
- `baseSeed = 20260621`

Average rank:

| Algorithm | AverageRank |
|---|---:|
| CVF-AE | 1.67 |
| CVF-AE-w/o-StateAdaptiveCVF | 2.33 |
| CVF-AE-w/o-CVF | 2.33 |
| CVF-AE-w/o-SparsePreservation | 3.67 |
| CVF-AE-w/o-Init | 5.00 |
| Base-AE | 6.00 |

Key aggregate results:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanFinalViolation | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanCVFCount | MeanCVFSuccess |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | Base-AE | 0.30 | 1068.50 | 3.00 | 2.345 | 4530.0 | NaN | NaN | 0.0 | 0.0 |
| 1 | CVF-AE-w/o-Init | 1.00 | 322.47 | 0.00 | 3.939 | 5323.7 | 18.7 | 213.5 | 580.2 | 416.2 |
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 1.00 | 301.78 | 0.00 | 4.073 | 5390.0 | 1.7 | 260.0 | 600.0 | 572.9 |
| 1 | CVF-AE-w/o-SparsePreservation | 1.00 | 307.71 | 0.00 | 3.333 | 5119.4 | 6.4 | 0.0 | 589.4 | 497.5 |
| 1 | CVF-AE-w/o-CVF | 1.00 | 306.07 | 0.00 | 3.122 | 4758.4 | 6.6 | 228.4 | 0.0 | 0.0 |
| 1 | CVF-AE | 1.00 | 306.62 | 0.00 | 6.214 | 5360.0 | 0.9 | 230.4 | 599.6 | 505.3 |
| 2 | Base-AE | 0.00 | 2481.90 | 12.40 | 4.238 | 4530.0 | NaN | NaN | 0.0 | 0.0 |
| 2 | CVF-AE-w/o-Init | 0.90 | 489.35 | 1.00 | 7.816 | 5076.3 | 46.0 | 133.8 | 412.5 | 291.0 |
| 2 | CVF-AE-w/o-StateAdaptiveCVF | 0.90 | 470.08 | 0.80 | 8.806 | 5197.9 | 34.67 | 204.6 | 463.3 | 347.9 |
| 2 | CVF-AE-w/o-SparsePreservation | 1.00 | 332.87 | 0.00 | 7.485 | 5083.9 | 26.2 | 0.0 | 553.9 | 422.3 |
| 2 | CVF-AE-w/o-CVF | 1.00 | 328.93 | 0.00 | 6.068 | 4698.7 | 35.1 | 168.7 | 0.0 | 0.0 |
| 2 | CVF-AE | 1.00 | 321.17 | 0.00 | 9.056 | 5261.5 | 28.0 | 201.0 | 530.5 | 398.2 |
| 4 | Base-AE | 0.00 | 1789.60 | 8.10 | 3.087 | 4530.0 | NaN | NaN | 0.0 | 0.0 |
| 4 | CVF-AE-w/o-Init | 0.50 | 771.68 | 2.40 | 6.391 | 5217.8 | 95.6 | 186.3 | 501.5 | 412.7 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 1.00 | 384.36 | 0.00 | 6.786 | 5197.7 | 0.0 | 67.7 | 600.0 | 259.6 |
| 4 | CVF-AE-w/o-SparsePreservation | 1.00 | 392.61 | 0.00 | 6.369 | 5130.0 | 0.0 | 0.0 | 600.0 | 303.0 |
| 4 | CVF-AE-w/o-CVF | 1.00 | 388.39 | 0.00 | 3.580 | 4615.5 | 0.0 | 85.5 | 0.0 | 0.0 |
| 4 | CVF-AE | 1.00 | 367.28 | 0.00 | 6.018 | 5224.6 | 0.0 | 94.6 | 600.0 | 296.0 |

### Medium-Gate Decision

Do not enter formal experiments yet.

Rationale:

- Positive evidence:
  - Full `CVF-AE` has the best average rank (`1.67`).
  - Full `CVF-AE` beats `CVF-AE-w/o-CVF` on Scene 2 and Scene 4 mean best fitness.
  - Full `CVF-AE` beats `CVF-AE-w/o-StateAdaptiveCVF` on Scene 2 and Scene 4 mean best fitness.
  - Full `CVF-AE` reaches full feasibility on all scenes.
- Remaining risks:
  - Scene 1 is not supportive: `w/o-StateAdaptiveCVF`, `w/o-CVF`, and `w/o-SparsePreservation` all have better mean fitness than full `CVF-AE`.
  - Runtime overhead is still too high for a low-overhead claim:
    - Scene 1 full vs `w/o-CVF` runtime ratio is about `1.99`.
    - Scene 2 full vs `w/o-CVF` runtime ratio is about `1.49`.
    - Scene 4 full vs `w/o-CVF` runtime ratio is about `1.68`.
  - CVF triggers are near the per-run cap (`~600`) in many medium runs, so the sparse-field design is not yet sparse enough at medium scale.

Recommended next action:

- Do not proceed to formal ablation/main comparison from this medium-gate result.
- Keep the full `CVF-AE` mechanism direction, because Scene 2/4 support exists.
- Before any formal experiment, reduce medium-scale CVF trigger frequency and runtime overhead, especially after feasibility is already established and in Scene 1-like easier states.

## 2026-06-18 CVF Sparse Trigger 2.0

Goal:

- Keep the Scene 2/4 benefit of CVF.
- Reduce medium-scale CVF trigger count and runtime overhead.
- Avoid unnecessary CVF intervention after feasible solutions have already formed.

Mechanism changes:

- Replaced the single CVF per-iteration trigger budget with state-specific budgets:
  - formation: `10%` of population;
  - preservation: `6%` of population;
  - refinement: `2%` of population;
  - recovery: `8%` of population.
- Added a post-feasible budget cap:
  - once the best solution is feasible, CVF is capped at `3%` of population per iteration.
- Added post-feasible throttling:
  - after feasibility is established, CVF can trigger only every `3` iterations.
- Added refinement throttling:
  - quality-refinement CVF can trigger only every `5` iterations.
- Added constraint-pressure gating:
  - CVF is used only for near-feasible infeasible candidates, high mean violation before feasibility, or low population feasibility after the first feasible solution.
- Feasible individuals in already stable populations no longer receive CVF.

Verification:

- MATLAB Code Analyzer passed for `optimizer_CVF_AE_uav.m`.
- `run_cvf_ae_gate_diagnostics.m` retained only existing-style informational `datestr/now` notes.
- A short six-algorithm smoke run passed and was removed.

Result directory:

- `routes/route_b_cvf_ae/results/cvf_ae_medium_gate_sparse2_20260618_095112`

Configuration:

- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- `nRuns = 10`
- `popSize = 30`
- `maxIter = 150`
- `baseSeed = 20260622`

Average rank:

| Algorithm | AverageRank |
|---|---:|
| CVF-AE | 1.67 |
| CVF-AE-w/o-SparsePreservation | 2.67 |
| CVF-AE-w/o-CVF | 2.67 |
| CVF-AE-w/o-StateAdaptiveCVF | 3.00 |
| CVF-AE-w/o-Init | 5.00 |
| Base-AE | 6.00 |

Key aggregate results:

| Scene | Algorithm | FeasibleRate | MeanBestFitness | MeanRuntime | MeanNEvals | MeanFirstFeasibleIter | MeanRepairCount | MeanCVFCount | MeanCVFSuccess |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | CVF-AE-w/o-StateAdaptiveCVF | 1.00 | 302.51 | 4.696 | 4809.3 | 1.7 | 259.1 | 20.2 | 19.1 |
| 1 | CVF-AE-w/o-SparsePreservation | 1.00 | 308.59 | 3.878 | 4590.6 | 4.0 | 0.0 | 60.6 | 52.3 |
| 1 | CVF-AE-w/o-CVF | 1.00 | 306.89 | 3.806 | 4763.2 | 4.0 | 233.2 | 0.0 | 0.0 |
| 1 | CVF-AE | 1.00 | 306.92 | 3.575 | 4811.5 | 0.9 | 229.1 | 52.4 | 43.2 |
| 2 | CVF-AE-w/o-SparsePreservation | 1.00 | 329.03 | 2.985 | 4616.3 | 28.1 | 0.0 | 86.3 | 70.6 |
| 2 | CVF-AE-w/o-CVF | 1.00 | 329.68 | 3.397 | 4697.1 | 36.8 | 167.1 | 0.0 | 0.0 |
| 2 | CVF-AE | 1.00 | 322.14 | 3.774 | 4817.7 | 30.1 | 197.1 | 90.6 | 71.0 |
| 4 | CVF-AE-w/o-StateAdaptiveCVF | 1.00 | 387.45 | 3.232 | 4628.3 | 0.0 | 64.1 | 34.2 | 21.9 |
| 4 | CVF-AE-w/o-SparsePreservation | 1.00 | 379.96 | 2.879 | 4568.0 | 0.0 | 0.0 | 38.0 | 25.5 |
| 4 | CVF-AE-w/o-CVF | 1.00 | 382.54 | 3.180 | 4616.6 | 0.0 | 86.6 | 0.0 | 0.0 |
| 4 | CVF-AE | 1.00 | 365.31 | 3.338 | 4665.5 | 0.0 | 91.7 | 43.8 | 29.4 |

### Sparse 2.0 Decision

The sparse trigger adjustment passed the medium gate.

Rationale:

- CVF trigger count dropped sharply:
  - Scene 1 full `CVF-AE`: `52.4`
  - Scene 2 full `CVF-AE`: `90.6`
  - Scene 4 full `CVF-AE`: `43.8`
  - Previous medium gate had full `CVF-AE` near `600` in all scenes.
- Runtime overhead is now controlled:
  - Scene 1 full runtime is slightly lower than `w/o-CVF` in this run (`3.575` vs `3.806`).
  - Scene 2 full vs `w/o-CVF` runtime ratio is about `1.11`.
  - Scene 4 full vs `w/o-CVF` runtime ratio is about `1.05`.
- Scene 2 and Scene 4 still support the CVF mechanism:
  - Scene 2 mean fitness: full `322.14` vs `w/o-CVF` `329.68`.
  - Scene 4 mean fitness: full `365.31` vs `w/o-CVF` `382.54`.
- Full `CVF-AE` keeps the best average rank (`1.67`).

Remaining caveat:

- Scene 1 still favors `w/o-StateAdaptiveCVF` by mean best fitness (`302.51` vs full `306.92`), so formal experiments should track whether the state-adaptive CVF schedule is mainly beneficial in harder constrained scenes rather than easy scenes.

Recommended next action:

- It is now reasonable to proceed to formal ablation planning.
- Do not change the map or restore Scene 3.
- Before running formal ablation, freeze the Sparse 2.0 CVF defaults and document that the CVF contribution is expected to matter most in Scene 2/4-style constrained environments.

## 2026-06-18 Sparse 2.0 Freeze And Formal Ablation Runner

Goal:

- Freeze Sparse 2.0 defaults before formal ablation.
- Add a stable formal ablation runner with resume support.
- Do not change the algorithm parameters during formal ablation.

Added:

- `routes/route_b_cvf_ae/docs/CVF_AE_SPARSE2_DEFAULTS.md`
- `run_cvf_ae_formal_ablation.m`

Frozen formal ablation configuration:

- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- default `nRuns = 30`
- default `popSize = 30`
- default `maxIter = 300`
- default `baseSeed = 20260623`

Runner notes:

- `run_cvf_ae_formal_ablation.m` delegates to `run_cvf_ae_gate_diagnostics.m`.
- It preserves per-run `run_records`.
- It supports `resumeExisting = true`.
- It writes an additional `CVF_AE_FORMAL_ABLATION_README.md` into the result folder.
- The existing summary CSV/MAT outputs remain the primary analysis artifacts.

Formal ablation must report runtime, `nEvals`, repair count, and CVF count in addition to fitness and feasibility.

## 2026-06-18 Formal Ablation Completed

Result folder:

- `routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_20260618_102649`

Configuration:

- scenes: `[1, 2, 4]`
- algorithms: `Base-AE`, `CVF-AE-w/o-Init`, `CVF-AE-w/o-StateAdaptiveCVF`, `CVF-AE-w/o-SparsePreservation`, `CVF-AE-w/o-CVF`, `CVF-AE`
- runs: `30` per algorithm per scene
- population size: `30`
- max iterations: `300`
- base seed: `20260623`

Completion:

- completed runs: `540 / 540`
- saved summary CSV, run CSV, average-rank CSV, decision markdown, and formal interpretation markdown
- preserved per-run `.mat` records under the ignored `run_records/` directory
- left the large `cvf_ae_gate_summary_workspace.mat` as a local generated artifact rather than a versioned text result

Average rank:

| Algorithm | Average rank |
|---|---:|
| `CVF-AE` | 1.67 |
| `CVF-AE-w/o-CVF` | 2.00 |
| `CVF-AE-w/o-StateAdaptiveCVF` | 3.00 |
| `CVF-AE-w/o-SparsePreservation` | 3.67 |
| `CVF-AE-w/o-Init` | 4.67 |
| `Base-AE` | 6.00 |

Interpretation:

- Full `CVF-AE` has the best aggregate rank and reaches `100%` feasible rate on Scenes 1, 2, and 4.
- `Base-AE` remains inadequate under stronger constraints, with `0%` feasible rate on Scenes 2 and 4.
- CVF-guided sparse preservation is supported: full `CVF-AE` is better than `CVF-AE-w/o-SparsePreservation` on all three scenes.
- Initialization remains important, especially on Scene 4 where `CVF-AE-w/o-Init` falls to `66.67%` feasible rate.
- The direct CVF field contribution is scene-dependent: full `CVF-AE` beats `w/o-CVF` on Scenes 1 and 4, while `w/o-CVF` has better mean fitness on Scene 2.

Decision:

- Proceed beyond formal ablation to main comparison planning.
- Keep Sparse 2.0 defaults frozen for the next stage.
- Do not change Scene 4, restore Scene 3, or introduce Route A comparisons.
- The manuscript claim should be conservative: CVF-AE improves aggregate feasibility/search quality with strongest evidence in harder constrained scenes, but CVF guidance should not be described as a monotonic win on every scene.

## 2026-06-22 主对比方案与 baseline 接入

目标：

- 冻结当前 `CVF-AE` 配置后进入主对比准备；
- 主对比适当包含经典算法、高被引算法、近年来算法和变体算法；
- 保证复现算法不是占位实现，而是具有完整更新机制、统一评价接口和统一统计输出。

新增方案文档：

- `routes/route_b_cvf_ae/docs/CVF_AE_MAIN_COMPARISON_PROTOCOL.md`

主排名组：

- `CVF-AE`
- `AE`
- `PSO`
- `GWO`
- `WOA`
- `HHO`
- `DBO`
- `CPO`

工程参考组暂不混入主排名：

- `A*`
- `RRT*`

实现动作：

- 新增 `optimizer_DBO_uav.m`
- 新增 `optimizer_CPO_uav.m`
- 扩展 `getUAVAlgorithmConfig.m`
- 扩展 `run_single_uav_algorithm_case.m`
- 扩展 `run_uav_comparison_lite_v2_batch.m`
- 新增 Route B 专用入口 `run_cvf_ae_main_comparison.m`

执行原则：

- 主对比不继续调整 `CVF-AE` 参数；
- 不恢复 code Scene 3；
- 不修改 Scene 4；
- CEC 暂作为后续可选补充，不进入当前主线。

预检执行：

- smoke: `run_cvf_ae_main_comparison('smoke')`，接口通过；
- precheck: `run_cvf_ae_main_comparison('precheck')`；
- result folder: `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_precheck_20260622_101130`；
- completed runs: `72 / 72`。

预检平均排名：

| Algorithm | Average rank |
|---|---:|
| `CVF-AE` | 1.33 |
| `CPO` | 2.00 |
| `DBO` | 3.00 |
| `GWO` | 5.00 |
| `WOA` | 5.00 |
| `HHO` | 6.00 |
| `PSO` | 6.33 |
| `AE` | 7.33 |

预检判断：

- 主对比预检通过，可以进入正式主对比；
- `CPO` 在 Scene 2 表现很强，正式实验需要重点观察；
- `DBO` 在 Scene 4 是强竞争 baseline；
- 当前结果只用于链路验证，不作为论文正式结论；
- 不因预检继续调整 `CVF-AE` 参数。

## 2026-06-22 正式主对比断点续跑机制

目标：

- 正式主对比运行时间较长，必须避免中断后从头开始；
- 每个 `(scene, algorithm, run)` 都应有独立断点记录；
- 重新运行时自动加载已完成 run，只补算缺失 run。

实现：

- `run_uav_comparison_lite_v2_batch.m` 在每个 run 前检查 `run_records/*.mat`；
- 当 `cfg.resumeExisting = true` 且记录存在时，直接加载 `result` 并参与汇总；
- 当记录不存在时，才调用对应 optimizer；
- `run_cvf_ae_main_comparison.m` 新增 `resume-formal` 模式；
- `resume-formal` 会自动寻找最新的 `cvf_ae_main_comparison_formal_*` 目录继续运行。

正式主对比命令：

```matlab
run_cvf_ae_main_comparison('formal')
```

中断续跑命令：

```matlab
run_cvf_ae_main_comparison('resume-formal')
```

## 2026-06-22 正式主对比完成

结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_20260622_103121`

配置：

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- runs: `30` per algorithm per scene
- population size: `30`
- max iterations: `300`
- base seed: `20260624`

完成情况：

- completed runs: `720 / 720`
- 每个 run 已保存到 `run_records/`
- 已保存 `uav_comparison_runs.csv`
- 已保存 `uav_comparison_summary_long.csv`
- 已保存 `uav_comparison_average_rank.csv`
- 已新增中文解释文档 `CVF_AE_MAIN_COMPARISON_INTERPRETATION.md`

平均排名：

| Algorithm | Average rank |
|---|---:|
| `CVF-AE` | 1.67 |
| `CPO` | 1.67 |
| `DBO` | 3.00 |
| `GWO` | 3.67 |
| `HHO` | 5.33 |
| `PSO` | 5.67 |
| `WOA` | 7.00 |
| `AE` | 8.00 |

分场景判断：

- Scene 1: `CPO` rank 1，`CVF-AE` rank 2；
- Scene 2: `CPO` rank 1，`CVF-AE` rank 2；
- Scene 4: `CVF-AE` rank 1，`DBO` rank 2，`CPO` rank 3；
- `CVF-AE` 在三场景均达到 `100%` feasible rate；
- `CPO` 是当前最强外部 baseline，必须在论文中正面讨论。

阶段判断：

- 正式主对比完成；
- `CVF-AE` 与 `CPO` 并列平均排名第一，主方法仍成立；
- 不能声称 `CVF-AE` 全面击败所有近年算法；
- 后续应进入统计检验、表格生成、收敛曲线、箱线图和路径可视化阶段；
- 不建议为了超过 `CPO` 继续调参。

## 2026-06-22 轨迹合理性审查

动机：

- 主对比不能只看 `fitness`、`feasible rate` 和平均排名；
- 对低空 UAV 路径规划而言，高空绕行和贴边绕行即使数值可行，也可能不符合任务语义；
- 用户明确提出需要检查轨迹图，避免“完全从高空或者边上绕行”的结果被误判为有效优势。

新增脚本：

- `analyze_cvf_ae_trajectory_sanity.m`

输出文件：

- `trajectory_sanity_runs.csv`
- `trajectory_sanity_summary.csv`
- `trajectory_sanity_flags.csv`
- `CVF_AE_TRAJECTORY_SANITY_INTERPRETATION.md`

关键发现：

- `CVF-AE` 没有明显高空绕行：
  - Scene 1 `MeanZ = 14.95`
  - Scene 2 `MeanZ = 15.96`
  - Scene 4 `MeanZ = 15.40`
- `CPO` 在 Scene 1/2 存在明显高空绕行风险：
  - Scene 1 `MeanZ = 26.12`
  - Scene 2 `MeanZ = 33.41`
  - Scene 2 `VeryHighAltitudeFrac = 0.76`
- `DBO/GWO` 在 Scene 4 存在明显贴边绕行倾向；
- 图像抽查显示 Scene 2 的 `CPO` 最佳轨迹抬高越障，Scene 4 的 `CPO` 最佳轨迹沿地图边界绕行。

结论修正：

- `CVF-AE` 与 `CPO` 数值平均排名并列第一；
- 但 `CPO` 的优势伴随高空绕行语义风险；
- `CVF-AE` 更符合低空巡航轨迹叙事；
- 后续论文应增加轨迹合理性表和代表性轨迹图；
- 不建议为了压过 `CPO` 继续调参。
## 2026-06-22 Scene 2-v2 中等难度场景调整与小规模验证

动机：
- 原 Scene 2 的轨迹图显示，多种算法容易靠近边缘、高空越障或绕开主通道；
- 这会让 Scene 2 更像“过紧约束场景”，不适合作为 Scene 1 和 Scene 4 之间的中等难度场景；
- 因此本轮不优先修改 Scene 4，而是先把 Scene 2 调整为中等约束走廊。

代码调整：
- `createMap.m`
  - Scene 2 从 dense obstacle scene 调整为 medium constrained corridor scene；
  - 建筑数量从 13 个降为 10 个；
  - 第一排建筑由 5 个改为 4 个，并扩大间距；
  - NFZ 从 3 个降为 2 个；
  - wind hotspots 从 4 个降为 3 个。
- `applyUAVSceneOverrides.m`
  - 单独为 Scene 2 设置高度范围 `[8, 32]`；
  - `heightRef` 和 `refCruiseZ` 设置为 `16`；
  - `params.weights.H` 设置为 `1.05`。

验证配置：
- scene: `2`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- runs: `5`
- population size: `20`
- max iterations: `80`
- base seed: `20260625`

结果目录：
- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_scene2_v2_sanity_20260622_130924`

关键结果：
- `CVF-AE`
  - feasible rate: `1.00`
  - mean best fitness: `303.26`
  - mean Z: `16.09`
  - mean high-altitude fraction: `0.00`
  - visual review flag rate: `0.00`
- `CPO`
  - feasible rate: `1.00`
  - mean best fitness: `296.27`
  - mean Z: `26.86`
  - mean high-altitude fraction: `0.74`
  - visual review flag rate: `0.80`
- `GWO` 和 `DBO` 在该场景仍有较明显贴边倾向；
- `WOA`, `PSO`, `HHO`, `AE` 的可行率或轨迹合理性仍不稳定。

轨迹判断：
- 新版 Scene 2 不再系统性迫使所有算法采用高空或边界绕行；
- `CVF-AE` 的最佳轨迹更接近低空通道搜索；
- `CPO` 的数值优势仍然存在，但主要伴随高空越障倾向；
- `GWO/DBO` 的贴边倾向能被轨迹 sanity 指标识别。

阶段判断：
- 保留 Scene 2-v2 作为新的中等难度场景；
- 不建议继续为了让 `CVF-AE` 在 Scene 2 数值 fitness 上超过 `CPO` 而调参；
- 下一步应冻结 Scene 2-v2，使用断点续跑机制重新执行正式主对比，并在论文叙事中同时报告 fitness、feasible rate 和轨迹合理性指标。
## 2026-06-22 Scene 2-v2 正式主对比与合并结果

执行策略：
- 冻结 Scene 2-v2；
- 只对 Scene 2-v2 重新运行正式主对比；
- Scene 1 和 Scene 4 沿用旧正式主对比结果；
- 原因是本轮只修改了 Scene 2，其他两个场景的地图与参数未变。

Scene 2-v2 正式结果目录：
- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_scene2_v2_formal_20260622_152052`

Scene 2-v2 配置：
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260624`
- resume: enabled

完成情况：
- run records: `240 / 240`
- 已生成 `uav_comparison_runs.csv`
- 已生成 `uav_comparison_summary_long.csv`
- 已生成 `uav_comparison_average_rank.csv`
- 已生成 `trajectory_sanity_runs.csv`
- 已生成 `trajectory_sanity_summary.csv`
- 已生成 `trajectory_sanity_flags.csv`
- 已生成最佳轨迹图到本地 `best_path_figures_exact/`

Scene 2-v2 raw fitness 排名：
- `CPO`: rank 1, mean fitness `278.94`, feasible rate `1.00`
- `CVF-AE`: rank 2, mean fitness `302.75`, feasible rate `1.00`
- `DBO`: rank 3, mean fitness `337.29`, feasible rate `1.00`
- `GWO`: rank 4, mean fitness `342.91`, feasible rate `1.00`

Scene 2-v2 轨迹 sanity 关键指标：
- `CVF-AE`
  - MeanZ: `15.99`
  - MeanHighAltitudeFrac: `0.00`
  - VisualReviewFlagRate: `0.00`
- `CPO`
  - MeanZ: `28.22`
  - MeanHighAltitudeFrac: `0.88`
  - VisualReviewFlagRate: `1.00`

解释：
- `CPO` 是强 baseline，应该保留在主表；
- 但 `CPO` 在 Scene 2-v2 的数值优势伴随明显 high-altitude bypass risk；
- `CVF-AE` 的优势应表述为更符合 low-altitude mission-consistent trajectory quality，而不是单纯宣称 raw fitness 全面最优。

合并结果目录：
- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_scene2_v2_merged_20260622_155500`

合并规则：
- Scene 1: 沿用 `cvf_ae_main_comparison_formal_20260622_103121`
- Scene 2: 使用 `cvf_ae_main_comparison_scene2_v2_formal_20260622_152052`
- Scene 4: 沿用 `cvf_ae_main_comparison_formal_20260622_103121`

合并后的平均排名：
- `CPO`: `1.67`
- `CVF-AE`: `1.67`
- `DBO`: `3.00`
- `GWO`: `3.67`
- `HHO`: `5.33`
- `PSO`: `5.67`
- `WOA`: `7.00`
- `AE`: `8.00`

阶段判断：
- Scene 2-v2 正式主对比完成；
- 合并后的主结果仍支持 `CVF-AE` 与 `CPO` 并列第一；
- 后续论文结果部分应采用合并结果目录作为主结果源；
- 不建议继续调整 Scene 2 或继续为了压过 `CPO` 做针对性调参。
## 2026-06-22 CVF-AE 正式消融实验

实验目的：
- 验证 CVF-AE 各机制对 fitness、feasibility、CVF 使用情况和轨迹合理性的贡献；
- 重点检查 `CVF`、constraint-aware initialization、state-adaptive CVF weighting 和 sparse preservation 是否都有稳定正贡献。

结果目录：
- `routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_scene2_v2_20260622_163919`

配置：
- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260626`
- resume: enabled

完成情况：
- run records: `540 / 540`
- 已生成 `cvf_ae_gate_runs.csv`
- 已生成 `cvf_ae_gate_summary.csv`
- 已生成 `cvf_ae_gate_average_rank.csv`
- 已生成 `trajectory_sanity_runs.csv`
- 已生成 `trajectory_sanity_summary.csv`
- 已生成 `trajectory_sanity_flags.csv`
- 已新增中文解释文件 `CVF_AE_FORMAL_ABLATION_INTERPRETATION.md`

执行备注：
- 第一次长 batch 在写入 `cvf_ae_gate_summary_workspace.mat` 时出现技术错误：`Unable to write file ... because it appears to be corrupt`；
- 该错误发生在 540 个 run records 和 CSV 汇总已写出之后；
- 删除 0 字节损坏 MAT 文件并用 `resumeExisting=true` 重新构建汇总后，runner 正常完成；
- 该错误不影响 run records、CSV 和本次结果判断。

平均排名：
- `CVF-AE-w/o-StateAdaptiveCVF`: `1.67`
- `CVF-AE`: `2.00`
- `CVF-AE-w/o-CVF`: `3.00`
- `CVF-AE-w/o-SparsePreservation`: `3.33`
- `CVF-AE-w/o-Init`: `5.00`
- `Base-AE`: `6.00`

关键发现：
- Constraint-aware initialization 是必要机制：
  - `w/o-Init` 在 Scene 4 可行率降至 `0.67`，mean fitness 从 full `CVF-AE` 的 `349.34` 恶化到 `587.23`。
- CVF 在强约束 Scene 4 中有正贡献：
  - full `CVF-AE`: `349.34`
  - `w/o-CVF`: `355.41`
- Sparse preservation 有必要保留：
  - `w/o-SparsePreservation` 在 Scene 4 为 `369.71`，且 trajectory visual risk 更高。
- `StateAdaptiveCVF` 当前不是稳定正贡献：
  - `w/o-StateAdaptiveCVF` 在 Scene 1 和 Scene 2-v2 的 scalar fitness 均优于 full；
  - 平均排名 `w/o-StateAdaptiveCVF = 1.67`，full `CVF-AE = 2.00`；
  - 论文中不应把 state-adaptive weighting 作为核心创新强讲。

轨迹 sanity：
- full `CVF-AE` 三个场景均无 high-altitude bypass；
- Scene 4 中 full `CVF-AE` 的 `VisualReviewFlagRate = 0.27`，低于 `w/o-StateAdaptiveCVF = 0.50` 和 `w/o-SparsePreservation = 0.53`；
- 这支持“完整版本在强约束场景中更稳定”的叙事。

阶段判断：
- 正式消融实验完成；
- 结果支持 initialization、CVF、sparse preservation 的必要性；
- 结果不支持把 state-adaptive weighting 写成全场景稳定增益；
- 下一步建议做统计检验，并考虑对 `StateAdaptiveCVF` 做小规模机制修正或在论文中弱化该模块。

## 2026-06-22 保守状态自适应 CVF 机制修正

目标：

- 针对正式消融中 `CVF-AE-w/o-StateAdaptiveCVF` 反超完整 `CVF-AE` 的问题，检查 `StateAdaptiveCVF` 是否可以通过保守化调整获得稳定正贡献；
- 不继续扩大正式实验规模，先做小规模机制验证；
- 技术性报错和命令仍保留英文，工作记录使用中文。

代码调整：

- 在 `optimizer_CVF_AE_uav.m` 中新增保守状态自适应记忆与状态判定；
- 在 `applyOperator_CVF_AE.m` 中降低 conservative state 下的 CVF 权重；
- 在 `run_cvf_ae_gate_diagnostics.m` 和 `getUAVAlgorithmConfig.m` 中新增 `CVF-AE-SA-lite`；
- 小规模验证通过后，已将保守状态自适应策略提升为默认 `CVF-AE` 配置；
- `CVF-AE-w/o-StateAdaptiveCVF` 保持为静态 CVF 消融入口。

小规模验证：

- 结果目录：`routes/route_b_cvf_ae/results/cvf_ae_sa_lite_validation_20260622_193237`
- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE-SA-lite`, `CVF-AE-w/o-StateAdaptiveCVF`, old `CVF-AE`
- runs: `10`
- population size: `30`
- max iterations: `300`
- base seed: `20260627`

结果：

- 平均排名：
  - `CVF-AE-SA-lite`: `1.00`
  - `CVF-AE-w/o-StateAdaptiveCVF`: `2.33`
  - old `CVF-AE`: `2.67`
- 三个场景中 `CVF-AE-SA-lite` feasible rate 均为 `1.00`；
- `CVF-AE-SA-lite` 未出现 high-altitude bypass；
- Scene 4 中 `CVF-AE-SA-lite` 的 trajectory sanity 风险低于静态 CVF，但略高于旧 full CVF-AE，因此后续正式结果仍需保留轨迹图人工 sanity check。

判断：

- 保守状态自适应策略可以作为新的默认 `CVF-AE` 实现；
- 旧版激进状态自适应不再作为论文主方法；
- 后续正式主对比和正式消融需要基于新的默认 `CVF-AE` 重新生成，不能直接沿用旧版完整 `CVF-AE` 的最终表格；
- 下一阶段建议先重跑正式消融，再视结果决定是否重跑正式主对比的全部场景或只重跑 `CVF-AE` 行。

## 2026-06-22 保守状态自适应 CVF 正式消融重跑

目标：

- 使用新的默认 `CVF-AE` 重新跑正式消融；
- 验证保守状态自适应 CVF、CVF 本体、约束感知初始化和稀疏保留是否均有正贡献；
- 同步生成 trajectory sanity，避免只看 scalar fitness。

结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_conservative_20260622_194947`

配置：

- scenes: `[1, 2, 4]`
- algorithms:
  - `Base-AE`
  - `CVF-AE-w/o-Init`
  - `CVF-AE-w/o-StateAdaptiveCVF`
  - `CVF-AE-w/o-SparsePreservation`
  - `CVF-AE-w/o-CVF`
  - `CVF-AE`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260629`
- resume: enabled

执行情况：

- run records: `540 / 540`
- 已生成正式消融 summary、average rank、decision 和 trajectory sanity；
- 第一次前台 batch 因工具 2 小时超时中断在 Scene 4 附近，随后使用同一结果目录和 `resumeExisting=true` 续跑完成；
- 中断前已保存的 run records 被成功复用，最终结果完整。

平均排名：

- `CVF-AE`: `1.00`
- `CVF-AE-w/o-StateAdaptiveCVF`: `2.33`
- `CVF-AE-w/o-CVF`: `3.00`
- `CVF-AE-w/o-SparsePreservation`: `3.67`
- `CVF-AE-w/o-Init`: `5.00`
- `Base-AE`: `6.00`

关键结论：

- 新默认 `CVF-AE` 在 Scene 1、Scene 2-v2、Scene 4 均优于 `CVF-AE-w/o-StateAdaptiveCVF`，说明保守状态自适应 CVF 已经从诊断阶段的负/不稳定贡献调整为稳定正贡献；
- 新默认 `CVF-AE` 在三个场景中均优于 `CVF-AE-w/o-CVF`，说明 CVF 本体保留为核心机制是合理的；
- `w/o-Init` 在 Scene 4 feasible rate 降至 `0.70`，说明约束感知初始化仍是强约束场景必要模块；
- `w/o-SparsePreservation` 在三个场景中均弱于完整方法，Scene 4 的 trajectory risk 也更高，说明稀疏保留应继续保留。

轨迹 sanity：

- 完整 `CVF-AE` 三个场景 feasible rate 均为 `1.00`；
- 完整 `CVF-AE` 三个场景 mean high-altitude fraction 均为 `0`；
- Scene 1 和 Scene 2-v2 的 `VisualReviewFlagRate = 0`；
- Scene 4 的 `VisualReviewFlagRate = 0.20`，低于 `w/o-CVF = 0.30`、`w/o-StateAdaptiveCVF = 0.533`、`w/o-SparsePreservation = 0.60`。

阶段判断：

- 保守状态自适应正式消融通过；
- 本目录应作为论文正式消融结果来源；
- 下一步应基于新的默认 `CVF-AE` 处理正式主对比结果，优先级高于继续调参。

## 2026-06-23 保守状态自适应 CVF 正式主对比重跑

目标：

- 基于新的默认 `CVF-AE` 重新跑正式主对比；
- 全量重跑 baseline 和 `CVF-AE`，避免不同 seed 或不同实现版本混合造成解释成本；
- 同步生成 trajectory sanity，用于识别 high-altitude bypass 和 boundary-hugging 风险。

结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`

配置：

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `AE`, `PSO`, `GWO`, `WOA`, `HHO`, `DBO`, `CPO`
- runs: `30`
- population size: `30`
- max iterations: `300`
- base seed: `20260630`
- resume: enabled

执行情况：

- run records: `720 / 720`
- 已生成主对比 summary、average rank 和 trajectory sanity；
- 执行中个别 baseline run 出现长时间无新 run record 且 MATLAB CPU 基本不增长的停滞；
- 已通过同一结果目录和 `resumeExisting=true` 断点续跑完成；
- 已完成的 run records 均被成功复用。

平均排名：

- `CVF-AE`: `1.33`
- `CPO`: `2.00`
- `DBO`: `2.67`
- `GWO`: `4.00`
- `HHO`: `5.33`
- `PSO`: `5.67`
- `WOA`: `7.00`
- `AE`: `8.00`

分场景判断：

- Scene 1：`CVF-AE` raw fitness rank 1，`CPO` rank 2；
- Scene 2-v2：`CPO` raw fitness rank 1，`CVF-AE` rank 2；
- Scene 4：`CVF-AE` raw fitness rank 1，`DBO` rank 2，`CPO` rank 3。

轨迹 sanity：

- `CVF-AE` 在 Scene 1 和 Scene 2-v2 的 `VisualReviewFlagRate = 0`；
- `CVF-AE` 在 Scene 4 的 `VisualReviewFlagRate = 0.20`；
- `CVF-AE` 三个场景 feasible rate 均为 `1.00`；
- `CPO` 在 Scene 2-v2 的 raw fitness 最优，但 mean high-altitude fraction 为 `0.882`，`VisualReviewFlagRate = 1.00`；
- `CPO` 在 Scene 1 也存在明显 high-altitude bypass 风险，mean high-altitude fraction 为 `0.663`，`VisualReviewFlagRate = 0.80`；
- 因此主表中可以保留 `CPO`，但论文解释必须配套 trajectory sanity，不能把 `CPO` 的低 scalar fitness 解释为低空任务一致性更优。

阶段判断：

- 保守状态自适应默认 `CVF-AE` 的正式主对比通过；
- 本目录应作为论文正式主对比结果来源；
- 下一步建议生成论文主表、主对比轨迹图和 trajectory sanity 辅助表。

## 2026-06-23 冻结主方法版本说明

阶段目标：

- 冻结路线 B 当前默认主方法，避免后续参数敏感性实验演变成反复调参；
- 明确后续实验只验证鲁棒性，除非出现全面、稳定、显著优于默认版本的参数设置，否则不再反向修改主方法。

新增文档：

- `routes/route_b_cvf_ae/docs/CVF_AE_CONSERVATIVE_FREEZE_NOTE.md`

冻结结论：

- 当前默认主方法为 `CVF-AE = Constraint Viability Field guided Alpha Evolution`；
- 默认实现为“保守状态自适应 CVF 调度版本的 CVF-AE”；
- 保留约束感知初始化、保守状态自适应 CVF 调度和稀疏可行性保持；
- 旧版激进状态自适应结果只作为诊断历史，不作为论文正式主方法。

冻结依据：

- 正式消融目录：`routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_conservative_20260622_194947`；
- 正式主对比目录：`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`；
- 正式消融中完整 `CVF-AE` 平均排名 `1.00`；
- 正式主对比中完整 `CVF-AE` 平均排名 `1.33`；
- `CVF-AE` 三个正式主对比场景 feasible rate 均为 `1.00`，且 Scene 1 / Scene 2-v2 轨迹 sanity 无人工复核风险。

后续边界：

- 参数敏感性只用于验证默认参数鲁棒性；
- 默认参数不要求每项第一，但应处于稳定前列；
- 只有参数变体在关键场景中全面、稳定、显著优于默认，并且不增加明显开销或轨迹 sanity 风险，才考虑重新打开主方法冻结；
- 不继续为了压过 Scene 2-v2 中 `CPO` 的 raw fitness 而修改主方法。

## 2026-06-23 运行开销分析

阶段目标：

- 复用现有正式主对比和正式消融结果，生成 `runtime`、`nEvals`、`viabilityFieldCount`、`viabilityFieldSuccessCount` 及相对 `w/o-CVF` 的开销比例；
- 支撑“低开销 CVF-AE”的论文表述；
- 不重跑任何优化实验。

新增脚本：

- `analyze_cvf_ae_runtime_overhead.m`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_runtime_overhead_analysis_20260623_from_existing_results`

输出文件：

- `main_comparison_overhead.csv`
- `ablation_overhead_vs_without_cvf.csv`
- `CVF_AE_RUNTIME_OVERHEAD_INTERPRETATION.md`

数据来源：

- 正式主对比：`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`
- 正式消融：`routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_conservative_20260622_194947`

关键结果：

- 正式消融中，完整 `CVF-AE` 相对 `CVF-AE-w/o-CVF` 的平均 runtime ratio 为 `0.976`；
- 正式消融中，完整 `CVF-AE` 相对 `CVF-AE-w/o-CVF` 的平均 `nEvals` ratio 为 `1.011`；
- 分场景 runtime ratio 范围为 `0.768` 到 `1.094`，不应写成稳定加速；
- 完整 `CVF-AE` 的平均 CVF 触发次数为 `39.5`，平均 CVF 成功次数为 `28.9`；
- 额外 `nEvals` 约为 `1.1%`，支持“低评价次数开销”和“稀疏 CVF 触发”的表述；
- 正式主对比中，`CVF-AE` 三个场景 feasible rate 均为 `1.00`，开销结论应与主对比性能、消融贡献和 trajectory sanity 一起解释。

写作边界：

- 可以写“低额外评价次数”和“受控运行时间开销”；
- 不应写“无开销”；
- 不应把 Scene 4 中 runtime ratio 小于 1 的结果解释成稳定加速，因为运行时间受 repair 次数、可行解形成速度和 MATLAB 运行波动影响。

## 2026-06-23 参数敏感性实验

阶段目标：

- 验证当前冻结的保守状态自适应 `CVF-AE` 对关键 CVF 参数是否鲁棒；
- 只做小范围参数敏感性，不进入反复调参；
- 判断是否存在全面、稳定、显著优于默认参数的替代设置。

新增脚本：

- `run_cvf_ae_param_sensitivity.m`
- `analyze_cvf_ae_param_sensitivity_sanity.m`

结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_param_sensitivity_conservative_20260623_131249`

配置：

- scenes: `[2, 4]`
- nRuns: `10`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260631`
- resumeExisting: `true`
- run records: `180 / 180`

参数组：

- `quota_scale`: `low / default / high`
- `step_strength`: `weak / default / strong`
- `state_switch_threshold`: `strict / default / loose`

关键结果：

- `quota_scale`
  - `high` 在 Scene 2-v2 和 Scene 4 的 mean best fitness 均略优于 `default`；
  - 但平均 `nEvals` 从 `9444.7` 增至 `9464.1`，平均 CVF 触发从 `47.5` 增至 `53.1`；
  - `low` 在两个场景均弱于 `default`，说明过低 CVF quota 会削弱强约束场景贡献。
- `step_strength`
  - 三档平均排名均为 `2.00`；
  - Scene 2-v2 中 `default` 最好，Scene 4 中 `weak` 最好；
  - 未形成稳定优于默认的方向。
- `state_switch_threshold`
  - `default` 平均排名 `1.50`，优于 `loose = 2.00` 和 `strict = 2.50`；
  - Scene 4 中 `default` 明显优于 `loose` 和 `strict`。

轨迹 sanity：

- 已生成：
  - `param_sensitivity_trajectory_sanity_runs.csv`
  - `param_sensitivity_trajectory_sanity_summary.csv`
  - `param_sensitivity_trajectory_sanity_flags.csv`
- Scene 2-v2 所有参数组和档位 `VisualReviewFlagRate = 0`；
- Scene 4 的 flagged runs 主要来自 boundary-hugging，不是 high-altitude bypass；
- `quota_scale = high` 在 Scene 4 的 `VisualReviewFlagRate = 0`，但其额外 CVF 触发和 `nEvals` 更高；
- `state_switch_threshold = default` 在 Scene 4 的 `VisualReviewFlagRate = 0.4`，后续代表轨迹图阶段需要继续人工筛选 median / best run。

阶段判断：

- 不修改当前主方法默认参数；
- 没有任何非默认参数同时在 fitness、`nEvals`、CVF 触发次数和 trajectory sanity 上全面、稳定、显著优于默认；
- 参数敏感性结论应写为“默认参数处于稳定前列，CVF-AE 对关键 CVF 参数具有鲁棒性”；
- 当前“保守状态自适应 CVF 调度版本的 CVF-AE”继续保持冻结。

## 2026-06-23 收敛曲线生成

阶段目标：

- 基于正式主对比结果生成论文用收敛曲线；
- 只复用已有 `run_records`，不重跑优化实验；
- 输出均值曲线和标准差阴影，用于支撑主对比收敛行为分析。

新增脚本：

- `make_cvf_ae_convergence_curves.m`

数据来源：

- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_convergence_curves_20260623_from_main_comparison`

配置：

- scenes: `[1, 2, 4]`
- algorithms: `CVF-AE`, `CPO`, `DBO`, `GWO`, `AE`, `PSO`, `HHO`
- primary algorithms with std shading: `CVF-AE`, `CPO`, `DBO`, `GWO`, `AE`
- source runs per scene / algorithm: `30`

输出文件：

- `cvf_ae_convergence_summary.csv`
- `cvf_ae_convergence_curves.csv`
- `CVF_AE_CONVERGENCE_INTERPRETATION.md`
- `scene1_convergence_mean_std.png`
- `scene2_convergence_mean_std.png`
- `scene4_convergence_mean_std.png`

关键结果：

- summary rows: `21`
- curve rows: `6300`
- Scene 1 最终均值：`CVF-AE = 298.1379`，`CPO = 298.3594`，`DBO = 344.8827`；
- Scene 2-v2 最终均值：`CPO = 278.1196`，`CVF-AE = 301.2018`，`DBO = 337.7867`；
- Scene 4 最终均值：`CVF-AE = 349.2270`，`DBO = 376.3041`，`CPO = 519.8797`；
- CVF-AE 在三个场景的 feasible rate 均为 `1.00`。

解释边界：

- 收敛曲线使用各 run 中由 Deb 可行性优先规则维护的 best-so-far fitness，可写为 feasible-aware best fitness；
- Scene 2-v2 中 `CPO` scalar fitness 最低，但必须结合正式主对比中的 trajectory sanity 一起解释，不能单独写成低空任务一致性更优；
- Scene 1 和 Scene 4 的曲线支持 `CVF-AE` 在强约束场景中具备稳定收敛和较低最终 fitness；
- 本阶段产物可作为论文主对比收敛曲线来源。

## 2026-06-23 近年非 AE 改进算法接入

阶段目标：

- 为扩展主对比补充近年非 AE 改进算法，而不是 AE-family 内部变体；
- 新增算法只使用统一 UAV 编码、统一 objective、统一边界投影和 Deb 可行性优先规则；
- 不使用 `CVF-AE` 的 CVF、repair、参考初始化或 sparse preservation 等主方法专属机制。

新增算法：

- `GDSAO`：source-aligned adaptation of Global Dynamic Evolution Snow Ablation Optimizer；
- `ERIME`：paper-based reimplementation of enhanced RIME；
- `MSCSO`：paper-based reimplementation of Modified Sand Cat Swarm Optimization。

新增脚本：

- `optimizer_GDESAO_uav.m`
- `optimizer_ERIME_uav.m`
- `optimizer_MSCSO_uav.m`

修改入口：

- `getUAVAlgorithmConfig.m`
- `run_single_uav_algorithm_case.m`
- `run_uav_comparison_lite_v2_batch.m`
- `run_cvf_ae_main_comparison.m`

新增 runner 模式：

- `recent-precheck`
- `recent-formal`
- `resume-recent-formal`

precheck：

- command: `run_cvf_ae_main_comparison('recent-precheck')`
- scenes: `[1, 2, 4]`
- algorithms: `GDSAO`, `ERIME`, `MSCSO`
- runs: `2`
- popSize: `12`
- maxIter: `20`
- run records: `18 / 18`

precheck 平均排名：

- `GDSAO`: `1.6667`
- `MSCSO`: `2.0000`
- `ERIME`: `2.3333`

阶段判断：

- 三个新增算法已通过接口和小规模运行验证；
- precheck 不作为论文性能结果，只说明算法能进入统一实验框架；
- 下一步应运行 `recent-formal`，再将新增算法结果与已冻结的正式主对比目录合并为扩展主表；
- Scene 4 中新增算法在小规模 precheck 已出现不可行 run，正式结果必须继续配套 trajectory sanity 和 feasible rate 解读。

## 2026-06-23 近年改进算法正式补充实验

阶段目标：

- 只补跑近年非 AE 改进算法 `GDSAO`、`ERIME`、`MSCSO`；
- 不重跑已冻结的 8 个正式主对比算法；
- 与正式主对比保持相同 scenes、runs、popSize、maxIter 和 UAV objective 口径；
- 运行后生成 trajectory sanity，并与原正式主对比合并为扩展主表。

新增辅助脚本：

- `run_cvf_ae_recent_improved_formal_chunk.m`
- `merge_cvf_ae_extended_main_comparison.m`

正式结果目录：

- `routes/route_b_cvf_ae/results/cvf_ae_main_comparison_recent_improved_formal_20260623_161229`

配置：

- scenes: `[1, 2, 4]`
- algorithms: `GDSAO`, `ERIME`, `MSCSO`
- runs: `30`
- popSize: `30`
- maxIter: `300`
- baseSeed: `20260701`
- run records: `270 / 270`

新增算法内部平均排名：

- `GDSAO`: `1.6667`
- `MSCSO`: `1.6667`
- `ERIME`: `2.6667`

新增算法分场景结果：

- Scene 1:
  - `MSCSO`: mean `314.3453`, feasible rate `1.00`
  - `GDSAO`: mean `315.7542`, feasible rate `1.00`
  - `ERIME`: mean `322.9893`, feasible rate `1.00`
- Scene 2-v2:
  - `MSCSO`: mean `291.1680`, feasible rate `1.00`
  - `GDSAO`: mean `307.0675`, feasible rate `1.00`
  - `ERIME`: mean `316.1932`, feasible rate `1.00`
- Scene 4:
  - `GDSAO`: mean `346.8474`, feasible rate `1.00`
  - `ERIME`: mean `360.2347`, feasible rate `1.00`
  - `MSCSO`: mean `402.2712`, feasible rate `0.9333`

trajectory sanity：

- 已生成：
  - `trajectory_sanity_runs.csv`
  - `trajectory_sanity_summary.csv`
  - `trajectory_sanity_flags.csv`
- flagged runs: `193 / 270`
- Scene 4:
  - `GDSAO` visual review flag rate `1.00`，主要来自 boundary-hugging；
  - `ERIME` visual review flag rate `0.9667`，主要来自 boundary-hugging；
  - `MSCSO` visual review flag rate `0.6667`，且 feasible rate 为 `0.9333`。

扩展主对比合并目录：

- `routes/route_b_cvf_ae/results/cvf_ae_extended_main_comparison_20260623_from_formal_and_recent`

扩展主对比平均排名：

- `CVF-AE`: `2.0000`
- `CPO`: `3.0000`
- `GDSAO`: `3.0000`
- `MSCSO`: `3.3333`
- `ERIME`: `4.3333`
- `DBO`: `5.3333`
- `GWO`: `7.0000`
- `HHO`: `8.3333`
- `PSO`: `8.6667`
- `WOA`: `10.0000`
- `AE`: `11.0000`

阶段判断：

- 加入近年改进算法后，`CVF-AE` 仍保持扩展平均排名第一；
- `GDSAO` 在 Scene 4 scalar fitness 略优于 `CVF-AE`，但 trajectory sanity 显示其边界贴靠风险极高，不能只按 scalar fitness 下结论；
- `MSCSO` 在 Scene 1 和 Scene 2-v2 scalar fitness 很强，但 Scene 4 feasible rate 降至 `0.9333` 且方差较大；
- 扩展主表应与 trajectory sanity 联合呈现，论文中不应写成“近年改进算法全面弱于 CVF-AE”，而应写成“CVF-AE 在扩展对比中保持最佳综合平均排名，并在强约束场景中具有更均衡的可行性与轨迹合理性”。

## 2026-06-23 代表轨迹图筛选与绘制

阶段目标：

- 固定代表 run 筛选规则，避免人工挑选轨迹；
- 同时生成主对比、扩展对比和消融实验的代表轨迹图；
- 输出 3D 和 top-view 两种视角，并保留代表 run 选择表。

新增脚本：

- `make_cvf_ae_representative_path_figures.m`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_representative_paths_20260623_from_formal_results`

数据来源：

- 正式主对比：`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_formal_conservative_20260623_091132`
- 近年改进算法补充：`routes/route_b_cvf_ae/results/cvf_ae_main_comparison_recent_improved_formal_20260623_161229`
- 正式消融：`routes/route_b_cvf_ae/results/cvf_ae_formal_ablation_conservative_20260622_194947`

筛选规则：

- 优先选择 feasible 且 `VisualReviewFlag = false` 的 run，并取 fitness 最接近 feasible 中位数者；
- 若无无复核风险 run，则选择 feasible run 中 fitness 最接近 feasible 中位数者；
- 若无 feasible run，则选择 violation 最小且 fitness 接近中位数者；
- 所有选择写入 `representative_run_selection_all.csv`。

图集：

- `main`: `CVF-AE`, `CPO`, `DBO`, `GWO`, `AE`
- `extended`: `CVF-AE`, `CPO`, `DBO`, `GDSAO`, `MSCSO`, `ERIME`
- `ablation`: `CVF-AE`, `w/o CVF`, `w/o StateCVF`, `w/o Sparse`, `w/o Init`, `Base-AE`

输出规模：

- 代表选择行数：`51`
- `feasible_clean_median`: `38`
- `feasible_flagged_median`: `9`
- `infeasible_min_violation_median`: `4`
- 每个图集每个场景输出 3D 和 top-view PNG，共 `18` 张 PNG。

人工检查：

- 已检查 `extended` Scene 4 的 3D / top-view 图，`GDSAO`、`CPO`、`DBO` 的 boundary-hugging 风险在图中可见；
- 已检查 `ablation` Scene 4 top-view 图，`Base-AE` 的不可行代表轨迹和消融变体差异可见；
- 这些图支持论文中“只看 scalar fitness 不足以判断路径合理性”的解释。

阶段判断：

- Stage 5 初版代表轨迹图已生成；
- 带有 `feasible_flagged_median` 或 `infeasible_min_violation_median` 的代表轨迹必须在论文图注或正文中明确说明其复核风险；
- 后续若要进入最终论文排版，可在当前 PNG 基础上进一步调整图例位置、线宽和是否拆分拥挤图。

## 2026-06-24 正式显著性检验

阶段目标：

- 基于已有正式逐次运行结果完成非参数显著性检验；
- 不重跑任何优化实验；
- 同时覆盖扩展主对比和正式消融；
- 对多重成对比较进行 Holm 校正，并报告效应量。

新增脚本：

- `analyze_cvf_ae_formal_significance.m`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_formal_significance_20260624_from_formal_results`

统计方案：

- 两批主对比和正式消融中，不同算法的随机种子均包含算法序号偏移，因此算法样本不是严格配对样本；
- 成对检验统一使用双侧 Wilcoxon rank-sum test（Mann-Whitney U），不使用 paired signed-rank test；
- 每个场景内对全部成对比较使用 Holm 校正；
- 同时输出跨所有场景比较的全局 Holm 校正结果；
- 使用 lower-is-better Cliff's delta 报告效应量，正值表示 `CVF-AE` 更优；
- 使用 Kruskal-Wallis 检验每个场景内全部算法分布是否存在总体差异。

扩展主对比结果：

- 三个场景的 Kruskal-Wallis 检验均显著，p 值范围为 `6.11e-43` 至 `1.64e-46`；
- 场景内 Holm 校正后，`CVF-AE` 对全部 10 个基线共得到 `21 胜 / 7 平 / 2 负`；
- Scene 1：`9 胜 / 1 平 / 0 负`，仅与 `CPO` 无显著差异；
- Scene 2：`6 胜 / 2 平 / 2 负`，显著弱于 `CPO` 和 `MSCSO`，与 `GDSAO`、`ERIME` 无显著差异；
- Scene 4：`6 胜 / 4 平 / 0 负`，对 `GDSAO`、`ERIME`、`MSCSO` 和 `CPO` 均无显著差异；
- 对原正式主对比 7 个算法为 `18 胜 / 2 平 / 1 负`；
- 对 3 个近年改进算法为 `3 胜 / 5 平 / 1 负`。

正式消融结果：

- 三个场景的 Kruskal-Wallis 检验均显著；
- 场景内 Holm 校正后，完整 `CVF-AE` 对 5 个消融版本共得到 `9 胜 / 6 平 / 0 负`；
- Scene 1：`4 胜 / 1 平 / 0 负`；
- Scene 2：`3 胜 / 2 平 / 0 负`；
- Scene 4：`2 胜 / 3 平 / 0 负`；
- 完整方法在任何场景均未显著弱于消融版本，但不能声称每个模块在每个场景都产生显著提升。

写作边界：

- 论文中应写为 Wilcoxon rank-sum / Mann-Whitney U test，而不是 paired Wilcoxon signed-rank test；
- 主结论使用场景内 Holm 校正 p 值，原始 p 值放入完整统计表或补充材料；
- Scene 2 中 `CPO` 和 `MSCSO` 的 scalar fitness 显著优于 `CVF-AE`，必须结合 trajectory sanity 与可行率讨论；
- Scene 4 中 `GDSAO` 的均值略优，但差异不显著，且存在高 boundary-hugging 风险；
- 消融显著性支持完整方法的综合有效性，但不支持“所有模块在所有场景均显著有效”的绝对表述。

## 2026-06-24 论文结果材料包与图表索引

阶段目标：

- 将已完成的主对比、显著性、消融、参数敏感性、开销和轨迹 sanity 结果统一整理成论文可用表格；
- 建立收敛曲线和代表轨迹图的正文/补充材料索引；
- 生成集中审阅用 Excel 工作簿；
- 不重跑任何优化实验。

新增脚本：

- `export_cvf_ae_paper_results_package.m`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_paper_results_package_20260624_from_formal_results`

输出内容：

- `CVF_AE_PAPER_RESULTS_PACKAGE.xlsx`
- `paper_table_main_compact.csv`
- `paper_table_main_extended_long.csv`
- `paper_table_main_significance.csv`
- `paper_table_ablation.csv`
- `paper_table_ablation_significance.csv`
- `paper_table_parameter_sensitivity.csv`
- `paper_table_overhead.csv`
- `paper_table_trajectory_sanity.csv`
- `paper_figure_index.csv`
- `CVF_AE_PAPER_RESULTS_PACKAGE_README.md`
- `CVF_AE_PAPER_RESULTS_WRITEUP_DRAFT.md`

整理规模：

- 扩展主对比：`33` 行，覆盖 `11` 个算法和 `3` 个正式场景；
- 正式消融：`18` 行，覆盖 `6` 个版本和 `3` 个正式场景；
- 图索引：`21` 张 PNG；
- 正文建议图：`8` 张；
- 补充材料建议图：`13` 张；
- Excel 工作簿：`10` 个 sheet，包括概览、正文主表、完整长表、显著性、消融、参数、开销、轨迹 sanity 和图索引。

正文材料建议：

- 主表优先使用 `paper_table_main_compact.csv`；
- 显著性正文报告场景内 Holm 校正后的 `+ / = / -`，完整 p 值和 Cliff's delta 放补充表；
- 消融正文使用 `paper_table_ablation.csv`，并结合消融显著性解释模块互补性；
- runtime 与 `NEvals` 单独成效率表，不将绝对 runtime 跨批次直接比较；
- 图索引建议正文放三场景收敛曲线、三场景扩展 top-view，以及 Scene 2/4 消融 top-view；
- 其余 3D 视图和经典基线轨迹放补充材料。

验证：

- MATLAB Code Analyzer 通过；
- CSV 行数、算法数、场景数和关键结论完成断言检查；
- Excel 共 `10` 个 sheet，全部完成渲染检查；
- Excel 公式错误扫描未发现 `#REF!`、`#DIV/0!`、`#VALUE!`、`#NAME?` 或 `#N/A`。

## 2026-06-24 参数图、箱线图与方法流程图

阶段目标：

- 补齐论文参数敏感性可视化；
- 补齐正式主对比运行分布箱线图；
- 绘制 CVF-AE 方法总体流程图；
- 更新论文结果包图索引和 Excel 工作簿；
- 不重跑任何优化实验。

新增脚本：

- `make_cvf_ae_paper_completion_figures.m`

输出目录：

- `routes/route_b_cvf_ae/results/cvf_ae_paper_completion_figures_20260624_from_formal_results`

输出图：

- `cvf_ae_parameter_sensitivity.png/.pdf`
  - 三个子图：CVF trigger quota、CVF step strength、state switching threshold；
  - 使用 Scene 2 和 Scene 4 的 mean best fitness ± std；
  - 虚线标记默认参数档位。
- `cvf_ae_boxplots_strong_algorithms.png/.pdf`
  - 算法：`CVF-AE`、`CPO`、`GDSAO`、`MSCSO`、`ERIME`、`DBO`；
  - 每算法每场景使用 `30` 次正式运行；
  - 建议正文使用。
- `cvf_ae_boxplots_all_algorithms_log.png/.pdf`
  - 覆盖扩展主对比全部 `11` 个算法；
  - 采用对数纵轴以容纳尺度差异；
  - 建议补充材料使用。
- `cvf_ae_method_flowchart.png/.pdf`
  - 展示约束感知初始化、状态识别、AE 候选、稀疏 CVF 分支、局部接受、稀疏 repair、Deb population acceptance 和迭代终止。

视觉检查：

- 参数图默认档位标记、误差棒和图例无重叠；
- 强算法箱线图算法颜色可区分，异常值可见；
- 全算法箱线图完整显示 `11` 个算法；
- 流程图分支、回环和终止路径无交叉遮挡，文本未溢出；
- PNG 和 vector PDF 均已输出。

图索引更新：

- 论文总图数从 `21` 更新为 `25`；
- 正文建议图从 `8` 更新为 `11`；
- 补充材料建议图从 `13` 更新为 `14`；
- `CVF_AE_PAPER_RESULTS_PACKAGE.xlsx` 的 Figure Index sheet 已同步更新；
- Excel 更新后公式错误扫描仍为零。

写作边界：

- 参数敏感性图用于支持默认参数处于稳定前列，不用于宣称默认值逐场景逐参数最优；
- Scene 4 的 CPO 箱体和离群点跨度较大，支持其稳定性和可行性风险解释；
- 箱线图仅呈现 scalar BestFitness 分布，仍需与 feasible rate 和 trajectory sanity 联合解释；
- 流程图中的 CVF 分支必须描述为稀疏触发，不是所有个体每代强制执行。

## 2026-06-24 论文场景编号统一

编号规则：

- 论文只使用 `Scene 1`、`Scene 2`、`Scene 3`；
- 内部实验代码仍使用 scene IDs `[1, 2, 4]`；
- `internal map ID 4 = paper Scene 3`；
- 内部未使用的 code Scene 3 不进入正式实验，也不出现在论文中。

执行边界：

- 不修改原始 run records、MAT 文件、地图生成逻辑或实验随机种子；
- 不把内部 source scene ID 4 直接写入论文表格、图题、文件名或正文；
- 所有论文导出通过 `cvfAePaperSceneId.m` 统一映射，避免各脚本重复硬编码。

已纳入映射的论文产物：

- 正式显著性检验及消融显著性；
- 论文结果 CSV 与 Excel；
- 收敛曲线及其 CSV；
- 参数敏感性图；
- 主对比箱线图；
- 代表轨迹图与选择表；
- 图索引与结果分析初稿。

## 2026-06-24 正式结果位置总索引

新增固定索引：

- `routes/route_b_cvf_ae/docs/CVF_AE_RESULTS_INDEX.md`

索引内容：

- 使用中文名称集中列出论文结果总包、主对比、显著性检验、消融、参数敏感性、运行开销、收敛曲线、代表轨迹和补充绘图的位置；
- 区分论文最终数据源与 precheck、gate 等开发过程目录；
- 列出各类结果的生成脚本；
- 规定后续正式结果更新时必须同步修改索引日期、目录、文件名和链接。

## 2026-06-29 中文初稿图表紧凑化与浮动控制

调整内容：

- 压缩中文初稿中的表 2、表 3、表 7 和表 8，删除表内长解释列和过长说明性 caption；
- 将场景设计目的、公共参数含义、运行开销解释和参数敏感性结论保留在正文段落中；
- 新增 `placeins` 并在第 5、6 章关键小节之间加入 `\FloatBarrier`，减少图表跨小节漂移；
- 将消融实验的 Scene 2 俯视图和 Scene 3 三维图合并为一行两图，统一为消融代表轨迹图；
- 同步缩短主对比、显著性和消融表 caption，并压缩消融长表列距。

验证结果：

- `xelatex -interaction=nonstopmode -halt-on-error main.tex` 编译通过并生成 `main.pdf`；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、overfull/underfull 或 longtable 宽度警告；
- 当前唯一剩余预期提示为 bibliography 为空，待后续文献库补充。

## 2026-06-29 中文初稿章节结构收敛

调整内容：

- 按 AJSE/Springer 常规研究论文结构，将中文稿主章节从 8 个收敛为 6 个；
- 将“相关工作”从独立 `\section` 降为“引言”下的 `\subsection`；
- 将“局限性”从独立 `\section` 降为“结果与讨论”末尾的 `\subsection{局限性与未来工作}`；
- 为引言、相关工作、问题建模、局限性和结论补充稳定 label；
- 将实验设计中硬编码的“第 3 章定义”改为 `\ref{sec:problem-formulation}` 交叉引用。

验证结果：

- `main.aux` 中目录主章节为：引言、问题建模、CVF-AE 方法、实验设计、结果与讨论、结论；
- `xelatex -interaction=nonstopmode -halt-on-error main.tex` 连续编译通过；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、overfull/underfull 或 longtable 宽度警告；
- 当前唯一剩余预期提示为 bibliography 为空，待后续文献库补充。

## 2026-06-29 第一章与参考文献初稿

本地文献处理：

- 扫描 `D:\Zotero\Downloads` 及子文件夹，索引 `162` 篇 PDF；
- 输出 `paper_ajse_zh/notes/local_pdf_inventory.md` 与 `local_pdf_inventory.json`；
- Zotero local API 未运行，因此本轮直接基于 PDF 文件名、PDF 元数据、前两页文本和 DOI 线索构建本地文献池。

联网核验：

- 使用 DOI/BibTeX 内容协商核验并拉取候选 BibTeX；
- 成功获取 `26` 条候选 BibTeX，另有 `2` 条 Elsevier DOI 因 HTTP 429 暂未拉取；
- 手工整理为 `paper_ajse_zh/bib/references.bib`，统一 citation key 并剔除错误 Cliff's delta 候选 DOI。

正文写作：

- 完成第一章“引言”中文初稿；
- 完成“相关工作”小节，覆盖 UAV 路径规划、元启发式优化、约束处理、人工势场/可行性引导和研究缺口；
- 补充统计检验方法引用：Mann--Whitney U、Holm 校正、Kruskal--Wallis 和 Cliff's delta；
- 保持主线为强约束三维/低空 UAV 路径规划 + Constraint Viability Field，不引入 CEC 或真实地图案例。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- `main.bbl` 中当前使用 `24` 条参考文献；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull/underfull 或空 bibliography；
- 静态扫描未发现本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT 或夸大表述。

## 2026-06-29 Zotero local API 复核

API 状态：

- Zotero local API 已启用并运行；
- Zotero version: `9.0.5`；
- local API status: `200`；
- connector status: `200`。

导出与审计：

- 导出 Zotero BibTeX 至 `paper_ajse_zh/notes/zotero_export_full.bib`；
- Zotero 导出条目数：`327`；
- 生成审计文件 `paper_ajse_zh/notes/zotero_reference_audit.md`；
- 当前 `references.bib` 条目数：`27`；
- 当前 DOI 与 Zotero 匹配：`21`；
- 当前 DOI 未在 Zotero 导出中匹配：`6`，均为基础方法或统计学文献：Deb 约束处理、Khatib 势场、Mann--Whitney、Kruskal--Wallis、Cliff's delta、Holm 校正；
- 发现 `9` 个当前引用在 Zotero 中存在同 DOI 重复条目。

处理结论：

- 不直接用 Zotero 全量导出覆盖 `references.bib`，因为 Zotero 库中存在较多重复 DOI 条目；
- 当前 `references.bib` 继续作为论文可编译源；
- 后续若补充文献，优先从 Zotero 审计中的 additional relevant candidates 中逐条筛选、去重并核验。

## 2026-06-29 第一章二次精修

调整内容：

- 删除第一章内部“相关工作”等显式小标题，使第 1 章成为连续引言；
- 将 UAV 路径规划、元启发式优化、约束处理、势场方法和研究缺口自然合并进引言段落；
- 保留贡献列表，并将“本文其余部分组织”置于第一章末尾；
- 保持现有引用集合，不新增文献条目；
- `sections/02_related_work.tex` 仅保留注释，以维持 `main.tex` 输入结构。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 目录中第 1 章仅显示“引言”，不再显示相关工作小节；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull/underfull 或空 bibliography；
- 静态扫描未发现本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、未核验引用占位或夸大表述。

## 2026-06-29 第一章代表性工作式压缩

调整内容：

- 按用户意见将相关工作从综述式泛述改为“某人做了什么 + 仍有什么不足”的代表性工作串联；
- 删除与本文无直接关系的多 UAV/编队展开，只保留单 UAV/三维低空强约束主线；
- 将领域算子、连续蚁群、候选重构、多目标进化、CPO/RBBMO/SBO/Jellyfish 和势场方法的不足收束到 CVF-AE 的创新点；
- 保持贡献和文章组织在第一章末尾；
- 未新增参考文献，正文实际引用由 `24` 条降为 `20` 条。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 第一章约 `2713` 个字符；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull/underfull 或空 bibliography；
- 静态扫描未发现本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、未核验引用占位或夸大表述。

## 2026-06-29 流程图与伪代码取舍

调整内容：

- 按用户意见在第 4 章中只保留 `CVF-AE 算法流程` 伪代码；
- 删除方法流程图在正文中的图环境和正文引用；
- 将流程图原本强调的机制边界合并进方法文字：CVF 分支是基础 AE 候选之外的额外候选，不是全种群强制更新；CVF 候选仍需通过局部接收规则；局部修复属于候选后处理；
- 未删除 `figures/cvf_ae_method_flowchart.png` 文件，保留为后续可选材料。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过并生成 `main.pdf`；
- `main.bbl` 当前实际编入 `20` 条参考文献；
- 静态扫描未发现 `method-flowchart`、`cvf_ae_method_flowchart` 或 `fig:method-flowchart` 残留引用；
- 静态扫描未发现本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、未核验引用占位或夸大表述；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用或未定义 citation。

## 2026-06-30 中文初稿双栏预览版

调整内容：

- 按用户导师建议，将中文初稿从 A4 单栏 `ctexart` 切换为 Letter 双栏预览版，用于估算接近 Transactions 类论文的篇幅和版面密度；
- 主模板改为 `letterpaper`、`twocolumn`、紧凑页边距和较紧凑的图表间距；
- 主对比、显著性、消融、运行开销和参数敏感性表改为 `table*` 跨双栏浮动；
- 消融表由双栏不兼容的 `longtable` 改为跨栏 `tabular`；
- 结果章节主要图改为 `figure*` 跨双栏浮动；
- 拆分第 3、4 章中双栏下过宽的公式，并将 CVF 候选公式改写为先定义状态融合方向 $\mathbf{D}_s$ 再生成候选解的紧凑形式。

验证结果：

- 参考的三篇导师示例 PDF 均为 Letter 双栏，页数约 `12--13` 页；
- 当前中文初稿生成的 `main.pdf` 为 Letter 纸，双栏，共 `18` 页；
- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation 或 overfull；
- 静态扫描未发现本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、未核验引用占位或夸大表述；
- 抽样渲染首页和结果页，标题、双栏正文、跨栏表格和主要结果图均能显示。

## 2026-06-30 运行时间展示取舍

调整内容：

- 按用户确认，将效率主线从绝对 wall-clock time 调整为评价开销和稀疏触发开销；
- 从消融表中删除 `Time(s)` 列；
- 从评价开销表中删除 time ratio，只保留 `nEvals`、`CVF trig.`、`CVF succ.`、触发率和同批次评价比值；
- 在实验设计和结果讨论中明确说明：由于 MATLAB 会话状态、repair 次数、路径可行形成速度和批处理负载会影响 wall-clock time，本文不将绝对运行时间作为主要效率证据；
- 将“运行开销”相关小节和贡献表述统一改为“评价开销”“额外评价次数受控”和“稀疏触发”。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 当前双栏 `main.pdf` 为 Letter 纸，共 `19` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation 或 overfull；
- 静态扫描未发现 `Time(s)`、time ratio、禁用统计写法、CEC、RRT、内部场景编号、本机绝对路径或夸大表述。

## 2026-06-30 双栏留白压缩

调整内容：

- 将表 5 的 key exception 长描述移出表格，仅保留 `Test group`、`Scene`、`Methods`、`+`、`=` 和 `-` 六列；
- 表 5 由跨双栏 `table*` 改为单栏 `table`，例外解释继续保留在正文统计显著性分析段落中；
- 图 5 不再左右并排展示，改为上下两个子图；
- 图 5 采用跨双栏 `figure*` 和固定子图高度，避免单栏上下图造成右栏整页空白。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 当前双栏 `main.pdf` 为 Letter 纸，共 `18` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation 或 overfull；
- 抽样渲染第 12 页和第 14 页，表 5 能嵌入正文栏，图 5 以上下形式显示且页面下方能继续接正文。

## 2026-06-30 图表标题精简与期刊式浮动

调整内容：

- 将结果章节图题压缩为名称型标题，表题统一改为中文短名，如“主对比”“显著性”“消融结果”“评价开销”和“参数敏感性”；
- 移除正文 `\FloatBarrier`，图表浮动选项统一放宽为 `[tbp]`，不再强制图表停留在对应正文附近；
- 放宽双栏浮动比例和页内浮动数量，使宽图、宽表按正式期刊常见方式集中排版；
- 图 5 继续保持上下展示，但扩大子图显示尺寸并压缩子图标题；
- 摘要、局限性和结论由占位文本改为正式中文短文，标题和声明区去除英文 `TODO` 占位。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation 或 overfull；
- 静态扫描未发现 `TODO`、本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、未核验引用占位、绝对运行时间列或夸大表述；
- 渲染检查第 9--13 页，结果章节文字、表 5 单栏表、跨栏主图、图 5、表 8 和图 6 均能正常显示，整体浮动布局比逐节强制放置更紧凑。

## 2026-06-30 双栏图表混排修正

调整原因：

- 双栏 LaTeX 中 `figure*` 和 `table*` 只能作为跨双栏浮动放在页顶、页底或浮动页，不能像单栏图表一样自然插入正文中间；
- 结果章连续出现主对比表、收敛图、代表性轨迹图、消融表和消融轨迹图等多个跨栏对象时，LaTeX 会把它们排成纯图表页；
- 按正式期刊常见做法，版面应减少跨栏对象数量，保留少数确需跨栏的大表/大图，其余图表改为单栏或更紧凑排布。

调整内容：

- 收敛曲线由跨栏三联图改为单栏纵向三子图，使其能与正文同页混排；
- 评价开销表和参数敏感性表由跨栏表改为单栏短表；
- 消融轨迹图改为左右并排，减少跨栏图高度；
- 主轨迹图保留跨栏 2 行 3 列排布，仍展示俯视和三维视角；
- 调整双栏浮动比例，避免过度鼓励纯图表浮动页。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 当前双栏 `main.pdf` 为 Letter 纸，共 `15` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation 或 overfull；
- 静态扫描未发现 `TODO`、本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、未核验引用占位、绝对运行时间列或夸大表述；
- 渲染检查第 9--13 页：第 10 页已由纯图表页调整为“跨栏主表 + 单栏收敛图 + 正文/单栏显著性表”的混排；消融图、评价开销表和参数表均与正文混排。代表性轨迹图和消融大表仍作为必要的大型结果展示跨栏排版。

## 2026-06-30 消融轨迹小图化

调整内容：

- 将“消融轨迹”由跨双栏 `figure*` 改为单栏 `figure`；
- 保留 Scene 2 俯视图和 Scene 3 三维图两个子图，但在单栏内左右并排作为小图展示；
- 继续保留统一图号和 `fig:ablation-paths` 标签，正文引用不变。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 当前双栏 `main.pdf` 为 Letter 纸，共 `15` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation 或 overfull；
- 静态扫描未发现 `TODO`、本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、未核验引用占位、绝对运行时间列或夸大表述；
- 渲染检查第 10--12 页，消融轨迹图已作为单栏小图与评价开销表和正文混排，不再占用跨栏大图位置。

## 2026-06-30 SCI 三区大修意见响应

调整内容：

- 新增 `paper_ajse_zh/notes/major_revision_plan.md`，将审稿式意见拆分为“立刻落稿”“需补实验或重跑”“投稿前处理”三类任务；
- 第 3 章将可行性判定改为非负约束分量分别满足，并说明当前聚合违反量只作为实现中的排序和诊断量，不解释为统一物理量；
- 第 3 章补充边界硬约束与边界裕度软代价的关系，避免边界违反逻辑不一致；
- 第 4 章补充基础 AE 方向模板、状态判定指标与阈值、保守状态调度滞回规则、CVF 状态权重和融合权重；
- 第 4 章将障碍物、禁飞区、风险、高度、边界和转弯 CVF 分量从概念性描述改为可追溯到代码实现的公式表达；
- 第 5 章将高空绕行、边界贴靠、绕行比例和控制点贴边等轨迹复核指标前置定义，并补充基线公平性说明。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 Missing character；
- 静态扫描未发现 `TODO`、本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、未核验引用占位、绝对运行时间列或夸大表述；
- 渲染检查第 4--9 页，新增方法公式和实验指标定义可读，未出现公式压栏或图表遮挡。

## 2026-06-30 统计明细表补充

调整内容：

- 从 `routes/route_b_cvf_ae/results/cvf_ae_formal_significance_20260624_from_formal_results/cvf_ae_pairwise_rank_sum_holm.csv` 读取正式主对比统计结果；
- 新增 `paper_ajse_zh/tables/table_significance_detail.tex`，按三场景并排列出 CVF-AE 对 10 个基线的场景内 Holm 校正 `p` 值、Cliff's delta 和胜平负关系；
- 在第 6 章“统计显著性分析”中接入该明细表，并说明 `R` 与 Cliff's delta 的方向含义；
- 保留原有显著性摘要表，用于快速展示主对比和消融的胜/平/负概况。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 Missing character；
- 静态扫描未发现 `TODO`、本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、未核验引用占位、绝对运行时间列或夸大表述；
- 渲染检查第 10--12 页，新增统计明细表与正文混排，未形成纯表页。

## 2026-06-30 显著性表合并

调整内容：

- 将原“显著性摘要表”和“逐场景统计明细表”合并为单个 `paper_ajse_zh/tables/table_significance.tex`；
- 删除 `paper_ajse_zh/tables/table_significance_detail.tex`，避免正文连续放置两张显著性表；
- 当前正文只展示主对比 CVF-AE 对 10 个基线的逐场景 Holm 校正 `p` 值、Cliff's delta 和胜平负关系；
- 第 6 章消融讨论不再引用消融显著性，改为基于消融均值解释状态自适应、CVF、初始化和稀疏保持的互补关系。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull、rerun-label 或 Missing character；
- 正文 `.tex` 静态扫描未发现 `table_significance_detail`、`significance-detail`、消融显著性正文表述、禁用统计写法、CEC、RRT、绝对路径、`Scene 4` 或夸大表述；
- 渲染检查第 10--12 页，合并后的表 5 位于正文页顶部，未形成纯表页或压栏。

## 2026-06-30 参数敏感性正文合并

调整内容：

- 删除主文中的独立“参数敏感性”小节；
- 删除 `paper_ajse_zh/tables/table_parameters.tex`，不再将参数敏感性作为正文表 8 展示；
- 移除参数敏感性图的正文调用；
- 将关键结论压缩并入“评价开销与参数稳健性”小节，强调参数扰动只作为稳健性检查，不作为独立性能证据或重新调参依据。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull、rerun-label 或 Missing character；
- 正文 `.tex` 静态扫描未发现 `table_parameters`、`tab:parameters`、`fig:parameter-sensitivity`、禁用统计写法、CEC、RRT、绝对路径、`Scene 4` 或夸大表述；
- 渲染检查第 12--14 页，表 7、合并后的参数稳健性段落、综合讨论、局限性和结论均正常显示，未出现参数表/参数图残留。

## 2026-06-30 表 5 单栏化与标题恢复

调整内容：

- 将 `paper_ajse_zh/tables/table_significance.tex` 从跨栏三场景横向并列表改为单栏纵向明细表；
- 保留 CVF-AE 对 10 个基线算法在 3 个场景上的 Holm 校正 `p` 值、Cliff's delta 和胜平负关系；
- 将主要图题和表题由名称型短标题恢复为标准描述型 caption，包括主对比、显著性、消融、评价开销、收敛曲线、代表性轨迹和消融轨迹。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过；
- 当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull、rerun-label 或 Missing character；
- 正文 `.tex` 静态扫描未发现禁用统计写法、CEC、RRT、绝对路径、`Scene 4`、残留参数表引用或夸大表述；
- 渲染检查第 10--12 页，表 5 为单栏纵向表并与正文混排，未形成纯表页或压栏。

## 2026-06-30 二轮审稿意见硬修

调整内容：

- 第 3 章进一步澄清 $V(\mathbf X)$ 是当前实现中的 implementation-specific violation score，仅用于不可行解排序和诊断，不解释为统一物理量纲距离；
- Deb 规则说明改为“实现相关违反分数 $V$ 更小者优先”，并明确归一化违反量或安全优先词典序属于后续算法变体，需要重新运行主对比、消融和统计检验；
- 第 4 章修正状态识别公式的逻辑关系，使用明确的 `\land` 和 `\lor`，删除 `\rho_f=0,\rho_f<0.20` 这类歧义写法；
- 第 4 章说明质量细化状态在本文保守调度中主要作为观测状态和权重模板保留，正式运行主要在可行性保持、可行性形成和停滞恢复之间切换；
- CVF 候选接收规则改写为“保守局部接收”，承认更激进的可行性改善接收不属于当前正式实验；
- 第 5、6 章将“参数敏感性实验”统一降格为“参数稳健性检查/补充说明”，并修正“风风险热点”错字；
- 局限性补充当前排序和候选接收策略的算法边界。

验证结果：

- `xelatex -> xelatex` 增量编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull、rerun-label 或 Missing character；
- 正文 `.tex` 静态扫描未发现 `TODO`、本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、参数图表残留、`风风险` 或 `参数敏感性实验`；
- 渲染检查第 4--6 页，新增 $V$ 说明、状态判定公式和保守调度说明均正常显示，未出现公式压栏或文字遮挡。

## 2026-06-30 投稿化降调与参考文献核验

调整内容：

- 摘要、贡献第 4 条、综合讨论和结论均降调为“所测试的三类合成低空场景”，避免把三组合成实验泛化为普遍结论；
- 主对比表末列由 `Flag` 改为 `Review flag`，并补充复核标记率表注；
- 消融表补充 `CVF trig./succ.` 含义，评价开销表补充 `Trig.`、`Succ.` 和 `Ratio` 含义；
- 对 `bib/references.bib` 进行 DOI 元数据核验，并新增 `paper_ajse_zh/notes/reference_verification_20260630.md`；
- `Holm1979Sequential` 删除不可解析 DOI-like stable 编号，改用 JSTOR stable URL；`Deb2000ConstraintHandling` 的 issue 字段规范为 `2-4`；
- 复查 `Kumar2025UAVReview` 的 DOI 元数据：issued date 为 2025，但 ACM CSUR 卷期为 58(3)，当前保留 year 2025 并在核验记录中说明。

验证结果：

- `xelatex -> bibtex -> xelatex -> xelatex` 编译链通过，当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull、rerun-label 或 Missing character；
- DOI 复核结果：27 条参考文献中 26 条 DOI 可解析，1 条无 DOI 但保留 JSTOR stable URL，修正后无题名、期刊、年份、卷期或页码不一致项；
- 正文 `.tex` 静态扫描未发现 `TODO`、本机绝对路径、内部场景编号、禁用统计写法、CEC、RRT、参数图表残留、`风风险`、`参数敏感性实验` 或“所有正式场景”；
- 渲染检查第 10--14 页，新增表注后的主对比表、消融表和评价开销表均正常显示，未出现表格压栏或文字遮挡。

## 2026-06-30 图 3、图 4 拆分排版

调整内容：

- 按用户意见保留表 6 为单张跨栏消融表，不拆成逐场景表；
- 将原图 3 的 6 子图拆成两张跨栏图：三类测试场景的代表性路径俯视对比、三类测试场景的代表性路径三维对比；
- 将原图 4 的两子图拆成两张单栏图：Scene 2 消融俯视对比、Scene 3 消融三维对比；
- 更新结果章中相关图引用和说明文字。

验证结果：

- `xelatex -> xelatex` 增量编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `17` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull、rerun-label 或 Missing character；
- 正文 `.tex` 静态扫描未发现旧 `fig:extended-paths` 引用、禁用统计写法、CEC、RRT、绝对路径、`Scene 4`、`风风险`、`参数敏感性实验` 或“所有正式场景”；
- 渲染检查第 12--16 页，拆分后的轨迹图明显放大，表 6 未拆分且正常显示，未出现图表压栏或文字遮挡。

## 2026-06-30 轨迹图拆分版式二次调整

调整内容：

- 图 3 俯视对比和图 4 三维对比均改为一行三图，避免上一版两图一行加单图居中的断裂感；
- 图 5 和图 6 消融轨迹图缩小为 `0.78\linewidth` 的单栏正文图，使其更接近图 1、图 2 的正文混排节奏；
- 表 6 继续保持单张跨栏消融表，不拆分。

验证结果：

- `xelatex -> xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull、rerun-label 或 Missing character；
- 正文 `.tex` 静态扫描未发现旧图引用、禁用统计写法、CEC、RRT、绝对路径、`Scene 4`、`风风险`、`参数敏感性实验` 或“所有正式场景”；
- 渲染检查第 12--14 页，主轨迹图为两张一行三图，消融图 5/6 以较小单栏图嵌入正文中，未出现图表压栏或文字遮挡。

## 2026-06-30 投稿前四项小修

调整内容：

- 将第 6 章主对比结果中的“最佳综合排名”改为“最佳平均场景排名”，避免把适应度平均排名误表述为可行率、复核标记和开销的综合排名；
- 将第 5 章主对比公平性说明收紧为“完整 CVF-AE 框架相对于未嵌入本文专属约束引导机制的基线搜索器”的比较，并说明模块贡献由消融实验解释；
- 将主对比表中 `Review flag` 的表注明确为“三场景共 90 次运行中被任一轨迹复核规则标记的比例”；
- 将第 4 章基础 AE 方向系数从正文内嵌小表改为正式编号表 `tab:base-ae-coefficients`。

验证结果：

- `xelatex -> xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull、rerun-label 或 Missing character；
- 正文 `.tex` 静态扫描未发现旧表述“综合排名”“搜索机制本身”“Review flag 表示”，也未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、绝对运行时间列或夸大表述；
- 渲染检查第 5--6 页，新增基础 AE 系数表位于右栏顶部，未造成异常空白、压栏或遮挡。

## 2026-06-30 符号与公式小修

调整内容：

- 规范第 4 章禁飞区高度判断的区间写法，将 `p_z\notin[z_l,z_u]` 改为 `p_z \notin [z_l,z_u]`；
- 复核第 4 章中 `\bar V`、`\mathbf d_o/d_o` 和 `\mathbf d_z/d_z` 的写法，保留向量加粗、标量不加粗的区分；
- 将原式 (48) 的转弯分量从比例式 `\propto` 改为显式分段公式，给出 $\gamma_{\mathrm{curv}}=0.22$、$\theta_c=\alpha_{\mathrm{curv}}\theta_{\max}$ 和 $\alpha_{\mathrm{curv}}=0.85$；
- 补充说明转弯分量后续仍经过状态权重、逐维截断和整体范数截断，避免读者误解其为无限制强制平滑。

验证结果：

- `xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `17` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull、rerun-label 或 Missing character；
- 正文 `.tex` 静态扫描未发现 `\propto`、旧式 `p_z\notin[`、`V >¯`、禁用统计写法、CEC、RRT、绝对路径、`Scene 4` 或夸大表述；
- 渲染检查第 6--7 页，禁飞区符号、障碍物/NFZ 向量标量写法和转弯分量公式均正常显示。

## 2026-07-02 第二、三章篇幅压缩

调整内容：

- 检查第二章源文件 `02_related_work.tex`，当前仅保留输入结构占位注释，不产生正文篇幅，因此无需压缩；
- 压缩第三章 `03_problem_formulation.tex` 的铺垫和解释性文字，保留路径表示、目标函数、约束违反分量、可行性判定和 Deb 规则的完整公式链；
- 删除未被正文引用的“问题建模中的主要符号”表，相关符号已在公式和正文首次出现处定义；
- 将 Deb 可行性优先规则从四项列表改为紧凑段落，减少竖向占用；
- 收紧路径采样、目标项解释、边界硬约束/软代价、障碍物/NFZ 违反量和实现相关违反分数的说明，避免重复解释。

验证结果：

- `03_problem_formulation.tex` 由约 `8319` 字符降至 `7370` 字符，行数由 `270` 降至 `239`；
- `xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull、rerun-label 或 Missing character；
- 正文 `.tex` 静态扫描未发现已删除的 `tab:problem-notation` 引用、旧符号表标题、TODO、绝对路径、CEC、RRT、`Scene 4` 或夸大表述；
- 渲染检查第 2--4 页，第三章公式链、约束说明和第 4 章衔接均正常显示。

## 2026-07-03 第四章 CVF-AE 方法篇幅压缩

调整内容：

- 压缩 `paper_ajse_zh/sections/04_method.tex` 的解释性文字，重点收紧总体框架、状态调度、CVF 分量说明、稀疏触发、局部接收和复杂度分析；
- 保留基础 AE 候选、CVF 候选、状态判定、CVF 场构建、各分量压力、截断、质量引导、局部接收和算法伪代码的公式、label 与复现信息；
- 将 CVF 状态权重和融合权重由长段落改为非浮动紧凑小表，避免双栏长数学串产生 overfull；
- 未修改 MATLAB 算法代码、实验数据、图表或参考文献。

验证结果：

- `04_method.tex` 由约 `15090` 字符降至 `13751` 字符，减少约 `1339` 字符；行数因新增非浮动小表略增，不代表内容扩张；
- `xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- 正文 `.tex` 与表格静态扫描未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、`signed-rank`、绝对运行时间列或“通用最优/全面优于”等夸大表述；
- 全项目扫描中 `notes/zotero_export_full.bib` 仍含 Zotero 导出摘要里的 RRT/CEC 和本地附件路径，这些不属于正文编译源或本次修改范围。

## 2026-07-03 AI 审稿意见小修

调整内容：

- 根据 AI 审稿意见，将第 3 章目标函数口径改为“综合路径质量代理目标”，并说明固定采样下的路径质量项不解释为严格飞行动力学或真实能耗模型；
- 将第 4 章 CVF 场权重由 $\eta_c(s,V_c)$ 校准为 $\eta_c(s)$，并说明局部违反程度通过压力分量 $\mathbf F_{k,c}$ 的幅值体现；
- 在复杂度分析中区分完整路径评价采样点数 $M$ 和 CVF 低密度采样点数 $\widetilde M$：额外候选评价仍按 $M$ 计，场构造开销按 $\widetilde M$ 计；
- 未修改 MATLAB 算法代码、实验数据、图表或参考文献。

验证结果：

- `xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- 正文 `.tex` 与表格静态扫描未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、`signed-rank` 或“通用最优/全面优于”等夸大表述；
- 静态复核确认旧式 `\eta_c(s,V_c)` 已从正文源中清除。

## 2026-07-03 贡献主线收束

调整内容：

- 根据 AI 审稿意见，将摘要、引言贡献段和结论的主线统一为“约束违反信息前移到候选生成阶段的有界方向修正”；
- 将引言贡献列表由四个模块并列改为一个核心贡献下的三个支撑点：B 样条控制点 CVF 候选方向、CVF 与可行性优先接收的边界、三类合成场景中的验证与适用边界；
- 摘要和结论同步弱化“模块堆栈”表述，避免把 CVF-AE 写成初始化、状态调度、稀疏保持等规则集合；
- 未修改 MATLAB 算法代码、实验数据、图表或参考文献。

验证结果：

- `xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- 正文 `.tex` 与表格静态扫描未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、`signed-rank` 或“通用最优/全面优于”等夸大表述。

## 2026-07-03 工程复核指标降调

调整内容：

- 将主对比表中的 `Review flag` 改为 `Eng. flag`，并在表注中明确其为固定阈值工程轨迹复核比例；
- 将摘要、实验设置、结果讨论和结论中的“轨迹复核风险/轨迹合理性检查”统一改为“工程轨迹复核标记/工程复核标记/轨迹形态诊断”；
- 明确工程轨迹复核只作为 sanity check 和诊断信息，不作为安全认证指标或独立优化目标；
- 未修改 MATLAB 算法代码、实验数据、图表或参考文献。

验证结果：

- `xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `16` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- 正文 `.tex` 与表格静态扫描未发现旧式 `Review flag` 或“复核风险”表述；“安全认证”仅出现在否定性说明中；
- 正文 `.tex` 与表格静态扫描未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、`signed-rank` 或“通用最优/全面优于”等夸大表述。

## 2026-07-03 第五、六章重复解释压缩

调整内容：

- 压缩第 5 章 `05_experimental_setup.tex` 中实验环境、场景设置、公共参数、评价指标、对比算法和统计检验的重复说明；
- 压缩第 6 章 `06_results_and_discussion.tex` 中 Scene 2/3 例外、工程复核解释、统计显著性、消融、评价开销、参数稳健性和综合讨论的重复防御性表述；
- 保留所有图表引用、关键例外数字、消融结论、评价开销比例和结论边界；
- 未修改 MATLAB 算法代码、实验数据、图表或参考文献。

压缩效果：

- 第 5 章约减少 `950` 字符；
- 第 6 章约减少 `1802` 字符；
- 双栏 `main.pdf` 从 `16` 页降至 `15` 页。

验证结果：

- `xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `15` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- 正文 `.tex` 与表格静态扫描未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、`signed-rank`、旧式 `Review flag`、旧式“复核风险”或“通用最优/全面优于”等夸大表述。

## 2026-07-03 小公式、伪代码和表格排版压缩

调整内容：

- 检查第 2 章和第 3 章公式排版：第 2 章仍为占位注释，不产生正文公式；第 3 章将未被交叉引用的小公式改为行内公式；
- 保留第 3 章目标函数、惩罚项、核心违反分量、可行性判定、实现相关违反分数和 Deb 可行性优先规则；
- 将第 4 章算法伪代码字号改为 `\scriptsize`，降低算法块的视觉松散感；
- 将表 5 显著性比较由逐场景 30 行改为每个基线一行、三场景并列的紧凑单栏表；
- 在正文中定义消融版本 V0--V5，表 6 仅保留编号；表 6 去除 `resizebox` 放大，改用 `tabular*` 均匀铺满双栏；
- 未修改 MATLAB 算法代码、实验数据、图像或参考文献。

压缩效果：

- 本轮涉及 5 个 LaTeX 源文件，净减少约 `103` 行；
- 双栏 `main.pdf` 从 `15` 页降至 `14` 页；
- 表 5 从 `30` 条数据行降至 `10` 条数据行，表 6 消融版本名由长名称改为 V0--V5。

验证结果：

- `xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `14` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- 正文 `.tex` 与表格静态扫描未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、`Review flag`、旧式“复核风险”或“通用最优/全面优于”等夸大表述；
- 已渲染抽查第 9--12 页，表 5、表 6、表 7 以及结果章节图文未出现压栏、遮挡或乱码。

## 2026-07-03 非实验审稿意见精修

调整内容：

- 弱化摘要和结论中的防御式表述，将“均衡工程型优化框架”改为“均衡型候选生成框架”，并减少“不是最低标量适应度”类重复自辩；
- 统一术语为“稀疏可行性保持机制”，替换“稀疏保持”“稀疏修复”“repair reuse”等混用表述；
- 在方法节明确区分观测状态 $s_{\mathrm{obs}}$ 与经保守调度后的生效状态 $s_t$，并同步修改 Algorithm 1；
- 在 CVF 构建小节开头补充说明：CVF 不是目标函数或约束函数的解析梯度，而是由局部约束压力构造的有界启发式候选方向；
- 在 CVF 接收规则后补充保守接收含义：CVF 分支只允许相对基础候选同时满足可行性优先和目标不劣的候选进入后续竞争；
- 将第 3 章关于“归一化违反量需重跑”的重复提醒移除，仅在局限性中保留算法变体需要重新实验的边界说明；
- 未新增实验、未改变实验口径、未修改 MATLAB 算法代码或实验数据。

公式小修：

- 转弯角公式加入 `clip(...,-1,1)`，并说明其用于避免反余弦输入因数值舍入越界；
- 禁飞区集合 $\mathcal Z$ 明确为已合并安全缓冲后的禁飞区集合；
- B 样条边界说明补充 open-uniform、非负基函数和 partition of unity 条件；
- CVF 范数截断由不等式口径改为分段缩放定义，并补充 `clip` 记号说明。

验证结果：

- `xelatex -> xelatex` 编译通过，当前双栏 `main.pdf` 为 Letter 纸，共 `14` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- 正文 `.tex` 与表格静态扫描未发现 TODO、本机绝对路径、CEC、RRT、`Scene 4`、旧式 `Review flag`、旧式“复核风险”、“工程型”、“稀疏保持”、“稀疏修复”或“通用最优/全面优于”等表述；
- 已渲染抽查第 3、5、6、7 页，转弯角公式、CVF 非梯度说明、范数截断公式和 Algorithm 1 均未出现压栏、遮挡或乱码。

## 2026-07-06 主文对比算法收缩为 selected-7

调整内容：

- 将主文对比算法统一为 `AE, PSO, GWO, HHO, ERIME, MSCSO, CVF-AE`，删除正文、表格、caption、图例和结论中对被移除算法的展示与讨论；
- 新增 `make_cvf_ae_selected7_paper_artifacts.m`，只复用既有 formal main 与 recent improved 的 raw run CSV / run records，不重跑优化实验；
- 新建结果目录 `routes/route_b_cvf_ae/results/cvf_ae_selected7_paper_artifacts_20260706/`，输出 selected-7 run 表、summary、平均排名、成对显著性、胜平负摘要和代表性路径选择记录；
- 重写 `table_main_comparison.tex` 和 `table_significance.tex`：主表只保留 7 个算法，显著性表只保留 CVF-AE 对 6 个基线；
- 重新生成并接入 `selected7_boxplots.png`、三张 selected 收敛曲线和六张 selected 代表性路径图；
- 修改第 1、5、6、8 章和摘要，将基线选择说明、结果讨论和结论边界统一为“所选代表性基线”口径。

重算统计：

- 每场景 mean/std/feasible rate、场景排名和三场景平均排名均在 selected-7 内重新计算；
- CVF-AE 平均排名为 `1.33`，MSCSO 为 `2.00`，ERIME 为 `2.67`；
- CVF-AE 对 6 个基线的逐场景 Wilcoxon rank-sum / Mann--Whitney U 检验按每场景 6 次比较重新做 Holm 校正；
- 18 次成对比较结果为 `15` 胜、`2` 平、`1` 负；唯一显著劣势为 Scene 2 对 MSCSO 的标量适应度比较；
- Cliff's delta 按 selected-7 成对比较重新生成，表 5 中正值仍表示 CVF-AE 分布更优。

验证结果：

- 已执行 `xelatex -> bibtex -> xelatex -> xelatex`，当前双栏 `main.pdf` 为 Letter 纸，共 `14` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- `main.aux`、`main.bbl`、正文 sections、tables 和 `main.tex` 静态扫描未发现被删除算法名、旧 `11/10` 口径、`Scene 4`、CEC、RRT 或“全面优于/通用最优”等表述；
- 已渲染抽查第 8--11 页，主结果表、显著性表、箱线图、收敛图和代表性路径图均只展示 selected-7，未见压栏、遮挡或明显乱码。

## 2026-07-06 Scene 2 CVF-AE 低空代表航迹重筛

调整内容：

- 针对 Scene 2 主对比图中 CVF-AE 代表航迹低空视觉效果不足的问题，未重跑实验，仅在既有 `trajectory_sanity_runs.csv` 和 run records 中重新筛选代表 run；
- 新增只读诊断脚本 `inspect_scene2_cvf_low_altitude_candidates.m`，比较 Scene 2 CVF-AE 可行且无复核标记 run 的 MeanZ、MaxZ、边界贴靠比例和建筑足迹投影比例；
- 在 `make_cvf_ae_selected7_paper_artifacts.m` 中为 Scene 2 的 CVF-AE 增加低空优先代表路径评分，其余算法和场景仍使用原代表路径筛选；
- 将 Scene 2 CVF-AE 代表路径由 `scene2_CVF-AE_run028.mat` 改为 `scene2_CVF-AE_run009.mat`。

筛选依据：

- `scene2_CVF-AE_run009.mat`：BestFitness=`301.0747`，MeanZ=`14.9056`，MaxZ=`18.0000`，BoundaryHugFrac=`0.0201`，ObstacleFootprintFrac=`0`；
- 原 `scene2_CVF-AE_run028.mat`：BestFitness=`301.1337`，MeanZ=`16.405`，MaxZ=`18.156`，BoundaryHugFrac=`0.0905`；
- 因此新 run 在保持可行、无工程复核标记和近似适应度的同时，更符合低空代表航迹展示目的。

验证结果：

- 已重新生成 `selected_scene2_representative_top.png` 和 `selected_scene2_representative_3d.png`，并重新执行 `xelatex -> xelatex`；
- 当前 `main.pdf` 仍为 `14` 页，编译日志未发现 LaTeX Error、未定义引用、未定义 citation 或 overfull；
- 渲染抽查第 11 页，Scene 2 俯视代表路径中 CVF-AE 深蓝轨迹避开建筑矩形投影；三维图仍存在透明障碍物前后遮挡视觉叠加，但对应俯视图未穿越建筑足迹。

## 2026-07-06 结果图 SCI 风格配色同步

调整内容：

- 将 `plotSceneOnly.m` 中的地图元素配色从高饱和橙色建筑改为低饱和浅灰蓝建筑，禁飞区改为 muted red，风热点改为蓝灰色；
- 将 selected-7 结果图算法线条统一为色盲友好 muted 配色，并保留线型双编码：CVF-AE 使用深蓝粗实线，其余算法使用灰、蓝、橙、粉、浅蓝和紫色；
- 更新 `make_cvf_ae_selected7_paper_artifacts.m`，使箱线图、收敛图和代表路径图使用同一套算法色板；
- 更新 `make_cvf_ae_representative_path_figures.m` 的消融线条色板，并重新生成正文使用的消融路径图；
- 保留 `palette_test_scene2_representative_3d.png` 作为配色测试图，不在正文中引用。

验证结果：

- 已重新生成 selected-7 箱线图、三场景收敛图、三场景代表路径俯视/三维图，以及消融 Scene 2 俯视图和 Scene 3 三维图；
- 本轮未修改实验数据、统计结果或正文数值；
- 已执行 `xelatex -> xelatex`，当前 `main.pdf` 为 `14` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- 渲染抽查第 9--11 页，主表、箱线图、收敛图、selected-7 路径图和消融路径图显示正常，地图背景不再压过路径线条。

## 2026-07-06 结果章结构重排

调整内容：

- 按“算法单独一章、实验结果及分析单独一章”的结构重排主文，`main.tex` 不再输入独立的 `05_experimental_setup.tex` 和 `07_limitations.tex`；
- 将实验设置压缩并合并到 `06_results_and_discussion.tex` 开头，作为“整体实验设置”小节；
- 第 4 章现在依次为“整体实验设置、主对比结果、消融分析、显著性分析、开销分析与局限性”；
- 原结果解释被分别放入主对比、消融、显著性和开销小节，不再集中放在独立综合讨论段；
- 同步修改引言中的章节安排说明；
- 新增 `placeins` 并在结果章小节边界加入 `\FloatBarrier`，避免图表浮动到对应小节标题之前。

验证结果：

- 已执行 `xelatex -> xelatex`，当前双栏 `main.pdf` 为 Letter 纸，共 `13` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- `main.aux`、`main.bbl`、正文 sections、tables 和 `main.tex` 静态扫描未发现被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或“全面优于/通用最优”等表述；
- 已渲染抽查第 7--10 页，结果章小节顺序和主要表图显示正常，未见压栏、遮挡或明显乱码。

## 2026-07-06 局限性移入结论与章节 tex 清理

调整内容：

- 将结果章末节由“开销分析与局限性”改为“开销分析”，仅保留评价次数、CVF 触发率、同批次评价比值和参数稳健性说明；
- 将局限性段落移入结论章末段，集中说明静态合成场景、真实地图/DEM、动态障碍、在线重规划、多无人机协同、后续算法变体和闭环验证等边界；
- 删除不再产生有效章节内容或不再被主文输入的 `02_related_work.tex`、`05_experimental_setup.tex` 和 `07_limitations.tex`；
- 将剩余章节 tex 按当前论文结构重命名为 `02_problem_formulation.tex`、`03_method.tex`、`04_results_and_discussion.tex` 和 `05_conclusion.tex`；
- 更新 `main.tex`，现在只输入摘要、引言、问题建模、方法、实验结果与分析和结论对应的有效 tex 文件。

验证结果：

- 已执行 `xelatex -> xelatex`，当前双栏 `main.pdf` 为 Letter 纸，共 `12` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- `main.tex`、sections、tables、`main.aux` 和 `main.bbl` 静态扫描未发现旧章节输入文件名、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或“全面优于/通用最优”等表述；
- 已渲染抽查第 10--12 页，开销分析、结论、声明区和参考文献显示正常，未见压栏、遮挡或明显乱码。

## 2026-07-06 新一轮审稿意见选择性采纳

调整内容：

- 保留代表性基线选择原则，正文说明 AE、PSO/GWO/HHO、ERIME/MSCSO 分别覆盖基础骨架、经典群智能和近期改进型元启发式方法；
- 删除主对比结果中关于历史算法集合、旧排名、更大集合校正或扩展补充材料的任何表述；
- 删除 Scene 2 代表路径“低空优先规则从既有可行 run 中筛选”的敏感措辞，改为说明代表性路径仅用于可视化展示，不参与优化、统计检验或表格排名；
- 将“所选代表性基线中最佳平均排名”口径统一到摘要、主对比结果、综合结果段和结论；
- 表 4 注释改为“主对比算法”排名口径，不再写“所选 7 个算法内”；
- 采纳公式与伪代码小修：质量引导方向中的 `\mathrm{clip}` 使用圆括号函数调用；Algorithm 1 第 21 行改为候选被选入稀疏可行性保持集合；
- 结论中将“需要重新开展正式实验”改为后续算法变体进一步验证的展望式表述；
- 生成工程轨迹复核分项表草稿 `paper_ajse_zh/notes/engineering_review_breakdown_draft.md` 和 `.csv`，仅供内部审查，未接入论文正文。

验证结果：

- 已执行 `xelatex -> xelatex`，当前双栏 `main.pdf` 为 Letter 纸，共 `12` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- `main.tex`、sections、tables、`main.aux` 和 `main.bbl` 静态扫描未发现“更大/旧排名/低空优先/既有可行/所选 7/需要重新开展正式实验/补充材料/Supplementary”、被删除算法名、旧 `11/10` 口径、`Scene 4`、CEC、RRT 或“全面优于/通用最优”等表述。

## 2026-07-07 第 3 章初始化与参考引导补齐

调整内容：

- 在第 3.2 节新增“约束感知初始化与参考弱引导”，补充参考控制向量、净空/风险扰动半径、引导初始化和弱参考方向的可复现说明；
- 将第 3.2 节开头从三步机制改为四个环节：约束感知初始化与弱参考方向、状态识别、CVF 压力映射、稀疏触发与保守接收；
- 修正 Algorithm 1/2 的初始化口径：基础 AE 保持普通初始化，CVF-AE 明确生成参考控制序列并进行约束感知初始化；
- 将第 4.3 节消融版本说明中的 V4 改为“仅去除约束感知初始化”，避免把该消融误解释为去除全部参考方向。

验证结果：

- 已执行 `xelatex -> xelatex`，当前双栏 `main.pdf` 为 Letter 纸，共 `13` 页；
- 编译日志未发现 LaTeX Error、Fatal error、Emergency stop、未定义引用、未定义 citation、overfull 或 rerun-label warning；
- `main.tex`、sections 和 tables 静态扫描未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或“全面优于/通用最优”等表述。

## 2026-07-11 论文方法归因与表述一致性修订

调整内容：

- 将第 3.1 节的基础 AE 流程和候选公式改为实际使用的固定平衡进化算子，移除原先误归入基础 AE 的状态调度和参考方向；
- 将状态化内部候选明确归入 CVF-AE，并将论文中的保守调度统一为形成、保持和恢复三种状态；
- 在第 3.2.1 节披露 CVF-AE 专属参考控制序列：采用平面 \SI{5}{m}、垂向 \SI{4}{m} 的三维栅格 A* 生成，作为内部初始化与弱方向先验，不作为对比算法；复杂障碍布局使用固定走廊控制点模板扩展初始覆盖；
- 保留 V4“去除约束感知初始化”的消融定义，并明确其不代表移除迭代阶段参考弱方向；Scene 3 的 V4 同时移除初始化走廊模板；
- 将 CVF 候选接收统一表述为“Deb 优先且目标不增的保守局部门控”，将路径阈值结果降级为仅供可视化与复核的辅助标记；
- 删除未由主文图表直接支撑的参数方向性结论，区分复杂度中的评价次数和评价工作量，并在摘要、引言、结果和结论中压缩重复表述。

验证结果：

- 已执行 `xelatex -> xelatex`，当前双栏 `main.pdf` 为 Letter 纸，共 `12` 页；
- 编译日志未发现 LaTeX Error、undefined reference、undefined citation、overfull 或 rerun-label warning；
- 静态扫描 `main.tex`、sections、tables、`main.aux` 和 `main.bbl` 未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或夸大表述；
- 已渲染抽查第 4--6 页，基础 AE/CVF-AE 伪代码、状态系数表、参考初始化说明、CVF 图与公式均未见压栏、遮挡或明显乱码。

## 2026-07-11 内部模板影响消融

调整内容：

- 新建隔离实验目录 `routes/route_b_cvf_ae/experiments/template_initialization_ablation/`，其中的 `overrides/init_COVE_AE.m` 为原初始化函数的仅实验覆盖副本；生产初始化函数、优化器、论文数据和图表均未修改；
- 新建运行器 `run_template_initialization_ablation.m`：仅运行复杂场景的 CVF-AE，模板开启与关闭各 30 次，参考路径、引导初始化、CVF、状态调度、修复、评价函数、预算和种子规则保持一致；
- 新建 `analyze_template_initialization_ablation.m`，仅输出内部 CSV、MAT 与 Markdown 汇总，不生成论文图表或 LaTeX 表格；
- 结果输出至 `results/template_initialization_ablation_20260711_225319/`，模板开启/关闭均为 30 个匹配种子 run。

内部结果：

- 模板开启：平均适应度 `344.242892`，中位数 `341.417588`，可行率 `1.0000`，平均 CVF 触发 `88.87`；
- 模板关闭：平均适应度 `477.179717`，中位数 `342.471549`，可行率 `0.7333`，平均 CVF 触发 `355.03`；
- 两条件总体最终适应度的双侧秩和检验为 `p=0.652044`，Cliff's delta 为 `0.008889`；可行率的双侧 Fisher 精确检验为 `p=0.004575`；
- 因此，固定走廊模板在该复杂场景中主要提高可行性形成稳定性并降低 CVF 介入次数。该结论目前仅供内部决策，尚未写入论文。
- 决策：保留固定走廊控制点模板作为约束感知初始化的组成；论文继续使用当前弱化的实现说明，不加入本内部消融的数值、图表或显著性结论。
# 2026-07-13: State-scheduler notation consistency

- Updated `paper_ajse_zh/sections/03_method.tex`: the conservative scheduler equation now outputs a requested state `q_t`; a non-maintenance request becomes the active state `s_t` only after two consecutive confirmations. This removes the notation mismatch between the equation, the explanatory text, and Algorithm 2 without changing the algorithm or experiments.

## 2026-07-13 可行性优先准则解释图

调整内容：

- 在 `paper_ajse_zh/sections/02_problem_formulation.tex` 的 Deb 可行性优先准则定义后加入单栏图 `fig:deb-feasibility-criterion`；
- 图仅展示候选解可行性比较：存在可行解时优先可行解、二者均可行时比较 $J$、二者均不可行时比较 $V$ 并以 $J$ 破除并列；
- CVF-AE 的“Deb 优先且目标不增”局部接收继续由第 3 章的伪代码和式 `eq:local-cvf-accept` 定义，未并入该图；
- 新图为单栏解释图，不使用实验结果、不改变算法或实验设置。其来源已记录在 `paper_ajse_zh/notes/source_mapping.md`。

验证结果：

- 已执行 `xelatex -> xelatex`，当前双栏 `main.pdf` 为 Letter 纸，共 `13` 页；
- 编译日志未发现 LaTeX Error、undefined reference、undefined citation、overfull 或 rerun-label warning；
- 已渲染抽查第 4 页，图和标题在单栏内正常显示，未见压栏、遮挡或乱码；
- 静态扫描 `main.tex`、sections 和 tables 未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或夸大表述。

## 2026-07-13 图文排版重平衡

调整内容：

- 将第 3 章的两段算法由 `[H]` 改为 `[tbp]`，避免算法无法在当前栏容纳时留下大面积空白；
- 将 Deb 可行性优先准则图替换为紧凑单栏横向版本，降低其占用高度；
- 移除第 4 章图前和章末的强制浮动屏障；收敛图保持页首优先，路径对比和消融路径图改为页底优先；
- 对连续跨栏图设置保守的高度上限，使图后正文可回填到同页或相邻栏，不改变图表数据、实验设置或结论。

验证结果：

- 已执行 `xelatex -> xelatex`，当前双栏 `main.pdf` 为 Letter 纸，共 `12` 页；
- 编译日志未发现 LaTeX Error、undefined reference、undefined citation、overfull 或 rerun-label warning；
- 已渲染抽查第 4、8--10 页：第 3 章开头无大面积留白，第 9--10 页均为图表与正文混排，未见纯图表页、压栏、遮挡或乱码；
- 静态扫描 `main.tex`、sections 和 tables 未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或夸大表述。
# 2026-07-13: Section 4 partial-revert recovery

- Reapplied the intended Section 4 result-reporting language in `paper_ajse_zh/sections/04_results_and_discussion.tex`: selected representative baseline scope, shared controls, auxiliary trajectory-review boundaries, rank-sum/Holm/Cliff's delta protocol, conservative Scene 2 interpretation, and representative-path usage limits.
- Replaced the unsupported directional parameter statement with a compact default-configuration statement. No MATLAB algorithm code, experimental data, statistics, tables, or figures were changed.
- Recompiled twice with XeLaTeX. The document is now 13 pages because the reference list continues onto the final page; visual inspection confirms that the Section 4 table and figure group is intact, with no clipping or overlap.

## 2026-07-14 全文一致性、文献与版面审查

调整内容：

- 将主对比公平性统一表述为相同路径编码、评价函数、边界投影、种群规模和迭代次数；不同算法的函数评价次数不强制相同，并在开销部分独立报告；
- 第 2 章明确以总违反分数 $V\leq10^{-10}$ 判定可行；第 3 章按实现统一请求状态 $q_t$、生效状态 $s_t$、状态化 AE 方向和 `round` 触发配额；
- 新增 6 行紧凑参数表，仅披露决定稀疏触发对象、触发数量和修复开销的关键参数，暂不加入完整目标/CVF 常数清单；
- 为 PSO、GWO、HHO、增强 RIME 来源和 MSCSO 补充文献引用；将 Feng 文献修正为 `Scientific Reports 16, 101 (2026)`；
- 重新约束宽图、宽表和单栏表的浮动位置，消除结果章连续纯图表页，同时保持路径图横向尺寸和图例可读性；未重跑实验，也未修改任何结果数值。

验证结果：

- 已执行 `bibtex -> xelatex -> xelatex`，最终双栏 `main.pdf` 为 Letter 纸，共 `13` 页；
- 编译日志未发现 LaTeX Error、undefined reference、undefined citation、overfull、纯浮动页或 rerun-label warning；
- 渲染检查第 9--11 页：主结果、统计表、集中图版、消融表和结论衔接正常，无压栏、遮挡或乱码；
- 源文件与 PDF 文本层扫描未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或夸大表述。

## 2026-07-14 方法参数披露精简

对照内容：

- 检查桌面“无人机参考文献”目录中的 15 份 PDF（约 14 篇独立论文）；多数论文仅在正文给出少量关键参数或一张紧凑设置表，只有进行参数敏感性/正交分析的少数论文采用详细披露；
- 当前 CVF-AE 稿件原先同时列出基础 AE 系数、三状态内部系数、18 个压力权重、压力几何常数和 6 行触发/修复参数，明显高于该组参考论文的正文披露密度。

调整内容：

- 撤除稀疏触发与可行性保持参数表，仅在正文保留三状态名义触发比例和产生可行解后的节流配置；
- 三状态候选表由 8 个内部方向系数加 3 个融合权重改为“方向侧重 + 3 个融合权重”，并将 18 个压力权重改为形成/保持/恢复状态的定性侧重；
- 将基础 AE 调度、初始化扰动、压力缓冲与缩放、风险激活、高度/边界缓冲、曲率激活、质量牵引和修复筛选中的实现级数值改为符号说明；
- 保留状态判定阈值、9 个融合权重、触发比例、可行后节流，以及实验设置中的目标权重、惩罚、运动约束、种群规模和迭代次数；未修改算法代码或实验结果。

验证结果：

- 已执行 `xelatex -> xelatex`，最终 `main.pdf` 为 Letter 纸，共 `13` 页；
- 编译日志未发现 LaTeX Error、undefined reference、undefined citation、overfull、纯浮动页或 rerun warning；
- 渲染检查第 4--8 页，精简后的状态表、CVF 公式、复杂度和实验设置连续排布，无大面积空白、压栏、遮挡或乱码；
- 静态扫描未发现已撤除参数表引用、旧实现数值残留、TODO、本机绝对路径或禁用术语。

### 图 7 浮动位置修复

- 参数精简后，双栏页底消融图被延迟到第 11 页参考文献区域；强制双栏页首会形成单独纯图页；
- 最终将图 7 改为单栏纵向两子图，取消消融小节内的局部屏障，保留结果章末总屏障；
- 图 7 现位于第 11 页左栏顶部并先于结论和参考文献，页面恢复为 13 页；双遍 XeLaTeX 与第 9--13 页渲染检查通过。

## 2026-07-18 引言叙事与贡献收束

调整内容：

- 重写中文引言的论证顺序，先明确“评价后约束处理无法提供候选移动方向”与“全种群强制场更新可能损害进化探索”之间的张力；
- 将 CVF-AE 定位为候选生成阶段的局部修正机制，并以“进入潜在可行走廊--决定何时介入--构造怎样移动--判断是否保留”串联约束感知初始化、状态调度、CVF 和保守接收；
- 贡献列表由 4 项收束为 3 项方法贡献，删除实验验证式第四项；主对比、消融、统计检验和开销分析改为列表外的验证说明；
- 同步改写方法章开头和结论首段，使全文沿用相同的闭环叙事；未修改 MATLAB 代码、实验设置、数据、统计、表格或图件。

验证结果：

- 已执行 `xelatex -> xelatex`，`main.pdf` 保持 Letter 双栏 13 页；
- 编译日志未发现 LaTeX Error、undefined reference、undefined citation、overfull 或 rerun-label warning；
- 渲染抽查第 1、4 和 11 页，引言、方法衔接和结论均无压栏、遮挡、乱码或异常空白；
- 静态扫描未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或夸大表述。

## 2026-07-18 第四章结果证据层级调整

调整内容：

- 主对比表移除跨三场景合并的 `Aux. flag` 列；预设阈值辅助复核标记仅保留为代表性路径的可视化和结果复核信息，不参与排名或统计检验；
- 主对比文字按可行性、最终标量适应度排名、运行分布与定性路径解释分层，明确现有排名按平均适应度计算，而非事后新增的约束优先综合排名；
- 收敛曲线明确仅描述相同种群规模和迭代次数下的搜索过程，不作为函数评价效率或严格收敛速度优势的证据；
- 消融分析补充 V2 与 V3：状态自适应在 Scene 3 的作用更明显；去除稀疏可行性保持虽减少评价次数但会降低三场景质量；删除无正文证据支撑的参数稳健性句；
- 未修改 MATLAB 代码、实验设置、运行数据、统计检验、图件或算法比较集合。

验证结果：

- 已执行 `xelatex -> xelatex`，`main.pdf` 保持 Letter 双栏 13 页；
- 编译日志未发现 LaTeX Error、undefined reference、undefined citation、overfull 或 rerun-label warning；
- 渲染抽查第 8--11 页，主结果表、主对比文字、消融解释、统计/开销表和结论衔接正常，无压栏、遮挡、乱码或异常空白；
- 静态扫描未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或夸大表述。

## 2026-07-18 方法--实验叙事对齐

调整内容：

- 第 3 章在约束感知初始化、CVF 场构建和保守接收三个转折点加入短桥接，明确初始化解决如何进入潜在可行走廊，状态调度决定何时介入，CVF 给出怎样移动，有界融合和保守接收限制何种修正可以保留；
- 第 4 章开头改为检验候选生成闭环，而非结果项目清单；主对比、消融、统计和开销分别对应整体价值、机制拆解、分布证据与稀疏介入代价；
- 消融导语将 V4、V2、V1、V3 和 V5 映射到进入先验、介入时机、约束移动、稀疏可行性保持和完整闭环移除，且明确保守接收规则没有被单独消融；
- 未修改 MATLAB 代码、实验设置、数据、统计、表格或图件。

验证结果：

- 已执行 `xelatex -> xelatex`，`main.pdf` 保持 Letter 双栏 13 页；
- 编译日志未发现 LaTeX Error、undefined reference、undefined citation、overfull 或 rerun-label warning；
- 渲染抽查第 5、7、8 和 9 页，新增方法桥接、第四章验证链和消融导语均无压栏、遮挡、乱码或异常空白；
- 静态扫描未发现 TODO、本机绝对路径、被删除算法名、旧 `11/10` 口径、`extended comparison`、`Scene 4`、CEC、RRT 或夸大表述。
- 已删除引言贡献列表后的实验验证重复说明，避免与第 4 章实验设置职责重叠；双遍 XeLaTeX 后仍为 13 页，日志无 LaTeX Error、undefined reference/citation、overfull 或 rerun-label warning。

## 2026-07-18 已保存结果的数据可用性审计

审计范围：

- 只读检查统一主对比结果包 `results/cvf_ae_selected7_main_comparison_formal_20260707_101155/` 及其论文产物；未重跑优化，未改动 MATLAB 代码、实验数据或论文图表。

审计结论：

- 三个论文场景的每个算法均保存 30 次独立 run；所有 run record 均包含 300 代 `bestHist`、最终路径、最终可行性、运行时间和函数评价次数。因此，现有收敛曲线和终态轨迹均可追溯。
- 各算法函数评价次数并不相同：AE、PSO、GWO 为固定值，而 HHO、ERIME、MSCSO 与 CVF-AE 因其内部候选评价而变化。因此正文应继续使用“相同种群规模和迭代次数”，不能写成相同函数评价预算；收敛曲线也不能作为函数评价效率或严格收敛速度证据。
- `firstFeasibleIter`、`firstFeasibleTime`、`feasibleRatioHistory` 和 `stateHistory` 的逐代有效记录只对 CVF-AE 完整可用。没有所有算法一致的可行性历史，不能新增跨算法“首次达到可行”比较；若未来需要该证据，必须先以统一记录口径重跑。
- 所有算法的最终轨迹可复核，且已有轨迹阈值摘要；这些阈值继续只作为可视化/复核辅助标记，不进入排名、显著性检验或新的主结论。

## 2026-07-18 轨迹图精简与单栏重组

调整内容：

- 采纳“减少轨迹图”的审稿意见：删除主对比中 Scene 1 的代表性路径展示；不再分别保留三场景俯视跨栏图和三场景三维跨栏图。
- 将 Scene 2 和 Scene 3 的俯视/三维路径合并为一张单栏 2x2 组合图，保留平面绕障与高度绕行两类互补的定性信息；代表性路径继续只用于可视化和结果复核，不参与优化、排名或统计检验。
- 为避免两个单栏图被 LaTeX 集中为纯浮动页，最终采用一个就地单栏组合图，并将其后的解释压缩为一个段落；未改动 MATLAB 代码、实验设置、结果数据、统计检验或图像数据内容。

验证结果：

- 已执行 `xelatex -> xelatex`，`main.pdf` 保持 Letter 双栏 13 页；
- 编译日志未发现 LaTeX Error、undefined reference、undefined citation、overfull、rerun-label 或纯浮动页 warning；
- 渲染抽查第 9--11 页，单栏轨迹组合图、消融图、收敛图、表格与正文混排正常，无压栏、遮挡、乱码、异常空白或纯图表页。

## 2026-07-18 排名口径表述

- 将“平均排名不应解释为新的约束优先综合排名”的防御式表述改为正向说明：场景排名按平均适应度计算，并与可行率分别报告。该修改不改变排名口径、数据、统计检验或结论。

## 2026-07-18 三维轨迹图视觉尺度校正

调整内容：

- 新增 `redraw_selected7_3d_trajectory_figures.m`，只读取正式主对比的既有代表性 run record，重绘 Scene 2/3 的三维代表路径；不调用优化器，不改变代表性运行选择、实验设置、数据、统计或表格。
- 将三维算法图例由坐标区外移至图内，扩大三维坐标区占比并收紧导出范围；在正文的四图组合中将俯视/三维子图宽度调整为 `0.41/0.53`，补偿三维投影的固有留白，使两类视图的实际视觉面积接近。

验证结果：

- 已执行 `xelatex -> xelatex`，`main.pdf` 保持 Letter 双栏 13 页；
- 编译日志未发现 LaTeX Error、undefined reference、undefined citation、overfull、rerun-label 或纯浮动页 warning；
- 渲染抽查第 9 页，Scene 2/3 的俯视与三维轨迹面板大小协调，无裁切、遮挡或异常空白。

## 2026-07-18 三维轨迹完整边界修正

调整内容：
- 针对三维视图底部被裁切的问题，将 `redraw_selected7_3d_trajectory_figures.m` 从单独导出坐标轴对象改为导出完整图窗；三维面板改为与俯视图一致的近方形画布，并保留底部坐标框、起点区域和障碍物底部。
- 由于两类源图已具有接近的长宽比，图 5 的四个子图统一为 `0.41\\linewidth`；未重跑算法，未修改代表运行选择、实验设置、数据、统计或表格。
验证结果：
- 已执行 `xelatex -> xelatex`，`main.pdf` 保持 Letter 双栏 13 页；日志无 LaTeX Error、undefined reference/citation 或 overfull warning；
- 渲染抽查第 9 页，Scene 2/3 的三维轨迹图完整呈现，四个面板无底边裁切、遮挡、图表重叠或纯浮动页。

## 2026-07-18 撤回三维轨迹重绘

- 按作者要求，已恢复仓库中原有的 Scene 2/3 三维代表性轨迹图，并删除临时重绘脚本；单栏图 5 仍保持四个等宽子图。
- 本次撤回未重跑算法，未修改已保存的结果记录、代表运行选择、实验设置、数据、统计、表格或正文。

## 2026-07-18 轨迹四面板分组排版

- 图 5 改为首行统一呈现 Scene 2/3 俯视图，第二行统一呈现 Scene 2/3 三维图；俯视子图宽度为 `0.40\\linewidth`，原始三维子图宽度为 `0.49\\linewidth`，以补偿透视画布较短造成的视觉缩小。
- 未修改图像文件、代表运行选择、实验设置、结果数据、统计或正文解释。
- 两张俯视图的子图宽度由 `0.40\\linewidth` 调为 `0.44\\linewidth`，缩小首行中间空隙；三维图行保持 `0.49\\linewidth`。

## 2026-07-18 第四章浮动体紧凑化

- 将图 3 从强制就地的 `[H]` 改为允许栏顶放置的普通单栏浮动体，避免因图文硬性绑定而打断两栏正文填充。
- 将图 4 从双栏页底专用的 `[!b]` 改为下页顶部优先的 `[!t]`，使它与收敛行为的分析更紧邻，不再被后续的图表和正文推迟到页底。

## 2026-07-18 主对比图表最终排版

- 图 3 改为允许栏顶放置的双栏图，三个箱线图获得更可读的尺度，同时避免与单栏代表路径图并置时出现的栏高失衡和大面积空白。
- 图 4 保持双栏顶部优先，图 5 恢复就地排版；渲染后图 3/图 4 依次位于后续页顶部，不再将图 4 压到更后页的底部。
- 双遍 XeLaTeX 后论文保持 13 页；渲染抽查第 9--10 页无裁切、重叠、纯浮动页或大面积单栏空白。

## 2026-07-18 箱线图证据顺序调整

- 将图 3 的运行分布分析移至箱线图前，并将该图改为栏底优先的单栏浮动体。论述先完成，图像作为紧随其后的证据放置，不再依赖就地浮动。

## 2026-07-19 第四章结果讨论扩充

- 主对比增加场景差异的解释：CVF-AE 的主要价值是在约束增强后保持可行候选形成和多场景综合结果，而非保证每个场景均为最低标量适应度；Scene 2 的 MSCSO 例外作为方法边界保留。
- 箱线图解释补充重复运行稳定性；消融讨论分别连接初始化进入先验、CVF 移动方向、状态调度介入时机与稀疏保持；统计与开销部分将 13/4/1 的比较结果与低于 1\% 的触发率和约 1\% 的相对评价增量合并解释。
- 未新增实验、指标或跨算法轨迹统计声明；双遍 XeLaTeX 后论文保持 13 页，渲染抽查第 9--11 页无裁切、重叠、纯浮动页或异常空白。

## 2026-07-19 第四章结果叙事统一

- 按“场景主对比 -> 重复运行分布 -> 同迭代配置下的搜索过程 -> 代表路径形态 -> 闭环消融 -> 统计证据 -> 稀疏评价开销”的顺序重写第四章分析段落，使每张表和图承担不同证据角色，并由前一层结果自然引出后一层解释。
- 主对比按 Scene 1--3 的约束递进说明结果，保留 Scene 2 中 MSCSO 标量适应度更低的例外；消融解释对应初始化进入先验、局部 CVF 方向、状态调度和稀疏保持，未增加任何新的实验或指标。
- 参考外部论文的均值摘要图思路后，未新增跨场景平均适应度柱状图：三个场景的标量适应度尺度不宜直接汇总，现有主表、箱线图和统计表已提供更完整且不重复的证据。
- 将图 3 分析文字置于图前并保持栏底浮动；收敛图和评价开销表的正文说明置于各自浮动体前。图 5 若改为普通浮动会造成整页纯浮动，故保留紧凑的就地安排以维持图文平衡。
- 双遍 XeLaTeX 后 `main.pdf` 保持 Letter 双栏 13 页；日志无 LaTeX Error、undefined reference/citation、overfull、rerun-label 或纯浮动页 warning。渲染抽查第 8--11 页未见裁切、重叠或异常空白；源文件扫描无 TODO、本机绝对路径和禁用术语。

## 2026-07-27 主对比表改为互补数据图

- 正文不再输入原主对比表。原表中的逐场景适应度均值和标准差与箱线图重复，因此改为双栏两面板摘要图：左图展示三个场景的可行率，右图展示三场景平均排名。
- 按作者意见将可行率分组柱状图改为折线图。横轴采用固定的 7 算法顺序，仅绘制 Scene 1--3 三条折线，并以不同 muted 色、线型和标记区分，避免 7 条算法曲线在可行率 $1.00$ 附近重叠。
- 按作者意见进一步将摘要图从跨栏改为单栏组合，两张子图纵向排列：可行率折线图使用 `0.95\\linewidth`，平均排名图缩小至 `0.68\\linewidth` 并居中。实际渲染位于第 9 页左栏，图例、算法标签和排名数值均可辨认。
- 新增 `make_cvf_ae_main_summary_figure.m`，只读取统一重跑结果目录中的 `selected7_summary_long.csv` 和 `selected7_average_rank.csv`，不调用优化器，不改变实验设置、运行记录、统计结果或算法集合。
- 新图保持 AE、PSO、GWO、HHO、ERIME、MSCSO、CVF-AE 的固定顺序，并复用 selected-7 的 muted SCI 配色。适应度中心、离散度和异常值继续由箱线图承担，收敛图和代表路径分别承担搜索过程与几何形态证据。
- 原 `tables/table_main_comparison.tex` 仅作为结果档案保留，不再被正文引用；关键适应度数值、Scene 2 的 MSCSO 例外和 CVF-AE 的 $1/2/1$ 场景排名仍在正文明确报告。
- MATLAB Code Analyzer 未发现问题。双遍 XeLaTeX 后 `main.pdf` 保持 Letter 双栏 13 页；日志无 LaTeX Error、undefined reference/citation、overfull、rerun-label 或纯浮动页 warning。渲染抽查第 8--11 页未见裁切、重叠或异常空白。

## 2026-07-27 消融表改为低密度摘要图

- 正文不再输入原消融结果表，原 `tables/table_ablation.tex` 仅作为完整结果档案保留。图 7 改为单栏纵向两面板：上图以热图展示 V0--V5 在 Scene 1--3 的逐场景排名，下图以三条折线展示各版本的可行率。
- 两个面板分别承担“可行解之间的相对质量”和“模块移除后的可行性退化”证据，避免继续罗列适应度、可行率、CVF 触发数和评价次数的全部组合。V0、V4、V5 的关键数据以及 V1--V3 的适应度和评价次数仍由正文明确报告。
- 新增 `make_cvf_ae_ablation_summary_figure.m`，只读取正式消融结果包中的冻结 CSV，不调用优化器，不改变实验设置、运行记录、统计结果或消融版本定义。
- MATLAB Code Analyzer 未发现问题。双遍 XeLaTeX 后 `main.pdf` 保持 Letter 双栏 13 页；日志无 LaTeX Error、undefined reference/citation、overfull、rerun-label 或纯浮动页 warning。
- 渲染抽查第 10 页：图 7 与图 8 分居两栏，图例、排名数字和可行率变化均可辨认；消融分析连续衔接，未见裁切、重叠、孤立词行或异常空白。

## 2026-07-27 图 7 等尺寸并排布局

- 图 7 的可行率折线图与排名热图统一为 `650x560` MATLAB 画布，主坐标框最终扩大为 `[0.10, 0.14, 0.88, 0.74]`，使论文中的实际绘图区接近图 3，而非仅保持外层图片尺寸一致。
- 子图顺序调整为左侧可行率、右侧排名热图。由于每个热图单元格均已直接标注精确排名，移除独立色标以避免重复信息和额外空间占用。
- PNG 导出由内容紧裁改为固定画布的 `print -dpng -r300`，两张论文图片均为 `2031x1750` 像素，避免相同 LaTeX 宽度下因导出边界不同产生视觉尺寸差异。
- 两个子图各占 `0.49\\linewidth`，在单栏内等长等宽并排，排列方式与图 3 一致。未改变消融数据、版本定义、配色或正文结论。
- MATLAB Code Analyzer 未发现问题。双遍 XeLaTeX 后 `main.pdf` 保持 Letter 双栏 13 页；第 10 页抽查确认两坐标框长宽一致、视觉面积接近图 3，文字和单元格排名可辨认，未见裁切、重叠或异常空白。

## 2026-07-27 图 3 等尺寸并排布局

- 将可行率图的 MATLAB 画布由 `1080x560` 缩小为与平均排名图一致的 `650x560`，重新分配坐标区边距，并将七个算法标签旋转 32 度以避免紧凑画布内重叠或裁切。
- 两图的坐标框统一为 `[0.20, 0.19, 0.75, 0.66]`；可行率图在创建外置图例后再次锁定该坐标框，避免图例自动压缩 (a) 的高度。由此两幅图不仅画布相同，实际坐标区的长宽也一致。
- 图 3(a) 与图 3(b) 改为各占 `0.49\\linewidth`，在单栏浮动体内等宽等高并排，不再纵向堆叠。
- 新图仍只读取冻结的 selected-seven CSV 摘要，不调用优化器，不改变实验设置、统计结果、算法顺序或正文结论。
- MATLAB Code Analyzer 未发现问题。双遍 XeLaTeX 后 `main.pdf` 保持 Letter 双栏 13 页；渲染抽查第 9 页确认两坐标框长宽一致，图例、算法标签和排名数值可辨认，未见裁切、重叠或异常空白。

## 2026-07-27 消融数值补证与图 8 精简

- 新增 6 行单栏紧凑表，仅保留消融分析正文实际引用的精确指标：V0--V5 在三个场景中的平均最终适应度、三场景平均函数评价次数，以及 Scene 3 的平均 CVF 触发数。
- 图 7 继续承担可行率与逐场景排名趋势，紧凑表不再重复可行率、排名、标准差和触发成功数，因此没有恢复原 18 行消融表的数据密度。
- 删除图 8 的 Scene 2 俯视子图，仅保留 Scene 3 代表性三维路径，用于补充主对比俯视图未展示的高度变化和三维障碍几何信息。
- 消融正文已显式引用紧凑表支撑 V0--V4 的适应度、触发次数和评价次数论断；未改变实验数据、消融版本定义或结论。
- 双遍 XeLaTeX 后 `main.pdf` 保持 Letter 双栏 13 页；日志无 LaTeX Error、undefined reference/citation、overfull 或 rerun-label。渲染抽查第 9--11 页确认新增表与图 8 清晰、无裁切、重叠或异常空白。

## 2026-07-27 恢复图 7 排名色标

- 恢复图 7 排名热力图右侧竖直色标，设置 1--6 的整数刻度并标注 `Rank`。
- 在 MATLAB 生图代码中分别固定热力图坐标区和色标位置，避免自动布局过度压缩热力图；画布尺寸、左右顺序、格内排名标注、冻结数据和配色均未改变。
- MATLAB Code Analyzer 未发现问题。重新生成图片并双遍 XeLaTeX 后，`main.pdf` 保持 Letter 双栏 13 页；第 10 页渲染确认色标、刻度、热力图数值和左侧可行率图均清晰，无裁切或重叠。

## 2026-07-27 表 4 单栏宽度扩展

- 将消融补充数值表由自然宽度 `tabular` 改为严格占满 `\linewidth` 的 `tabular*`，使用弹性列间距均匀展开六列。
- 表 4 仍为单栏表，字号、表头、数值和注释内容均未改变；上下横线与注释宽度现在对齐单栏边界。
- 双遍 XeLaTeX 后 `main.pdf` 保持 Letter 双栏 13 页；第 10 页渲染确认列间距均匀，无裁切、重叠或越栏。

## 2026-07-27 全文审查优先修订与测试图

- 正式评价指标调整为最终最佳适应度、可行率、函数评价次数和平均排名；最终违反量与预设阈值辅助复核标记不再列为主要指标，后者仍只服务轨迹可视化和结果复核。
- 明确本文可行率对应固定 $M$ 点离散评价器下的数值可行性，并在结论限制中补充尚未采用连续碰撞检测或自适应加密验证采样点间路径段。
- 第三章补充与代码一致的核心定义：四个互异差分索引的无放回抽样、质量方向的 $0.60/0.40$ 牵引与二阶差分平滑、近可行阈值及 F/P/R 筛选范围、稀疏局部修复的阶段/排序/违反量/配额和 Deb 保留条件。未写入正式三状态之外的通用代码分支。
- 修正实验设置中的高度上界歧义，并在运行时表下注明 Main、Abl.、Rate 与 Ratio 的含义。消融段落中的因果和互补措辞改为由现有结果直接支持的“提示/产生贡献”表述。
- 图 2 重画为适合单栏的上下结构示意图；图 3(a) 和图 7(a) 改为无连线点图；图 4 增加均值菱形标记并同步修改图注和正文。
- 在 `paper_ajse_zh/figures/review_previews/` 生成三个不进入正文的测试方案：图 5 后期局部放大版本、表 5 的 Cliff's delta/Holm 热图、表 6 的稀疏触发与评价次数比图。正文中的图 5、表 5 和表 6保持不变。
- 新增 `make_cvf_pressure_mapping_figure.m`、`redraw_selected7_boxplot_figure.m` 和 `make_cvf_ae_review_preview_figures.m`；更新主对比和消融摘要图脚本。所有图只读取冻结 CSV/MAT，不重跑优化、统计或实验。
- MATLAB Code Analyzer 未发现问题。最终双遍 XeLaTeX 后 `main.pdf` 为 Letter 双栏 13 页；日志无 LaTeX Error、undefined reference/citation、overfull 或 rerun-label。渲染抽查第 6、8--11 页无裁切、重叠、纯图表页或异常空白；正文源文件和 PDF 均未发现禁用对比术语、本机绝对路径或 TODO。

## 2026-07-27 图 2 对应关系、图 5 局部窗与显著性热图定稿

- 图 2 改为同一组三色采样压力的宏观/局部对应展示：上图给出三个采样点压力到控制点 $q_k$ 的映射，下图将完全相同的三支箭头平移到共同原点，并以青绿色箭头显示平均方向。正文与图注同步改为该逻辑，不再混入另一组局部分量。
- 收紧图 2 的 MATLAB 物理画布并增大图内字号，保证单栏缩放后标题、向量标签和平均方向仍可辨认。
- 将带后期迭代局部窗的图 5 正式放入正文。三个主坐标区等尺寸，三个局部窗使用完全一致的相对位置和长宽，仍只读取冻结的 selected-seven MAT 结果。
- 将原显著性表替换为 Cliff's delta/Holm 热图，保留发散色标，并在单元格中标注效应量及 $+$、$=$、$-$ 校正关系。原表文件保留在工程中但正文不再输入。
- 评价开销结果继续使用原紧凑表，表格源内容与形式未改；由于前一显著性表退出正文，其显示编号由 LaTeX 自动前移。
- 新增 `make_cvf_ae_convergence_inset_figure.m` 与 `make_cvf_ae_significance_heatmap.m`，并更新 `make_cvf_pressure_mapping_figure.m`。所有生图均只读取冻结数据或绘制方法示意，不重跑优化器、统计检验、主对比或消融实验。
- MATLAB Code Analyzer 对三个正式生图脚本均未发现问题。最终双遍 XeLaTeX 后 `main.pdf` 保持 Letter 双栏 13 页；日志无 LaTeX Error、undefined reference/citation 或 overfull。
- 渲染抽查第 6、10、11 页确认图 2 对应关系清晰、图 5 局部窗位置一致、热图色标完整、评价开销表未受挤压，未见裁切、重叠或异常空白。活动源文件未检出 TODO、本机绝对路径或禁用对比术语。

## 2026-07-28 图 1 最终取舍与闭环框架图

- 删除第二章 Deb 可行性优先流程图及其正文引用，Deb 比较规则仍由第二章文字完整说明。旧图存在候选记号不一致、与正文重复且突出标准规则而非本文创新的问题，因此不作为最终图 1。
- 新图 1 以四个连续问题组织 CVF-AE：约束感知初始化回答从哪里开始，F/P/R 状态调度回答何时介入，稀疏 CVF 候选生成回答怎样移动，保守接收与稀疏修复回答哪些修正保留。
- 群体更新后的可行性、违反程度、多样性和搜索进展反馈到状态调度，形成迭代闭环；初始化不被误画为每代重复执行。
- 图中只保留论文正式定义的 F/P/R 状态与正式算法路径，不含代码中的其他通用状态或可选分支。现有采样压力映射图自动顺延为图 2。
- 新增 `make_cvf_ae_closed_loop_framework.m`，输出正式 PNG 与矢量 PDF；脚本仅绘制方法示意，不运行优化器，并通过 MATLAB Code Analyzer。
- 使用 `[H]` 将图 1 固定在 3.2 的两段引导文字之后、3.2.1 之前，保证先提出四个问题、再展示闭环、最后逐节展开。
- 双遍 XeLaTeX 后 `main.pdf` 保持 Letter 双栏 13 页；日志无 LaTeX Error、undefined reference/citation 或 overfull。渲染抽查第 4--6 页确认章节顺序、图号、标签清晰度和双栏平衡正常，未出现纯图页或异常空白。

## 2026-07-29 删除正文闭环框架图

- 从第三章 3.2 删除 CVF-AE 闭环框架图、图注、标签及专门引出该图的描述句，避免与算法 2 和分节公式重复。
- 保留“从哪里开始、何时介入、怎样移动、是否保留”的四阶段概括，使 3.2 直接过渡到 3.2.1，方法主线不因删图中断。
- 原框架图 PDF、生成脚本及后续制作的 Draw.io 版本均保留为未被正文引用的备用素材，未删除任何实验、结果或生图资源。
- 后续正式图片由 LaTeX 自动顺延编号，交叉引用无需手工改号。
- 双遍 XeLaTeX 后 `main.pdf` 为 Letter 双栏 13 页；日志无 LaTeX Error、undefined reference/citation 或 overfull。渲染抽查第 4--5 页确认伪代码完整、双栏平衡，3.2 与 3.2.1 衔接正常。

## 2026-07-30 用户重画的 CVF 压力图单栏试排

- 将用户在 Draw.io 中重画并导出的矢量 PDF 复制到正式图目录，替换正文图 1 的现有 PDF。
- 图注同步改为“代表性主导约束压力映射、共同原点平均、曲率压力与最终 CVF 方向合成”的完整说明；正文中采样点实际压力仍由活跃分量加权叠加。
- 图前正文同步明确：颜色区分代表性主导来源，实际采样压力由活跃的非曲率分量按相应状态权重叠加，曲率分量在采样压力平均后于控制点层加入。
- 按用户要求继续使用单栏 `figure` 与 `width=\linewidth`，未切换为双栏通栏。
- 双遍 XeLaTeX 后 `main.pdf` 保持 Letter 双栏 13 页，日志无 LaTeX Error、undefined reference/citation 或 overfull。
- 第 6 页渲染确认图形完整、无裁切、重叠或异常空白；单栏缩放后图内标题、图例和下方合成标签明显小于正文，当前版本保留用于与后续通栏方案比较。

## 2026-07-30 第三章优先凝练

- 凝练 3.2.1 初始化说明，保留参考路径用途、硬约束点处理、固定走廊模板、统一 Deb 筛选和迭代阶段参考弱方向，未改变方法定义。
- 缩短图 1 前的机制复述以及 CVF 压力到有界融合的过渡句，避免重复图示、公式和分节结构已经表达的信息。
- 将 CVF 逐维截断与强度缩放合并为一个公式，并将整体范数阈值与分段截断规则合并；执行顺序、参数值和所得方向不变。
- 先定义局部平滑增量，再给出质量引导方向，删除对公式内容的重复解释。
- 修改后双遍 XeLaTeX 编译成功，`main.pdf` 保持 Letter 双栏 13 页；无 LaTeX Error、undefined reference/citation、overfull 或 rerun-label warning。
- 源文件检查未发现 TODO、本机绝对路径、禁用对比术语或已删除强度公式的陈旧引用；渲染抽查第 5--7 页未见裁切、重叠、公式断裂或异常空白。

## 2026-07-30 中文稿最终一致性审查与正式消融纠正

- 修正正式消融的控制变量继承：V1、V3 和 V4 现在与 V0 共用保守 F/P/R 状态调度；为 V3 新增独立的初始化修复开关，使其只移除迭代阶段稀疏保持而保留一次初始化修复。日志状态名同步只记录实际生效状态。
- 小规模回归确认受影响版本只出现 F/P/R 三种正式状态，V1 的 CVF 触发数为零，V3 不执行迭代修复。随后按 3 场景、6 版本、30 次运行、`N=30`、`T=300` 汇总为 540 条正式消融记录，其中重新运行 V1/V3/V4 共 270 条。
- 正式结果目录为 `results/cvf_ae_formal_ablation_corrected_20260730_v2/`，论文数据与图件目录为 `results/cvf_ae_corrected_ablation_paper_artifacts_20260730/`。完整性检查确认状态历史长度均为 300，V1 的场触发数均为 0，V3 仅保留初始化一次修复产生的少量记录。
- 重新生成消融可行率图、逐场景排名热图和 Scene 3 代表性三维路径图，并同步正文紧凑表及备用全量表。V0 三场景均排名第 1；V4 在 Scene 3 的可行率为 0.47、平均 CVF 触发数为 403.8。
- 由于三个场景批次并行启动，纠正后消融不比较跨批次壁钟时间。开销仅使用函数评价次数与 CVF 触发数；V0 相对同配置 V1 的三场景评价次数比分别为 1.002、1.001 和 1.010，平均额外评价约 0.44%。
- 第三章伪代码与公式进一步对齐实现：区分请求状态 `q_t` 与生效状态 `s_t`，修复候选仅在 Deb 更优时保留，代末统一更新最优解，补充 A* 高度偏好、状态化噪声尺度和完整复杂度项。
- 补齐“非曲率压力平均 + 状态加权曲率压力”的最终控制点增量公式，删除风险压力式中代码未使用的分母 epsilon，并将边界公式中的英文占位改为中文。
- 第四章明确消融批次独立于主对比，精确说明 V2/V3/V4 的保留机制，并移除“纠正后数据”等内部过程措辞。摘要、结论、评价开销表与正文数据已统一。
- 文献表补充 Deb 可行性规则来源，修正 Wang 与 Fu 文献文章号。最终执行 `bibtex -> xelatex -> xelatex` 及后续双遍编译，`main.pdf` 为 Letter 双栏 13 页；无 LaTeX Error、未定义引用/文献、overfull 或 rerun warning。
- 实验环境中的 MATLAB 版本由旧稿残留的 R2022b 改为 R2024b，与本机唯一安装版本及本轮正式消融实际运行环境一致。
- MATLAB Code Analyzer 对优化器、纠正结果生成器和代表路径生图器均为零问题；运行器与初始化器只保留既有的动态结构增长及 `datestr`/`now` API 更新提示，不含正确性诊断。
- 全部 13 页已渲染检查，第三、四章图文分布连续，新增公式、图表、结论与参考文献均无裁切、重叠或异常空白。活动源文件和 PDF 未检出 TODO、本机绝对路径、禁用算法/场景术语、旧消融数值或过程性纠错措辞。
