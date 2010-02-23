%Function to compute R, G, B MSEs, CPSNR between two RGB images
%  Eric Dubois 2005-05-11
%          Computes the mean square errors excluding a border of width b on all
%          four sides. 
%          function [MSE_R MSE_G MSE_B CPSNR) = cpsnr_calc(RGB1,RGB2,bord)
%          RGB1(:,:,3)  first input image, double
%          RGB2(:,:,3)  second input image, double both same size
%          b         width of border on each side of the image to exclude 
%                       from error calculations
%          MSE_*        output, mean square error for component *,
%                       multiplied by 255^2, as if input was in range [0 255]
%          CPSNR        output, color PSNR
%
function [MSE_R MSE_G MSE_B CPSNR] = cpsnr_calc(RGB1,RGB2,b)
S = size(RGB1);
N1 = S(1); N2 = S(2);
MSE_R = sum(sum((RGB1(b+1:N1-b,b+1:N2-b,1)-RGB2(b+1:N1-b,b+1:N2-b,1)).^2))*255^2/((N1-2*b)*(N2-2*b));
MSE_G = sum(sum((RGB1(b+1:N1-b,b+1:N2-b,2)-RGB2(b+1:N1-b,b+1:N2-b,2)).^2))*255^2/((N1-2*b)*(N2-2*b));
MSE_B = sum(sum((RGB1(b+1:N1-b,b+1:N2-b,3)-RGB2(b+1:N1-b,b+1:N2-b,3)).^2))*255^2/((N1-2*b)*(N2-2*b));
CMSE = (MSE_R + MSE_G + MSE_B)/3;
CPSNR = 10*log10(255^2/CMSE);