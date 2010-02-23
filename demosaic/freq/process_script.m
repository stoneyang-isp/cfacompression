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

close all; 
close all hidden;
clear all;

%default values for parameters
need_post_processing = false;
CFA_type = 2;
gamma = 1/2.2;
load sep_filter
%--------------------------%

settings = {'experiment1'; 'experiment2'; 'simulation1'; 'simulation2'};
num_settings = length(settings);

for count = 1:num_settings
    setting = settings{count};
    switch setting
        case 'experiment1'
            clear im;
            im{1} = imread('../VandewalleKAS07_data/testChart_1.tif');
            im{2} = imread('../VandewalleKAS07_data/testChart_2.tif');
            im{3} = imread('../VandewalleKAS07_data/testChart_3.tif');
            im{4} = imread('../VandewalleKAS07_data/testChart_4.tif');
            nimage = length(im);
            need_post_processing = true;
            nimage = length(im);
            % delta_est = [0 0; 5.5184 2.7381; 6.7964 -15.1391; 8.8643 -5.9104]; % using EPFL
            % phi_est = [0 0.0221 -0.1000 -0.1000]; % using EPFL
            factor = 2;
            CFA_type = 2;
            gamma = 2.2;
            % Normalization -- images are encoded with 12 bits
            for i = 1:nimage
                im{i} = im2double(im{i});
            end
            [delta_est phi_est] = estimate_motion(im, 0.6, 25);
            crop = 0.05; % crop percentage, from the center of the image

        case 'experiment2'
            clear im;
            im{1} = imread('../VandewalleKAS07_data/webcam_1.bmp');
            im{2} = imread('../VandewalleKAS07_data/webcam_2.bmp');
            im{3} = imread('../VandewalleKAS07_data/webcam_3.bmp');
            im{4} = imread('../VandewalleKAS07_data/webcam_4.bmp');
            nimage = length(im);
            need_post_processing = true;
            factor = 2;
            CFA_type = 3;
            gamma = 1/2.2
            for i=1:nimage
                im{i} = im2double(im{i});
                im{i} = sum(im{i}, 3)/3; %flattening the RAW's
            end
            % delta_est = [0 0; 4.1828 -0.1235; 8.7658 -0.6479; 8.4341 -0.6965]; % using EPFL
            % phi_est = [0 0.1 0 0]; % using EPFL
            [delta_est phi_est] = estimate_motion(im, 0.6, 25);
            crop = 0.05; %crop percentage, from the center of the image

        case 'simulation1'
            clear im;
            im{1} = imread('../VandewalleKAS07_data/lighthouse_CFA_ds2_1.tif');
            im{2} = imread('../VandewalleKAS07_data/lighthouse_CFA_ds2_2.tif');
            im{3} = imread('../VandewalleKAS07_data/lighthouse_CFA_ds2_3.tif');
            im{4} = imread('../VandewalleKAS07_data/lighthouse_CFA_ds2_4.tif');
            nimage = length(im);
            need_post_processing = false;
            for i = 1:nimage
                im{i} = im2double(im{i});
            end
            delta_est = -[0 0; 0 0.5; 0.5 0; 0.5 0.5];
            phi_est = [0 0 0 0];
            factor = 2;
            CFA_type = 2;
            crop = 0.1; %crop percentage, from the center of the image

        case 'simulation2'
            clear im;
            im{1} = imread('../VandewalleKAS07_data/testimage_1.tif');
            im{2} = imread('../VandewalleKAS07_data/testimage_2.tif');
            im{3} = imread('../VandewalleKAS07_data/testimage_3.tif');
            im{4} = imread('../VandewalleKAS07_data/testimage_4.tif');
            nimage = length(im);
            need_post_processing = false;
            for i = 1:4
                im{i} = im2double(im{i});
            end
            delta_est = -[0 0; 0 0.5; 0.5 0; 0.5 0.5];
            phi_est = [0 0 0 0];
            factor = 2;
            CFA_type = 2;
            crop = 0.1; %crop percentage, from the center of the image

        otherwise
            error('incorrect setting defined');
    end
    %-----------------------------------------------------%
    
    %-----------------------------------------------------%
    %% Image processing
    
    
    reconstruction = {'epfldemosaicing', 'epflsrdemosaicing', 'srdemosaicing', 'duboisdemosaicing', 'duboissrdemosaicing', 'duboiscombined'};
    num_reconstruction = length(reconstruction);
    
    for reconstr_count = 1:num_reconstruction
        [im_result, delta_est, phi_est] = process_images_for_script...
            (im, reconstruction{reconstr_count}, factor, crop, sep_filter, CFA_type, need_post_processing, gamma);
        
        imwrite(im_result, ['result_' setting '_' reconstruction{reconstr_count} '.tif'])

    end
    
end
