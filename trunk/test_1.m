% direct apply jpeg to CFA data

clear;clc;close all;

imgIndex = [1];
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

    ind = sprintf('test1_%02d.jpg',i);
    imwrite(rawImage,ind,'jpg');

    jpeg_data = read_jpeg(ind);
    jpeg_data_cell = {jpeg_data};
    
    %calculate compression ratio
    compression_ratio = calculate_compressionRatio(trueImage,jpeg_data_cell);

    %reconstruction image
    recon_rawImage = imresize(double(imread(ind)),1);
    recon_rawImage = recon_rawImage ./ max(recon_rawImage(:));
    
    %apply demosaic algorithms and evaluate errors
    for j=1:length(DM)
        disp(['Demosaicking... ' DM{j}]);
        dmImage = applyDemosaic(recon_rawImage, DM{j});
        mse(j) = evaluateQuality(trueImage, dmImage, 'mse');
        psnr(j) = evaluateQuality(trueImage, dmImage, 'psnr');
        scielab(j) = evaluateQuality(trueImage, dmImage, 'scielab');
        figure(1); subplot(1,length(DM),j); displayRGB(dmImage); title(DM{j});
    end
    %figure(2);
    %subplot(131); bar(mse); title('mse');
    %subplot(132); bar(psnr); title('psnr');
    %subplot(133); bar(scielab); title('scielab');
    
    disp('direct apply JPEG to CFA data');
    disp(compression_ratio);
end

