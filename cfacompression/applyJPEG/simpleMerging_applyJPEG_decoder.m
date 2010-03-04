function [recon_rawImage] = simpleMerging_applyJPEG_decoder(ind_cell, demosaic_method)

addpath cfacompression/applyJPEG/tempImages

if length(ind_cell) ~= 3
    disp('length of ind_cell should be 3');
end

ind_red = ind_cell{1};
ind_green = ind_cell{2};
ind_blue = ind_cell{3};

recon_red = double(imread(ind_red));
recon_green = double(imread(ind_green));
recon_blue = double(imread(ind_blue));

% reconstruction raw image
recon_rawImage = reconstruction_rawImage(recon_red, recon_green(1:2:end,:), recon_green(2:2:end,:), recon_blue);

end