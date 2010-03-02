function [recon_y1, recon_y2] = inverse_structure_Conversion(recon_y)

recon_y1 = zeros(size(recon_y,1)/2 , size(recon_y,2));
recon_y2 = recon_y(2:2:end,:);

for x=1:size(recon_y1,1)
    for y=1:size(recon_y1,2)
        if x==1
            recon_y1(x,y) = 2*recon_y(2*x-1,y) - 0.5*recon_y(2*x,y);
        else
            recon_y1(x,y) = 2*recon_y(2*x-1,y) - 0.5*recon_y(2*x-2,y) - 0.5*recon_y(2*x,y);
        end
    end
end

end