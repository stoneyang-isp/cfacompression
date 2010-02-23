function imOut = EPFLDemosaicing(im, CFA_type, separation_filter)
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

[H W P]=size(im);
P = 3; % This is because we'll want to deal with color pictures

[mR mG mB] = CFAMasks(CFA_type, W, H); %Type 2 CFA is for 350D

% luminance estimation
flum = separation_filter;
   
L=conv2(im,flum,'same');

% Chrominance calculation
Chr=im-L;
Chr=reshape([conv2(Chr.*mR,[1 2 1;2 4 2;1 2 1]/4,'same') conv2(Chr.*mG,[0 1 0;1 4 1;0 1 0]/4,'same')...
                    conv2(Chr.*mB,[1 2 1;2 4 2;1 2 1]/4,'same')],H,W,P);

% rebuild demosaiced image
for k = 1:3
    imOut(:,:,k) = (L+Chr(:,:,k));
end