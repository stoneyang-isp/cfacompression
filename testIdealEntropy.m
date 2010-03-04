clear;clc;close all;

imgIndex = [9 19 23];
imgIndex = [1:24];
imgIndex = [23];
DM = {'bilinear', 'homogeneity', 'frequency'};
name1 = {'Red', 'Green', 'Blue'};
name2 = {'Y', 'Cb', 'Cr'};

for j=1:3
    pmfRGB{j} = zeros(1,256);
    pmfYCbCr{j} = zeros(1,513);
    for k=1:length(DM)
        pmfDMRGB{k,j} = zeros(1,256);
    end
end
pmfCFA = zeros(1,256);
pmfJointRGB = zeros(256,256,256);

for i=1:length(imgIndex) 
    
    disp(['Image ' num2str(i)]);
    % read ground truth image
    imgFile = sprintf('kodim/kodim%02d.png', imgIndex(i));
    trueImage = double(imread(imgFile));
    trueImageYCbCr = floor(rgb2ycbcr(trueImage));
    [h w c] = size(trueImage);

    for j=1:3
        % entropy R, G, B
        pmfRGB{j} = pmfRGB{j} + evaluatePmf(trueImage(:,:,j), 0, 255);
        % entropy Y, Cb, Cr
        pmfYCbCr{j} = pmfYCbCr{j} + evaluatePmf(trueImageYCbCr(:,:,j), -256, 256);
    end

    % joint entropy of RGB values
    pmfJointRGB = pmfJointRGB + evaluateJointPmf(trueImage);

    % CFA: GRBG
    rawImage = mosaicRGB(trueImage);

    % demosaic
    for k=1:length(DM)
        dmImage{k} = truncate(round(applyDemosaic(rawImage, DM{k})), 0, 255);
    end
    
    % entropy CFA
    pmfCFA = pmfCFA + evaluatePmf(rawImage, 0, 255);

    for k=1:length(DM)
        for j=1:3
            pmfDMRGB{k,j} = pmfDMRGB{k,j} + evaluatePmf(dmImage{k}(:,:,j), 0, 255);
        end
    end    
end

bppRGB = 0; bppYCbCr = 0; bppDMRGB = zeros(1,length(DM));
for j=1:3
    pmfRGB{j} = pmfRGB{j} ./ sum(pmfRGB{j}(:));
    entropyRGB(j) = evaluateEntropy(pmfRGB{j});
    bppRGB = bppRGB + entropyRGB(j);
    pmfYCbCr{j} = pmfYCbCr{j} ./ sum(pmfYCbCr{j}(:));
    entropyYCbCr(j) = evaluateEntropy(pmfYCbCr{j});
    bppYCbCr = bppYCbCr + entropyYCbCr(j);
    for k=1:length(DM)
        pmfDMRGB{k,j} = pmfDMRGB{k,j} ./ sum(pmfDMRGB{k,j}(:));
        entropyDMRGB(k,j) = evaluateEntropy(pmfDMRGB{k,j});
        bppDMRGB(k) = bppDMRGB(k) + entropyDMRGB(k,j);
    end
end
pmfJointRGB = pmfJointRGB ./ sum(pmfJointRGB(:)); 
entropyJointRGB = evaluateEntropy(pmfJointRGB(:));
pmfCFA = pmfCFA ./ sum(pmfCFA(:));
entropyCFA = evaluateEntropy(pmfCFA);

for j=1:3, disp(['Entropy of ' name1{j} ' channel: ' num2str(entropyRGB(j)) ' bpp']);, end
disp(['Total ' num2str(bppRGB) ' bits per pixel / ' num2str(h*w*bppRGB) ' bits per image']);

disp('.');
for j=1:3, disp(['Entropy of ' name2{j} ' channel: ' num2str(entropyYCbCr(j)) ' bpp']);, end
disp(['Total ' num2str(bppYCbCr) ' bits per pixel / ' num2str(h*w*bppYCbCr) ' bits per image']);

disp('.');
disp(['Joint entropy of RGB channels: ' num2str(entropyJointRGB) ' bpp']);
disp(['Total ' num2str(entropyJointRGB) ' bits per pixel / ' num2str(h*w*entropyJointRGB) ' bits per image']);

disp('.');
disp(['Entropy of CFA image: ' num2str(entropyCFA) ' bpp']);
disp(['Total ' num2str(entropyCFA) ' bits per pixel / ' num2str(h*w*entropyCFA) ' bits per image']);

disp('.');
for k=1:length(DM)
    for j=1:3, disp(['Entropy of ' name1{j} ' channel after ' DM{k} ' : ' num2str(entropyDMRGB(k,j)) ' bpp']);, end
    disp(['Total ' num2str(bppDMRGB) ' bits per pixel / ' num2str(h*w*bppDMRGB) ' bits per image']);
end

