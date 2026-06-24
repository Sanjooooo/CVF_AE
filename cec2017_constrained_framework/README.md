# CEC2017 Constrained Framework

Independent MATLAB framework for the Route B / CVF-AE supplementary
constrained-optimization study.

This directory is deliberately separate from `cec2017_framework/`. The older
framework uses the CEC2017 single-objective bound-constrained suite and cannot
validate a general constraint-handling mechanism.

Selected benchmark:

- CEC2017 constrained single-objective real-parameter optimization;
- 28 functions;
- official competition dimensions: 10 and 100;
- equality tolerance: `1e-4`;
- official budget: `10000 * D` candidate evaluations;
- official runs: 20.

The framework counts one joint objective-and-constraint evaluation of one
candidate as one FE. Every evaluated CVF candidate is included in that budget.
The generic CVF direction uses already evaluated population constraint
differences, so direction construction itself performs no hidden evaluations.

Main entry points:

```matlab
run(fullfile('cec2017_constrained_framework', 'tests', 'run_stage_a_tests.m'))
run(fullfile('cec2017_constrained_framework', 'experiments', ...
    'run_stage_b_precheck.m'))
```

Formal experiments are intentionally disabled until Stage B and Stage C gates
are documented as passed.

