# Experiment protocol

## Counting

One candidate evaluation returns objective, inequalities, and equalities and
counts as one FE. The FE counter is enforced by the evaluator. An attempted
over-budget evaluation raises `CVFAE:FEBudgetExceeded`.

## Constraint handling

- inequality feasibility: `g <= 0`;
- equality feasibility: `abs(h) <= 1e-4`;
- official violation: mean of positive inequalities and absolute equalities
  that exceed the tolerance;
- CVF pressure: mean of normalized positive inequalities and equality excess;
- acceptance: Deb feasibility rules using official violation.

## Shared fairness settings

- uniform random initialization in `[-100,100]^D`;
- identical seed for the same function, dimension, and run ID across algorithms;
- identical population size;
- identical boundary projection;
- identical FE budget;
- no UAV reference initialization, repair, map information, or geometry fields.

## Stages

- Stage A: all function interfaces, reference sanity, vectorization fixes,
  tolerance, FE budget, and reproducibility.
- Stage B: C01, C03, C06, C14, C18 at 10D; 3 runs; 3000 FEs; population 20.
- Stage C: all 28 functions at 10D; 5 runs; 20000 FEs.
- Formal: C01--C28 at 10D and 100D; 20 runs; `10000*D` FEs.

Stage C and formal execution require a written gate decision based on the
preceding stage.

