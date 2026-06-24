function idx = cec_best_index(records)
%CEC_BEST_INDEX Return the Deb-best record index.

idx = 1;
for k = 2:numel(records)
    if cec_deb_better(records(k), records(idx))
        idx = k;
    end
end
end

