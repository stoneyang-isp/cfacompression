function [output]=bilinear_demosaicing(input, CFA_Type)
% Bilinear Interpolation of the missing pixels
% Bayer CFA
%       R G R G
%       G B G B
%       R G R G
%       G B G B
%
% The input can be on one or three channels
%
% Output = a complete RGB image on 3 channels

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

im=double(input);
    
M = size(im, 1);
N = size(im, 2);
channel = size(size(im), 2);    % == 2 => one channel
                                % == 3 => three channel

if nargin < 2
    CFA_Type = 1;
end
                                
[red_mask green_mask blue_mask] = CFAMasks(CFA_Type, N, M);

if channel == 2
    R=im.*red_mask;
    G=im.*green_mask;
    B=im.*blue_mask;
elseif channel == 3
    R=im(:,:,1).*red_mask;
    G=im(:,:,2).*green_mask;
    B=im(:,:,3).*blue_mask;
end
    
% Interpolation for the green at the missing points
    G= G + imfilter(G, [0 1 0; 1 0 1; 0 1 0]/4);
    
% Interpolation for the blue at the missing points
% First, calculate the missing blue pixels at the red location
    B1 = imfilter(B,[1 0 1; 0 0 0; 1 0 1]/4);
% Second, calculate the missing blue pixels at the green locations
% by averaging the four neighouring blue pixels
    B2 = imfilter(B+B1,[0 1 0; 1 0 1; 0 1 0]/4);
    B = B + B1 + B2;
    
% Interpolation for the red at the missing points
% First, calculate the missing red pixels at the blue location
    R1 = imfilter(R,[1 0 1; 0 0 0; 1 0 1]/4);
% Second, calculate the missing red pixels at the green locations   
    R2 = imfilter(R+R1,[0 1 0; 1 0 1; 0 1 0]/4);
    R = R + R1 + R2;
    

    output(:,:,1)=R; output(:,:,2)=G; output(:,:,3)=B;
