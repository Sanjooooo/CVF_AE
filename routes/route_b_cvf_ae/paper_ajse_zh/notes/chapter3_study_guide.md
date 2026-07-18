# CVF-AE 第三章学习笔记

本文档整理论文《CVF-AE 方法》第 3 章的学习说明，便于将公式、符号和算法流程连起来理解。它是阅读辅助材料，不替代论文正文；其中未公开逐项数值的固定实现常数，仍以论文中的语义描述为准。

## 0. 第三章的总体逻辑

基础 AE 通过种群差分、精英和随机扰动产生候选路径。CVF-AE 在其基础上增加四个环节：

1. 用参考路径和约束信息产生一部分更有希望可行的初始个体；
2. 根据种群可行性、违反量、多样性和进展，选择形成、保持或恢复状态；
3. 将局部障碍物、禁飞区、风险、边界和转弯压力转为控制点修正方向；
4. 只对少数近可行候选启用该修正，并以严格的局部规则接收结果。

可概括为：

$$
\text{种群/路径几何信息}
\rightarrow \text{有界 CVF 候选}
\rightarrow \text{保守局部接收}
\rightarrow \text{Deb 父代替换}.
$$

记路径的 $K$ 个内部控制点为 $\mathbf q_k\in\mathbb R^3$。将其依次拼接后，优化变量为 $\mathbf X\in\mathbb R^{3K}$。$\Pi_\Omega(\cdot)$ 表示把候选投影回变量可行边界 $\Omega$；$\prec_{\mathrm{Deb}}$ 表示第 2 章定义的 Deb 可行性优先关系。

---

## 1. 3.1 基础 AE 与 CVF-AE 流程

### 1.1 两个算法的共同基础

基础 AE 与 CVF-AE 使用相同的路径编码、目标函数 $J(\mathbf X)$、总违反分数 $V(\mathbf X)$、边界投影和 Deb 规则。它们的区别不在于路径如何评价，而在于如何产生候选：

- **基础 AE**：每个个体只产生基础进化候选；
- **CVF-AE**：仍生成基础候选，但少数被触发的个体还会生成一个 CVF 候选，并执行更严格的局部比较。

因此，CVF-AE 不是另一套独立规划器，而是基础 AE 的约束引导增强版本。

### 1.2 Algorithm 1：基础 AE 的循环

对每一代、每个个体 $\mathbf X_i$：

1. 构造基础方向 $\mathbf D_{\mathrm{AE}}$；
2. 生成并评价候选 $\mathbf X_{\mathrm{AE}}$；
3. 若 $\mathbf X_{\mathrm{AE}}\prec_{\mathrm{Deb}}\mathbf X_i$，用候选替换父代；
4. 更新当前最优个体 $\mathbf X^*$。

Deb 规则的作用是先比较可行性：可行解优于不可行解；同为不可行时违反分数较低者优先；同为可行时再比较目标值。

### 1.3 基础 AE 候选公式

$$
\mathbf X_{\mathrm{AE}}=
\Pi_\Omega\left(
(1-\eta_t-\mu_t)(\mathbf X_i+\mathbf D_{\mathrm{AE}})
+\eta_t\mathbf X_i+\mu_t\mathbf X_{\mathrm{elite}}
\right).
$$

符号含义：

- $\mathbf X_i$：第 $i$ 个父代路径；
- $\mathbf D_{\mathrm{AE}}$：本次进化移动方向；
- $\mathbf X_{\mathrm{elite}}$：从精英池抽取的个体；
- $\eta_t,\mu_t$：随迭代进程平滑变化的组合系数；
- $\Pi_\Omega$：边界投影。

这是一种“基础移动、保留当前个体、向精英回拉”的组合。作为凸组合使用时，三个系数应保持非负；$\eta_t$ 和 $\mu_t$ 越大，候选越保守、越受现有个体或精英影响。

### 1.4 基础 AE 方向公式

$$
\begin{aligned}
\mathbf D_{\mathrm{AE}}
={}&a_e\mathbf r_e\odot\mathbf d_{\mathrm{elite}}
+a_b\mathbf r_b\odot\mathbf d_{\mathrm{best}}\\
&+a_d\left(\omega_d\mathbf d_{ab}+(1-\omega_d)\mathbf d_{cd}\right)
+a_s\mathbf r_s\odot\mathbf d_{\mathrm{sample}}\\
&+a_u\rho_t\boldsymbol\xi\odot(\mathbf u-\mathbf l).
\end{aligned}
$$

方向项含义如下：

- $\mathbf d_{\mathrm{best}}=\mathbf X^*-\mathbf X_i$：从当前个体指向当前最优解；
- $\mathbf d_{\mathrm{elite}}=\bar{\mathbf X}_{\mathrm{elite}}-\mathbf X_i$：从当前个体指向精英均值；
- $\mathbf d_{\mathrm{sample}}=\mathbf X_{\mathrm{elite}}-\mathbf X_i$：从当前个体指向一个精英样本；
- $\mathbf d_{ab}=\mathbf X_a-\mathbf X_b$、$\mathbf d_{cd}=\mathbf X_c-\mathbf X_d$：随机差分方向；
- $\mathbf r_e,\mathbf r_b,\mathbf r_s$：定义在 $[0,1]^{3K}$ 的独立逐维随机向量；
- $\boldsymbol\xi\sim\mathcal U([-1,1]^{3K})$：逐维均匀随机扰动；
- $\odot$：逐元素相乘；
- $a_e,a_b,a_d,a_s,a_u$：精英、最优、差分、采样和随机扰动的固定调度系数；
- $\omega_d$：两个差分方向的组合权重；
- $\rho_t$：随机扰动的进程相关幅度；论文公式用该符号表达扰动调度，未在本节单独展开其数值规律；
- $\mathbf u-\mathbf l$：各维搜索范围，用于使随机扰动适应变量尺度。

随机差分的构造很直接：从种群中随机抽取索引 $a,b,c,d$（通常排除当前个体 $i$），形成两条向量差。若 $\mathbf X_a$ 与 $\mathbf X_b$ 在某些控制点坐标上差异大，$\mathbf d_{ab}$ 就在这些坐标上提供更强的探索方向。差分项的价值在于利用种群内部已形成的空间结构，而不是只朝单个最优解收缩。

### 1.5 Algorithm 2：CVF-AE 的额外步骤

CVF-AE 在每代先识别状态并获得生效状态 $s_t$。对每个个体，先始终生成基础候选 $\mathbf X_{\mathrm{AE}}$。仅当个体满足稀疏触发条件时，才额外构造 $\mathbf D_{\mathrm{CVF}}$ 和质量方向 $\mathbf D_{\mathrm Q}$，得到 $\mathbf X_{\mathrm{CVF}}$。

若 CVF 候选同时在 Deb 顺序上优于基础候选、且目标值不更差，才将其作为待替换候选；否则保留基础候选。少量候选还会进入局部可行性保持步骤。最后，无论来自哪条支路，候选仍需在 Deb 规则下优于父代，才能替换父代。

---

## 2. 3.2.1 约束感知初始化与参考弱引导

### 2.1 参考控制序列

CVF-AE 除随机初始化外，引入一条低分辨率参考控制序列。它通过平面分辨率 $\SI{5}{m}$、垂向分辨率 $\SI{4}{m}$ 的三维栅格搜索得到，并综合占据、风险和边界代价。该序列仅作为 CVF-AE 的内部初始化与弱方向先验，**不是主对比算法**。

重采样后，参考控制点为 $\{\mathbf q_k^{\mathrm{ref}}\}_{k=1}^{K}$，其中：

$$
\mathbf q_k^{\mathrm{ref}}=
\begin{bmatrix}x_k^{\mathrm{ref}}&y_k^{\mathrm{ref}}&z_k^{\mathrm{ref}}\end{bmatrix}^{\mathsf T}.
$$

其向量化形式为：

$$
\mathbf X_{\mathrm{ref}}=
\mathrm{vec}\left(
[(\mathbf q_1^{\mathrm{ref}})^\mathsf T,\ldots,
(\mathbf q_K^{\mathrm{ref}})^\mathsf T]^\mathsf T
\right).
$$

例如 $K=3$ 时，$\mathbf X_{\mathrm{ref}}=[x_1,y_1,z_1,x_2,y_2,z_2,x_3,y_3,z_3]^\mathsf T$。因此它能与个体 $\mathbf X_i$ 直接相减，并构成后续弱引导方向：

$$
\mathbf d_{\mathrm{ref}}=\mathbf X_{\mathrm{ref}}-\mathbf X_i.
$$

“弱引导”意味着它只是候选方向中的一项，不要求路径严格贴合参考序列。

### 2.2 自适应扰动半径

围绕第 $k$ 个参考控制点的扰动半径为：

$$
r_k=
\max\left(
r_{\min},
\frac{c_d d_{\mathrm{clr}}(\mathbf q_k^{\mathrm{ref}})}
{1+c_\phi\phi(\mathbf q_k^{\mathrm{ref}})}
\right).
$$

- $d_{\mathrm{clr}}(\cdot)$：到障碍物、禁飞区、高度边界和水平边界的最小裕度；
- $\phi(\cdot)$：风险场强度；
- $c_d$：把净空转换为扰动范围的比例系数；
- $c_\phi$：风险对扰动范围的抑制系数；
- $r_{\min}$：最小扰动半径。

该式体现的机制是：净空越大，允许探索的局部范围越大；风险越高，扰动范围越小；即使在狭窄区域，也保留 $r_{\min}$ 以避免种群完全失去差异。

### 2.3 引导个体的生成

$$
\mathbf q_{i,k}^{(0)}=
\Pi_\Omega\left(
\mathbf q_k^{\mathrm{ref}}+\boldsymbol\epsilon_{i,k}
\right),
\qquad
\boldsymbol\epsilon_{i,k}\sim\mathcal U([-r_k,r_k]^3).
$$

- $\mathbf q_{i,k}^{(0)}$：第 $i$ 个初始个体的第 $k$ 个控制点；
- $\boldsymbol\epsilon_{i,k}$：三个坐标上独立的均匀随机扰动；
- $\Pi_\Omega$：越界时投影回允许的变量范围。

若扰动点进入硬约束内部，会先投影到边界内并作局部外推。其余个体仍采用均匀随机初始化，因此种群并不会全部挤在参考路径周围。复杂障碍布局下可使用固定走廊控制点模板扩展初始覆盖；模板、参考序列和其余样本都经同一目标函数和 Deb 规则筛选。

---

## 3. 3.2.2 状态识别与保守调度

### 3.1 四个监测量

可行率和平均违反量为：

$$
\rho_f=\frac{1}{N}\sum_{i=1}^{N}
\mathbb I(\mathbf X_i\ \mathrm{feasible}),
\qquad
\bar V=\frac{1}{N}\sum_{i=1}^{N}V(\mathbf X_i).
$$

- $\mathbb I(\cdot)$：示性函数，条件成立为 1，否则为 0；
- $\rho_f$：种群中可行个体的比例；
- $\bar V$：种群总违反分数的平均值。

多样性为：

$$
D_{\mathrm{pop}}=
\frac{1}{3K}\sum_{j=1}^{3K}
\mathrm{std}\left(
\frac{X_{1j},\ldots,X_{Nj}}{u_j-l_j}
\right).
$$

- $X_{ij}$：第 $i$ 个个体在第 $j$ 维的值；
- $u_j,l_j$：第 $j$ 维的上、下边界；
- $\mathrm{std}$：种群在该维度的标准差。

先用 $u_j-l_j$ 标准化，是为了消除不同坐标轴取值范围的影响。$D_{\mathrm{pop}}$ 小说明种群逐渐聚集，可能陷入局部区域。

近期相对改进为：

$$
\Delta J_{\mathrm{recent}}=
\frac{\max(0,J^*_{t-w}-J^*_{t})}
{\max(1,|J^*_{t-w}|)},
\qquad w=15.
$$

- $J_t^*$：第 $t$ 代当前最优个体的目标值；
- $w=15$：回看窗口；
- 分子只记录有效下降，防止把退化当作改进；
- 分母避免目标值接近零时数值不稳定。

当

$$
\Delta J_{\mathrm{recent}}<10^{-4}
\quad\land\quad
(D_{\mathrm{pop}}<0.08\lor t>2w)
$$

时，搜索被识别为停滞，记其示性函数为 $\chi_{\mathrm{stag}}$。

### 3.2 请求状态 $q_t$ 与生效状态 $s_t$

$$
q_t=
\begin{cases}
\mathrm F,&
\neg\mathrm{feasible}(\mathbf X^*)
\land(\rho_f\leq0.10\lor\bar V\geq18),\\
\mathrm R,&
\chi_{\mathrm{stag}}=1\land\rho_f<0.55\land\bar V\geq6,\\
\mathrm P,&\mathrm{otherwise}.
\end{cases}
$$

- **F（Formation，形成）**：当前最好路径仍不可行，且可行率很低或平均违反严重。目标是优先进入或扩展可行区域；
- **R（Recovery，恢复）**：搜索停滞、可行率仍不高且违反量仍较大。目标是恢复探索能力；
- **P（Preservation，保持）**：其余常规情形。目标是在已有可行基础上稳定优化路径质量。

形成条件优先于恢复条件。$q_t$ 只是根据本代指标得到的**请求状态**；实际用于候选构造的是**生效状态** $s_t$。F 或 R 请求需要连续确认两代后才生效，避免单代波动造成状态来回切换。保持状态之外的请求受到这一确认机制约束。

### 3.3 状态化基础方向

在生效状态 $s_t$ 下，内部基础方向写作：

$$
\begin{aligned}
\mathbf D_{\mathrm{AE}}^{(s_t)}
={}&c_b\mathbf r_b\odot\mathbf d_{\mathrm{best}}
+c_e\mathbf r_e\odot\mathbf d_{\mathrm{elite}}
+c_s\mathbf r_s\odot\mathbf d_{\mathrm{sample}}\\
&+c_r\mathbf r_r\odot\mathbf d_{\mathrm{ref}}
+c_1\mathbf d_{ab}+c_2\mathbf d_{cd}
+c_u\boldsymbol\xi+c_g\boldsymbol\zeta.
\end{aligned}
$$

- $\boldsymbol\xi$、$\boldsymbol\zeta$：分别为均匀和高斯扰动；
- $c_b$ 至 $c_g$：按状态固定的方向系数；
- 其余差分、最优、精英、采样和参考方向见前文。

相应基础候选为：

$$
\mathbf X_{\mathrm{AE}}=
\Pi_\Omega\left(
(1-\nu_s)(\mathbf X_i+\mathbf D_{\mathrm{AE}}^{(s_t)})
+\nu_s\mathbf X_{\mathrm{elite}}
\right).
$$

$\nu_s$ 是随进程缓慢增加的精英牵引系数，在形成状态略增强。论文用“方向侧重”概括固定实现系数：F 更重视参考/精英与均匀扰动，P 更重视最优/精英与局部差分，R 更重视差分恢复与高斯扰动。

---

## 4. 3.2.3 CVF 构建与压力分量

CVF 不是 $-\nabla J$ 或 $-\nabla V$ 形式的解析梯度。它是从路径局部几何和约束信息中构成的、有界的控制点修正方向。

### 4.1 从路径采样点映射到控制点

给定低密度路径采样集 $\widetilde{\mathcal P}=\{\widetilde{\mathbf p}_m\}_{m=1}^{\widetilde M}$，采样点 $m$ 的压力归入最近控制点：

$$
k^*(m)=\arg\min_{1\leq k\leq K}
\|\widetilde{\mathbf p}_m-\mathbf q_k\|_2.
$$

$k^*(m)$ 是最近控制点的索引。该映射把路径局部的几何问题转化为对优化变量中对应控制点的修改。

第 $k$ 个控制点的总场方向为：

$$
\mathbf F_k=
\sum_{c\in\mathcal C}\eta_c(s_t)\mathbf F_{k,c},
\qquad
\mathcal C=
\{\mathrm{obs},\mathrm{nfz},\mathrm{risk},\mathrm{alt},\mathrm{curv},\mathrm{bnd}\}.
$$

- $\mathbf F_{k,c}$：第 $c$ 类压力分量；
- $\eta_c(s_t)$：当前生效状态下该分量的权重；
- 六类压力依次表示障碍物、禁飞区、风险、高度、转弯和水平边界。

多个采样点命中同一控制点时，取平均而非累加：

$$
\Delta\mathbf q_k^{\mathrm{path}}=
\begin{cases}
\dfrac{1}{n_k}\sum_{m:k^*(m)=k}
\mathbf F(\widetilde{\mathbf p}_m),&n_k>0,\\
\mathbf0,&n_k=0.
\end{cases}
$$

$n_k$ 是映射到第 $k$ 个控制点且压力非零的采样点数。平均可以避免采样密度差异导致某一个控制点被不成比例地推动。曲率分量直接基于控制点序列计算，随后与 $\Delta\mathbf q_k^{\mathrm{path}}$ 相加。

### 4.2 障碍物压力

对轴对齐盒障碍物

$$
\mathcal B=[x_1,x_2]\times[y_1,y_2]\times[z_1,z_2],
$$

令 $\mathbf c_{\mathcal B}(\mathbf p)$ 为点 $\mathbf p$ 在盒体上的最近点。外部点的加权相对向量和距离为：

$$
\mathbf d_o=[p_x-c_x,\ p_y-c_y,\ \lambda_z(p_z-c_z)]^\mathsf T,
\qquad d_o=\|\mathbf d_o\|_2.
$$

- $\lambda_z$：垂向缩放系数，使高度差在距离度量中的影响可调；
- $r_o$：障碍物缓冲半径。

若 $0<d_o\leq r_o$：

$$
\mathbf f_{\mathrm{obs}}(\mathbf p;\mathcal B)=
\frac{r_o-d_o}{r_o}\frac{\mathbf d_o}{d_o}.
$$

方向是远离障碍物的单位方向，幅值在接近障碍物时增大、在缓冲区外缘降为零。若点已进入障碍物内部：

$$
\mathbf f_{\mathrm{obs}}(\mathbf p;\mathcal B)=
(r_o+d_{\min})\mathbf n_{\min},
$$

其中 $d_{\min}$ 是到最近水平外侧面的穿透深度，$\mathbf n_{\min}$ 是该面的外法向。内部压力更强，目的在于迅速将路径推出障碍物。

### 4.3 禁飞区压力

禁飞区建模为柱体 $\mathcal Z=(\mathbf c_z,r_z,z_l,z_u)$。若 $p_z\notin[z_l,z_u]$，该分量为零；否则定义水平相对向量：

$$
\mathbf d_z=[p_x-c_{z,x},p_y-c_{z,y},0]^\mathsf T,
\qquad d_z=\|\mathbf d_z\|_2.
$$

$$
\mathbf f_{\mathrm{nfz}}(\mathbf p;\mathcal Z)=
\begin{cases}
(r_z-d_z+r_n)\dfrac{\mathbf d_z}{d_z},&d_z\leq r_z,\\
\dfrac{r_z+r_n-d_z}{r_n}\dfrac{\mathbf d_z}{d_z},
&r_z<d_z\leq r_z+r_n,\\
\mathbf0,&d_z>r_z+r_n.
\end{cases}
$$

- $\mathbf c_z$：柱体中心；$r_z$：柱体半径；$[z_l,z_u]$：生效高度范围；
- $r_n$：禁飞区外侧缓冲半径。

区域内部得到较强的向外水平压力；缓冲带内的压力随距离增大而减小；缓冲带外不施加该分量。当 $d_z$ 很小时，实现中采用固定水平单位方向以避免除零。

### 4.4 风险热点压力

风险热点定义为 $\mathcal H_h=(\mathbf c_h,\sigma_h,a_h)$，其中 $\mathbf c_h$ 是中心，$\sigma_h$ 是影响范围，$a_h$ 是峰值强度。风险场为：

$$
\phi_h(\mathbf p)=
a_h\exp\left(
-\frac{\|\widetilde{\mathbf d}_h\|_2^2}{2\sigma_h^2}
\right),
$$

$$
\widetilde{\mathbf d}_h=
[p_x-c_{h,x},p_y-c_{h,y},\lambda_z(p_z-c_{h,z})]^\mathsf T.
$$

仅当 $\phi_h(\mathbf p)>\phi_0$ 时触发：

$$
\mathbf f_{\mathrm{risk}}(\mathbf p;\mathcal H_h)=
\kappa_r(\phi_h(\mathbf p)-\phi_0)
\frac{\widetilde{\mathbf d}_h}
{\|\widetilde{\mathbf d}_h\|_2+\epsilon_l}.
$$

- $\phi_0$：风险激活阈值，排除远距离的微弱风险；
- $\kappa_r$：风险压力强度；
- $\epsilon_l$：避免分母为零的极小正数。

该分量始终指向远离风险热点中心的方向。

### 4.5 高度与边界压力

高度压力为：

$$
f_{\mathrm{alt},z}(\mathbf p)=
\begin{cases}
z_l-p_z,&p_z<z_l,\\
z_u-p_z,&p_z>z_u,\\
\lambda_z(z_l+b_z-p_z),&z_l\leq p_z<z_l+b_z,\\
-\lambda_z(p_z-z_u+b_z),&z_u-b_z<p_z\leq z_u,\\
0,&\text{其余情况}.
\end{cases}
$$

- $z_l,z_u$：允许高度下、上界；
- $b_z$：高度缓冲带宽度。

越界时压力直接把点推回允许高度；尚未越界但进入缓冲带时，也会提前产生较弱的远离边界压力。此外叠加弱参考高度项 $\lambda_{\mathrm{ref}}(z_{\mathrm{ref}}-p_z)$，其中 $\lambda_{\mathrm{ref}}$ 为固定弱引导系数。

以 $x$ 方向为例，水平边界压力为：

$$
f_{\mathrm{bnd},x}(\mathbf p)=
\begin{cases}
x_{\min}+b_b-p_x,&p_x<x_{\min}+b_b,\\
x_{\max}-b_b-p_x,&p_x>x_{\max}-b_b,\\
0,&\text{其余情况}.
\end{cases}
$$

$y$ 方向完全类似，$b_b$ 为水平边界缓冲宽度。压力负责提前纠偏，而硬边界仍由投影 $\Pi_\Omega$ 保证。

### 4.6 转弯压力

若控制点处局部转角 $\vartheta_k$ 接近或超过阈值：

$$
\vartheta_k\geq\theta_c,
\qquad \theta_c=\alpha_{\mathrm{curv}}\theta_{\max},
$$

则施加：

$$
\mathbf F_{k,\mathrm{curv}}=
\gamma_{\mathrm{curv}}
\left[
\tfrac12(\mathbf q_{k-1}+\mathbf q_{k+1})-\mathbf q_k
\right].
$$

- $\theta_{\max}$：最大允许转弯角；
- $\alpha_{\mathrm{curv}}$：转弯压力的激活比例；
- $\theta_c$：激活阈值；
- $\gamma_{\mathrm{curv}}$：平滑强度。

中括号是相邻控制点中点减当前控制点的局部平滑方向。只有出现尖锐转弯趋势时才激活，避免无差别地抹平所有路径细节。

---

## 5. 3.2.4 有界融合与稀疏接收

### 5.1 向量化与逐维截断

先把所有控制点增量展平：

$$
\widetilde{\mathbf D}_{\mathrm{CVF}}=
\mathrm{vec}\left(
[\Delta\mathbf q_1^\mathsf T,\ldots,
\Delta\mathbf q_K^\mathsf T]^\mathsf T
\right).
$$

再逐维限制：

$$
\bar D_{\mathrm{CVF},j}=
\mathrm{clip}\left(
\widetilde D_{\mathrm{CVF},j},
-\rho_{\mathrm{step}}(u_j-l_j),
\rho_{\mathrm{step}}(u_j-l_j)
\right).
$$

- $\rho_{\mathrm{step}}$：单维最大步长相对于该维搜索范围的比例；
- $\mathrm{clip}$：将数值限制在给定区间。

这种相对步长限制避免某一控制点坐标被异常压力一次推得过远，同时适应各变量的不同量纲范围。

### 5.2 强度缩放和整体范数截断

$$
\mathbf D_{\mathrm{CVF}}^{(0)}=
\kappa_{\mathrm{cvf}}\bar{\mathbf D}_{\mathrm{CVF}}.
$$

$\kappa_{\mathrm{cvf}}$ 为 CVF 总体强度系数。随后定义：

$$
h_{\mathrm{cvf}}=
\rho_{\mathrm{norm}}\|\mathbf u-\mathbf l\|_2,
\qquad
r_{\mathrm{cvf}}=
\frac{h_{\mathrm{cvf}}}
{\|\mathbf D_{\mathrm{CVF}}^{(0)}\|_2+\epsilon_l}.
$$

$$
\mathbf D_{\mathrm{CVF}}=
\begin{cases}
\mathbf D_{\mathrm{CVF}}^{(0)},
&\|\mathbf D_{\mathrm{CVF}}^{(0)}\|_2\leq h_{\mathrm{cvf}},\\
r_{\mathrm{cvf}}\mathbf D_{\mathrm{CVF}}^{(0)},
&\text{否则}.
\end{cases}
$$

- $\rho_{\mathrm{norm}}$：整体最大步长比例；
- $h_{\mathrm{cvf}}$：允许的整体 CVF 位移上限；
- $r_{\mathrm{cvf}}$：超出上限时的缩放比。

逐维截断限制单个变量，范数截断限制整个路径向量；两者共同确保 CVF 是有界局部修正。

### 5.3 质量引导方向

$$
\begin{aligned}
\mathbf G_{\mathrm Q}
&=\omega_{\mathrm Q}(\mathbf X^*-\mathbf X_i)
+(1-\omega_{\mathrm Q})(\mathbf X_{\mathrm{elite}}-\mathbf X_i),\\
\mathbf D_{\mathrm Q}
&=\mathrm{clip}(\mathbf G_{\mathrm Q}+\mathbf D_{\mathrm{sm}},\rho_{\mathrm Q}).
\end{aligned}
$$

- $\omega_{\mathrm Q}$：当前最优方向的固定权重；
- $\mathbf G_{\mathrm Q}$：最优解和精英样本共同形成的质量引导；
- $\mathbf D_{\mathrm{sm}}$：控制点局部平滑增量；
- $\rho_{\mathrm Q}$：质量方向的逐维上界。

CVF 主要回答“怎样更安全”，质量方向补充回答“怎样不明显牺牲路径质量与平滑性”。

### 5.4 三方向融合与 CVF 候选

$$
\mathbf D_s=
\alpha_s\mathbf D_{\mathrm{AE}}^{(s_t)}
+\beta_s\mathbf D_{\mathrm{CVF}}
+\gamma_s\mathbf D_{\mathrm Q}.
$$

$$
\mathbf X_{\mathrm{CVF}}=
\Pi_\Omega\Bigl(
(1-\mu_t)(\mathbf X_i+\mathbf D_s)
+\mu_t\mathbf X_{\mathrm{elite}}
\Bigr).
$$

三种状态的系数为：

| 生效状态 $s_t$ | 基础方向侧重 | $(\alpha_s,\beta_s,\gamma_s)$ |
| --- | --- | --- |
| F | 参考/精英方向与均匀扰动 | $(.80,.40,.04)$ |
| P | 最优/精英方向与局部差分 | $(.90,.38,.06)$ |
| R | 差分恢复与高斯扰动 | $(.90,.28,.04)$ |

这三个系数是独立的缩放系数，**不是概率，也不要求和为 1**。F 状态相对增强 CVF 影响，P 状态以基础 AE 为主并持续约束修正，R 状态降低 CVF 对恢复探索的限制但保留关键安全牵引。

### 5.5 稀疏触发配额

$$
N_{\mathrm{cvf}}^{(t)}\leq
\max\{1,\operatorname{round}(r_{s_t}N)\}.
$$

- $N_{\mathrm{cvf}}^{(t)}$：第 $t$ 代实际触发 CVF 的个体数；
- $r_{s_t}$：当前状态的名义触发比例；
- $N$：种群规模。

$$
r_{\mathrm F}=0.06,
\qquad r_{\mathrm P}=0.06,
\qquad r_{\mathrm R}=0.04.
$$

若 $N=30$，F/P 状态的名义配额为 2，R 状态为 1。公式使用不等号，是因为可触发的近可行不可行个体可能少于名义配额。F/P 优先处理排序靠前的近可行候选；R 放宽排序限制以恢复探索。一旦种群已有可行最优解，CVF 只每 3 代检查一次，且单代比例不超过 $0.03$。

### 5.6 保守局部接收

CVF 候选只有同时满足以下两项才替代基础候选：

$$
\mathbf X_{\mathrm{CVF}}
\prec_{\mathrm{Deb}}
\mathbf X_{\mathrm{AE}},
\qquad
J(\mathbf X_{\mathrm{CVF}})
\leq J(\mathbf X_{\mathrm{AE}}).
$$

第一项要求 CVF 候选在 Deb 可行性顺序上更好，例如从不可行变为可行，或同为不可行时总违反分数更低；第二项要求原目标不增加。只满足其中一个条件时，仍保留基础 AE 候选。

候选产生之后，稀疏可行性保持仅对少量候选实施碰撞、禁飞区和转弯修复，并施加局部风险降低校正。它不是对整个种群反复执行的独立优化过程。

---

## 6. 3.3 算法复杂度

设：

- $N$：种群规模；
- $T$：最大迭代次数；
- $M$：完整路径评价时的采样点数；
- $\widetilde M$：CVF 低密度采样点数；
- $K$：内部控制点数；
- $G$：空间约束元素数；
- $N_{\mathrm{cvf}}$：每代实际触发 CVF 的个体数。

一次完整路径评价的复杂度为：

$$
O\big(M(G+K)\big).
$$

基础 AE 每代评价 $N​$ 个候选，因此整体评价工作量为：

$$
O\big(TNM(G+K)\big).
$$

CVF-AE 的额外工作来自被触发个体的低密度场构造和额外完整候选评价：

$$
O\big(TN_{\mathrm{cvf}}[M+\widetilde M](G+K)\big).
$$

由于设计上 $N_{\mathrm{cvf}}\ll N$，CVF 的额外开销由少量关键候选承担。这里“稀疏触发”不仅是搜索策略，也是在维持额外计算代价可控。

## 7. 阅读时应把握的主线

1. **基础 AE 提供全局进化能力**：最优、精英、差分、采样和随机扰动共同生成多样候选。
2. **参考序列只提供弱先验**：它改善初始化与早期方向，不作为外部对比算法，也不强制最终路径跟随它。
3. **状态调度决定侧重点**：F 解决严重不可行，P 稳定优化，R 应对停滞且可行性不足的情形。
4. **CVF 是局部几何压力，不是解析梯度**：路径采样点的压力被映射并平均到最近控制点。
5. **CVF 的影响受到多层限制**：逐维截断、整体范数截断、稀疏配额和 Deb 加目标的双重接收门控共同防止过度修正。
6. **最终父代替换仍由 Deb 规则决定**：即使通过了局部 CVF 门控，候选也必须优于父代才会进入下一代。
