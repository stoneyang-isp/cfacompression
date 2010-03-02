function jpeg_data = read_jpeg(ind)

fp = fopen(ind,'r');
jpeg_data=fread(fp,[1,inf],'uchar');
fclose(fp);

end