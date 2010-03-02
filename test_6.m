% apply jpeg to each color component
% A Novel Method of Lossy Image Compression for Digital Image Sensors with Bayer Color Filter Arrays
% Method1
% 1. low-pass filtering (filter2)
% 2. down-sampling
% 3. color space conversion
% 4. JPEG compression

clear;clc;close all;

imgIndex = [1];
DM = {'bilinear', 'homogeneity', 'frequency'};

for i=1:length(imgIndex)

    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    [compression_ratio , mse, psnr, scielab, dmImage] = NovelmethodFilter2_applyJPEG(imgFile,'bilinear',75);
    
    disp('Novel Method 2');
    disp(compression_ratio);
end


