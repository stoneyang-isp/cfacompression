function [H] = evaluateEntropy(p)

H = 0;
for i=1:length(p)
    if p(i) ~= 0
        H = H - p(i)*log2(p(i));
    end
end

return
