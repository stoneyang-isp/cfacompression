% apply jpeg to each color component
% New Efficient Methods of Image Compression in Digital Cameras with Color
% Filter Array
% Method 1
% 1. convert to YCbCr
% 2. Structure Conversion

function [compression_ratio, ind_cell] = structureConversion_applyJPEG_encoder(rawImage,quality)

addpath tempImages applyJPEG

% extract color component from rawImage
[red_Array, green_Array1, green_Array2, blue_Array] = extract_colorComponent(rawImage);

% convert RGB to YCbCr
[y_Array1, y_Array2, cb_Array, cr_Array] = cfa_rgb2ycbcr(red_Array, green_Array1, green_Array2, blue_Array);

% structure conversion
y_Array = structure_Conversion(y_Array1, y_Array2);

temp_max = max(max([y_Array;cb_Array;cr_Array]));
y_Array = y_Array/temp_max;
cb_Array = cb_Array/temp_max;
cr_Array = cr_Array/temp_max;

% aware that matlab is terrible at displaying images
% zoom in to get rid of aliasing effects

ind_y=sprintf('tempImages/test3_y.jpg');
ind_cb=sprintf('tempImages/test3_cb.jpg');
ind_cr=sprintf('tempImages/test3_cr.jpg');

imwrite(y_Array,ind_y,'jpg','Quality',quality);
imwrite(cb_Array,ind_cb,'jpg','Quality',quality);
imwrite(cr_Array,ind_cr,'jpg','Quality',quality);

jpeg_y = read_jpeg(ind_y);
jpeg_cb = read_jpeg(ind_cb);
jpeg_cr = read_jpeg(ind_cr);
jpeg_cell = {jpeg_y, jpeg_cb, jpeg_cr};

% calculate compression ratio
compression_ratio = calculate_compressionRatio(rawImage,jpeg_cell);

ind_cell = {ind_y, ind_cb, ind_cr};

end