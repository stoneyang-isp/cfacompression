function compressionRatio = calculate_compressionRatio(trueImage,jpeg_data)

len = length(jpeg_data);
total_len = 0;
for i=1:len
    total_len = total_len + length(jpeg_data{i}) - 623;
end

compressionRatio = size(trueImage,1)*size(trueImage,2)*size(trueImage,3)/(total_len);

end