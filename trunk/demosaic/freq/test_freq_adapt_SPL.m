%Apply adaptive frequency domain method to a given image
clear all;
close all;
ifname = input('Enter filename of the original image: ','s');
ORIG = im2double(imread(ifname));
% Create CFA mosaic
CFA = create_CFA(ORIG);
% Apply  demosaicking method
OUT = demos_freq_adapt_SPL(CFA);
figure, imshow(OUT)
%compute error
b=6;
[MSE_R MSE_G MSE_B CPSNR] = cpsnr_calc(ORIG,OUT,b);