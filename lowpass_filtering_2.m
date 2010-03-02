function green_Array = lowpass_filtering_2(green_Array1,green_Array2)

temp_green_Array = zeros(size(green_Array1,1)*2,size(green_Array1,2)*2);
temp_green_Array(1:2:end,1:2:end) = green_Array1;
temp_green_Array(2:2:end,2:2:end) = green_Array2;

for x=1:size(temp_green_Array,1)
    for y=1:size(temp_green_Array,2)
        if mod(x+y,2) == 1
            if x == 1
                green_l = temp_green_Array(x+1,y);
            else
                green_l = temp_green_Array(x-1,y);
            end
            if y == size(temp_green_Array,2)
                green_d = temp_green_Array(x,y-1);
            else
                green_d = temp_green_Array(x,y+1);
            end
            if y == 1
                green_u = temp_green_Array(x,y+1);
            else
                green_u = temp_green_Array(x,y-1);
            end
            if x == size(temp_green_Array,1)
                green_r = temp_green_Array(x-1,y);
            else
                green_r = temp_green_Array(x+1,y);
            end
            green_sum = green_d + green_u + green_l + green_r;

            temp_green_Array(x,y) = 0.25 * green_sum;
        end
    end
end

green_Array = zeros(size(green_Array1,1)*2,size(green_Array1,2));

green_Array(1:2:end,:) = temp_green_Array(1:2:end,2:2:end);
green_Array(2:2:end,:) = temp_green_Array(2:2:end,1:2:end);

end