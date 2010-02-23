%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab code and data to reproduce results from the paper                  %
% "Joint Demosaicing and Super-Resolution Imaging from a Set of             %
% Unregistered Aliased Images"                                              %
% Patrick Vandewalle, Karim Krichane, David Alleysson and Sabine SŸsstrunk  %
% available at http://lcavwww.epfl.ch/reproducible_research/VandewalleKAS07/%
%                                                                           %
% Copyright (C) 2007 Laboratory of Audiovisual Communications (LCAV),       %
% Ecole Polytechnique Federale de Lausanne (EPFL),                          %
% CH-1015 Lausanne, Switzerland.                                            %
%                                                                           %
% This program is free software; you can redistribute it and/or modify it   %
% under the terms of the GNU General Public License as published by the     %
% Free Software Foundation; either version 2 of the License, or (at your    %
% option) any later version. This software is distributed in the hope that  %
% it will be useful, but without any warranty; without even the implied     %
% warranty of merchantability or fitness for a particular purpose.          %
% See the GNU General Public License for more details                       %
% (enclosed in the file GPL).                                               %
%                                                                           %
% Latest modifications: June 7, 2007.                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Graphical User Interfaces
%   demoGUI           - main program
%   generation        - generate a set of low resolution shifted and 
%                       rotated RAW images, simulated from a single input image
%
% Image Registration
%   estimate_motion   - shift and rotation estimation using algorithm 
%                       by Vandewalle et al.
%   estimate_rotation - rotation estimation using algorithm by Vandewalle et al.
%   estimate_shift    - shift estimation using algorithm by Vandewalle et al.
%
% Image Reconstruction and/or Demosaicing
%   bilinear_demosaicing - reconstruct a high resolution image from a set of 
%                       low resolution images and their registration parameters
%                       using bilinear interpolation
%   demos_freq_adapt_SPL - reconstruct an RGB image from a single RAW image using the 
%                       adaptive frequency selection method by Dubois
%   duboiscombined    - reconstruct a high resolution image from a set of 
%                       low resolution RAW images and their registration parameters
%                       using a combined super-resolution and demosaicing by Dubois
%   EPFLDemosaicing   - reconstruct an RGB image from a single RAW image using the 
%                       frequency selection method by Alleysson et al.
%   FreqSelDemosaic   - reconstruct a high resolution image from a set of 
%                       low resolution RAW images and their registration parameters
%                       using the frequency selection method by Alleysson et al.
%   interpolation     - reconstruct a high resolution image from a set of 
%                       low resolution images and their registration parameters
%                       using bicubic interpolation
%   n_conv (and n_convolution) - reconstruct a high resolution image from a set
%                       of low resolution images and their registration parameters
%                       using algorithm by Pham et al. n_conv calls n_convolution
%   SRDemosaicing     - reconstruct a high resolution image from a set of 
%                       low resolution RAW images and their registration parameters
%                       using combined super-resolution and demosaicing. Method proposed
%                       in this paper (Vandewalle et al. 07)
%
% Helper Functions
%   c2p               - compute the polar coordinates of the pixels of an image
%   CFAMasks          - define the CFA filter to be used
%   cls               - clear workspace, close all windows (including hidden ones)
%   cpsnr_calc        - compute the color PSNR from two RGB images
%   create_simulated_RAW_images - generate a simulated set of shifted and rotated RAW images
%                       a single RGB image
%   demos_adapt_filters.mat - luminance/chrominance separation filter used by Dubois
%   gammaCorr         - apply gamma correction to a given image
%   process_script.m  - example script that enables background processing of large images, 
%                       bypassing the GUI (used to generate most results from the paper)
%   sep_filter.mat    - luminance/chrominance separation filter used by Alleysson et al.
%   shift             - shift an image over a non-integer amount of pixels
%   test_freq_adapt_SPL - used to test the adaptive frequency selection algorithm by Dubois
%   whiteBalance	  - apply a white balancing algorithm to a given image
%
% Images Used in the GUI
%   cfa_type1-4.tiff  - images of different CFA types
%   gray_logo.tif     - gray square
%   logo_epfl_small.tif - EPFL logo
%   logo_warning.tif  - warning logo
