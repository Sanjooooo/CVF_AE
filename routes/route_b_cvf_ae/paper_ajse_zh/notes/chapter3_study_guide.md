# CVF-AE 第三章学习笔记（与当前论文同步）

> 阅读对象：已读过第二章、但不假设熟悉进化算法、A*、势场或约束优化的读者。
>
> 本文档按论文当前第三章的顺序逐步解释 CVF-AE。它是学习辅助材料，不替代论文正文；公式的“推导”用于阐明建模逻辑，不能理解为新的实验设定或严格的真实飞行动力学模型。

---

## 0. 第三章的总体逻辑

第二章已经规定了：一条路径怎样编码、怎样计算目标值 $J$、怎样计算违反分数 $V$，以及 Deb 可行性优先规则怎样比较候选路径。第三章只回答一个新问题：**在不推翻基础进化搜索的前提下，怎样把局部约束信息转化为少量、受限且值得保留的移动建议？**

CVF-AE 的闭环为：

```text
参考路径与约束感知初始化
              ↓
群体可行性、违反程度与进展 → 状态调度 F / P / R
              ↓
基础 AE 候选（始终生成） ──→ 少量近可行个体才生成 CVF 候选
              ↓                              ↓
                    Deb 优先 + J 不增的局部门控
                                   ↓
          早期的稀疏可行性保持 / 局部修复（仅少数候选）
                                   ↓
                 Deb 优于父代才进入下一代，并更新最优解
```

这里有四个不可混淆的角色：

| 名称 | 它做什么 | 它不做什么 |
| --- | --- | --- |
| 基础 AE | 负责每代、每个个体的主体全局搜索 | 不使用 CVF 压力场 |
| CVF | 把局部障碍、禁飞、风险、高度、边界和转弯信息写成修正方向 | 不是 $-\nabla J$ 或 $-\nabla V$ 的解析梯度 |
| 状态调度 | 决定当前更偏向形成可行解、稳定保持，还是恢复探索 | 不直接判定最终可行性 |
| Deb 规则 | 决定候选是否优于另一候选或父代 | 不构造移动方向 |

因此，CVF-AE 不是用 CVF 取代 AE，而是“**AE 始终搜索，CVF 只在必要处给出有界局部建议**”。

本文仍使用第二章的符号：$N$ 为种群规模，$T$ 为最大迭代次数，$K$ 为内部控制点数，$\mathbf X_i\in\mathbb R^{3K}$ 为第 $i$ 个候选路径，$\Pi_\Omega$ 为边界投影，$\prec_{\mathrm{Deb}}$ 为 Deb 优先关系。

---

## 1. 3.1 基础 AE 与 CVF-AE 流程

### 1.1 两个算法的共同基础

两套算法共用以下部分：

- 第二章的三次 B 样条路径编码；
- 目标函数 $J$、违反分数 $V$ 与 Deb 可行性优先规则；
- 控制点边界投影 $\Pi_\Omega$；
- 种群规模、迭代轮数和路径评价器。

差异只在候选生成：

| 算法 | 每个个体必做 | 额外步骤 |
| --- | --- | --- |
| 基础 AE | 生成一个基础 AE 候选，并用 Deb 规则同父代比较 | 无 |
| CVF-AE | 生成状态化的内部基础候选 | 对很少的合格近可行个体，再生成 CVF 候选；可能再做一次局部修复 |

### 1.2 Algorithm 1：基础 AE 的循环

基础 AE 可以概括为六步：

1. 在边界内初始化 $N$ 条候选路径；
2. 评价每条路径的 $J$ 和 $V$，按 Deb 规则得到当前最优 $\mathbf X^*$；
3. 对第 $t=1,\ldots,T$ 代中的每个父代 $\mathbf X_i$，构造基础进化方向；
4. 生成并评价基础候选 $\mathbf X_{\mathrm{AE}}$；
5. 仅当 $\mathbf X_{\mathrm{AE}}\prec_{\mathrm{Deb}}\mathbf X_i$ 时，用它替换父代；
6. 更新本代当前最优解。

“优于”首先指可行性更好，而不是单纯的 $J$ 更小。因此，一个 $J$ 很低但仍碰障碍物的候选，不会因为数值低就自动压过可行路径。

### 1.3 基础 AE 候选公式

$$
\mathbf X_{\mathrm{AE}}=
\Pi_\Omega\left(
(1-\eta_t-\mu_t)(\mathbf X_i+\mathbf D_{\mathrm{AE}})
+\eta_t\mathbf X_i+\mu_t\mathbf X_{\mathrm{elite}}
\right).
$$

| 符号 | 含义 |
| --- | --- |
| $\mathbf X_i$ | 当前父代个体 |
| $\mathbf D_{\mathrm{AE}}$ | 本次进化移动方向 |
| $\mathbf X_{\mathrm{elite}}$ | 从精英池抽取的一条优质路径 |
| $\eta_t,\mu_t$ | 随迭代进程平滑变化的组合系数 |
| $\Pi_\Omega$ | 把越界控制点截回允许的盒形边界 |

先看括号内的主移动 $\mathbf X_i+\mathbf D_{\mathrm{AE}}$，再把它、原父代和精英样本作凸组合。论文明确要求

$$
\eta_t\ge0,\qquad\mu_t\ge0,\qquad\eta_t+\mu_t\le1.
$$

因此三个系数 $1-\eta_t-\mu_t$、$\eta_t$、$\mu_t$ 均非负且和为 1：候选不会以“负权重外推”的方式离开这三项组合的范围。最后投影只负责硬边界，不评价障碍或禁飞区。

### 1.4 基础 AE 方向公式

$$
\begin{aligned}
\mathbf D_{\mathrm{AE}}
={}&a_e\mathbf r_e\odot\mathbf d_{\mathrm{elite}}
+a_b\mathbf r_b\odot\mathbf d_{\mathrm{best}}\\
&+a_d\bigl(\omega_d\mathbf d_{ab}+(1-\omega_d)\mathbf d_{cd}\bigr)
+a_s\mathbf r_s\odot\mathbf d_{\mathrm{sample}}\\
&+a_u\rho_t\boldsymbol\xi\odot(\mathbf u-\mathbf l).
\end{aligned}
$$

其中，令 $\tau=t/T$，并定义

$$
\begin{aligned}
\mathbf d_{\mathrm{best}}&=\mathbf X^*-\mathbf X_i,\\
\mathbf d_{\mathrm{elite}}&=\bar{\mathbf X}_{\mathrm{elite}}-\mathbf X_i,\\
\mathbf d_{\mathrm{sample}}&=\mathbf X_{\mathrm{elite}}-\mathbf X_i.
\end{aligned}
$$

- $\mathbf d_{\mathrm{best}}$ 牵引当前个体向全局当前最优解靠近；
- $\mathbf d_{\mathrm{elite}}$ 牵引它向精英池平均位置靠近，降低只跟随一个个体的偶然性；
- $\mathbf d_{\mathrm{sample}}$ 引向随机精英样本，保留多样化引导。

从除当前个体 $i$ 外的其余 $N-1$ 个种群成员中，等概率且不重复地随机选取四个不同的索引，记为 $a,b,c,d$，再令

$$
\mathbf d_{ab}=\mathbf X_a-\mathbf X_b,
\qquad
\mathbf d_{cd}=\mathbf X_c-\mathbf X_d.
$$

这两条差分方向反映种群当前已经探索到的变化尺度；无放回和互异要求避免把同一个个体重复用于相减而产生退化方向。$\omega_d$ 决定两条差分的相对权重。

$\mathbf r_e,\mathbf r_b,\mathbf r_s\in[0,1]^{3K}$ 是逐维独立随机向量，$\odot$ 表示逐元素相乘，所以同一条方向不会在所有坐标上以完全相同幅度作用。$\boldsymbol\xi\sim\mathcal U([-1,1]^{3K})$ 是均匀随机扰动，$\mathbf u-\mathbf l$ 将扰动缩放到各维的合法搜索范围。$a_e,a_b,a_d,a_s,a_u$ 是固定调度系数，$\rho_t$ 是随进程变化的扰动幅度。

### 1.5 Algorithm 2：CVF-AE 的额外步骤

CVF-AE 在每一代先计算请求状态 $q_t$，经保守确认后得到真正参与候选生成的生效状态 $s_t$。然后对每个个体：

1. 先生成和评价状态化内部基础候选 $\mathbf X_{\mathrm{AE}}^{(s_t)}$；
2. 只有满足稀疏触发资格时，才额外构造 $\mathbf D_{\mathrm{CVF}}$ 与 $\mathbf D_Q$，并生成 $\mathbf X_{\mathrm{CVF}}$；
3. CVF 候选必须同时在 Deb 顺序更优且 $J$ 不增加，才可替换基础候选为中间候选 $\mathbf Y$；
4. 在早期阶段，极少数 $\mathbf Y$ 可能接受一次局部可行性保持/修复；
5. 最后仍只有 $\mathbf Y\prec_{\mathrm{Deb}}\mathbf X_i$ 时才替换父代。

这意味着 CVF 候选至少要过两道门：先胜过基础候选，再胜过父代。CVF 不是强制修正，也没有跳过基础搜索。

---

## 2. 3.2.1 约束感知初始化与参考弱引导

### 2.1 参考控制序列

CVF-AE 不只完全随机初始化。它先在三维栅格上运行一次低分辨率 A*，栅格平面分辨率为 $5\,\mathrm m$、垂向分辨率为 $4\,\mathrm m$；A* 的内部搜索同时考虑占据、风险、边界和高度偏好代价。所得路线再重采样为与本文编码一致的 $K$ 个内部控制点。

设这些点为 $\{\mathbf q_k^{\mathrm{ref}}\}_{k=1}^K$，则向量化参考序列为

$$
\mathbf X_{\mathrm{ref}}=
\operatorname{vec}\left(
[(\mathbf q_1^{\mathrm{ref}})^\mathsf T,\ldots,
(\mathbf q_K^{\mathrm{ref}})^\mathsf T]^\mathsf T
\right).
$$

当 $K=2$ 时，它就是

$$
[x_1^{\mathrm{ref}},y_1^{\mathrm{ref}},z_1^{\mathrm{ref}},
x_2^{\mathrm{ref}},y_2^{\mathrm{ref}},z_2^{\mathrm{ref}}]^\mathsf T.
$$

它的用途只有两个：为部分初始个体提供潜在可行走廊附近的起点，以及在迭代时给出弱方向 $\mathbf d_{\mathrm{ref}}=\mathbf X_{\mathrm{ref}}-\mathbf X_i$。它不是基线算法，不参加主对比；也不是要让最终路径复制的硬模板。

### 2.2 自适应扰动半径

$$
r_k=\max\left(
r_{\min},
\frac{c_d\,d_{\mathrm{clr}}(\mathbf q_k^{\mathrm{ref}})}
{1+c_\phi r_{\mathrm{obj}}(\mathbf q_k^{\mathrm{ref}})}
\right).
$$

| 参数/量 | 含义 | 对半径的影响 |
| --- | --- | --- |
| $d_{\mathrm{clr}}(\mathbf q_k^{\mathrm{ref}})$ | 到障碍、禁飞区、高度边界和水平边界的最小净空 | 净空越大，允许扰动通常越大 |
| $r_{\mathrm{obj}}(\mathbf q_k^{\mathrm{ref}})$ | 第二章评价器使用的风险密度 | 风险越高，分母越大，扰动越收缩 |
| $c_d$ | 净空缩放系数 | 调节净空对半径的影响 |
| $c_\phi$ | 风险收缩系数 | 调节风险对半径的抑制 |
| $r_{\min}$ | 最小扰动半径 | 防止半径缩到零、种群失去变化 |

这一式的逻辑是：参考点若位于开阔且低风险区域，初始点可在更大范围内探索；若位于狭窄或高风险区域，就应在参考走廊附近更谨慎地扰动。

### 2.3 引导个体的生成

$$
\mathbf q_{i,k}^{(0)}=
\Pi_\Omega\left(
\mathbf q_k^{\mathrm{ref}}+\boldsymbol\epsilon_{i,k}
\right),
\qquad
\boldsymbol\epsilon_{i,k}\sim\mathcal U([-r_k,r_k]^3).
$$

这表示在第 $k$ 个参考点附近的三维立方体内均匀抽一个扰动，再投影回硬边界。部分个体采用此引导生成；其余个体仍均匀初始化。复杂布局下，固定走廊控制点模板可扩大初始覆盖。

上标 $(0)$ 表示初始化（第 $0$ 代），下标 $i$ 表示第 $i$ 个种群个体，下标 $k$ 表示该路径的第 $k$ 个内部控制点。对同一引导个体，$\{\mathbf q^{(0)}_{i,k}\}_{k=1}^{K}$ 按控制点顺序拼接为初始决策向量 $\mathbf X_i^{(0)}\in\mathbb R^{3K}$；它只用于种群初始化，后续迭代更新的是不带上标 $(0)$ 的 $\mathbf X_i$。

需要准确把握：投影只保证控制点不出规划盒。障碍物、禁飞区、转弯等仍需由相同评价器和 Deb 规则筛选；参考序列不能保证所有引导个体一开始就可行。

---

## 3. 3.2.2 状态识别与保守调度

### 3.1 三个监测量与停滞事件

令 $\mathbf X_t^*$ 是第 $t$ 代按 Deb 规则的最优个体，$J_t^*=J(\mathbf X_t^*)$。可行率和平均违反量为

$$
\rho_f=\frac1N\sum_{i=1}^N\mathbb I(\mathbf X_i\ \mathrm{feasible}),
\qquad
\bar V=\frac1N\sum_{i=1}^NV(\mathbf X_i).
$$

$\rho_f$ 表示种群中可行路径比例；$\bar V$ 表示不可行程度的总体水平。它们不可互相替代：例如两种群体可行率相同，但一种群体的不可行样本离可行边界更近，$\bar V$ 会更小。

最近 $w=15$ 个已完成迭代的相对改进为

$$
\Delta J_{\mathrm{recent}}=
\frac{\max(0,J^*_{t-w}-J_t^*)}
{\max(1,|J^*_{t-w}|)}.
$$

若目标降低，分子为正；若没有降低或反而升高，$\max(0,\cdot)$ 令其为零。分母 $\max(1,|J^*_{t-w}|)$ 防止用很小的基准数导致不稳定的相对比率。当历史长度超过窗口且 $\Delta J_{\mathrm{recent}}<10^{-4}$ 时，停滞示性变量 $\chi_{\mathrm{stag}}=1$。

### 3.2 请求状态 $q_t$ 与生效状态 $s_t$

当前论文的请求状态是：

$$
q_t=
\begin{cases}
\mathrm F,&\neg\operatorname{feasible}(\mathbf X^*),\\
\mathrm R,&\chi_{\mathrm{stag}}=1\land\rho_f<0.55\land\bar V\ge6,\\
\mathrm P,&\text{其他情况}.
\end{cases}
$$

| 状态 | 全称 | 触发含义 | 候选构造侧重 |
| --- | --- | --- | --- |
| F | Formation，形成 | 当前最优仍不可行，即种群尚无可行个体 | 参考/精英方向与均匀扰动 |
| P | Preservation，保持 | 未满足 F 或 R 条件 | 最优/精英方向与局部差分 |
| R | Recovery，恢复 | 搜索停滞、可行率不足且平均违反仍高 | 差分恢复与高斯扰动 |

形成条件具有优先权；因为 $\mathbf X^*$ 按 Deb 规则选取，$\neg\operatorname{feasible}(\mathbf X^*)$ 等价于“当前种群没有任何可行个体”。这与旧版本中还需额外低可行率或高违反阈值的 F 条件不同，现稿是“无可行解即请求 F”。

$q_t$ 只是即时请求，不直接决定候选。除 P 外的请求必须连续确认 2 代，才成为实际用于候选构造的生效状态 $s_t$；此设计抑制单代随机波动导致的频繁切换。原始识别器还记录质量细化状态，但本文保守调度只激活 F/P/R 三种状态。

### 3.3 状态化内部基础方向

定义参考弱方向 $\mathbf d_{\mathrm{ref}}=\mathbf X_{\mathrm{ref}}-\mathbf X_i$，并沿用最优、精英、样本和两条差分方向。当前状态下的内部基础方向是

$$
\begin{aligned}
\mathbf D_{\mathrm{AE}}^{(s_t)}
={}&c_b\mathbf r_b\odot\mathbf d_{\mathrm{best}}
+c_e\mathbf r_e\odot\mathbf d_{\mathrm{elite}}\\
&+c_s\mathbf r_s\odot\mathbf d_{\mathrm{sample}}
+c_r\mathbf r_r\odot\mathbf d_{\mathrm{ref}}\\
&+c_1\mathbf d_{ab}+c_2\mathbf d_{cd}\\
&+c_u\boldsymbol\xi\odot(\mathbf u-\mathbf l)
+c_g\boldsymbol\zeta\odot(\mathbf u-\mathbf l).
\end{aligned}
$$

$\boldsymbol\xi$ 是 $[-1,1]^{3K}$ 上的均匀扰动，$\boldsymbol\zeta$ 是标准高斯扰动。各 $c$ 系数由状态决定，部分随 $\tau=t/T$ 平滑变化；论文刻意不把未公开的逐项数值写成新的参数声明，而以“方向侧重”描述其机制。

内部基础候选为

$$
\mathbf X_{\mathrm{AE}}^{(s_t)}=
\Pi_\Omega\left(
(1-\nu_s)(\mathbf X_i+\mathbf D_{\mathrm{AE}}^{(s_t)})
+\nu_s\mathbf X_{\mathrm{elite}}
\right).
$$

$\nu_s$ 随进程缓慢增加，形成状态会额外增强精英锚定。这里 $\mathbf X_{\mathrm{AE}}^{(s_t)}$ 是 **CVF-AE 内部的状态化基础候选**；3.1 中不带上标的 $\mathbf X_{\mathrm{AE}}$ 则是基础 AE 的固定平衡候选，二者不可混同。

---

## 4. 3.2.3 CVF 构建与压力分量

### 4.1 从低密度路径采样点映射到控制点

CVF 不求 $J$ 的梯度，也不假设势场连续、可微。它先在低密度采样路径

$$
\widetilde{\mathcal P}=\{\widetilde{\mathbf p}_m\}_{m=1}^{\widetilde M}
$$

上计算局部压力，再把压力分配给最近的内部控制点：

$$
k^*(m)=\arg\min_{1\le k\le K}
\|\widetilde{\mathbf p}_m-\mathbf q_k\|_2.
$$

这里 $k^*(m)$ 是第 $m$ 个采样点对应的控制点编号。低密度采样数在实验中为 $\widetilde M=64$，用于候选修正，而第二章的完整评价仍使用 $M=220$ 个点。

非曲率压力集合和合成压力为

$$
\mathcal C_{\mathrm{path}}=
\{\mathrm{obs},\mathrm{nfz},\mathrm{risk},\mathrm{alt},\mathrm{bnd}\},
\qquad
\mathbf F(\widetilde{\mathbf p}_m)=
\sum_{c\in\mathcal C_{\mathrm{path}}}
\eta_c(s_t)\mathbf f_c(\widetilde{\mathbf p}_m).
$$

$\eta_c(s_t)$ 是状态相关权重：F 强化障碍、禁飞和高度压力；P 相对均衡；R 整体减弱约束牵引但保留关键安全方向。对于多个障碍物、禁飞区或风险热点，先在同类内求和：

$$
\begin{aligned}
\mathbf f_{\mathrm{obs}}(\mathbf p)&=\sum_{\mathcal B_j\in\mathcal O}\mathbf f_{\mathrm{obs}}(\mathbf p;\mathcal B_j),\\
\mathbf f_{\mathrm{nfz}}(\mathbf p)&=\sum_{\mathcal Z_j\in\mathcal Z}\mathbf f_{\mathrm{nfz}}(\mathbf p;\mathcal Z_j),\\
\mathbf f_{\mathrm{risk}}(\mathbf p)&=\sum_h\mathbf f_{\mathrm{risk}}(\mathbf p;\mathcal H_h).
\end{aligned}
$$

同一控制点可能被多个采样点命中。先计数

$$
n_k=\sum_{m=1}^{\widetilde M}
\mathbb I\left(k^*(m)=k\ \land\
\|\mathbf F(\widetilde{\mathbf p}_m)\|_2>0\right),
$$

再取平均：

$$
\Delta\mathbf q_k^{\mathrm{path}}=
\begin{cases}
\dfrac1{n_k}\displaystyle\sum_{m:k^*(m)=k,\ \|\mathbf F(\widetilde{\mathbf p}_m)\|_2>0}
\mathbf F(\widetilde{\mathbf p}_m),&n_k>0,\\[6pt]
\mathbf0,&n_k=0.
\end{cases}
$$

取平均而不直接相加，可避免某控制点仅因为附近采样点较密集就获得不成比例的大推力。

### 4.2 障碍物压力

对轴对齐盒体障碍物

$$
\mathcal B=[x_1,x_2]\times[y_1,y_2]\times[z_1,z_2],
$$

令 $\mathbf c_{\mathcal B}(\mathbf p)$ 为点 $\mathbf p$ 在盒体上最近的点。对盒外点，定义加权相对向量和距离：

$$
\mathbf d_o=[p_x-c_x,\ p_y-c_y,\ \lambda_z(p_z-c_z)]^\mathsf T,
\qquad d_o=\|\mathbf d_o\|_2.
$$

$\lambda_z$ 允许垂向差异在距离度量中有不同权重。若点位于缓冲带 $0<d_o\le r_o$ 内，则

$$
\mathbf f_{\mathrm{obs}}(\mathbf p;\mathcal B)=
\frac{r_o-d_o}{r_o}\frac{\mathbf d_o}{d_o}.
$$

右侧第二项给出“从障碍物最近点向外”的单位方向；第一项从靠近缓冲外缘的 0 线性增大到接近障碍物表面的 1。因此它只在缓冲区给出远离障碍物的建议。当前缓冲半径为 $r_o=7\,\mathrm m$。

若点已在障碍物内部，采用更强的外推：

$$
\mathbf f_{\mathrm{obs}}(\mathbf p;\mathcal B)=
(r_o+d_{\min})\mathbf n_{\min}.
$$

$d_{\min}$ 是到最近水平外侧面的穿透深度，$\mathbf n_{\min}$ 是该面的外法向；内部压力强度随穿透增加。它是生成候选的提示，而不是最后可行性判定本身。

### 4.3 禁飞区压力

第 $j$ 个柱状禁飞区写作

$$
\mathcal Z_j=(\mathbf c_j,r_j,z_j^-,z_j^+).
$$

其中 $\mathbf c_j$ 是水平中心，$r_j$ 是柱体半径，$[z_j^-,z_j^+]$ 是它的有效高度范围。若 $p_z$ 不在该高度范围内，禁飞区压力为零；否则令

$$
\mathbf d_j=[p_x-c_{j,x},p_y-c_{j,y},0]^\mathsf T,
\qquad d_j=\|\mathbf d_j\|_2,
$$

并取

$$
\mathbf f_{\mathrm{nfz}}(\mathbf p;\mathcal Z_j)=
\begin{cases}
(r_j-d_j+r_n)\dfrac{\mathbf d_j}{d_j},&d_j\le r_j,\\[6pt]
\dfrac{r_j+r_n-d_j}{r_n}\dfrac{\mathbf d_j}{d_j},&r_j<d_j\le r_j+r_n,\\[6pt]
\mathbf0,&d_j>r_j+r_n.
\end{cases}
$$

| 位置 | 压力含义 |
| --- | --- |
| 柱体内部 $d_j\le r_j$ | 较强水平向外推出 |
| 外部缓冲带 $r_j<d_j\le r_j+r_n$ | 距离越远压力越小 |
| 缓冲带外 | 不施加该分量 |

$r_n=7\,\mathrm m$ 是外侧缓冲半径。中心附近 $d_j\approx0$ 时，代码采用固定水平单位方向，避免分母为零。

### 4.4 风险热点压力

第 $h$ 个风险热点为 $\mathcal H_h=(\mathbf c_h,\sigma_h,a_h)$。其用于 CVF 的风险场为

$$
\widetilde{\mathbf d}_h=
[p_x-c_{h,x},p_y-c_{h,y},\lambda_z(p_z-c_{h,z})]^\mathsf T,
$$

$$
\phi_h^{\mathrm{CVF}}(\mathbf p)=
a_h\exp\left(-\frac{\|\widetilde{\mathbf d}_h\|_2^2}{2\sigma_h^2}\right).
$$

这是以热点中心为峰值的高斯型分布：在中心为 $a_h$，随着加权距离增大而快速衰减。仅当 $\phi_h^{\mathrm{CVF}}(\mathbf p)>\phi_0$ 时，施加

$$
\mathbf f_{\mathrm{risk}}(\mathbf p;\mathcal H_h)=
\kappa_r(\phi_h^{\mathrm{CVF}}(\mathbf p)-\phi_0)
\frac{\widetilde{\mathbf d}_h}{\|\widetilde{\mathbf d}_h\|_2}.
$$

它指向远离热点中心的方向。$\phi_0=0.24$ 是激活阈值，$\kappa_r=1.80$ 是强度系数；中心点附近使用固定单位方向处理除零。

**最容易混淆处：** 这里的 $\phi_h^{\mathrm{CVF}}$ 只服务 CVF 候选方向；第二章目标函数中的风险密度是 $r_{\mathrm{obj}}(\mathbf p)$。两者不共享同一距离模型或高度调制，不能把本式直接代入第二章的风险项 $R$。

### 4.5 高度与边界压力

令 $z_l=z_{\min}$、$z_u=z_{\max}$。高度标量压力为

$$
f_{\mathrm{alt},z}(\mathbf p)=
\begin{cases}
z_l-p_z,&p_z<z_l,\\
z_u-p_z,&p_z>z_u,\\
\lambda_z(z_l+b_z-p_z),&z_l\le p_z<z_l+b_z,\\
-\lambda_z(p_z-z_u+b_z),&z_u-b_z<p_z\le z_u,\\
0,&\text{其他情况}.
\end{cases}
$$

若低于下界，压力为正，推向上方；若高于上界，压力为负，推向下方。即使尚未越界，进入宽度 $b_z=3\,\mathrm m$ 的缓冲带也会被温和地推向可用高度范围内部。

将硬高度边界压力与参考高度弱引导组合为三维向量：

$$
\mathbf f_{\mathrm{alt}}(\mathbf p)=
\left[0,0,
f_{\mathrm{alt},z}(\mathbf p)+\lambda_{\mathrm{ref}}(z_{\mathrm{ref}}-p_z)
\right]^\mathsf T.
$$

$z_{\mathrm{ref}}$ 项只使 CVF 候选弱地朝参考高度靠近；它**不进入第二章的目标函数 $J$，也不改变硬高度约束**。

水平方向以 $x$ 为例：

$$
f_{\mathrm{bnd},x}(\mathbf p)=
\begin{cases}
x_{\min}+b_b-p_x,&p_x<x_{\min}+b_b,\\
x_{\max}-b_b-p_x,&p_x>x_{\max}-b_b,\\
0,&\text{其他情况}.
\end{cases}
$$

$y$ 方向同理，三维边界压力为

$$
\mathbf f_{\mathrm{bnd}}(\mathbf p)=
[f_{\mathrm{bnd},x}(\mathbf p),f_{\mathrm{bnd},y}(\mathbf p),0]^\mathsf T.
$$

$b_b=6\,\mathrm m$ 是 CVF 的水平边界压力宽度；它不同于参考路径构造中的边界偏好裕度 $m_b=12\,\mathrm m$。前者是第三章的局部候选压力，后者仅影响参考路径构造。真正不出规划盒仍由 $\Pi_\Omega$ 保证。

### 4.6 转弯压力

转弯压力不从路径采样点映射，而直接在控制点层处理。用控制点替换第二章转角公式中的采样点，得到局部转角 $\vartheta_k$。其启动阈值为

$$
\theta_c=\alpha_{\mathrm{curv}}\theta_{\max},
$$

其中 $\alpha_{\mathrm{curv}}=0.85$，$\theta_{\max}=55^\circ$。当 $\vartheta_k\ge\theta_c$ 时，施加

$$
\mathbf F_{k,\mathrm{curv}}=
\gamma_{\mathrm{curv}}
\left[\tfrac12(\mathbf q_{k-1}+\mathbf q_{k+1})-\mathbf q_k\right],
$$

否则 $\mathbf F_{k,\mathrm{curv}}=\mathbf0$。括号中是相邻两控制点中点减当前点，即将当前点拉向局部中点的平滑方向；$\gamma_{\mathrm{curv}}=0.22$ 控制其强度。

最终控制点增量为

$$
\Delta\mathbf q_k=
\Delta\mathbf q_k^{\mathrm{path}}
+\eta_{\mathrm{curv}}(s_t)\mathbf F_{k,\mathrm{curv}}.
$$

前一项来自障碍、禁飞、风险、高度和边界采样压力的平均；后一项是状态加权的控制点层曲率修正。二者在此才合成，避免把曲率错误地当成另一个采样压力。

---

## 5. 3.2.4 有界融合与稀疏接收

### 5.1 向量化与逐维截断

把 $K$ 个控制点增量首尾拼接：

$$
\widetilde{\mathbf D}_{\mathrm{CVF}}=
\operatorname{vec}\left([
\Delta\mathbf q_1^\mathsf T,\ldots,
\Delta\mathbf q_K^\mathsf T]^\mathsf T\right).
$$

随后施加逐维对称截断并缩放：

$$
\mathbf D_{\mathrm{CVF}}^{(0)}=
\kappa_{\mathrm{cvf}}
\left[
\operatorname{clip}
\left(\widetilde D_{\mathrm{CVF},j},
\rho_{\mathrm{step}}(u_j-l_j)\right)
\right]_{j=1}^{3K}.
$$

这里 $\operatorname{clip}(x,a)$ 表示把 $x$ 限制到 $[-a,a]$。所以第 $j$ 个坐标的压力步长不会超过该坐标搜索范围 $(u_j-l_j)$ 的 $\rho_{\mathrm{step}}$ 倍。实验中 $\rho_{\mathrm{step}}=0.040$、$\kappa_{\mathrm{cvf}}=0.65$。

### 5.2 整体范数截断

逐维截断还不能排除“很多维都各走一点，合起来却很大”的情形。因此再定义

$$
h_{\mathrm{cvf}}=\rho_{\mathrm{norm}}\|\mathbf u-\mathbf l\|_2,
$$

$$
\mathbf D_{\mathrm{CVF}}=
\begin{cases}
\mathbf D_{\mathrm{CVF}}^{(0)},
&\|\mathbf D_{\mathrm{CVF}}^{(0)}\|_2\le h_{\mathrm{cvf}},\\[4pt]
\dfrac{h_{\mathrm{cvf}}\mathbf D_{\mathrm{CVF}}^{(0)}}
{\|\mathbf D_{\mathrm{CVF}}^{(0)}\|_2},
&\text{其他情况}.
\end{cases}
$$

当向量总长度过大时，第二行只缩小其长度、保留方向。当前 $\rho_{\mathrm{norm}}=0.085$。逐维截断与范数截断共同保证 CVF 只能产生有限的局部修正，而不会一次改写整条路径。

### 5.3 质量引导方向

CVF 主要回答“怎样靠近可行区域”；质量方向补充“怎样不明显牺牲当前较优解结构”。内部控制点的局部平滑增量为

$$
\Delta\mathbf q_{\mathrm{sm},k}=
0.10(\mathbf q_{k-1}-2\mathbf q_k+\mathbf q_{k+1}),
\qquad k=2,\ldots,K-1.
$$

两端控制点的平滑增量为零。该式仍是二阶差分：如果当前点偏离邻点连线，它将被拉回邻点中间。

向量化后记为 $\mathbf D_{\mathrm{sm}}$，取 $\omega_Q=0.60$、$\boldsymbol\rho_Q=0.05(\mathbf u-\mathbf l)$：

$$
\begin{aligned}
\mathbf G_Q&=0.60(\mathbf X^*-\mathbf X_i)
+0.40(\mathbf X_{\mathrm{elite}}-\mathbf X_i),\\
\mathbf D_Q&=
\operatorname{clip}(\mathbf G_Q+\mathbf D_{\mathrm{sm}},\boldsymbol\rho_Q).
\end{aligned}
$$

因此 $\mathbf D_Q$ 同时向当前最优、一个精英样本靠近，并带有小幅局部平滑；最后同样逐维限幅。

### 5.4 三方向融合与 CVF 候选

$$
\mathbf D_s=
\alpha_s\mathbf D_{\mathrm{AE}}^{(s_t)}
+\beta_s\mathbf D_{\mathrm{CVF}}
+\gamma_s\mathbf D_Q,
$$

$$
\mathbf X_{\mathrm{CVF}}=
\Pi_\Omega\Bigl(
(1-\mu_t)(\mathbf X_i+\mathbf D_s)
+\mu_t\mathbf X_{\mathrm{elite}}
\Bigr).
$$

三组融合系数如下：

| 生效状态 $s_t$ | $(\alpha_s,\beta_s,\gamma_s)$ | 含义 |
| --- | --- | --- |
| F | $(.80,.40,.04)$ | 适当增强 CVF，帮助形成可行趋势 |
| P | $(.90,.38,.06)$ | 以基础搜索为主，持续较均衡修正 |
| R | $(.90,.28,.04)$ | 降低 CVF 对恢复探索的限制 |

它们是三个独立的缩放系数，不是概率，**不要求和为 1**。基础候选始终生成，而 CVF 候选只对被触发个体生成。

### 5.5 稀疏触发配额

设状态 $s_t$ 的名义触发比例为 $r_{s_t}$，则每代实际 CVF 触发个数满足

$$
N_{\mathrm{cvf}}^{(t)}
\le\max\{1,\operatorname{round}(r_{s_t}N)\}.
$$

可触发对象必须是近可行不可行个体：

$$
\varepsilon_v<V(\mathbf X_i)\le15.
$$

F/P 只在当前标量适应度前 $45\%$ 的这类对象中寻找，R 可在全部近可行对象中寻找；实现随后按种群索引顺序遍历合格对象直到配额用完，并非再按名次逐个挑选。名义比例为

$$
r_F=0.06,\qquad r_P=0.06,\qquad r_R=0.04.
$$

当种群已出现可行最优解后，CVF 只每 3 代检查一次，且单代比例不超过 $0.03$。这层设计控制了额外评价次数，也避免在已经找到可行区后让 CVF 接管主体搜索。

### 5.6 保守局部接收与稀疏可行性保持

对同一父代生成的基础候选与 CVF 候选，CVF 候选仅在同时满足

$$
\mathbf X_{\mathrm{CVF}}\prec_{\mathrm{Deb}}\mathbf X_{\mathrm{AE}}^{(s_t)},
\qquad
J(\mathbf X_{\mathrm{CVF}})\le J(\mathbf X_{\mathrm{AE}}^{(s_t)})
$$

时才被选为 $\mathbf Y$；否则 $\mathbf Y=\mathbf X_{\mathrm{AE}}^{(s_t)}$。

第一项要求约束意义上更好，第二项要求带惩罚综合适应度不变差。二者同时存在，防止某个 CVF 修正虽降低某类违反量，却明显牺牲综合质量。

此外，稀疏可行性保持发生在候选生成之后：

- 仅当 $\tau\ge0.15$；
- 仅从标量适应度前 $30\%$ 的候选中选取；
- 还要满足 $\varepsilon_v<V(\mathbf Y)\le25$；
- 单代最多 $\max\{1,\operatorname{round}(0.08N)\}$ 个；
- 每个入选候选仅进行一次碰撞、禁飞区、转弯局部修复与风险降低校正；
- 修复结果 $\mathbf X_{\mathrm{rep}}$ 只有在 $\mathbf X_{\mathrm{rep}}\prec_{\mathrm{Deb}}\mathbf Y$ 时才保留。

它不是对整个种群反复运行的第二个优化器，而是对少数有希望的不可行候选作一次有限修复。即使经过本地门控或修复，最终仍需 Deb 优于父代，才会进入下一代。

---

## 6. 3.3 算法复杂度

记：

| 符号 | 含义 |
| --- | --- |
| $N$ | 种群规模 |
| $T$ | 最大迭代次数 |
| $M$ | 完整路径评价采样数 |
| $\widetilde M$ | CVF 低密度采样数 |
| $K$ | 内部控制点数 |
| $G$ | 空间约束元素数 |
| $N_{\mathrm{cvf}}$ | 每代 CVF 触发数 |
| $N_{\mathrm{rep}}$ | 每代局部修复触发数 |
| $N_{\mathrm{init}}$ | 初始化阶段需要修复的个体数 |
| $Q$ | A* 栅格节点数 |

一次完整路径评价要在 $M$ 个点处理空间元素和控制点关系，代价为

$$
O\bigl(M(G+K)\bigr).
$$

基础搜索一共评价约 $TN$ 个候选，主工作量为

$$
O\bigl(TNM(G+K)\bigr).
$$

CVF 和局部修复的额外迭代工作量为

$$
O\left(
T\{N_{\mathrm{cvf}}[M+\widetilde M]+N_{\mathrm{rep}}M\}(G+K)
\right).
$$

式中 CVF 触发需要额外处理低密度压力场和完整候选评价，修复需要完整路径处理。初始化时还要评价 $N$ 个初始个体，至多修复 $N_{\mathrm{init}}$ 个个体，其主导开销为

$$
O\bigl((N+N_{\mathrm{init}})M(G+K)\bigr).
$$

参考路径预处理还包括 $O(QG)$ 的栅格占据与代价构造，以及数组扫描开放集实现的 A* 核心搜索 $O(Q^2)$。候选向量更新、状态统计和种群排序不属于这里统计的完整路径评价成本。由于设计目标是 $N_{\mathrm{cvf}},N_{\mathrm{rep}}\ll N$，CVF-AE 的额外开销由少量关键候选承担，而非扩展到全种群，因此其主导渐近复杂度仍为

$$
O\bigl(TNM(G+K)\bigr).
$$

---

## 7. 阅读时应把握的主线

1. **先区分评价与生成。** $J$、$V$ 和 Deb 规则负责评价与筛选；CVF 只负责提出移动建议。
2. **参考路径是弱先验。** A* 序列帮助初始化和提供弱方向，不是外部对比算法，也不强制最终路径跟随它。
3. **F/P/R 是介入侧重，不是三套独立算法。** F 在尚无可行解时形成走廊，P 稳定搜索，R 在停滞且可行性不足时恢复探索。
4. **CVF 不是连续势场或梯度法。** 它由分段局部几何规则构成，压力可在边界处跳变；安全和质量是否接受仍由后续规则决定。
5. **压力先在路径层计算、再映射到控制点。** 障碍、禁飞、风险、高度和边界属于采样压力；曲率直接在控制点层计算，之后才合成。
6. **有界融合与稀疏触发共同限制 CVF。** 逐维截断、范数截断、很小配额、局部双重门控和父代 Deb 替换，防止 CVF 过度干预。
7. **最终目标不变。** 无论候选来自基础 AE、CVF 还是局部修复，只有按 Deb 规则优于父代才保留；基础 AE 始终承担全局搜索主体。

把第三章缩成一行：

$$
\text{参考弱先验}
\rightarrow \text{状态识别}
\rightarrow \text{基础候选 + 稀疏有界 CVF 候选}
\rightarrow \text{保守接收/修复}
\rightarrow \text{Deb 父代替换}.
$$
