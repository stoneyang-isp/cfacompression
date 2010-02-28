function [compressionRatio encodedData] = applyCFACompression(input, method)

addpath cfacompression/losslessprediction 

switch method
    case 'jpeg'
        
        
    case 'losslessprediction'
        % compressionRatio is obtained by ideal entropy coding
        % encodedData contains uncompressed prediction errors
        [compressionRatio encodedData] = cfaLosslessPrediction(input);
end

return