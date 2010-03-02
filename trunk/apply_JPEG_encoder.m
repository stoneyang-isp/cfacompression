function [compression_ratio, ind_cell] = apply_JPEG_encoder(rawImage,quality,type)

switch type
    case 'directJPEG'
        [compression_ratio, ind_cell] = CFAdataDirect_applyJPEG_encoder(rawImage,quality);
    case 'simpleMerging'
        [compression_ratio, ind_cell] = simpleMerging_applyJPEG_encoder(rawImage,quality);
    case 'structureConversion'
        [compression_ratio, ind_cell] = structureConversion_applyJPEG_encoder(rawImage,quality);
    case 'structureSeperation'
        [compression_ratio, ind_cell] = structureSeperation_applyJPEG_encoder(rawImage,quality);
    case 'NovelMethod1'
        [compression_ratio, ind_cell] = NovelmethodFilter1_applyJPEG_encoder(rawImage,quality);
    case 'NovelMethod2'
        [compression_ratio, ind_cell] = NovelmethodFilter2_applyJPEG_encoder(rawImage,quality);
end

end