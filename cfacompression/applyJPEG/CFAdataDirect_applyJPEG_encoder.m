% direct apply jpeg to CFA data

function [compression_ratio, ind_cell] = CFAdataDirect_applyJPEG_encoder(rawImage,quality, mode)

addpath cfacompression/applyJPEG/tempImages

ind = sprintf('cfacompression/applyJPEG/tempImages/test1.jpg');
if strcmp(mode, 'lossless')
    imwrite(uint8(rawImage), ind, 'jpg', 'Mode', mode);
else
    imwrite(uint8(rawImage),ind,'jpg','Quality',quality);
end

jpeg_data = read_jpeg(ind);
jpeg_data_cell = {jpeg_data};

%calculate compression ratio
compression_ratio = calculate_compressionRatio(rawImage,jpeg_data_cell);

ind_cell = {ind};

end