
% test lossy CFA compression methods
clear;clc;close all;

mode = 'lossy';
imgIndex = [13:18];
CM = {'directJPEG' , 'simpleMerging' , 'structureConversion' , 'structureSeperation' , 'NovelMethod1', 'NovelMethod2'};
DM = {'bilinear', 'homogeneity', 'frequency'};
dir = ['results_' mode '/'];
quality = [10:10:100];

% imgIndex = [23 24];
% CM = {'directJPEG' , 'simpleMerging'};
% DM = {'bilinear', 'frequency'};
% quality = [30 50];

for i=1:length(imgIndex)

    disp(['Image ' num2str(imgIndex(i)) '..']);
    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    filename = sprintf('kodim%02d',imgIndex(i));
    trueImage = double(imread(imgFile));
    [h w c] = size(trueImage);

    % CFA: GRBG
    % simulate cfa image
    rawImage = mosaicRGB(trueImage);
    for k=1:length(DM)
        dmImage{k} = applyDemosaic(rawImage, DM{k});
    end

    for j=1:length(CM)
        disp(['CFA lossy.. ' CM{j}]);
        
        for q=1:length(quality)
            
            [compression_ratio, ind_cell] = applyCFALossyCompression(rawImage, CM{j}, quality(q));
            reconImage = applyCFALossyDecompression(ind_cell, CM{j});
            
            mse = evaluateQuality(rawImage, reconImage, 'mse');

            fid = fopen([dir filename '_lossy_' CM{j} '_none_data.txt'], 'a');
            fprintf(fid, '%s\t lossy \t%s\t%7.3f\t%7.3f\t%7.3f\t%s\t%7.3f\t%7.3f\t%7.3f\t%7.3f\t \n', filename, CM{j}, h*w, h*w/compression_ratio, quality(q), 'none', mse, 0, 0, 0);
            fclose(fid);

            for k=1:length(DM)
                rgbImage{k} = applyDemosaic(reconImage, DM{k});

                mse1 = evaluateQuality(rgbImage{k}, dmImage{k}, 'mse');
                mse2 = evaluateQuality(rgbImage{k}, trueImage, 'mse');
                scielab1 = evaluateQuality(rgbImage{k}/255, dmImage{k}/255, 'scielab');
                scielab2 = evaluateQuality(rgbImage{k}/255, trueImage/255, 'scielab');

                fid = fopen([dir filename '_lossy_' CM{j} '_' DM{k} '_data.txt'], 'a');
                fprintf(fid, '%s\t lossy \t%s\t%7.3f\t%7.3f\t%7.3f\t%s\t%7.3f\t%7.3f\t%7.3f\t%7.3f\t \n', filename, CM{j}, h*w, h*w/compression_ratio, quality(q), 'none', mse1, scielab1, mse2, scielab2);
                fclose(fid);
                
            end
        end
        
        
    end
end
