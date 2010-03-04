function [recon_rawImage] = structureConversion_applyJPEG_decoder(ind_cell, demosaic_method)

addpath cfacompression/applyJPEG/tempImages

if length(ind_cell) ~= 3
    disp('length of ind_cell should be 3');
end

ind_y = ind_cell{1};
ind_cb = ind_cell{2};
ind_cr = ind_cell{3};

recon_y = double(imread(ind_y));
recon_cb = double(imread(ind_cb));
recon_cr = double(imread(ind_cr));

% inverse structure conversion
[recon_y1, recon_y2] = inverse_structure_Conversion(recon_y);

% convert YCbCr to RGB
[recon_red, recon_green1, recon_green2, recon_blue] = cfa_ycbcr2rgb(recon_y1, recon_y2, recon_cb, recon_cr);

% reconstruction raw image
recon_rawImage = reconstruction_rawImage(recon_red, recon_green1, recon_green2, recon_blue);

end