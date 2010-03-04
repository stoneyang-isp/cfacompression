function [red_Array, green_Array1, green_Array2, blue_Array] = cfa_ycbcr2rgb(y_Array1, y_Array2, cb_Array, cr_Array)

color_conversion = [128.6 0 25 65.5;0 128.6 25 65.5;-37.1 -37.1 112 -37.8; -46.9 -46.9 -18.2 112];

color_conversion = color_conversion ./255;
color_conversion_const = [0;0;128;128];


green_Array1 = zeros(size(cb_Array));
green_Array2 = zeros(size(cb_Array));
red_Array = zeros(size(cb_Array));
blue_Array = zeros(size(cb_Array));

for x=1:size(cb_Array,1)
    for y=1:size(cb_Array,2)
        temp = [y_Array1(x,y) ; y_Array2(x,y) ; cb_Array(x,y) ; cr_Array(x,y)];
        output = inv(color_conversion) * (temp-color_conversion_const);
        green_Array1(x,y) = output(1);
        green_Array2(x,y) = output(2);
        blue_Array(x,y) = output(3);
        red_Array(x,y) = output(4);
    end
end

end