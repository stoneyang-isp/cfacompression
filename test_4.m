% apply jpeg to each color component
% New Efficient Methods of Image Compression in Digital Cameras with Color Filter Array
% Method 2
% 1. convert to YCbCr
% 2. Structure Seperation

clear;clc;close all;

imgIndex = [1];
DM = {'bilinear', 'homogeneity', 'frequency'};

for i=1:length(imgIndex)

    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    
    [compression_ratio , mse, psnr, scielab, dmImage] = structureSeperation_applyJPEG(imgFile,'bilinear',75);
    
    disp('Method 2');
    disp(compression_ratio);
end

