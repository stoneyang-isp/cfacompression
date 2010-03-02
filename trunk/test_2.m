% apply jpeg to each color component
% reshaping Green array (simple merging)

clear;clc;close all;

imgIndex = [1];
DM = {'bilinear', 'homogeneity', 'frequency'};

for i=1:length(imgIndex)

    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    
    [compression_ratio , mse, psnr, scielab, dmImage] = simpleMerging_applyJPEG(imgFile,'bilinear',75);

    disp('Simple Merging');
    disp(compression_ratio);
end

