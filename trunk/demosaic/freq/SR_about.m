%% Joint Demosaicing and Super-Resolution Imaging
%
% Matlab code, GUI, and data to reproduce results from the paper
%
% P. Vandewalle, K. Krichane, D. Alleysson and S. Susstrunk, Joint
% Demosaicing and Super-Resolution Imaging from a Set of Unregistered 
% Aliased Images, Proc. IS&T/SPIE Electronic Imaging: Digital Photography 
% III, Vol. 6502, 2007. doi: 10.1117/12.703980.
%                                                                          
% More information at
% http://lcavwww.epfl.ch/reproducible_research/VandewalleKAS07/
%
% Developed by Karim Krichane and Patrick Vandewalle. 
% Feel free to send any questions/comments to
% superresolution@epfl.ch
%
%% Acknowledgements
% We would like to thank Prof. E. Dubois for sharing his demosaicing code
% [2] with us, and allowing us to include his code in this GUI. 
%
%% References of implemented methods
% [1] D. Alleysson, S. Susstrunk, and J. H?erault, "Linear demosaicing
% inspired by the human visual system," IEEE Transactions on Image 
% Processing 14(4), pp. 439?449, 2005. doi: 10.1109/TIP.2004.841200
%
% [2] E. Dubois, "Frequency-domain methods for demosaicking of Bayer-sampled
% color images", IEEE Signal Processing Letters, vol. 12, pp. 847-850, 2005.
% doi: 10.1109/LSP.2005.859503 
%
% [3] T. Q. Pham, L. J. van Vliet, and K. Schutte, "Robust Fusion of 
% Irregularly Sampled Data Using Adaptive Normalized Convolution," EURASIP 
% Journal on Applied Signal Processing 2006, 2006. Article ID 83268, 
% 12 pages. doi: 10.1155/ASP/2006/83268
%
% [4] P. Vandewalle, S. S?usstrunk, and M. Vetterli, "A Frequency Domain
% Approach to Registration of Aliased Images with Application to 
% Super-Resolution," EURASIP Journal on Applied Signal Processing, Special 
% Issue on Super-Resolution Imaging 2006, 2006. Article ID 71459, 14 pages.
% doi: 10.1155/ASP/2006/71459
%
% [5] P. Vandewalle, K. Krichane, D. Alleysson and S. Süsstrunk, "Joint
% Demosaicing and Super-Resolution Imaging from a Set of Unregistered 
% Aliased Images", Proc. IS&T/SPIE Electronic Imaging: Digital Photography 
% III, Vol. 6502, 2007. doi: 10.1117/12.703980 

%% Copyright
% % Copyright (C) 2007 Laboratory of Audiovisual Communications (LCAV),
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
%
