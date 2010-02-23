function output = separateChannels(input)

[h w d] = size(input);
if d~= 1, disp('Input should be a raw image data');, end

%[ 1 2 ]
%[ 3 4 ]
output(:,:,1) = input(1:2:h, 1:2:w);
output(:,:,2) = input(1:2:h, 2:2:w);
output(:,:,3) = input(2:2:h, 1:2:w);
output(:,:,4) = input(2:2:h, 2:2:w);

return