function [compression_ratio , mse, psnr, scielab, dmImage] =apply_JPEG(imgFile,demosaic_method,quality,type)

switch type
    case 'directJPEG'
        [compression_ratio , mse, psnr, scielab, dmImage] = CFAdataDirect_applyJPEG(imgFile,demosaic_method,quality);
    case 'simpleMerging'
        [compression_ratio , mse, psnr, scielab, dmImage] = simpleMerging_applyJPEG(imgFile,demosaic_method,quality);
    case 'structureConversion'
        [compression_ratio , mse, psnr, scielab, dmImage] = structureConversion_applyJPEG(imgFile,demosaic_method,quality);
    case 'structureSeperation'
        [compression_ratio , mse, psnr, scielab, dmImage] = structureSeperation_applyJPEG(imgFile,demosaic_method,quality);
    case 'NovelMethod1'
        [compression_ratio , mse, psnr, scielab, dmImage] = NovelmethodFilter1_applyJPEG(imgFile,demosaic_method,quality);
    case 'NovelMethod2'
        [compression_ratio , mse, psnr, scielab, dmImage] = NovelmethodFilter2_applyJPEG(imgFile,demosaic_method,quality);
end