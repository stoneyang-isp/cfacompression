function [rec2, F] = n_conv(s,delta_est,phi_est,factor, noiseCorrect, TwoPass, pixelMask)
% N_CONV - reconstruct a high resolution image using normalized convolution
%    [rec2, F] = n_conv(s,delta_est,phi_est,factor, noiseCorrect, TwoPass, pixelMask)
%    reconstruct an image with FACTOR times more pixels in both dimensions
%    using normalized convolution on the pixels from the images in S
%    (S{1},...) and using the shift and rotation information from DELTA_EST 
%    and PHI_EST

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

ss = size(s{1});

if nargin < 4
    errordlg('Not enough input arguments', 'Error...');
elseif nargin < 5
    noiseCorrect = false;
    TwoPass = false;
    pixelMask = ones(ss(1), ss(2), 1);
elseif nargin < 6
    pixelMask = ones(ss(1), ss(2), 1);
end

    
n1 = sum(pixelMask, 1);
n2 = sum(pixelMask, 2);

if n1(1)==0
    n1=n1(2);
else
    n1=n1(1);
end

if n2(1)==0
    n2=n2(2);
else
    n2=n2(1);
end



n=length(s); %n is the number of input images
if (length(ss)==3) 
    layer_count = ss(3)
else
    layer_count = 1
end

for layer = 1:layer_count %for each color channel
    center = (ss+1)/2;
    phi_rad = phi_est*pi/180;

    % compute the coordinates of the pixels from the N images, using DELTA_EST and PHI_EST
    for i=1:n % for each image
        s_c{i}=s{i}(:,:,layer);
        [x y] = find(pixelMask);
        s_c{i}=s_c{i}(find(pixelMask));
        r{i} = reshape(x, n1, [])*factor; % create matrix with row indices
        c{i} = reshape(y, n1, [])*factor; % create matrix with column indices
        r{i} = r{i}-factor*center(1); % shift rows to center around 0
        c{i} = c{i}-factor*center(2); % shift columns to center around 0
        coord{i} = [c{i}(:) r{i}(:)]*[cos(phi_rad(i)) sin(phi_rad(i)); -sin(phi_rad(i)) cos(phi_rad(i))]; % rotate 
        r{i} = coord{i}(:,2)+factor*center(1)+factor*delta_est(i,1); % shift rows back and shift by delta_est
        c{i} = coord{i}(:,1)+factor*center(2)+factor*delta_est(i,2); % shift columns back and shift by delta_est
        rn{i} = r{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
        cn{i} = c{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
        sn{i} = s_c{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
    end

    s_ = []; r_ = []; c_ = []; sr_ = []; rr_ = []; cr_ = [];
    for i=1:n % for each image
        s_ = [s_; sn{i}];
        r_ = [r_; rn{i}];
        c_ = [c_; cn{i}];
    end
    clear s_c r c coord rn cn sn

    % Apply the normalized convolution algorithm
    if nargout == 2
        [rec, F] = n_convolution(c_,r_,s_,ss*factor,factor, s{1}(:,:,layer), noiseCorrect, TwoPass);
    else
        rec = n_convolution(c_,r_,s_,ss*factor,factor, s{1}(:,:,layer), noiseCorrect, TwoPass);
    end

    rec(isnan(rec))=0;
    rec2(:,:,layer) = rec;
end
