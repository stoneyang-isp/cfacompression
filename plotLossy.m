
% test lossy CFA compression methods
clear;clc;close all;

mode = 'lossy';
imgIndex = [1:24];
CM = {'directJPEG' , 'simpleMerging' , 'structureConversion' , 'structureSeperation' , 'NovelMethod1', 'NovelMethod2'};
DM = {'bilinear', 'homogeneity', 'frequency'};
dir = ['results_' mode '/'];
quality = [10:10:100];

% imgIndex = [23 24];
% CM = {'directJPEG' , 'simpleMerging'};
% DM = {'bilinear', 'frequency'};
% quality = [30 50];

rateRAW1 = zeros(length(CM), length(quality));
rateRAW2 = zeros(length(CM), length(quality));
mseRAW = zeros(length(CM), length(quality));
mseRGB = zeros(length(CM), length(quality), length(DM));
scielabRGB = zeros(length(CM), length(quality), length(DM));
for i=1:length(imgIndex)

    filename = sprintf('kodim%02d',imgIndex(i));

    for j=1:length(CM)

        for q=1:length(quality)

            fid = fopen([dir filename '_lossy_' CM{j} '_none_data.txt'], 'r');

            while 1
                tline = fgetl(fid);
                if ~ischar(tline),   break,   end
                lengthOrig = sscanf(tline, '%*s %*s %*s %f %*f %*f %*s %*f %*f %*f %*f');
                lengthComp = sscanf(tline, '%*s %*s %*s %*f %f %*f %*s %*f %*f %*f %*f');
                qq = sscanf(tline, '%*s %*s %*s %*f %*f %f %*s %*f %*f %*f %*f');
                mse = sscanf(tline, '%*s %*s %*s %*f %*f %*f %*s %f %*f %*f %*f');
                index = find(quality == qq);

                rateRAW1(j, index) = rateRAW1(j, index) + lengthOrig;
                rateRAW2(j, index) = rateRAW2(j, index) + lengthComp;
                mseRAW(j, index) = mseRAW(j, index) + mse;
            end

            fclose(fid);

            for k=1:length(DM)

                fid = fopen([dir filename '_lossy_' CM{j} '_' DM{k} '_data.txt'], 'r');

                while 1
                    tline = fgetl(fid);
                    if ~ischar(tline),   break,   end
                    qq = sscanf(tline, '%*s %*s %*s %*f %*f %f %*s %*f %*f %*f %*f');
                    mse = sscanf(tline, '%*s %*s %*s %*f %*f %*f %*s %f %*f %*f %*f');
                    scielab = sscanf(tline, '%*s %*s %*s %*f %*f %*f %*s %*f %f %*f %*f');
                    index = find(quality == qq);

                    mseRGB(j, index, k) = mseRGB(j, index, k) + mse;
                    scielabRGB(j, index, k) = scielabRGB(j, index, k) + scielab;
                end

                fclose(fid);

            end
        end


    end
end

rateRAW = rateRAW1 ./ rateRAW2;
mseRAW = mseRAW / length(imgIndex);
mseRGB = mseRGB / length(imgIndex);
scielabRGB = scielabRGB / length(imgIndex);

psnrRAW = 10*log10(255*255./mseRAW);
psnrRGB = 10*log10(255*255./mseRGB);

rateRAW = 8./rateRAW;

rateRAW = rateRAW(:,1:9);
psnrRAW = psnrRAW(:,1:9,:);
psnrRGB = psnrRGB(:,1:9,:);
scielabRGB = scielabRGB(:,1:9,:);

figure(1);
plot(rateRAW', psnrRAW'); title('CFA Comparison'); xlabel('Rate (bpp)'); ylabel('PSNR (dB)');
legend(CM, 'Location', 'Southeast');

figure(2);
for i=1:length(DM)
    subplot(1, length(DM),i); plot(rateRAW', psnrRGB(:,:,i)'); title(['RGB Comparison - ' DM{i}]); xlabel('Rate (bpp)'); ylabel('PSNR (dB)');
    legend(CM, 'Location', 'Southeast');
end

figure(3);
for i=1:length(DM)
    subplot(1, length(DM),i); plot(rateRAW', scielabRGB(:,:,i)'); title(['RGB Comparison - ' DM{i}]); xlabel('Rate (bpp)'); ylabel('sCIELAB');
    legend(CM, 'Location', 'Northeast');
end

