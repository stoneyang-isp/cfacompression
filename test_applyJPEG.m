% test CFA compression using JPEG

clear;clc;close all;

addpath cfacompression/applyJPEG

imgIndex = [23];
CM = {'directJPEG' , 'simpleMerging' , 'structureConversion' , 'structureSeperation' , 'NovelMethod1' , 'NovelMethod2'};
%CM = {'NovelMethod2'};
%mode = 'lossless'; quality = [100];
mode = 'lossy'; quality = [25 50 75 100];
%quality = [25];

for i=1:length(imgIndex)

    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    trueImage = double(imread(imgFile));
%     trueImage = trueImage ./ max(trueImage(:));
    [h w c] = size(trueImage);

    % CFA: GRBG
    % simulate cfa image
    rawImage = mosaicRGB(trueImage);
    
    for j=1:length(CM)
        disp(CM{j});
        for q=1:length(quality)
            disp(['quality = ' num2str(quality(q))]);
            [compression_ratio, ind_cell] = apply_JPEG_encoder(rawImage,quality(q),CM{j}, mode);
            [reconImage] = apply_JPEG_decoder(ind_cell, CM{j});
            mse = evaluateQuality(rawImage, reconImage, 'mse');
            %disp(compression_ratio);
            disp(mse);
        end
        figure;
        subplot(121); imagesc(rawImage, [0 255]); colormap gray; axis image;
        subplot(122); imagesc(reconImage, [0 255]); colormap gray; axis image;
    end

end

