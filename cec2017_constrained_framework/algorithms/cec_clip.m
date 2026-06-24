function x = cec_clip(x, lb, ub)
%CEC_CLIP Shared boundary projection.
x = min(max(x, lb), ub);
end

