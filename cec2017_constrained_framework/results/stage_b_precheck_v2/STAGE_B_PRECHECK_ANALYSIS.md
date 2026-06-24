# Stage B precheck analysis

Date: 2026-06-24

## Protocol

- Suite: CEC2017 constrained, author-maintained September 2024 MATLAB code.
- Dimension: 10.
- Functions: C01 (inequality), C03 (mixed), C06 (equalities), C14
  (mixed/narrow manifold), C18 (mixed and non-smooth).
- Algorithms: AE, CVF-AE, CVF-AE-w/o-CVF, DE, PSO.
- Runs: 3 per function and algorithm.
- Population: 20.
- Budget: 3000 joint objective/constraint FEs per run.
- Initialization: uniform random in `[-100,100]^10`.
- Equality tolerance: `1e-4`.
- Selection: common Deb feasibility rules.
- Seeds: identical for the same function and run ID across algorithms.

The precheck is development evidence only and is not a paper result.

## Results

| Function | AE | CVF-AE | Direction |
|---|---:|---:|---|
| C01 feasible rate | 1.00 | 1.00 | tie |
| C01 mean feasible objective | 2.8713 | 2.4240 | CVF-AE better |
| C03 mean violation | 0.01640 | 0.01640 | tie |
| C06 mean violation | 3.3293 | 3.3672 | CVF-AE worse |
| C14 mean violation | 0.62819 | 1.06011 | CVF-AE worse |
| C18 mean violation | 487.5017 | 534.0529 | CVF-AE worse |

CVF-AE versus AE function-level outcome: 1 win / 1 tie / 3 losses.

Across 15 CVF-AE runs:

- feasible runs: 3/15, equal to AE;
- CVF trigger count: 602;
- CVF candidate successes over the corresponding AE candidate: 297;
- extra evaluations: 602/45000 = 1.34%;
- every run stopped at exactly 3000 FEs.

The `CVF-AE-w/o-CVF` control matches AE numerically under identical seeds, as
expected because the generic CEC implementation deliberately excludes UAV-only
initialization, repair, and state modules.

## Comparison with the first implementation

The retained first precheck is in `../stage_b_precheck/`.

First implementation:

- quota: 10% of the population;
- trigger order: population index order;
- CVF candidate composed from the parent and base AE step.

It improved mean violation on C03 and C06 but worsened C14 and C18. The second
implementation removed index bias, reduced the quota to 5%, and applied the CVF
increment to the already constructed AE candidate. This reduced extra FEs but
did not produce stable cross-function gains.

## Interpretation

The current population-difference CVF is not a reliable surrogate for a local
constraint-pressure direction on equality manifolds and narrow mixed feasible
regions. A CVF candidate can be locally Deb-better than the paired AE candidate
while still spending evaluations that would otherwise support broader AE
exploration. The 49.3% local CVF success rate therefore does not establish a
net algorithm-level benefit.

This is a mechanism limitation, not an FE accounting error:

- all extra CVF evaluations are counted;
- no run exceeds the budget;
- vectorized author-code fixes are verified;
- fixed seeds reproduce exactly;
- AE and the no-CVF control agree.

## Gate decision

Stage B does not pass.

Do not run Stage C or the complete 10D/100D official experiment with the
current generic CVF.

Before a new gate, the mechanism needs a pre-declared redesign that supplies a
more informative general constraint direction. A defensible next candidate is
a counted low-dimensional constraint probe or finite-difference approximation,
with all probe evaluations charged to the same FE budget. That redesign must be
tested against the same fixed Stage B function set and seeds; functions cannot
be removed because they are unfavorable.

