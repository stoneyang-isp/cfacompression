% direct apply jpeg to CFA data

clear;clc;close all;

imgIndex = [1];
DM = {'bilinear', 'homogeneity', 'frequency'};

for i=1:length(imgIndex)

    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    [compression_ratio , mse, psnr, scielab, dmImage] = CFAdataDirect_applyJPEG(imgFile,'bilinear',75);
    
    disp('direct apply JPEG to CFA data');
    disp(compression_ratio);
end

