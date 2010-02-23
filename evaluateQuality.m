function [result errorImage] = evaluateQuality(imTrue, imOutput, mode, display);

addpath scielab

if iscell(imOutput) == 0
    imTemp = imOutput; clear imOutput;
    imOutput{1} = imTemp;
end

switch mode
    case 'mse'
        for i=1:length(imOutput)
            if size(imTrue,3)==1
                errorImage{i} = (imTrue - imOutput{i}).^2;
                result(i) = mean(mean(errorImage{i}));
            elseif size(imTrue,3)==3
                errorImage{i} = sum((imTrue - imOutput{i}).^2,3)/3;
                result(i) = mean(mean(errorImage{i}));
            end
            errMax(i) = max(errorImage{i}(:));
            errMin(i) = min(errorImage{i}(:));
        end
    case 'psnr'
        for i=1:length(imOutput)
            if size(imTrue,3)==1
                errorImage{i} = (imTrue - imOutput{i}).^2;
                result(i) = mean(mean(errorImage{i}));
                result(i) = 20*log10(1/sqrt(result(i)));
            elseif size(imTrue,3)==3
                errorImage{i} = sum((imTrue - imOutput{i}).^2,3)/3;
                result(i) = mean(mean(errorImage{i}));
                result(i) = 20*log10(1/sqrt(result(i)));
            end
            errMax(i) = max(errorImage{i}(:));
            errMin(i) = min(errorImage{i}(:));
        end
    case 'scielab'
        if size(imTrue,3)~=3
            result = zeros(length(imOutput));
            return
        end
        sampPerDeg = 23;
        load displaySPD;
        load SmithPokornyCones;
        rgb2lms = cones'* displaySPD;
        load displayGamma;
        rgbWhite = [1 1 1];
        whitepoint = rgbWhite * rgb2lms';

        for i=1:length(imOutput)
            % input image should be from 0 to 1
            img = truncate([ imTrue(:,:,1) imTrue(:,:,2) imTrue(:,:,3)], 0, 1);
            imgRGB = dac2rgb(img,gammaTable);
            img1LMS = changeColorSpace(imgRGB,rgb2lms);
            img = truncate([ imOutput{i}(:,:,1) imOutput{i}(:,:,2) imOutput{i}(:,:,3)], 0, 1);
            imgRGB = dac2rgb(img,gammaTable);
            img2LMS = changeColorSpace(imgRGB,rgb2lms);
            imageformat = 'lms';

            errorImage{i} = scielab(sampPerDeg, img1LMS, img2LMS, whitepoint, imageformat);
            result(i) = median(errorImage{i}(:));
            errMax(i) = max(errorImage{i}(:));
            errMin(i) = min(errorImage{i}(:));
        end
end

if(exist('display')==1)
    figure;
    for k=1:length(imOutput)
        subplot(ceil(length(imOutput)/2), 2, k); imshow(errorImage{k}, [min(errMin) max(errMax)]);
    end
end

return