% test CFA compression using JPEG

clear;clc;close all;

imgIndex = [1];
CM = {'directJPEG' , 'simpleMerging' , 'structureConversion' , 'structureSeperation' , 'NovelMethod1' , 'NovelMethod2'};
for i=1:length(imgIndex)

    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    for j=1:length(CM)
        [compression_ratio , mse(j), psnr(j), scielab(j), dmImage{j}] = apply_JPEG(imgFile,'bilinear',75,CM{j});
        disp(CM{j});
        disp(compression_ratio);
    end
    
end

