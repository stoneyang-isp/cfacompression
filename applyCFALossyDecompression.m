function [reconImage] = applyCFALossyDecompression(encodedData, method)

addpath cfacompression/losslessprediction cfacompression/applyJPEG

switch method
    
    case {'directJPEG', 'simpleMerging', 'structureConversion', 'structureSeperation', 'NovelMethod1', 'NovelMethod2'}

        reconImage = apply_JPEG_decoder(encodedData, method);
       
end

return