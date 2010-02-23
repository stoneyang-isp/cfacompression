function [mR mG mB] = CFAMasks(type, W, H)
% CFAMASKS - generate CFA mask
% [mR mG mB] = CFAMasks(type, W, H)
% generates a CFA mask of W x H pixels, and of type TYPE (1-4)

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

[x y]=meshgrid(1:W,1:H);

switch type
    case 1
        % B G B G...
        % G R G R...
        % B G B G...
        % ...
        mR=(1+cos(pi*x)).*(1+cos(pi*y))/4;
        mG=(1-cos(pi*(x+y)))/2;
        mB=(1-cos(pi*x)).*(1-cos(pi*y))/4;
    case 2
        %%modulation functions 2 (Canon 350D)
        % R G R G...
        % G B G B...
        % R G R G...
        % ...
        mR=(1-cos(pi*x)).*(1-cos(pi*y))/4;
        mG=(1-cos(pi*(x+y)))/2;
        mB=(1+cos(pi*x)).*(1+cos(pi*y))/4;
    case 3
        %%modulation functions 3
        % G R G R...
        % B G B G...
        % G R G R...
        % ...
        mR=(1+cos(pi*x)).*(1-cos(pi*y))/4;
        mG=(1+cos(pi*(x+y)))/2;
        mB=(1-cos(pi*x)).*(1+cos(pi*y))/4;
    case 4
        %%modulation functions 4
        % G B G B...
        % R G R G...
        % G B G B...
        % ...
        mR=(1-cos(pi*x)).*(1+cos(pi*y))/4;
        mG=(1+cos(pi*(x+y)))/2;
        mB=(1+cos(pi*x)).*(1-cos(pi*y))/4;
    otherwise
        error('Please give a type between 1-4')
end

