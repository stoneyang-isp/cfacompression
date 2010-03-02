function [red_Array, green_Array1, green_Array2, blue_Array] = extract_colorComponent(rawImage)

red_Array = rawImage(2:2:end,1:2:end);
green_Array1 = rawImage(1:2:end,1:2:end);
green_Array2 = rawImage(2:2:end,2:2:end);
blue_Array = rawImage(1:2:end,2:2:end);

end