function results = run_stage_a_tests()
%RUN_STAGE_A_TESTS Run framework interface and accounting tests.

rootDir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(rootDir, 'tests'));
results = runtests(fullfile(rootDir, 'tests', ...
    'test_cec2017c_framework.m'));
disp(table(results));
assert(all([results.Passed]), 'Stage A tests did not all pass.');
end

