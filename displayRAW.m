function displayRAW(img, mode)
% 'bayer (grbg)'
if nargin ~= 1
    imagesc(img);axis('image');colormap('gray');
    return;
end

imgCFA = zeros([size(img), 3]);
pattern = ones(floor(size(img,1)/2));

imgCFA(1:2:size(img,1), 1:2:size(img,2), 2) = img(1:2:size(img,1), 1:2:size(img,2));
imgCFA(2:2:size(img,1), 2:2:size(img,2), 2) = img(2:2:size(img,1), 2:2:size(img,2));
imgCFA(1:2:size(img,1), 2:2:size(img,2), 1) = img(1:2:size(img,1), 2:2:size(img,2));
imgCFA(2:2:size(img,1), 1:2:size(img,2), 3) = img(2:2:size(img,1), 1:2:size(img,2));

% imgCFA = imgCFA/(max(max(max(imgCFA))));

imagesc(truncate(imgCFA.^0.6, 0, 1), [0 1]);axis('image');

return;