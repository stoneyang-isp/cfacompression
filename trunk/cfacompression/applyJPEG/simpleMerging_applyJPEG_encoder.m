% apply jpeg to each color component
% reshaping Green array (simple merging)

function [compression_ratio, ind_cell] = simpleMerging_applyJPEG_encoder(rawImage,quality, mode)

addpath cfacompression/applyJPEG/tempImages

% extract color component from rawImage
[red_Array, green_Array1, green_Array2, blue_Array] = extract_colorComponent(rawImage);

% simple merging green array
green_Array = merge_Array(green_Array1, green_Array2);

ind_red=sprintf('cfacompression/applyJPEG/tempImages/test2_red.jpg');
ind_green=sprintf('cfacompression/applyJPEG/tempImages/test2_green.jpg');
ind_blue=sprintf('cfacompression/applyJPEG/tempImages/test2_blue.jpg');

if strcmp(mode, 'lossless')
    imwrite(uint8(red_Array),ind_red,'jpg','Mode',mode);
    imwrite(uint8(green_Array),ind_green,'jpg','Mode',mode);
    imwrite(uint8(blue_Array),ind_blue,'jpg','Mode',mode);
else    
    imwrite(uint8(red_Array),ind_red,'jpg','Quality',quality);
    imwrite(uint8(green_Array),ind_green,'jpg','Quality',quality);
    imwrite(uint8(blue_Array),ind_blue,'jpg','Quality',quality);
end

jpeg_red = read_jpeg(ind_red);
jpeg_green = read_jpeg(ind_green);
jpeg_blue = read_jpeg(ind_blue);
jpeg_cell = {jpeg_red , jpeg_green , jpeg_blue};

% calculate compression ratio
compression_ratio = calculate_compressionRatio(rawImage, jpeg_cell);

ind_cell = {ind_red , ind_green , ind_blue};

end