# Stage B gate decision

Decision: **FAIL - formal run is blocked**.

Reasons:

- CVF-AE versus AE: 1 win / 1 tie / 3 losses over the fixed representative
  functions.
- Feasible-run count is not improved.
- Equality and mixed-constraint functions remain unstable.
- Extra evaluations are correctly counted and modest, so the failure cannot be
  attributed to an unfair budget implementation.

Current readiness:

- source provenance: ready;
- independent framework: ready;
- Stage A interface/accounting tests: passed;
- Stage B mechanism gate: failed;
- Stage C: not authorized by the gate;
- formal CEC experiment: not ready.

Preliminary serial runtime estimate for the planned five-algorithm full
protocol is roughly 7--10 days on the current machine, dominated by 100D
experiments. This estimate is not a reason for the block; the mechanism gate is.

