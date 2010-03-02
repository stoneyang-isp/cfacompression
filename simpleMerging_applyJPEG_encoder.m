% apply jpeg to each color component
% reshaping Green array (simple merging)

function [compression_ratio, ind_cell] = simpleMerging_applyJPEG_encoder(rawImage,quality)

addpath tempImages applyJPEG

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
compression_ratio = calculate_compressionRatio(rawImage, jpeg_cell);

ind_cell = {ind_red , ind_green , ind_blue};

end