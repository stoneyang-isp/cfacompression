clear;clc;close all;

imgIndex = [1:24];
imgIndex = [23];
DM = {'bilinear', 'homogeneity', 'frequency'};

for i=1:length(imgIndex)

    disp(['Image ' num2str(i) '..']);
    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    trueImage = double(imread(imgFile));
    [h w c] = size(trueImage);

    % CFA: GRBG
    rawImage = mosaicRGB(trueImage);

    [compressionRatio encodedData] = applyCFACompression(rawImage, 'losslessprediction');
    
    disp(['Compression Ratio: ' num2str(compressionRatio)]);
    
end
