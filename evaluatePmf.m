% assume data is integers from a to b
function pmf = evaluatePmf(data, a, b)

pmf = zeros(1, b-a+1);
for i=1:length(data(:))
    pmf(data(i)-a+1) = pmf(data(i)-a+1) + 1;
end

pmf = pmf ./ sum(pmf);

return
