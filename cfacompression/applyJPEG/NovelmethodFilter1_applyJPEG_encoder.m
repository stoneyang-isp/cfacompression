% apply jpeg to each color component
% A Novel Method of Lossy Image Compression for Digital Image Sensors with Bayer Color Filter Arrays
% Method1
% 1. low-pass filtering (filter1)
% 2. down-sampling
% 3. color space conversion
% 4. JPEG compression

function [compression_ratio, ind_cell] = NovelmethodFilter1_applyJPEG_encoder(rawImage,quality,mode)

addpath cfacompression/applyJPEG/tempImages

% extract color component from rawImage
[red_Array, green_Array1, green_Array2, blue_Array] = extract_colorComponent(rawImage);

% lowpass filtering using filter1
green_Array = lowpass_filtering_1(green_Array1,green_Array2);

% convert RGB to YCbCr
[y_Array1, y_Array2, cb_Array, cr_Array] = cfa_rgb2ycbcr(red_Array, green_Array(1:2:end,:), green_Array(2:2:end,:), blue_Array);

y_Array = merge_Array(y_Array1, y_Array2);

% aware that matlab is terrible at displaying images
% zoom in to get rid of aliasing effects

ind_y=sprintf('cfacompression/applyJPEG/tempImages/test5_y.jpg');
ind_cb=sprintf('cfacompression/applyJPEG/tempImages/test5_cb.jpg');
ind_cr=sprintf('cfacompression/applyJPEG/tempImages/test5_cr.jpg');

if strcmp(mode, 'lossless')
    imwrite(uint8(y_Array),ind_y,'jpg','Mode',mode);
    imwrite(uint8(cb_Array),ind_cb,'jpg','Mode',mode);
    imwrite(uint8(cr_Array),ind_cr,'jpg','Mode',mode);
else
    imwrite(uint8(y_Array),ind_y,'jpg','Quality',quality);
    imwrite(uint8(cb_Array),ind_cb,'jpg','Quality',quality);
    imwrite(uint8(cr_Array),ind_cr,'jpg','Quality',quality);
end

jpeg_y = read_jpeg(ind_y);
jpeg_cb = read_jpeg(ind_cb);
jpeg_cr = read_jpeg(ind_cr);
jpeg_cell = {jpeg_y, jpeg_cb, jpeg_cr};

% calculate compression ratio
compression_ratio = calculate_compressionRatio(rawImage,jpeg_cell);

ind_cell = {ind_y, ind_cb, ind_cr};

end