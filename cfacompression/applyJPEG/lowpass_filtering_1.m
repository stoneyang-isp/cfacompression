function green_Array = lowpass_filtering_1(green_Array1,green_Array2)

temp_green_Array = zeros(size(green_Array1,1)*2,size(green_Array1,2)*2);
temp_green_Array(1:2:end,1:2:end) = green_Array1;
temp_green_Array(2:2:end,2:2:end) = green_Array2;

for x=1:size(temp_green_Array,1)/2
    for y=1:size(temp_green_Array,2)/4
        green_d = temp_green_Array(2*x,4*y-2);
        if x == 1
            green_u = green_d;
        else
            green_u = temp_green_Array(2*x-2,4*y-2);
        end
        green_l = temp_green_Array(2*x-1,4*y-3);
        green_r = temp_green_Array(2*x-1,4*y-1);
        green_sum = green_u + green_d + green_l + green_r;

        temp_green_Array(2*x-1,4*y-2) = 0.25 * green_sum;

        green_u = temp_green_Array(2*x-1,4*y-1);
        if x == size(temp_green_Array,1)/2
            green_d = green_u;
        else
            green_d = temp_green_Array(2*x+1,4*y-1);
        end
        green_l = temp_green_Array(2*x,4*y-2);
        green_r = temp_green_Array(2*x,4*y);
        green_sum = green_u + green_d + green_l + green_r;

        temp_green_Array(2*x,4*y-1) = 0.25 * green_sum;
    end
end

green_Array = zeros(size(green_Array1,1)*2,size(green_Array1,2));

green_Array(:,1:2:end) = temp_green_Array(:,2:4:end);
green_Array(:,2:2:end) = temp_green_Array(:,3:4:end);

end