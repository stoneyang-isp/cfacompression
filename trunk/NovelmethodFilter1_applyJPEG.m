% apply jpeg to each color component
% A Novel Method of Lossy Image Compression for Digital Image Sensors with Bayer Color Filter Arrays
% Method1
% 1. low-pass filtering (filter1)
% 2. down-sampling
% 3. color space conversion
% 4. JPEG compression

function [compression_ratio , mse, psnr, scielab, dmImage] = NovelmethodFilter1_applyJPEG(imgFile,demosaic_method,quality)

addpath tempImages applyJPEG

trueImage = imresize(double(imread(imgFile)), 1);
trueImage = trueImage ./ max(trueImage(:));

% CFA: GRBG
% simulate cfa image
rawImage = mosaicRGB(trueImage);

% extract color component from rawImage
[red_Array, green_Array1, green_Array2, blue_Array] = extract_colorComponent(rawImage);

% lowpass filtering using filter1
green_Array = lowpass_filtering_1(green_Array1,green_Array2);

% convert RGB to YCbCr
[y_Array1, y_Array2, cb_Array, cr_Array] = cfa_rgb2ycbcr(red_Array, green_Array(1:2:end,:), green_Array(2:2:end,:), blue_Array);

y_Array = merge_Array(y_Array1, y_Array2);

temp_max = max(max([y_Array;cb_Array;cr_Array]));
y_Array = y_Array/temp_max;
cb_Array = cb_Array/temp_max;
cr_Array = cr_Array/temp_max;

% aware that matlab is terrible at displaying images
% zoom in to get rid of aliasing effects

ind_y=sprintf('tempImages/test5_y.jpg');
ind_cb=sprintf('tempImages/test5_cb.jpg');
ind_cr=sprintf('tempImages/test5_cr.jpg');

imwrite(y_Array,ind_y,'jpg','Quality',quality);
imwrite(cb_Array,ind_cb,'jpg','Quality',quality);
imwrite(cr_Array,ind_cr,'jpg','Quality',quality);

jpeg_y = read_jpeg(ind_y);
jpeg_cb = read_jpeg(ind_cb);
jpeg_cr = read_jpeg(ind_cr);
jpeg_cell = {jpeg_y, jpeg_cb, jpeg_cr};

% calculate compression ratio
compression_ratio = calculate_compressionRatio(trueImage,jpeg_cell);

recon_y = imresize(double(imread(ind_y)),1);
recon_cb = imresize(double(imread(ind_cb)),1);
recon_cr = imresize(double(imread(ind_cr)),1);

% convert YCbCr to RGB
[recon_red, recon_green1, recon_green2, recon_blue] = cfa_ycbcr2rgb(recon_y(1:2:end,:), recon_y(2:2:end,:), recon_cb, recon_cr);

% reconstruction raw image
recon_rawImage = reconstruction_rawImage(recon_red, recon_green1, recon_green2, recon_blue);
recon_rawImage = recon_rawImage ./ max(recon_rawImage(:));

%apply demosaic algorithms and evaluate errors
disp(['Demosaicking... ' demosaic_method]);
dmImage = applyDemosaic(recon_rawImage, demosaic_method);
mse = evaluateQuality(trueImage, dmImage, 'mse');
psnr = evaluateQuality(trueImage, dmImage, 'psnr');
scielab = evaluateQuality(trueImage, dmImage, 'scielab');

end