function [dmImage] = CFAdataDirect_applyJPEG_decoder(ind_cell, demosaic_method)

addpath tempImages applyJPEG

if length(ind_cell) ~= 1
    disp('length of ind_cell should be 1');
end

ind = ind_cell{1};

%reconstruction image
recon_rawImage = imresize(double(imread(ind)),1);
recon_rawImage = recon_rawImage ./ max(recon_rawImage(:));

%apply demosaic algorithms and evaluate errors
disp(['Demosaicking... ' demosaic_method]);
dmImage = applyDemosaic(recon_rawImage,demosaic_method);

end