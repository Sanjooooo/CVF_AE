function tf = cec_deb_better(a, b)
%CEC_DEB_BETTER Official feasibility-first comparison.

if a.isFeasible ~= b.isFeasible
    tf = a.isFeasible;
elseif a.isFeasible
    tf = a.f < b.f;
elseif a.violation ~= b.violation
    tf = a.violation < b.violation;
else
    tf = a.f < b.f;
end
end

