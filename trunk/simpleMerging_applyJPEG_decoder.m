function [dmImage] = simpleMerging_applyJPEG_decoder(ind_cell, demosaic_method)

addpath tempImages applyJPEG

if length(ind_cell) ~= 3
    disp('length of ind_cell should be 3');
end

ind_red = ind_cell{1};
ind_green = ind_cell{2};
ind_blue = ind_cell{3};

recon_red = imresize(double(imread(ind_red)),1);
recon_green = imresize(double(imread(ind_green)),1);
recon_blue = imresize(double(imread(ind_blue)),1);

% reconstruction raw image
recon_rawImage = reconstruction_rawImage(recon_red, recon_green(1:2:end,:), recon_green(2:2:end,:), recon_blue);
recon_rawImage = recon_rawImage ./ max(recon_rawImage(:));

%apply demosaic algorithms and evaluate errors
disp(['Demosaicking... ' demosaic_method]);
dmImage = applyDemosaic(recon_rawImage, demosaic_method);

end