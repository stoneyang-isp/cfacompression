% Demosaicking using the adaptive frequency domain method
% Signal Processing Letters, vol. 12, pp. 847-850, Dec. 2005
% This software is for provided for non-commercial and research purposes only
% Copyright Eric Dubois, University of Ottawa 2005
%  
%       [RGB] = demos_freq_adapt(CFA)
%       CFA(:,:)   input Bayer CFA mosaicked image, double according to the
%       pattern       G R
%                     B G
%       RGB(:,:,3) output RGB image, double
function [RGB] = duboiscombined(CFA, factor, delta_est, phi_est)
%load the filters
load demos_adapt_filters

nimage = length(CFA);

for i = 1:nimage
    %Use the filters to demosaic the CFA image
    S = size(CFA{i});
    N1 = S(1); N2 = S(2);
    yc = 0:N1-1; xc = 0:N2-1;
    [XC,YC] = meshgrid(xc,yc);
    %Filter the input image with the two Gaussian filters and compute the
    %energy
    eX = imfilter(CFA{i},hG1,'replicate','same').^2;
    eY = imfilter(CFA{i},hG2,'replicate','same').^2;
    %average energy with moving average filter
    NMA=5;
    h_MA = ones(NMA,NMA)/(NMA^2);
    eX = imfilter(eX,h_MA,'replicate','same');
    eY = imfilter(eY,h_MA,'replicate','same');
    %compute weights
    wX = eX./(eX+eY);
    wY = 1 - wX;
    %Extract chrominance in corners using h1
    C1mhat = imfilter(CFA{i},h1,'replicate','same');
    %Extract chrominance on sides at f_y = 0 using hCm
    C2mahat = imfilter(CFA{i},h2a,'replicate','same');
    %Extract chrominance on sides at f_x = 0
    C2mbhat = imfilter(CFA{i},h2b,'replicate','same');
    %estimate C2 component
    C2hat{i} = (wY.*C2mahat.*(-1).^(XC) - wX.*C2mbhat.*(-1).^(YC));
    %estimate the luma component
    Lhat{i} = CFA{i} - C1mhat - C2hat{i}.*((-1).^XC - (-1).^YC);
    %Reconstructed image
    C1hat{i} = C1mhat.*(-1).^(XC+YC);

end


%Reconstruct HR components
C1hat_HR = n_conv(C1hat,delta_est,phi_est,factor);
C2hat_HR = n_conv(C2hat,delta_est,phi_est,factor);
Lhat_HR = n_conv(Lhat,delta_est,phi_est,factor);

%Green channel
RGB(:,:,2) = C1hat_HR + Lhat_HR;
%Red channel
RGB(:,:,1) = Lhat_HR - C1hat_HR - 2*C2hat_HR;
%Blue channel
RGB(:,:,3) = Lhat_HR - C1hat_HR + 2*C2hat_HR;