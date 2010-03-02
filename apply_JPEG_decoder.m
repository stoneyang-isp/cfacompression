function [dmImage] = apply_JPEG_decoder(ind_cell, demosaic_method,type)

switch type
    case 'directJPEG'
        [dmImage] = CFAdataDirect_applyJPEG_decoder(ind_cell, demosaic_method);
    case 'simpleMerging'
        [dmImage] = simpleMerging_applyJPEG_decoder(ind_cell, demosaic_method);
    case 'structureConversion'
        [dmImage] = structureConversion_applyJPEG_decoder(ind_cell, demosaic_method);
    case 'structureSeperation'
        [dmImage] = structureSeperation_applyJPEG_decoder(ind_cell, demosaic_method);
    case 'NovelMethod1'
        [dmImage] = NovelmethodFilter1_applyJPEG_decoder(ind_cell, demosaic_method);
    case 'NovelMethod2'
        [dmImage] = NovelmethodFilter2_applyJPEG_decoder(ind_cell, demosaic_method);
end

end