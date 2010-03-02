% direct apply jpeg to CFA data

function [compression_ratio, ind_cell] = CFAdataDirect_applyJPEG_encoder(rawImage,quality)

addpath tempImages applyJPEG

% aware that matlab is terrible at displaying images
% zoom in to get rid of aliasing effects

ind = sprintf('tempImages/test1.jpg');
imwrite(rawImage,ind,'jpg','Quality',quality);

jpeg_data = read_jpeg(ind);
jpeg_data_cell = {jpeg_data};

%calculate compression ratio
compression_ratio = calculate_compressionRatio(rawImage,jpeg_data_cell);

ind_cell = {ind};

end