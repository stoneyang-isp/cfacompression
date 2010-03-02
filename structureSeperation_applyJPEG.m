% apply jpeg to each color component
% New Efficient Methods of Image Compression in Digital Cameras with Color Filter Array
% Method 2
% 1. convert to YCbCr
% 2. Structure Seperation

function  [compression_ratio , mse, psnr, scielab, dmImage] = structureSeperation_applyJPEG(imgFile,demosaic_method,quality)

addpath tempImages applyJPEG

trueImage = imresize(double(imread(imgFile)), 1);
trueImage = trueImage ./ max(trueImage(:));

% CFA: GRBG
% simulate cfa image
rawImage = mosaicRGB(trueImage);

% extract color component from rawImage
[red_Array, green_Array1, green_Array2, blue_Array] = extract_colorComponent(rawImage);

% convert RGB to YCbCr
[y_Array1, y_Array2, cb_Array, cr_Array] = cfa_rgb2ycbcr(red_Array, green_Array1, green_Array2, blue_Array);

temp_max = max(max([y_Array1;y_Array2;cb_Array;cr_Array]));
y_Array1 = y_Array1/temp_max;
y_Array2 = y_Array2/temp_max;
cb_Array = cb_Array/temp_max;
cr_Array = cr_Array/temp_max;

% aware that matlab is terrible at displaying images
% zoom in to get rid of aliasing effects

ind_y1=sprintf('tempImages/test4_y1.jpg');
ind_y2=sprintf('tempImages/test4_y2.jpg');
ind_cb=sprintf('tempImages/test4_cb.jpg');
ind_cr=sprintf('tempImages/test4_cr.jpg');

imwrite(y_Array1,ind_y1,'jpg','Quality',quality);
imwrite(y_Array2,ind_y2,'jpg','Quality',quality);
imwrite(cb_Array,ind_cb,'jpg','Quality',quality);
imwrite(cr_Array,ind_cr,'jpg','Quality',quality);

jpeg_y1 = read_jpeg(ind_y1);
jpeg_y2 = read_jpeg(ind_y2);
jpeg_cb = read_jpeg(ind_cb);
jpeg_cr = read_jpeg(ind_cr);
jpeg_cell = {jpeg_y1, jpeg_y2, jpeg_cb, jpeg_cr};

% calculate compression ratio
compression_ratio = calculate_compressionRatio(trueImage,jpeg_cell);

recon_y1 = imresize(double(imread(ind_y1)),1);
recon_y2 = imresize(double(imread(ind_y2)),1);
recon_cb = imresize(double(imread(ind_cb)),1);
recon_cr = imresize(double(imread(ind_cr)),1);

% convert YCbCr to RGB
[recon_red, recon_green1, recon_green2, recon_blue] = cfa_ycbcr2rgb(recon_y1, recon_y2, recon_cb, recon_cr);

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