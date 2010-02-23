function imOut = SRDemosaicing(im, factor, CFA_type, separation_filter, delta_est, phi_est)
% Simulation of demosaicing by frequency selection

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

nimage = length(im);

[H W P]=size(im{1});
P = 3; % This is because we'll want to deal with color pictures

[mR mG mB] = CFAMasks(CFA_type, W, H); %Type 2 CFA for 350D


% %Creating CFA images
% for i=1:nimage
%     I2_ds{i} = reshape([I_ds{i}(:,:,1).*mR I_ds{i}(:,:,2).*mG I_ds{i}(:,:,3).*mB],H,W,P);
% end

%figure;image(I2_ds{1});axis('image');

%Fourier spectrum of CFA image
% fI=abs(fftshift(fft2(sum(I2_ds{1},3))));
% fI=fI./(fI+mean(fI(:)));
%figure;image(fI*255);colormap(gray(256));axis('image')

%luminance estimation
flum = separation_filter;

for i=1:nimage     
    L{i}=conv2(im{i},flum,'same');
end

%figure;image(L{1}*255);colormap(gray(256));axis('image');

%Fourier spectrum of Luminance
% fI=abs(fftshift(fft2(L{1})));
% fI=fI./(fI+mean(fI(:)));
%figure;image(fI*255);colormap(gray(256));axis('image')

%Chrominance calculation
for i=1:nimage
    Chr{i}=im{i}-L{i};
    Chr{i}=reshape([conv2(Chr{i}.*mR,[1 2 1;2 4 2;1 2 1]/4,'same') conv2(Chr{i}.*mG,[0 1 0;1 4 1;0 1 0]/4,'same')...
                    conv2(Chr{i}.*mB,[1 2 1;2 4 2;1 2 1]/4,'same')],H,W,P);
end



if nargin<6    
    %Estimate motion between LR images
    %%%%
    % EPFL METHOD
    [delta_est, phi_est] = estimate_motion(im, 0.6, 25)
    %%%%
    % KEREN METHOD
    %[delta_est, phi_est] = keren(L)
    %%%%
    % MARCEL SHIFT ONLY
    % delta_est = marcel_shift(L)
    % phi_est = zeros(size(delta_est, 2))
    %%%%
    % MARCEL METHOD
    %[delta_est phi_est] = marcel(L)
end

%Reconstruct HR Luminance and Chrominance separately, using a
%Super-Resolution algorithm (interpolation in this example)

%L_HR = interpolation(L,delta_est,phi_est,factor);
L_HR = n_conv(L,delta_est,phi_est,factor);
%[L_HR movFrames] = n_conv(L,delta_est,phi_est,factor);

%Chr_HR = interpolation(Chr,delta_est,phi_est,factor);
Chr_HR = n_conv(Chr, delta_est, phi_est, factor);

%rebuild HR demosaiced image
for i = 1:size(Chr_HR, 3)
    I_final_HR(:,:,i) = (L_HR+Chr_HR(:,:,i));
end

% %rebuild LR demosaiced image
% for i = 1:size(Chr{1}, 3)
%     I_final_LR(:,:,i) = (L{1}+Chr{1}(:,:,i));
% end


% figure; imshow(I_final_HR);
% figure; imshow(I_final_LR);
% 
% %save results in current dir
% imwrite(I_final_HR, 'result_HR.tif');
% imwrite(I_final_LR, 'result_LR.tif');

imOut = I_final_HR;
% close all hidden;