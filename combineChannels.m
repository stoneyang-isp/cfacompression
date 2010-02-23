function output = combineChannels(input)

[h w d] = size(input);
if d~=4, disp('Input should be a 4-ch image data');, end

%[ 1 2 ]
%[ 3 4 ]
output(1:2:2*h, 1:2:2*w) = input(:,:,1);
output(1:2:2*h, 2:2:2*w) = input(:,:,2);
output(2:2:2*h, 1:2:2*w) = input(:,:,3);
output(2:2:2*h, 2:2:2*w) = input(:,:,4);

return