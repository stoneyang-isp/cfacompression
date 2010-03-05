clear;clc;close all;

mode = 'lossless';
imgIndex = [1:24];
CM = {'directJPEG' , 'simpleMerging' , 'structureConversion' , 'structureSeperation' , 'losslessPrediction'};
DM = {'bilinear', 'homogeneity', 'frequency'};
% dir = ['results_' mode '/'];
quality = [20:10:90];

sizeOrig = zeros(1,length(quality));
sizeComp = zeros(1,length(quality));
mseRGB = zeros(1,length(quality));
for i=1:length(imgIndex)

    disp(['Image ' num2str(i) '..']);
    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    filename = sprintf('kodim%02d',imgIndex(i));
    trueImage = double(imread(imgFile));
    [h w c] = size(trueImage);

    for j=1:length(quality)
        
        imwrite(uint8(trueImage), 'temp.jpg', 'Quality', quality(j));
        reconImage = double(imread('temp.jpg'));
        info = imfinfo('temp.jpg');
        mse = evaluateQuality(trueImage, reconImage, 'mse');
        sizeOrig(j) = sizeOrig(j) + h*w;
        sizeComp(j) = sizeComp(j) + info.FileSize - 163;
        mseRGB(j) = mseRGB(j) + mse;
        
    end
end

rate = sizeOrig ./ sizeComp;
rate = 8./rate;
mseRGB = mseRGB / length(imgIndex);
psnrRGB = 10*log10(255*255./mseRGB);

rateRGBJPEG = rate; psnrRGBJPEG = psnrRGB;
save RGBJPEG.mat rateRGBJPEG psnrRGBJPEG;
% figure; plot(rate, psnrRGB);

