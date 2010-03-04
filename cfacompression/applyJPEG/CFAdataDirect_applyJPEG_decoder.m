function [rawImage] = CFAdataDirect_applyJPEG_decoder(ind_cell)

addpath cfacompression/applyJPEG/tempImages

if length(ind_cell) ~= 1
    disp('length of ind_cell should be 1');
end

ind = ind_cell{1};

%reconstruction image
rawImage = double(imread(ind));

end