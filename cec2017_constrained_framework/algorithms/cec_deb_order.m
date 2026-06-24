function order = cec_deb_order(records)
%CEC_DEB_ORDER Sort indices from best to worst by Deb rules.

n = numel(records);
order = 1:n;
for i = 1:n-1
    best = i;
    for j = i+1:n
        if cec_deb_better(records(order(j)), records(order(best)))
            best = j;
        end
    end
    if best ~= i
        order([i best]) = order([best i]);
    end
end
end

