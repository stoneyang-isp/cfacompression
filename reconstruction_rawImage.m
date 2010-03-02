function recon_rawImage = reconstruction_rawImage(recon_red,recon_green1,recon_green2,recon_blue)

recon_rawImage = zeros(size(recon_red)*2);
recon_rawImage(2:2:end,1:2:end) = recon_red;
recon_rawImage(1:2:end,1:2:end) = recon_green1;
recon_rawImage(2:2:end,2:2:end) = recon_green2;
recon_rawImage(1:2:end,2:2:end) = recon_blue;

end