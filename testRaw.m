clear;clc;close all;

imgIndex = [9 19 23];
imgIndex = [23];
DM = {'bilinear', 'homogeneity', 'frequency'};

for i=1:length(imgIndex)
    
    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    trueImage = imresize(double(imread(imgFile)), 1);
    trueImage = trueImage ./ max(trueImage(:));
    
    % CFA: GRBG
    % simulate cfa image
    rawImage = mosaicRGB(trueImage);

    % aware that matlab is terrible at displaying images
    % zoom in to get rid of aliasing effects
    figure(1); 
    subplot(131); displayRGB(trueImage);
    subplot(132); displayRAW(rawImage);
    subplot(133); displayRGB(rawImage);
    
    % apply demosaic algorithms and evaluate errors
    for j=1:length(DM)
        disp(['Demosaicking... ' DM{j}]);
        dmImage = applyDemosaic(rawImage, DM{j});
        mse(j) = evaluateQuality(trueImage, dmImage, 'mse');
        psnr(j) = evaluateQuality(trueImage, dmImage, 'psnr');
        scielab(j) = evaluateQuality(trueImage, dmImage, 'scielab');
        figure(2); subplot(1,length(DM),j); displayRGB(dmImage); title(DM{j});
    end    
    
    figure(3); 
    subplot(131); bar(mse); title('mse');
    subplot(132); bar(psnr); title('psnr');
    subplot(133); bar(scielab); title('scielab');
    
end

