# CVF-AE Mechanism Derivation

Algorithm name:

> CVF-AE = Constraint Viability Field guided Alpha Evolution.

This note defines the minimal mathematical mechanism used by the Route B
prototype. The goal is not to replace the UAV objective or the Deb feasibility
rule. The goal is to construct a sparse, bounded direction that points a small
number of control points toward locally more viable regions.

## 1. Path And Control-Point Notation

Let an encoded UAV path be

```text
X = [q_1, q_2, ..., q_K] in R^(3K),
```

where each interior B-spline control point is

```text
q_k = [x_k, y_k, z_k]^T, k = 1,...,K.
```

The fixed start and goal are appended by `decodeSolution`, so the full control
polygon is

```text
Q = [q_0, q_1, ..., q_K, q_{K+1}].
```

The sampled B-spline path is

```text
P(X) = {p_m}_{m=1}^{M}, p_m in R^3.
```

For a violated or near-boundary sampled point `p_m`, the sparse prototype maps
its pressure back to the nearest interior control point:

```text
k*(m) = argmin_{1 <= k <= K} ||p_m - q_k||_2.
```

This keeps the CVF update cheap and local. A future version can replace this
nearest-control mapping with B-spline basis weights, but the current gate uses
the nearest-control mapping to avoid additional bookkeeping.

## 2. Constraint Viability Field

For each active control point, the constraint viability field is

```text
F_v(q_k) = sum_{c in C} lambda_c(s, V_c) F_c(q_k),
```

where

```text
C = {obs, nfz, risk, alt, curv, boundary}.
```

The scalar `lambda_c` depends on the current constraint state `s` and the
constraint severity. The implementation uses bounded severity multipliers rather
than global penalty constants, so the field is a search direction, not a second
fitness function.

The vectorized field step is

```text
D_CVF(X) = vec([F_v(q_1), ..., F_v(q_K)]).
```

The final prototype applies componentwise clipping:

```text
|D_CVF,j| <= rho_cvf (ub_j - lb_j),
```

and then calls `boundSolution` after composing the candidate.

## 3. Constraint Components

### 3.1 Obstacle Field `F_obs`

For an axis-aligned obstacle box `B`, if a sampled point is inside the box, the
field points to the nearest horizontal exit face. If the point is outside but
within the influence distance `r_obs`, it receives a weaker repulsion away from
the nearest box point:

```text
F_obs(p_m) = eta_obs * dir_exit_or_nearest / (epsilon + d_obs).
```

The implementation ignores obstacle boxes that are far away or vertically
irrelevant for the sampled point.

### 3.2 No-Fly-Zone Field `F_nfz`

For a cylindrical no-fly zone `(c_x, c_y, r, z_min, z_max)`, points inside the
active height interval are pushed radially outward:

```text
F_nfz(p_m) = eta_nfz * ([p_x, p_y] - [c_x, c_y]) / ||[p_x, p_y] - [c_x, c_y]||.
```

Near-boundary points receive a smaller outward pressure inside the influence
band.

### 3.3 Risk Field `F_risk`

For wind-risk hotspots, the field follows a risk-descending direction. Each
hotspot contributes an outward vector weighted by the local Gaussian pressure:

```text
F_risk(p_m) = sum_h eta_risk * r_h(p_m) * (p_m - c_h) / ||p_m - c_h||.
```

The vertical component is damped so that risk avoidance mainly changes the
horizontal route unless altitude is explicitly violated.

### 3.4 Altitude Field `F_alt`

Altitude violations receive a direct pull into the valid height band:

```text
F_alt,z(p_m) =
    z_min - p_z, if p_z < z_min,
    z_max - p_z, if p_z > z_max,
    k_h (z_ref - p_z), near the band boundary.
```

The horizontal components of `F_alt` are zero.

### 3.5 Curvature Field `F_curv`

For consecutive control points, curvature pressure uses local smoothing:

```text
F_curv(q_k) = 0.5(q_{k-1} + q_{k+1}) - q_k.
```

It is applied only when local turning pressure is active, and it is weaker in
quality-refinement state than in feasibility-formation state.

### 3.6 Boundary Field `F_boundary`

Map boundary pressure pulls points back from the lateral margin and valid height
range. It is treated as a support term, not a primary contribution.

## 4. CVF-AE Candidate Generation

The base Alpha Evolution step produces an ordinary offspring:

```text
X_AE = X_i + D_AE.
```

For a sparse set of selected individuals, CVF-AE also builds a field-guided
candidate:

```text
X_CVF = X_i + alpha_s D_AE + beta_s D_CVF + gamma_s D_Q.
```

`D_Q` is a lightweight quality direction, currently implemented as a small
pull toward the elite/best anchor plus local smoothing. The state-dependent
weights are:

| State | `alpha_s` | `beta_s` | `gamma_s` | Intent |
|---|---:|---:|---:|---|
| Feasibility formation | 0.75 | 1.00 | 0.05 | form a feasible route early |
| Feasibility preservation | 0.85 | 0.70 | 0.08 | keep feasibility while searching |
| Quality refinement | 1.00 | 0.25 | 0.14 | reduce unnecessary CVF pressure |
| Stagnation recovery | 0.90 | 0.55 | 0.04 | recover without field over-collapse |

The CVF candidate adds at most one extra fitness evaluation for each triggered
individual. The ordinary AE offspring is retained when the CVF candidate is not
Deb-better.

## 5. Acceptance Rule

The prototype uses the existing Deb rule:

1. feasible dominates infeasible;
2. among feasible candidates, lower objective value wins;
3. among infeasible candidates, lower total violation `V` wins;
4. ties use the objective value.

The local acceptance is:

```text
X_trial = X_CVF, if DebBetter(X_CVF, X_AE)
        = X_AE,  otherwise.
```

The population acceptance is:

```text
X_i(t+1) = X_trial, if DebBetter(X_trial, X_i(t))
         = X_i(t),  otherwise.
```

`viabilityFieldSuccessCount` is incremented only when `X_CVF` is Deb-better than
the ordinary AE offspring.

## 6. Low-Overhead Bound

Let `N` be population size, `T` be max iterations, `M` be path samples, and
`K` be the number of interior control points.

The base evolutionary loop evaluates `O(NT)` candidates. A fitness evaluation
itself samples the full B-spline path and checks constraints, so it dominates
most scalar vector operations.

The CVF prototype triggers at most

```text
N_cvf <= ceil(r_cvf N)
```

individuals per generation. It samples at most `M_cvf <= M` path points and maps
each active point to one control point. The additional non-evaluation cost is

```text
O(T N_cvf M_cvf (N_obs + N_nfz + N_risk + K)).
```

The additional evaluation count is bounded by

```text
Delta evals <= T N_cvf.
```

The gate experiment reports `nEvals`, runtime, repair counts, CVF counts, and
CVF success counts, so the field cannot be claimed as useful if it only wins by
unreported extra computation.

## 7. Gate Interpretation

The small-scale gate should only decide whether the mechanism is promising
enough for a medium gate. It is not a final ablation. The mechanism passes the
small gate only if CVF-AE improves at least one of feasibility rate, first
feasible iteration, final violation, or mean best fitness on Scene 2 or Scene 4,
without a large evaluation or runtime increase.
