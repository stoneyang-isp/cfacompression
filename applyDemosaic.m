% Applies demosaic to the image.
%
function imDemosaic = applyDemosaic(imRaw, mode)

addpath demosaic/ah demosaic/freq 

if size(imRaw,3)==1
    imInput = decomposeRAW(imRaw);
else
    imInput = imRaw;
end

switch mode
    case 'bilinear'
        % modified to handle data after demosaicking
        imInput = [imInput(:,2,:) imInput imInput(:,size(imInput,2)-1,:)];
        imInput = [imInput(2,:,:); imInput; imInput(size(imInput,1)-1,:,:)];

        imDemosaic(:,:,2) = conv2(imInput(:,:,2), [0 1/4 0; 1/4 1 1/4; 0 1/4 0] , 'valid');
        imTemp = conv2(imInput(:,:,1), [1/2 1 1/2], 'valid');
        imDemosaic(:,:,1) = conv2(imTemp, [1/2 1 1/2]' , 'valid');
        imTemp = conv2(imInput(:,:,3), [1/2 1 1/2], 'valid');
        imDemosaic(:,:,3) = conv2(imTemp, [1/2 1 1/2]' , 'valid');
    case 'homogeneity'
        imDemosaic = MNdemosaic(imInput,1);
    case 'frequency'
        imDemosaic = demos_freq_adapt_SPL(imRaw);
end
        
return
