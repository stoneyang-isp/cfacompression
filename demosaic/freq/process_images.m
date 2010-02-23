function [im_result, delta_est, phi_est] = process_images(im, reconstruction, factor, crop_factor, separation_filter, cfa_type, delta_est, phi_est);
% PROCESS_IMAGES - process the images for joint super-resolution and demosaicing
% [im_result, delta_est, phi_est] = process_images(im, reconstruction, factor, crop_factor, separation_filter, cfa_type, delta_est, phi_est)

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

%default values for parameters
answer = questdlg('Will your image need post-processing (gamma-correction + white-balancing)?', 'Post processing?', 'Yes', 'No', 'Yes');
switch answer
    case 'Yes'
        need_post_processing = true;
    otherwise
        need_post_processing = false;
end
CFA_type = cfa_type;

if need_post_processing
    prompt={'Enter gamma value'};
    name='Gamma=';
    numlines=1;
    defaultanswer={'2.2'};

    answer=inputdlg(prompt,name,numlines,defaultanswer);
    gamma = str2double(answer{1})
end


%--------------------------%

nimage = length(im);
crop = crop_factor; %crop percentage, from the center of the image


%-----------------------------------------------------%
%% cropping images to a smaller size...

ss = size(im{1});
s1 = ss(1);
s2 = ss(2);
x1 = floor(round(s1/2 - s1*0.5*crop)/2) * 2 + 1; %we make sure we start at an odd x and y because of the CFA
x2 = round(s1/2 + s1*0.5*crop);
y1 = floor(round(s2/2 - s2*0.5*crop)/2) * 2 + 1;
y2 = round(s2/2 + s2*0.5*crop);
clear im_small;
for i = 1:nimage
    im_small{i} = im{i}(x1:x2, y1:y2);
end

%figure('name', 'Cropped image', 'NumberTitle', 'off'); imshow(im_small{1}, []);

%-----------------------------------------------------%
%% Image processing

if nargin == 6
    delta_est = [0 0];
    phi_est = [0];
end

switch reconstruction
    case 'bilinear'
        im_result = bilinear_demosaicing(im_small{1}, CFA_type);
        if(need_post_processing)
            % White balancing
            im_result = whiteBalance(im_result, 'gray');
            % gamma correction
            im_result = gammaCorr(im_result, gamma);
        end
    case 'srdemosaicing'
        if nargin == 6
            [delta_est phi_est] = estimate_motion(im, 0.6, 25);
        else
            %delta_est and phi_est are in the given inputs
        end

        im_result = SRDemosaicing(im_small, factor, CFA_type, separation_filter, delta_est, phi_est);
        %figure; imshow(im_HR_SR)
        if(need_post_processing)
            % White balancing
            im_HR_SR_wb = whiteBalance(im_result, 'gray');
            % gamma correction
            im_result = gammaCorr(im_HR_SR_wb, gamma);
        end
    case 'epfldemosaicing'
        im_result = EPFLDemosaicing(im_small{1}, CFA_type, separation_filter);
        if(need_post_processing)
            %White balancing...
            im_EPFL_wb = whiteBalance(im_result, 'gray');
            % gamma correction
            im_result = gammaCorr(im_EPFL_wb, gamma);
            %figure; imshow(im_EPFL{i})
        end
    case 'epflsrdemosaicing'
        for i=1:nimage
            im_EPFL{i} = EPFLDemosaicing(im_small{i}, CFA_type, separation_filter);
            im_EPFL_full{i} = EPFLDemosaicing(im{i}, CFA_type, separation_filter);

            if(need_post_processing)
                %White balancing...
                im_EPFL_wb{i} = whiteBalance(im_EPFL{i}, 'gray');
                % gamma correction
                im_EPFL{i} = gammaCorr(im_EPFL_wb{i}, gamma);
                %figure; imshow(im_EPFL{i})
            end
        end

        clear im_EPFL_gray;
        for i=1:nimage
            im_EPFL_full_gray{i} = rgb2gray(im_EPFL_full{i});
        end
        [delta_est phi_est] = estimate_motion(im_EPFL_full_gray, 0.6, 25);
        %figure('name', 'EPFL Demosaicing (single image)', 'NumberTitle', 'off'); imshow(im_EPFL{1});

        im_result = n_conv(im_EPFL, delta_est, phi_est, factor);

    case 'duboisdemosaicing'
        %Making sure the image is sent with CFA type 3:
        % G R
        % B G
        switch CFA_type
            case 1
                im_small{1} = im_small{1}(2:end, 1:end);
            case 2
                im_small{1} = im_small{1}(1:end, 2:end);
            case 4
                im_small{1} = im_small{1}(2:end, 2:end);
        end
        
        im_result = demos_freq_adapt_SPL(im_small{1});
        if(need_post_processing)
            %White balancing...
            im_DUBOIS_wb = whiteBalance(im_result, 'gray');
            % gamma correction
            im_result = gammaCorr(im_DUBOIS_wb, gamma);
            %figure; imshow(im_DUBOIS{i})
        end
    case 'duboissrdemosaicing'
        for i=1:nimage
            
            %Making sure the image is sent with CFA type 3:
            % G R
            % B G
            switch CFA_type
                case 1
                    im_small{i} = im_small{i}(2:end, 1:end);
                    im{i} = im{i}(2:end, 1:end);
                case 2
                    im_small{i} = im_small{i}(1:end, 2:end);
                    im{i} = im{i}(1:end, 2:end);
                case 4
                    im_small{i} = im_small{i}(2:end, 2:end);
                    im{i} = im{i}(2:end, 2:end);
            end
            
            im_DUBOIS{i} = demos_freq_adapt_SPL(im_small{i});
            im_DUBOIS_full{i} = demos_freq_adapt_SPL(im{i});

            if(need_post_processing)
                %White balancing...
                im_DUBOIS_wb{i} = whiteBalance(im_DUBOIS{i}, 'gray');
                % gamma correction
                im_DUBOIS{i} = gammaCorr(im_DUBOIS_wb{i}, gamma);
                %figure; imshow(im_DUBOIS{i})
            end
        end

        clear im_DUBOIS_gray;
        for i=1:nimage
            im_DUBOIS_full_gray{i} = rgb2gray(im_DUBOIS_full{i});
        end
        [delta_est phi_est] = estimate_motion(im_DUBOIS_full_gray, 0.6, 25);
        %figure('name', 'DUBOIS Demosaicing (single image)', 'NumberTitle', 'off'); imshow(im_DUBOIS{1});

        im_result = n_conv(im_DUBOIS, delta_est, phi_est, factor);
        
    case 'duboiscombined'
        for i=1:nimage
            
            %Making sure the image is sent with CFA type 3:
            % G R
            % B G
            switch CFA_type
                case 1
                    im_small{i} = im_small{i}(2:end, 1:end);
                    im{i} = im{i}(2:end, 1:end);
                case 2
                    im_small{i} = im_small{i}(1:end, 2:end);
                    im{i} = im{i}(1:end, 2:end);
                case 4
                    im_small{i} = im_small{i}(2:end, 2:end);
                    im{i} = im{i}(2:end, 2:end);
            end
        end
        
        if nargin == 6
            [delta_est phi_est] = estimate_motion(im, 0.6, 25);
        else
            %delta_est and phi_est are in the given inputs
        end

        im_result = duboiscombined(im_small, factor, delta_est, phi_est);
        %figure; imshow(im_HR_SR)
        if(need_post_processing)
            % White balancing
            im_HR_SR_wb = whiteBalance(im_result, 'gray');
            % gamma correction
            im_result = gammaCorr(im_HR_SR_wb, gamma);
        end

    otherwise
        errordlg('Reconstruction method unknown')
end
