function metrics = cec2017c_violation(g, h, equalityTolerance)
%CEC2017C_VIOLATION Compute official and CVF-normalized violations.

if nargin < 3 || isempty(equalityTolerance)
    equalityTolerance = 1e-4;
end

g = g(:)';
h = h(:)';

gViolation = max(0, g);
hOfficial = abs(h);
hOfficial(hOfficial <= equalityTolerance) = 0;
hExcess = max(0, abs(h) - equalityTolerance);

officialVector = [gViolation, hOfficial];
cvfVector = [gViolation, hExcess];
if isempty(officialVector)
    officialViolation = 0;
    normalizedViolation = 0;
else
    officialViolation = mean(officialVector);
    normalizedViolation = mean(cvfVector ./ (1 + cvfVector));
end

metrics = struct();
metrics.officialVector = officialVector;
metrics.cvfVector = cvfVector;
metrics.officialViolation = officialViolation;
metrics.normalizedViolation = normalizedViolation;
metrics.isFeasible = all(g <= 0) && all(abs(h) <= equalityTolerance);
metrics.violatedCount = nnz(officialVector > 0);
end

