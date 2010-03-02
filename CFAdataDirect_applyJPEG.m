% direct apply jpeg to CFA data (test)

function [compression_ratio , mse, psnr, scielab, dmImage] = CFAdataDirect_applyJPEG(imgFile,demosaic_method,quality)

addpath tempImages applyJPEG

% read ground truth image
trueImage = imresize(double(imread(imgFile)), 1);
trueImage = trueImage ./ max(trueImage(:));

% CFA: GRBG
% simulate cfa image
rawImage = mosaicRGB(trueImage);

% aware that matlab is terrible at displaying images
% zoom in to get rid of aliasing effects

ind = sprintf('tempImages/test1.jpg');
imwrite(rawImage,ind,'jpg','Quality',quality);

jpeg_data = read_jpeg(ind);
jpeg_data_cell = {jpeg_data};

%calculate compression ratio
compression_ratio = calculate_compressionRatio(trueImage,jpeg_data_cell);

%reconstruction image
recon_rawImage = imresize(double(imread(ind)),1);
recon_rawImage = recon_rawImage ./ max(recon_rawImage(:));

%apply demosaic algorithms and evaluate errors
disp(['Demosaicking... ' demosaic_method]);
dmImage = applyDemosaic(recon_rawImage,demosaic_method);
mse = evaluateQuality(trueImage, dmImage, 'mse');
psnr = evaluateQuality(trueImage, dmImage, 'psnr');
scielab = evaluateQuality(trueImage, dmImage, 'scielab');

end