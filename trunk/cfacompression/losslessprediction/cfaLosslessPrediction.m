function [compressionRatio encodedData] = cfaLosslessPrediction(rawImage)

[h w] = size(rawImage);

% two subimages: green and non-green
rawGreen = zeros(h,w); rawNonGreen = zeros(h,w);
rawGreen(1:2:h, 1:2:w) = rawImage(1:2:h, 1:2:w);
rawGreen(2:2:h, 2:2:w) = rawImage(2:2:h, 2:2:w);
rawNonGreen(2:2:h, 1:2:w) = rawImage(2:2:h, 1:2:w);
rawNonGreen(1:2:h, 2:2:w) = rawImage(1:2:h, 2:2:w);

% neglect edges
border = [4 3]; % top left / bottom right

% green channel prediction: context matching based prediction
predictGreen = zeros(h,w);
candidate = [0 -2; -1 -1; -2 0; -1 1];
support  = [0 -2; -1 -1; -2 0; -1 1];
weights = [5 2 1 0] / 8;
offset = 0;
for i=1+border(1):h-border(2)
    for j=1+border(1)+offset:2:w-border(2)
        values = []; distance = [];
        for k=1:size(candidate,1)
            ii = i + candidate(k,1); jj = j + candidate(k,2);
            values = [values rawGreen(ii, jj)];
            dist = 0;
            for l=1:size(support,1)
                dist = dist + abs( rawGreen(ii+support(l,1), jj+support(l,2)) - rawGreen(i+support(l,1), j+support(l,2)) );
            end
            distance = [distance dist];
        end
        sorted = sortrows([values; distance]',2)';
        predictGreen(i,j) = round(sum(sorted(1,:) .* weights));
    end
    if offset==0, offset = 1;, else offset = 0;, end
end

% adaptive green interpolation
interpGreen = zeros(h,w);
offset = 1;
dHPoints = [-1 -2;1 -2;0 -1;-1 0;1 0];
dVPoints = [-2 -1;-2 1;-1 0;0 -1;0 1];
for i=1+border(1):h-border(2)
    for j=1+border(1)+offset:2:w-border(2)
        dH = 0;
        for k=1:size(dHPoints,1)
            dH = dH + abs( rawGreen(i+dHPoints(k,1),j+dHPoints(k,2)) - rawGreen(i+dHPoints(k,1),j+dHPoints(k,2)+2) );
        end
        dV = 0;
        for k=1:size(dVPoints,1)
            dV = dV + abs( rawGreen(i+dVPoints(k,1),j+dVPoints(k,2)) - rawGreen(i+dVPoints(k,1)+2,j+dVPoints(k,2)) );
        end
        if dH==0 && dV==0, dH = 1; dV = 1;, end
        Gh = (rawGreen(i,j+1)+rawGreen(i,j-1))/2;
        Gv = (rawGreen(i+1,j)+rawGreen(i-1,j))/2;
        interpGreen(i,j) = round( (dH*Gv + dV*Gh) / (dH+dV) );
    end
    if offset==0, offset = 1;, else offset = 0;, end
end

% non-green channel prediction: context matching based prediction
predictNonGreen = zeros(h,w);
candidate = [0 -2; -2 -2; -2 0; -2 2];
support = [0 -1; -1 0; 0 1; 1 0];
weights = [4 2 1 1] / 8;
offset = 1;
for i=1+border(1):h-border(2)
    for j=1+border(1)+offset:2:w-border(2)
        values = []; distance = [];
        for k=1:size(candidate,1)
            ii = i + candidate(k,1); jj = j + candidate(k,2);
            values = [values (interpGreen(ii,jj)-rawNonGreen(ii, jj))];
            dist = 0;
            for l=1:size(support,1)
                dist = dist + abs( rawGreen(ii+support(l,1), jj+support(l,2)) - rawGreen(i+support(l,1), j+support(l,2)) );
            end
            distance = [distance dist];
        end
        sorted = sortrows([values; distance]',2)';
        predictNonGreen(i,j) = round(sum(sorted(1,:) .* weights));
    end
    if offset==0, offset = 1;, else offset = 0;, end
end

% compare prediction and original
diffGreen = rawGreen - predictGreen;
diffNonGreen = (interpGreen - rawNonGreen) - predictNonGreen;

% figure;imagesc(abs(diffGreen(5:h-2,5:w-2)),[0 50]);colormap gray; axis image;
% figure;imagesc(abs(diffGreen2(5:h-2,5:w-2)),[0 50]);colormap gray; axis image;
% 
% predictImage = zeros(h,w);
% predictImage(1:2:h, 1:2:w) = predictGreen(1:2:h, 1:2:w);
% predictImage(2:2:h, 2:2:w) = predictGreen(2:2:h, 2:2:w);
% predictImage(2:2:h, 1:2:w) = predictNonGreen(2:2:h, 1:2:w) + interpGreen(2:2:h, 1:2:w);
% predictImage(1:2:h, 2:2:w) = predictNonGreen(1:2:h, 2:2:w) + interpGreen(1:2:h, 2:2:w);

temp1 = diffGreen(1+border(1):2:h-border(2), 1+border(1):2:w-border(2));
temp2 = diffGreen(2+border(1):2:h-border(2), 2+border(1):2:w-border(2));
encodeGreen = [temp1(:)' temp2(:)'];
temp1 = diffNonGreen(2+border(1):2:h-border(2), 1+border(1):2:w-border(2));
temp2 = diffNonGreen(1+border(1):2:h-border(2), 2+border(1):2:w-border(2));
encodeNonGreen = [temp1(:)' temp2(:)'];

encodedData = [encodeGreen encodeNonGreen];

entropyAll = evaluateEntropy(evaluatePmf(encodedData, -256, 256));

compressionRatio = 8 / entropyAll;

return