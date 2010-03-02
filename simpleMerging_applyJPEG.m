% apply jpeg to each color component
% reshaping Green array (simple merging)

function [compression_ratio , mse, psnr, scielab, dmImage] = simpleMerging_applyJPEG(imgFile,demosaic_method,quality)

addpath tempImages applyJPEG

% read ground truth image
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

ind_red=sprintf('tempImages/test2_red.jpg');
ind_green=sprintf('tempImages/test2_green.jpg');
ind_blue=sprintf('tempImages/test2_blue.jpg');

imwrite(red_Array,ind_red,'jpg','Quality',quality);
imwrite(green_Array,ind_green,'jpg','Quality',quality);
imwrite(blue_Array,ind_blue,'jpg','Quality',quality);

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
disp(['Demosaicking... ' demosaic_method]);
dmImage = applyDemosaic(recon_rawImage, demosaic_method);
mse = evaluateQuality(trueImage, dmImage, 'mse');
psnr = evaluateQuality(trueImage, dmImage, 'psnr');
scielab = evaluateQuality(trueImage, dmImage, 'scielab');

end
