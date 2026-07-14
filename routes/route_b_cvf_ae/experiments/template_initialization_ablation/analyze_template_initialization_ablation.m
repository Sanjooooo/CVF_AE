function out = analyze_template_initialization_ablation(templateOnDir, templateOffDir, outDir)
%ANALYZE_TEMPLATE_INITIALIZATION_ABLATION Export internal-only diagnostics.

if nargin < 3 || isempty(outDir)
    outDir = fullfile(fileparts(templateOnDir), 'analysis');
end
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

onRuns = localReadRuns(templateOnDir, 'template_on');
offRuns = localReadRuns(templateOffDir, 'template_off');
summary = [localSummary(onRuns); localSummary(offRuns)];
seedMatched = localMatchSeeds(onRuns, offRuns);
test = localRankSum(onRuns, offRuns);

writetable(summary, fullfile(outDir, 'template_ablation_summary.csv'));
writetable(seedMatched, fullfile(outDir, 'template_ablation_seed_matched.csv'));
writetable(test, fullfile(outDir, 'template_ablation_rank_sum.csv'));
localWriteReadme(outDir, summary, seedMatched, test);

out = struct('summary', summary, 'seedMatched', seedMatched, 'rankSum', test, ...
    'outDir', outDir);
save(fullfile(outDir, 'template_ablation_analysis.mat'), 'out');
end

function runs = localReadRuns(resultDir, condition)
path = fullfile(resultDir, 'uav_comparison_runs.csv');
assert(exist(path, 'file') == 2, 'Missing run table: %s', path);
runs = readtable(path);
assert(all(strcmpi(string(runs.Algorithm), 'CVF-AE')), ...
    'Unexpected algorithm in %s', path);
assert(all(runs.Scene == 4), 'This internal experiment must contain Scene 3 only.');
runs.Condition = repmat(string(condition), height(runs), 1);
end

function row = localSummary(runs)
valid = isfinite(runs.BestFitness);
fitness = runs.BestFitness(valid);
row = table(string(runs.Condition(1)), sum(valid), mean(fitness), std(fitness), ...
    median(fitness), mean(logical(runs.Feasible(valid))), ...
    mean(runs.Violation(valid)), mean(runs.NEvals(valid)), ...
    mean(runs.ViabilityFieldCount(valid)), ...
    'VariableNames', {'Condition','N','MeanFitness','StdFitness','MedianFitness', ...
    'FeasibleRate','MeanViolation','MeanNEvals','MeanCVFTriggers'});
end

function matched = localMatchSeeds(onRuns, offRuns)
left = onRuns(:, {'Seed','BestFitness','Feasible','Violation','NEvals','ViabilityFieldCount'});
right = offRuns(:, {'Seed','BestFitness','Feasible','Violation','NEvals','ViabilityFieldCount'});
left.Properties.VariableNames(2:end) = strcat('TemplateOn_', left.Properties.VariableNames(2:end));
right.Properties.VariableNames(2:end) = strcat('TemplateOff_', right.Properties.VariableNames(2:end));
matched = innerjoin(left, right, 'Keys', 'Seed');
matched.OffMinusOnFitness = matched.TemplateOff_BestFitness - matched.TemplateOn_BestFitness;
matched.OffMinusOnViolation = matched.TemplateOff_Violation - matched.TemplateOn_Violation;
end

function test = localRankSum(onRuns, offRuns)
on = onRuns.BestFitness(isfinite(onRuns.BestFitness));
off = offRuns.BestFitness(isfinite(offRuns.BestFitness));
[p, h, stats] = ranksum(on, off, 'alpha', 0.05, 'tail', 'both');
delta = localLowerIsBetterDelta(on, off);
onFeasible = sum(logical(onRuns.Feasible));
offFeasible = sum(logical(offRuns.Feasible));
fisherP = localFisherTwoSided(onFeasible, height(onRuns) - onFeasible, ...
    offFeasible, height(offRuns) - offFeasible);
test = table(numel(on), numel(off), mean(on), mean(off), p, logical(h), ...
    stats.ranksum, delta, onFeasible, offFeasible, fisherP, ...
    'VariableNames', {'NTemplateOn','NTemplateOff','TemplateOnMean', ...
    'TemplateOffMean','RankSumP','RejectAt005','RankSumStatistic', ...
    'CliffsDeltaTemplateOnLowerBetter','TemplateOnFeasible', ...
    'TemplateOffFeasible','FeasibleRateFisherP'});
end

function delta = localLowerIsBetterDelta(a, b)
delta = (sum(a(:) < b(:)) - sum(a(:) > b(:))) / (numel(a) * numel(b));
end

function p = localFisherTwoSided(a, b, c, d)
row1 = a + b;
row2 = c + d;
col1 = a + c;
col2 = b + d;
total = row1 + row2;
lo = max(0, row1 - col2);
hi = min(row1, col1);
observed = localHypergeomProbability(a, row1, col1, col2, total);
p = 0;
for x = lo:hi
    px = localHypergeomProbability(x, row1, col1, col2, total);
    if px <= observed + 1e-12
        p = p + px;
    end
end
p = min(1, p);
end

function p = localHypergeomProbability(x, row1, col1, col2, total)
p = exp(gammaln(col1 + 1) - gammaln(x + 1) - gammaln(col1 - x + 1) + ...
    gammaln(col2 + 1) - gammaln(row1 - x + 1) - gammaln(col2 - row1 + x + 1) - ...
    gammaln(total + 1) + gammaln(row1 + 1) + gammaln(total - row1 + 1));
end

function localWriteReadme(outDir, summary, seedMatched, test)
path = fullfile(outDir, 'INTERNAL_TEMPLATE_ABLATION_SUMMARY.md');
fid = fopen(path, 'w', 'n', 'UTF-8');
if fid < 0
    warning('Could not write summary: %s', path);
    return;
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid, '# Internal template-initialization ablation summary\n\n');
fprintf(fid, 'This output is for internal review only. No paper figures or LaTeX tables are generated.\n\n');
fprintf(fid, '## Aggregate results\n\n');
fprintf(fid, '| Condition | N | Mean fitness | Std | Median | Feasible rate | Mean violation | Mean evaluations | Mean CVF triggers |\n');
fprintf(fid, '|---|---:|---:|---:|---:|---:|---:|---:|---:|\n');
for i = 1:height(summary)
    fprintf(fid, '| %s | %d | %.6f | %.6f | %.6f | %.4f | %.6f | %.2f | %.2f |\n', ...
        summary.Condition(i), summary.N(i), summary.MeanFitness(i), ...
        summary.StdFitness(i), summary.MedianFitness(i), summary.FeasibleRate(i), ...
        summary.MeanViolation(i), summary.MeanNEvals(i), summary.MeanCVFTriggers(i));
end
fprintf(fid, '\n## Distribution comparison\n\n');
fprintf(fid, '- Two-sided Mann--Whitney U / rank-sum p: %.6g\n', test.RankSumP);
fprintf(fid, '- Reject at 0.05: %d\n', test.RejectAt005);
fprintf(fid, '- Cliff''s delta (template-on lower-is-better): %.6f\n', test.CliffsDeltaTemplateOnLowerBetter);
fprintf(fid, '- Feasible runs, template on / off: %d / %d\n', ...
    test.TemplateOnFeasible, test.TemplateOffFeasible);
fprintf(fid, '- Two-sided Fisher exact p for feasible rate: %.6g\n', test.FeasibleRateFisherP);
fprintf(fid, '- Mean paired seed difference, off minus on: %.6f\n', mean(seedMatched.OffMinusOnFitness));
fprintf(fid, '\nPositive off-minus-on fitness means templates reduced the final scalar fitness under the matched seed list.\n');
end
