% test CFA compression using JPEG

clear;clc;close all;

imgIndex = [1];
CM = {'directJPEG' , 'simpleMerging' , 'structureConversion' , 'structureSeperation' , 'NovelMethod1' , 'NovelMethod2'};
for i=1:length(imgIndex)

    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    trueImage = imresize(double(imread(imgFile)), 1);
    trueImage = trueImage ./ max(trueImage(:));

    % CFA: GRBG
    % simulate cfa image
    rawImage = mosaicRGB(trueImage);
    
    for j=1:length(CM)
        [compression_ratio, ind_cell] = apply_JPEG_encoder(rawImage,75,CM{j});
        [dmImage] = apply_JPEG_decoder(ind_cell,'bilinear',CM{j});
        disp(CM{j});
        disp(compression_ratio);
    end

end

