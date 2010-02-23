close all;

% tiff files
filename = 'lighthouse2.tif';

P = double(imread(filename));
filename = filename(1:(end-4));

Q = mosaic(P);
X = MNdemosaic(Q,1);
Y = MNdemosaic(Q,2);

imwrite(X/256,sprintf('MN1_%s.bmp',filename));
imwrite(Y/256,sprintf('MN2_%s.bmp',filename));
