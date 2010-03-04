% apply jpeg to each color component
% New Efficient Methods of Image Compression in Digital Cameras with Color Filter Array
% Method 2
% 1. convert to YCbCr
% 2. Structure Seperation

function [compression_ratio, ind_cell] = structureSeperation_applyJPEG_encoder(rawImage,quality, mode)

addpath cfacompression/applyJPEG/tempImages

% extract color component from rawImage
[red_Array, green_Array1, green_Array2, blue_Array] = extract_colorComponent(rawImage);

% convert RGB to YCbCr
[y_Array1, y_Array2, cb_Array, cr_Array] = cfa_rgb2ycbcr(red_Array, green_Array1, green_Array2, blue_Array);

% aware that matlab is terrible at displaying images
% zoom in to get rid of aliasing effects

ind_y1=sprintf('cfacompression/applyJPEG/tempImages/test4_y1.jpg');
ind_y2=sprintf('cfacompression/applyJPEG/tempImages/test4_y2.jpg');
ind_cb=sprintf('cfacompression/applyJPEG/tempImages/test4_cb.jpg');
ind_cr=sprintf('cfacompression/applyJPEG/tempImages/test4_cr.jpg');

if strcmp(mode, 'lossless')
    imwrite(uint8(y_Array1),ind_y1,'jpg','Mode',mode);
    imwrite(uint8(y_Array2),ind_y2,'jpg','Mode',mode);
    imwrite(uint8(cb_Array),ind_cb,'jpg','Mode',mode);
    imwrite(uint8(cr_Array),ind_cr,'jpg','Mode',mode);
else

    imwrite(uint8(y_Array1),ind_y1,'jpg','Quality',quality);
    imwrite(uint8(y_Array2),ind_y2,'jpg','Quality',quality);
    imwrite(uint8(cb_Array),ind_cb,'jpg','Quality',quality);
    imwrite(uint8(cr_Array),ind_cr,'jpg','Quality',quality);
end

jpeg_y1 = read_jpeg(ind_y1);
jpeg_y2 = read_jpeg(ind_y2);
jpeg_cb = read_jpeg(ind_cb);
jpeg_cr = read_jpeg(ind_cr);
jpeg_cell = {jpeg_y1, jpeg_y2, jpeg_cb, jpeg_cr};

% calculate compression ratio
compression_ratio = calculate_compressionRatio(rawImage,jpeg_cell);

ind_cell = {ind_y1, ind_y2, ind_cb, ind_cr};

end