%% -------------------------------------------------------------------------
% Matlab code and data to reproduce results from the paper                  
% "Joint Demosaicing and Super-Resolution Imaging from a Set of             
% Unregistered Aliased Images"                                              
% Patrick Vandewalle, Karim Krichane, David Alleysson and Sabine SŸsstrunk  
% available at http://lcavwww.epfl.ch/reproducible_research/VandewalleKAS07/
%                                                                           
% Copyright (C) 2007 Laboratory of Audiovisual Communications (LCAV),       
% Ecole Polytechnique Federale de Lausanne (EPFL),                          
% CH-1015 Lausanne, Switzerland.                                            
%                                                                           
% This program is free software; you can redistribute it and/or modify it   
% under the terms of the GNU General Public License as published by the     
% Free Software Foundation; either version 2 of the License, or (at your    
% option) any later version. This software is distributed in the hope that  
% it will be useful, but without any warranty; without even the implied     
% warranty of merchantability or fitness for a particular purpose.          
% See the GNU General Public License for more details                       
% (enclosed in the file GPL).                                               
%                                                                           
% Latest modifications: June 7, 2007.                                       

close all
clear all

filename = 'images/lighthouse.tif';
I_orig=double(imread(filename))/255;

ds_factor = 2; %downsampling factor

% im{1} = I_orig(1:ds_factor:end, 1:ds_factor:end, :);
% im{2} = I_orig(1:ds_factor:end, 2:ds_factor:end, :);
% im{3} = I_orig(2:ds_factor:end, 1:ds_factor:end, :);
% im{4} = I_orig(2:ds_factor:end, 2:ds_factor:end, :);

im{1} = I_orig;
im{2} = circshift(I_orig, [0 1]);
im{3} = circshift(I_orig, [1 0]);
im{4} = circshift(I_orig, [1 1]);

figure;image(im{1});axis('image');
[H W P]=size(im{1});


%modulation functions
[mR mG mB] = CFAMasks(2, W, H);

for i=1:4
    im_cfa(:,:,i) = im{i}(:,:,1).*mR + im{i}(:,:,2).*mG + im{i}(:,:,3).*mB;
    imwrite(im_cfa(:,:,i), ['lighthouse_CFA_' num2str(i) '.tif']);
end

save im_cfa im_cfa
    
    
figure;image(I);axis('image');
[H W P]=size(I);
[x y]=meshgrid(1:W,1:H);

%modulation functions
mR=(1+cos(pi*x)).*(1+cos(pi*y))/4;
mG=(1-cos(pi*(x+y)))/2;
mB=(1-cos(pi*x)).*(1-cos(pi*y))/4;

%Creating CFA image
I2=reshape([I(:,:,1).*mR I(:,:,2).*mG I(:,:,3).*mB],H,W,P);
figure;image(I2);axis('image');

%Fourier spectrum of CFA image
fI=abs(fftshift(fft2(sum(I2,3))));
fI=fI./(fI+mean(fI(:)));
figure;image(fI*255);colormap(gray(256));axis('image')

%luminance estimation
flum = [ 0  0  0  0  1  0  1  0  0  0  0
         0  0  0 -1  0 -2  0 -1  0  0  0
         0  0  1  1  2  1  2  1  1  0  0
         0 -1  1 -5  3 -9  3 -5  1 -1  0
         1  0  2  3  1  7  1  3  2  0  1
         0 -2  1 -9  7 104 7 -9  1 -2  0
         1  0  2  3  1  7  1  3  2  0  1
         0 -1  1 -5  3 -9  3 -5  1 -1  0
         0  0  1  1  2  1  2  1  1  0  0
         0  0  0 -1  0 -2  0 -1  0  0  0
         0  0  0  0  1  0  1  0  0  0  0]/128;
L=conv2(sum(I2,3),flum,'same');
figure;image(L*255);colormap(gray(256));axis('image');

%Fourier spectrum of Luminance
fI=abs(fftshift(fft2(L)));
fI=fI./(fI+mean(fI(:)));
figure;image(fI*255);colormap(gray(256));axis('image')

%Chrominance calculation
Chr=sum(I2,3)-L;
Chr=reshape([conv2(Chr.*mR,[1 2 1;2 4 2;1 2 1]/4,'same') conv2(Chr.*mG,[0 1 0;1 4 1;0 1 0]/4,'same')...
    conv2(Chr.*mB,[1 2 1;2 4 2;1 2 1]/4,'same')],H,W,P);

%rebuild demosaiced image
I3=reshape([L+Chr(:,:,1) L+Chr(:,:,2) L+Chr(:,:,3)],H,W,P);
I3=double(uint8(I3*255))/255;
figure;image(I3);axis('image')

