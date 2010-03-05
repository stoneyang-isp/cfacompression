
% test lossless CFA compression methods
clear;clc;close all;

mode = 'lossless';
imgIndex = [1:24];
CM = {'directJPEG' , 'simpleMerging' , 'structureConversion' , 'structureSeperation' , 'losslessPrediction'};
DM = {'bilinear', 'homogeneity', 'frequency'};
dir = ['results_' mode '/'];

totalData = zeros(1,length(CM)); totalEncoded = zeros(1,length(CM));
for i=1:length(imgIndex)

    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    filename = sprintf('kodim%02d',imgIndex(i));

    fid = fopen([dir filename '_lossless_data.txt'], 'r');
    while 1
        tline = fgetl(fid);
        if ~ischar(tline),   break,   end
        methodCM = char(sscanf(tline, '%*s %*s %s %*f %*f'))';
        lengthOrig = sscanf(tline, '%*s %*s %*s %f %*f');
        lengthComp = sscanf(tline, '%*s %*s %*s %*f %f');
        for j=1:length(CM)
            if strcmp(methodCM, CM{j}), break;, end
            if j==length(CM), disp('Error!');, end
        end

        totalData(j) = totalData(j) + lengthOrig;
        totalEncoded(j) = totalEncoded(j) + lengthComp;
    end
    fclose(fid);
end
ratio = totalData ./ totalEncoded;
figure; bar(ratio);
