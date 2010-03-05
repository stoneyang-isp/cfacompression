function [compressionRatio encodedData] = applyCFALosslessCompression(input, method)

addpath cfacompression/losslessprediction cfacompression/applyJPEG

switch method
    
    case {'directJPEG', 'simpleMerging', 'structureConversion', 'structureSeperation'}

        [compressionRatio, ind_cell] = apply_JPEG_encoder(input, 0, method, 'lossless');
        encodedData = ind_cell;
        
    case 'losslessPrediction'
        % compressionRatio is obtained by ideal entropy coding
        % encodedData contains uncompressed prediction errors
        [compressionRatio encodedData] = cfaLosslessPrediction(input);
end

return