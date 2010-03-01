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
    
    red_Array = rawImage(2:2:end,1:2:end);
    green_Array = zeros(size(rawImage,1),size(rawImage,2)/2);
    green_Array(1:2:end,:) = rawImage(1:2:end,1:2:end);
    green_Array(2:2:end,:) = rawImage(2:2:end,2:2:end);
    blue_Array = rawImage(1:2:end,2:2:end);
    
    % aware that matlab is terrible at displaying images
    % zoom in to get rid of aliasing effects

    ind_red=sprintf('test2_%02d_red.jpg',i);
    ind_green=sprintf('test2_%02d_green.jpg',i);
    ind_blue=sprintf('test2_%02d_blue.jpg',i);
    
    imwrite(red_Array,ind_red,'jpg');
    imwrite(green_Array,ind_green,'jpg');
    imwrite(blue_Array,ind_blue,'jpg');

    fp_red = fopen(ind_red,'r');
    jpeg_red=fread(fp_red,[1,inf],'uchar');
    fclose(fp_red);
    
    fp_green = fopen(ind_green,'r');
    jpeg_green=fread(fp_green,[1,inf],'uchar');
    fclose(fp_green);
    
    fp_blue = fopen(ind_blue,'r');
    jpeg_blue=fread(fp_blue,[1,inf],'uchar');
    fclose(fp_blue);

    compression_ratio = size(trueImage,1)*size(trueImage,2)*size(trueImage,3)/(length(jpeg_red)-623+length(jpeg_green)-623+length(jpeg_blue)-623);

    recon_red = imresize(double(imread(ind_red)),1);
    recon_green = imresize(double(imread(ind_green)),1);
    recon_blue = imresize(double(imread(ind_blue)),1);
    
    recon_rawImage = zeros(size(rawImage));
    recon_rawImage(2:2:end,1:2:end) = recon_red;
    recon_rawImage(1:2:end,1:2:end) = recon_green(1:2:end,:);
    recon_rawImage(2:2:end,2:2:end) = recon_green(2:2:end,:);
    recon_rawImage(1:2:end,2:2:end) = recon_blue;
    
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

