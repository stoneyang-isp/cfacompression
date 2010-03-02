function y_Array = structure_Conversion(y_Array1, y_Array2)

y_Array = zeros(size(y_Array1,1)*2,size(y_Array1,2));
y_Array(2:2:end,:) = y_Array2;

for x=1:size(y_Array1,1)
    for y=1:size(y_Array1,2)
        if x == 1
            y_Array(2*x-1,y) = 0.5*y_Array1(x,y) + 0.25*y_Array2(x,y);
        else
            y_Array(2*x-1,y) = 0.5*y_Array1(x,y) + 0.25*y_Array2(x-1,y) + 0.25*y_Array2(x,y);
        end
    end
end

end