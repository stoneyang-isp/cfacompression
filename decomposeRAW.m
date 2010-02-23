% GRBG -> RAW
function imDecompose = decomposeRAW(imRaw)

imDecompose = zeros([size(imRaw) 3]);
imDecompose(1:2:size(imRaw,1), 1:2:size(imRaw,2), 2) = imRaw(1:2:size(imRaw,1), 1:2:size(imRaw,2));
imDecompose(2:2:size(imRaw,1), 2:2:size(imRaw,2), 2) = imRaw(2:2:size(imRaw,1), 2:2:size(imRaw,2));
imDecompose(1:2:size(imRaw,1), 2:2:size(imRaw,2), 1) = imRaw(1:2:size(imRaw,1), 2:2:size(imRaw,2));
imDecompose(2:2:size(imRaw,1), 1:2:size(imRaw,2), 3) = imRaw(2:2:size(imRaw,1), 1:2:size(imRaw,2));

return