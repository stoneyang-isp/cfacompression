function [recon_rawImage] = structureSeperation_applyJPEG_decoder(ind_cell, demosaic_method)

addpath cfacompression/applyJPEG/tempImages

if length(ind_cell) ~= 4
    disp('length of ind_cell should be 4');
end

ind_y1 = ind_cell{1};
ind_y2 = ind_cell{2};
ind_cb = ind_cell{3};
ind_cr = ind_cell{4};

recon_y1 = double(imread(ind_y1));
recon_y2 = double(imread(ind_y2));
recon_cb = double(imread(ind_cb));
recon_cr = double(imread(ind_cr));

% convert YCbCr to RGB
[recon_red, recon_green1, recon_green2, recon_blue] = cfa_ycbcr2rgb(recon_y1, recon_y2, recon_cb, recon_cr);

% reconstruction raw image
recon_rawImage = reconstruction_rawImage(recon_red, recon_green1, recon_green2, recon_blue);

end