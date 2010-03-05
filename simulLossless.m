
% test lossless CFA compression methods
clear;clc;close all;

mode = 'lossless';
imgIndex = [1:24];
CM = {'directJPEG' , 'simpleMerging' , 'structureConversion' , 'structureSeperation' , 'losslessPrediction'};
DM = {'bilinear', 'homogeneity', 'frequency'};
dir = ['results_' mode '/'];

for i=1:length(imgIndex)

    disp(['Image ' num2str(i) '..']);
    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    filename = sprintf('kodim%02d',imgIndex(i));
    trueImage = double(imread(imgFile));
    [h w c] = size(trueImage);

    % CFA: GRBG
    % simulate cfa image
    rawImage = mosaicRGB(trueImage);

    fid = fopen([dir filename '_lossless_data.txt'], 'a');
    for j=1:length(CM)
        disp(['CFA lossless.. ' CM{j}]);
        [compression_ratio, ind_cell] = applyCFALosslessCompression(rawImage, CM{j});

        fprintf(fid, '%s\t lossless \t%s\t%7.3f\t%7.3f\t \n', filename, CM{j}, h*w, h*w/compression_ratio);
        
    end
    fclose(fid);
end
