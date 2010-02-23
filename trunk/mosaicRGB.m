%
% Changes RGB image into RAW image with GRBG pattern.
%
% 'bayer (grbg)'

function imRaw = mosaicRGB(imRGB)

imRaw = zeros([size(imRGB,1) size(imRGB,2)]);
imRaw(1:2:size(imRGB,1), 1:2:size(imRGB,2)) = imRGB(1:2:size(imRGB,1), 1:2:size(imRGB,2),2);
imRaw(2:2:size(imRGB,1), 2:2:size(imRGB,2)) = imRGB(2:2:size(imRGB,1), 2:2:size(imRGB,2),2);
imRaw(1:2:size(imRGB,1), 2:2:size(imRGB,2)) = imRGB(1:2:size(imRGB,1), 2:2:size(imRGB,2),1);
imRaw(2:2:size(imRGB,1), 1:2:size(imRGB,2)) = imRGB(2:2:size(imRGB,1), 1:2:size(imRGB,2),3);

return