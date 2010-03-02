% apply jpeg to each color component
% reshaping Green array (simple merging)

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
    
    % extract color component from rawImage
    [red_Array, green_Array1, green_Array2, blue_Array] = extract_colorComponent(rawImage);
    
    % simple merging green array
    green_Array = merge_Array(green_Array1, green_Array2);
    
    % aware that matlab is terrible at displaying images
    % zoom in to get rid of aliasing effects

    ind_red=sprintf('test2_%02d_red.jpg',i);
    ind_green=sprintf('test2_%02d_green.jpg',i);
    ind_blue=sprintf('test2_%02d_blue.jpg',i);
    
    imwrite(red_Array,ind_red,'jpg');
    imwrite(green_Array,ind_green,'jpg');
    imwrite(blue_Array,ind_blue,'jpg');

    jpeg_red = read_jpeg(ind_red);
    jpeg_green = read_jpeg(ind_green);
    jpeg_blue = read_jpeg(ind_blue);
    jpeg_cell = {jpeg_red , jpeg_green , jpeg_blue};

    % calculate compression ratio
    compression_ratio = calculate_compressionRatio(trueImage, jpeg_cell);

    recon_red = imresize(double(imread(ind_red)),1);
    recon_green = imresize(double(imread(ind_green)),1);
    recon_blue = imresize(double(imread(ind_blue)),1);
    
    % reconstruction raw image
    recon_rawImage = reconstruction_rawImage(recon_red, recon_green(1:2:end,:), recon_green(2:2:end,:), recon_blue);
    recon_rawImage = recon_rawImage ./ max(recon_rawImage(:));
    
    %apply demosaic algorithms and evaluate errors
    for j=1:length(DM)
        disp(['Demosaicking... ' DM{j}]);
        dmImage = applyDemosaic(recon_rawImage, DM{j});
        mse(j) = evaluateQuality(trueImage, dmImage, 'mse');
        psnr(j) = evaluateQuality(trueImage, dmImage, 'psnr');
        scielab(j) = evaluateQuality(trueImage, dmImage, 'scielab');
        figure(2); subplot(1,length(DM),j); displayRGB(dmImage); title(DM{j});
    end
    %figure(3);
    %subplot(131); bar(mse); title('mse');
    %subplot(132); bar(psnr); title('psnr');
    %subplot(133); bar(scielab); title('scielab');

    disp('Simple Merging');
    disp(compression_ratio);
end

