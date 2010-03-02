function green_Array = merge_Array(green_Array1, green_Array2)

green_Array = zeros(size(green_Array1,1)*2 , size(green_Array1,2));
green_Array(1:2:end,:) = green_Array1;
green_Array(2:2:end,:) = green_Array2;

end