function [dmImage] = structureSeperation_applyJPEG_decoder(ind_cell, demosaic_method)

addpath tempImages applyJPEG

if length(ind_cell) ~= 4
    disp('length of ind_cell should be 4');
end

ind_y1 = ind_cell{1};
ind_y2 = ind_cell{2};
ind_cb = ind_cell{3};
ind_cr = ind_cell{4};

recon_y1 = imresize(double(imread(ind_y1)),1);
recon_y2 = imresize(double(imread(ind_y2)),1);
recon_cb = imresize(double(imread(ind_cb)),1);
recon_cr = imresize(double(imread(ind_cr)),1);

% convert YCbCr to RGB
[recon_red, recon_green1, recon_green2, recon_blue] = cfa_ycbcr2rgb(recon_y1, recon_y2, recon_cb, recon_cr);

% reconstruction raw image
recon_rawImage = reconstruction_rawImage(recon_red, recon_green1, recon_green2, recon_blue);
recon_rawImage = recon_rawImage ./ max(recon_rawImage(:));

%apply demosaic algorithms and evaluate errors
disp(['Demosaicking... ' demosaic_method]);
dmImage = applyDemosaic(recon_rawImage, demosaic_method);

end