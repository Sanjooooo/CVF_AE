# Internal template-initialization ablation

- Purpose: isolate the effect of fixed corridor templates in Scene 3 initialization
- Algorithm: `CVF-AE`
- Scene ID: `4`
- Runs: `30`
- Population / iterations: `30` / `300`
- Base seed: `20260711`
- Template enabled: `1`
- Override used: `D:\MATLAB\Project\COVE_AE_matlab\routes\route_b_cvf_ae\experiments\template_initialization_ablation\overrides\init_COVE_AE.m`

Only the template switch changes between conditions. Reference-path generation, guided initialization, state scheduling, CVF, repair, evaluator, budget, and run-seed rule are unchanged.
