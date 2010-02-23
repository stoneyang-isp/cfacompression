% assume data is a RGB image. evaluate joint pmf of R, G, B values
function pmf = evaluateJointPmf(data)

[h w c] = size(data);
pmf = zeros(256,256,256);
for i=1:h
    for j=1:w
        pmf(data(i,j,1)+1,data(i,j,2)+1,data(i,j,3)+1) = pmf(data(i,j,1)+1,data(i,j,2)+1,data(i,j,3)+1) + 1;
    end
end

pmf = pmf ./ sum(pmf(:));

return
