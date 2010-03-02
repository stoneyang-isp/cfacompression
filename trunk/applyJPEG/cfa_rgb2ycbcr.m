function [y_Array1, y_Array2, cb_Array, cr_Array] = cfa_rgb2ycbcr(red_Array, green_Array1, green_Array2, blue_Array)

color_conversion = [128.6 0 25 65.5;0 128.6 25 65.5;-37.1 -37.1 112 -37.8; -46.9 -46.9 -18.2 112];
color_conversion_const = [0;0;128;128];

y_Array1 = zeros(size(red_Array));
y_Array2 = zeros(size(red_Array));
cb_Array = zeros(size(red_Array));
cr_Array = zeros(size(red_Array));

for x=1:size(red_Array,1)
    for y=1:size(red_Array,2)
        temp = [green_Array1(x,y) ; green_Array2(x,y) ; blue_Array(x,y) ; red_Array(x,y)];
        output = color_conversion*temp + color_conversion_const;
        y_Array1(x,y) = output(1);
        y_Array2(x,y) = output(2);
        cb_Array(x,y) = output(3);
        cr_Array(x,y) = output(4);
    end
end

end