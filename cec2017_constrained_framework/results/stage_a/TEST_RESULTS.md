# Stage A test results

Date: 2026-06-24

MATLAB R2024b:

- 6 passed;
- 0 failed;
- 0 incomplete.

Covered checks:

- all C01--C28 interfaces at 10D;
- objective and constraint dimensions;
- finite values;
- C01 shift reference (`f=0`, feasible);
- equality tolerance at `1e-4`;
- FE counting and hard budget rejection;
- C18/C27 vectorized versus individual evaluation consistency;
- fixed-seed AE reproducibility.

MATLAB Code Analyzer found no issues in the new algorithm, experiment, and
test code. The adapter has one expected warning because the unmodified author
implementation requires `global initial_flag`. Warnings inside `third_party`
are retained rather than changing the source package.

