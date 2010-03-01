% apply jpeg to each color component
% New Efficient Methods of Image Compression in Digital Cameras with Color
% Filter Array
% Method 1
% 1. convert to YCbCr
% 2. Structure Conversion

clear;clc;close all;

imgIndex = [1];
DM = {'bilinear', 'homogeneity', 'frequency'};
color_conversion = [128.6 0 25 65.5;0 128.6 25 65.5;-37.1 -37.1 112 -37.8; -46.9 -46.9 -18.2 112];
color_conversion_const = [0;0;128;128];

for i=1:length(imgIndex)

    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    trueImage = imresize(double(imread(imgFile)), 1);
    trueImage = trueImage ./ max(trueImage(:));
    
    % CFA: GRBG
    % simulate cfa image
    rawImage = mosaicRGB(trueImage);
    
    red_Array = rawImage(2:2:end,1:2:end);
    green_Array1 = rawImage(1:2:end,1:2:end);
    green_Array2 = rawImage(2:2:end,2:2:end);
    blue_Array = rawImage(1:2:end,2:2:end);
    
    y_Array1 = zeros(size(red_Array));
    y_Array2 = zeros(size(red_Array));
    cb_Array = zeros(size(red_Array)); 
    cr_Array = zeros(size(red_Array));
    
    for x=1:size(red_Array,1)
        for y=1:size(red_Array,2)
            temp = [green_Array1(x,y) ; green_Array2(x,y) ; blue_Array(x,y) ; red_Array(x,y)];
            output = color_conversion*temp + color_conversion_const;
            y_Array1(x,y) = output(1);
            y_Array2(x,y) = output(2);
            cb_Array(x,y) = output(3);
            cr_Array(x,y) = output(4);
        end
    end
    
    y_Array = zeros(size(red_Array,1)*2,size(red_Array,2));
    y_Array(2:2:end,:) = y_Array2;
    
    for x=1:size(y_Array1,1)
        for y=1:size(y_Array1,2)
            if x == 1
                y_Array(2*x-1,y) = 0.5*y_Array1(x,y) + 0.25*y_Array2(x,y);
            else
                y_Array(2*x-1,y) = 0.5*y_Array1(x,y) + 0.25*y_Array2(x-1,y) + 0.25*y_Array2(x,y);
            end
        end
    end

    temp_max = max(max([y_Array;cb_Array;cr_Array]));
    y_Array = y_Array/temp_max;
    cb_Array = cb_Array/temp_max;
    cr_Array = cr_Array/temp_max;
    
    % aware that matlab is terrible at displaying images
    % zoom in to get rid of aliasing effects

    ind_y=sprintf('test3_%02d_y.jpg',i);
    ind_cb=sprintf('test3_%02d_cb.jpg',i);
    ind_cr=sprintf('test3_%02d_cr.jpg',i);
    
    imwrite(y_Array,ind_y,'jpg');
    imwrite(cb_Array,ind_cb,'jpg');
    imwrite(cr_Array,ind_cr,'jpg');

    fp_y = fopen(ind_y,'r');
    jpeg_y=fread(fp_y,[1,inf],'uchar');
    fclose(fp_y);
    
    fp_cb = fopen(ind_cb,'r');
    jpeg_cb=fread(fp_cb,[1,inf],'uchar');
    fclose(fp_cb);
    
    fp_cr = fopen(ind_cr,'r');
    jpeg_cr=fread(fp_cr,[1,inf],'uchar');
    fclose(fp_cr);

    compression_ratio = size(trueImage,1)*size(trueImage,2)*size(trueImage,3)/(length(jpeg_y)-623+length(jpeg_cb)-623+length(jpeg_cr)-623);

    recon_y = imresize(double(imread(ind_y)),1);
    recon_cb = imresize(double(imread(ind_cb)),1);
    recon_cr = imresize(double(imread(ind_cr)),1);
    
    recon_y1 = zeros(size(red_Array));
    recon_y2 = recon_y(2:2:end,:);
    
    for x=1:size(recon_y1,1)
        for y=1:size(recon_y1,2)
            if x==1
                recon_y1(x,y) = 2*recon_y(2*x-1,y) - 0.5*recon_y(2*x,y);
            else
                recon_y1(x,y) = 2*recon_y(2*x-1,y) - 0.5*recon_y(2*x-2,y) - 0.5*recon_y(2*x,y);
            end
        end
    end
    
    recon_green1 = zeros(size(red_Array));
    recon_green2 = zeros(size(red_Array));
    recon_red = zeros(size(red_Array));
    recon_blue = zeros(size(red_Array));
    
    for x=1:size(red_Array,1)
        for y=1:size(red_Array,2)
            temp = [recon_y1(x,y) ; recon_y2(x,y) ; recon_cb(x,y) ; recon_cr(x,y)];
            output = inv(color_conversion) * (temp-color_conversion_const);
            recon_green1(x,y) = output(1);
            recon_green2(x,y) = output(2);
            recon_blue(x,y) = output(3);
            recon_red(x,y) = output(4);
        end
    end

        
    recon_rawImage = zeros(size(rawImage));
    recon_rawImage(2:2:end,1:2:end) = recon_red;
    recon_rawImage(1:2:end,1:2:end) = recon_green1;
    recon_rawImage(2:2:end,2:2:end) = recon_green2;
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
    
    disp('Method 1');
    disp(compression_ratio);
end

