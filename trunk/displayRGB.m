function displayRGB(img)

if size(img,3)==1
    imagesc(truncate(img.^0.6, 0, 1), [0 1]);axis('image'); colormap('gray');
elseif size(img,3)==3
    imagesc(truncate(img.^0.6, 0, 1), [0 1]);axis('image');
end

return;