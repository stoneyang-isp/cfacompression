function compressionRatio = calculate_compressionRatio(rawImage,jpeg_data)

len = length(jpeg_data);
total_len = 0;
for i=1:len
    total_len = total_len + length(jpeg_data{i}) - 623;
end

compressionRatio = size(rawImage,1)*size(rawImage,2)*3/(total_len);

end