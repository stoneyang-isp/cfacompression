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

nimage = 4;
CFA_type = 2;
factor = 0.5;
filename = 'images/testimage.tif';
I=im2double(imread(filename));
%figure;image(I);axis('image');

I_ds{1} = I;
I_ds{2} = shift(I, 1, 0);
I_ds{3} = shift(I, 0, 1);
I_ds{4} = shift(I, 1, 1);

for i = 1:nimage
    I_ds{i} = imresize(I_ds{i}, factor);
end

[H W P]=size(I_ds{1});
[mR mG mB] = CFAMasks(CFA_type, W, H); %Type 2 CFA for 350D

%Creating CFA images
for i=1:nimage
    I2_ds{i} = I_ds{i}(:,:,1).*mR + I_ds{i}(:,:,2).*mG + I_ds{i}(:,:,3).*mB;
    figure; imshow(I2_ds{i});
    imwrite(I2_ds{i}, ['RAWs/testimage_RAW_ds2_' num2str(i) '.tif'])
end
