function [compressionRatio encodedData] = applyCFALossyCompression(input, method, quality)

addpath cfacompression/losslessprediction cfacompression/applyJPEG

switch method
    
    case {'directJPEG', 'simpleMerging', 'structureConversion', 'structureSeperation', 'NovelMethod1', 'NovelMethod2'}

        [compressionRatio, ind_cell] = apply_JPEG_encoder(input, quality, method, 'lossy');
        encodedData = ind_cell;
        
end

return