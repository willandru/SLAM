clc, clear , close all


imagen1 = imread('Real_cartographer.pgm');
imagen2 = imread('Real_frontier.pgm');
imagen3 = imread('Real_hector.pgm');
imagen4 = imread('Real_karto.pgm');
imagen5 = imread('Real_gmapping.pgm');

imagen2= imagen2(60:170, 190:310);
imagen3=imagen3(955:1035,1015:1095);
imagen4=imagen4(85:175,35:125);
imagen5=imagen5(170:260,120:220);


imagen1 = imread('Real_cartographer.pgm');
imagen3 = imread('Real_hector.pgm');

B=imagen3(950:1047, 1000:1114);



map1 = imagen1; %size: 98x155
map2 = B;  %size: 98x155

map3= imresize(imagen2, size(imagen1)); 
map4= imresize(imagen4, size(imagen1)); 
map5= imresize(imagen5, size(imagen1)); 



figure(1)
subplot(3,2,1)
imshow(map1)
title('im1-GT')
subplot(3,2,2)
imshow(map2)
title('im3')
subplot(3,2,3)
imshow(map3)
title('im2')
subplot(3,2,4)
imshow(map4)
title('im4')
subplot(3,2,5)
imshow(map5)
title('im5')
% Convert maps to binary (adjust threshold as needed)
binaryMap1 = imbinarize(map1);
binaryMap2 = imbinarize(map2);
binaryMap3 = imbinarize(map3);
binaryMap4 = imbinarize(map4);
binaryMap5 = imbinarize(map5);

% Display the binary maps
figure(2);
subplot(3, 2, 1);
imshow(binaryMap1);
title('Binary Map 1');
subplot(3, 2, 2);
imshow(binaryMap2);
title('Binary Map 2');
subplot(3, 2, 3);
imshow(binaryMap3);
title('Binary Map 3');
subplot(3, 2, 4);
imshow(binaryMap4);
title('Binary Map 4');
subplot(3, 2, 5);
imshow(binaryMap5);
title('Binary Map 5');

%Extract features (BORDES)
edgesMap1 = edge(binaryMap1, 'Canny');
edgesMap2 = edge(binaryMap2, 'Canny');
edgesMap3 = edge(binaryMap3, 'Canny');
edgesMap4 = edge(binaryMap4, 'Canny');
edgesMap5 = edge(binaryMap5, 'Canny');


figure(3);
subplot(3, 2, 1);
imshow(edgesMap1);
title('Edges Map 1');
subplot(3, 2, 2);
imshow(edgesMap2);
title('Edges Map 2');
subplot(3, 2, 3);
imshow(edgesMap3);
title('Edges Map 3');
subplot(3, 2, 4);
imshow(edgesMap4);
title('Edges Map 4');
subplot(3, 2, 5);
imshow(edgesMap5);
title('Edges Map 5');

%Convert to Point Clouds
% Find the indices of non-zero values (features or points)
[rows1, cols1] = find(edgesMap1);
[rows2, cols2] = find(edgesMap2);
[rows3, cols3] = find(edgesMap3);
[rows4, cols4] = find(edgesMap4);
[rows5, cols5] = find(edgesMap5);

% Convert these indices to point cloud format (with Z-coordinates set to 0)
points1 = [cols1, rows1, zeros(size(cols1))];
points2 = [cols2, rows2, zeros(size(cols2))];
points3 = [cols3, rows3, zeros(size(cols3))];
points4 = [cols4, rows4, zeros(size(cols4))];
points5 = [cols5, rows5, zeros(size(cols5))];

% Create the point cloud objects
ptCloud1 = pointCloud(points1);
ptCloud2 = pointCloud(points2);
ptCloud3 = pointCloud(points3);
ptCloud4 = pointCloud(points4);
ptCloud5 = pointCloud(points5);


%ICP

[tform2, ptCloudReg2, rmse2] = pcregistericp(ptCloud2, ptCloud1, 'Extrapolate', true);
[tform3, ptCloudReg3, rmse3] = pcregistericp(ptCloud3, ptCloud1, 'Extrapolate', true);
[tform4, ptCloudReg4, rmse4] = pcregistericp(ptCloud4, ptCloud1, 'Extrapolate', true);
[tform5, ptCloudReg5, rmse5] = pcregistericp(ptCloud5, ptCloud1, 'Extrapolate', true);


ptCloudAligned2 = pctransform(ptCloud2, tform2);
ptCloudAligned3 = pctransform(ptCloud3, tform3);
ptCloudAligned4 = pctransform(ptCloud4, tform4);
ptCloudAligned5 = pctransform(ptCloud5, tform5);



figure(4);
pcshowpair(ptCloud1, ptCloudAligned2);
title('Aligned Point Clouds MAP 2');


figure(5);
pcshowpair(ptCloud1, ptCloudAligned3);
title('Aligned Point Clouds MAP 3');

figure(6);
pcshowpair(ptCloud1, ptCloudAligned4);
title('Aligned Point Clouds MAP 4');

figure(7);
pcshowpair(ptCloud1, ptCloudAligned5);
title('Aligned Point Clouds MAP 5');










%AKNN
% Extract locations from the aligned point cloud
alignedPoints = ptCloudAligned2.Location;
% Initialize array to hold distances
distances = zeros(ptCloudAligned2.Count, 1);
% Loop over each point in the aligned point cloud
for i = 1:ptCloudAligned2.Count
    % Find the nearest neighbor in ptCloud1 for the current point in ptCloudAligned
    [indices, dists] = findNearestNeighbors(ptCloud1, alignedPoints(i, :), 1);
    
    % Store the distance of the nearest neighbor
    distances(i) = dists;
end
% Calculate the ADNN (Average Distance to Nearest Neighbor)
adnn = mean(distances);
% Display the ADNN
disp(['ADNN: ', num2str(adnn)]);


% Calculate ADNN for each aligned point cloud
adnn2 = calculateADNN(ptCloud1, ptCloudAligned2);
adnn3 = calculateADNN(ptCloud1, ptCloudAligned3);
adnn4 = calculateADNN(ptCloud1, ptCloudAligned4);
adnn5 = calculateADNN(ptCloud1, ptCloudAligned5);

% Display the ADNNs
disp(['ADNN for Map 2: ', num2str(adnn2)]);
disp(['ADNN for Map 3: ', num2str(adnn3)]);
disp(['ADNN for Map 4: ', num2str(adnn4)]);
disp(['ADNN for Map 5: ', num2str(adnn5)]);



% 

imageSize = size(map1); % Size of the output image
image1 = pointCloudToImage(ptCloud1, imageSize);
image2 = pointCloudToImage(ptCloudAligned2, imageSize);
image3 = pointCloudToImage(ptCloudAligned3, imageSize);
image4 = pointCloudToImage(ptCloudAligned4, imageSize);
image5 = pointCloudToImage(ptCloudAligned5, imageSize);

image1= 1-image1;
image2= 1-image2;
image3= 1-image3;
image4= 1-image4;
image5= 1-image5;

% image1 = pointCloudToImage(ptCloud1, size(map1), 1); % Adjust '1' as needed for thickness
% image2 = pointCloudToImage(ptCloudAligned, size(map1), 1); % Adjust '1' as needed for thickness
% 

figure(8)
subplot(2,2,1)
imshow(binaryMap1);
subplot(2,2,2)
imshow(binaryMap2);
subplot(2,2,3)
imshow(image1);
subplot(2,2,4)
imshow(image2);

% % Visualize the result
figure(9)
subplot(5,2,1)
imshow(binaryMap1);
subplot(5,2,2)
imshow(image1);
subplot(5,2,3)
imshow(binaryMap2);
subplot(5,2,4)
imshow(image2);
subplot(5,2,5)
imshow(binaryMap3);
subplot(5,2,6)
imshow(image3);
subplot(5,2,7)
imshow(binaryMap4);
subplot(5,2,8)
imshow(image4);
subplot(5,2,9)
imshow(image4);
subplot(5,2,10)
imshow(image4);

% % Visualize the result
figure(10)
subplot(4,2,1)
imshow(binaryMap1);
subplot(4,2,2)
imshow(image1);
subplot(4,2,3)
imshow(binaryMap2);
subplot(4,2,4)
imshow(image2);
subplot(4,2,5)
imshow(binaryMap3);
subplot(4,2,6)
imshow(image3);
subplot(4,2,7)
imshow(binaryMap4);
subplot(4,2,8)
imshow(image4);



% Asegúrate de que el fondo sea 0 y los puntos de interés sean 1
binaryMap1 = ~binaryMap1; % Invierte si es necesario
binaryMap2 = ~binaryMap2; % Invierte si es necesario
binaryMap3 = ~binaryMap3; % Invierte si es necesario
binaryMap4 = ~binaryMap4; % Invierte si es necesario
binaryMap5 = ~binaryMap5; % Invierte si es necesario

% Crear imágenes RGB para cada mapa
imageRGB1 = zeros([size(binaryMap1), 3], 'uint8');
imageRGB2 = zeros([size(binaryMap2), 3], 'uint8');
imageRGB3 = zeros([size(binaryMap3), 3], 'uint8');
imageRGB4 = zeros([size(binaryMap4), 3], 'uint8');
imageRGB5 = zeros([size(binaryMap5), 3], 'uint8');

% Asignar el color rojo a los puntos de interés del primer mapa
imageRGB1(:,:,1) = binaryMap1 * 255; % Rojo para binaryMap1
% Asignar el color verde a los puntos de interés del segundo mapa
imageRGB2(:,:,2) = binaryMap2 * 255; % Verde para binaryMap2
imageRGB3(:,:,2) = binaryMap3 * 255; % Verde para binaryMap2
imageRGB4(:,:,2) = binaryMap4 * 255; % Verde para binaryMap2
imageRGB5(:,:,2) = binaryMap5 * 255; % Verde para binaryMap2

% Combinar las imágenes
combinedImage2 = imadd(imageRGB1, imageRGB2);
combinedImage3 = imadd(imageRGB1, imageRGB3);
combinedImage4 = imadd(imageRGB1, imageRGB4);
combinedImage5 = imadd(imageRGB1, imageRGB5);

% Identificar los píxeles de fondo en la imagen combinada
backgroundMask2 = all(combinedImage2 == 0, 3);
backgroundMask3 = all(combinedImage3 == 0, 3);
backgroundMask4 = all(combinedImage4 == 0, 3);
backgroundMask5 = all(combinedImage5 == 0, 3);

% Cambiar solo los píxeles de fondo a blanco
combinedImage2(repmat(backgroundMask2, [1, 1, 3])) = 255;
combinedImage3(repmat(backgroundMask3, [1, 1, 3])) = 255;
combinedImage4(repmat(backgroundMask4, [1, 1, 3])) = 255;
combinedImage5(repmat(backgroundMask5, [1, 1, 3])) = 255;

% Visualizar la imagen combinada
figure;
subplot(2,2,1)
imshow(combinedImage2);
title('Hector SLAM vs Cartographer ');
subplot(2,2,2)
imshow(combinedImage3);
title('Frontier vs Cartographer');
subplot(2,2,3)
imshow(combinedImage4);
title('Karto vs Cartographer');
subplot(2,2,4)
imshow(combinedImage5);
title('Gmapping vs Cartographer');




% Function to calculate ADNN
function adnn = calculateADNN(refPtCloud, alignedPtCloud)
    % Extract locations from the aligned point cloud
    alignedPoints = alignedPtCloud.Location;
    % Initialize array to hold distances
    distances = zeros(alignedPtCloud.Count, 1);
    % Loop over each point in the aligned point cloud
    for i = 1:alignedPtCloud.Count
        % Find the nearest neighbor in refPtCloud for the current point in alignedPtCloud
        [indices, dists] = findNearestNeighbors(refPtCloud, alignedPoints(i, :), 1);
        % Store the distance of the nearest neighbor
        distances(i) = dists;
    end
    % Calculate the ADNN (Average Distance to Nearest Neighbor)
    adnn = mean(distances);
end


function image = pointCloudToImage(ptCloud, imageSize)
    points = ptCloud.Location(:, 1:2);

  %  Determine the scale factors if the point cloud is not in pixel coordinates
    scaleX = (imageSize(2) - 1) / (max(points(:, 1)) - min(points(:, 1)));
    scaleY = (imageSize(1) - 1) / (max(points(:, 2)) - min(points(:, 2)));

   % Scale and translate points to fit the imageSize
    points(:, 1) = (points(:, 1) - min(points(:, 1))) * scaleX + 1;
    points(:, 2) = (points(:, 2) - min(points(:, 2))) * scaleY + 1;

   % Round the coordinates to the nearest pixel
    points = round(points);

   % Initialize the image
    image = zeros(imageSize);

    %Mark the points in the image
    for i = 1:size(points, 1)
        image(points(i, 2), points(i, 1)) = 1; % The points are marked as white (1)
    end
end

% function image = pointCloudToImage(ptCloud, imageSize, pointThickness)
%     % Extract the X and Y coordinates of the points
%     points = ptCloud.Location(:, 1:2);
% 
%     % Determine the scale factors if the point cloud is not in pixel coordinates
%     scaleX = (imageSize(2) - 1) / (max(points(:, 1)) - min(points(:, 1)));
%     scaleY = (imageSize(1) - 1) / (max(points(:, 2)) - min(points(:, 2)));
% 
%     % Scale and translate points to fit the imageSize
%     points(:, 1) = (points(:, 1) - min(points(:, 1))) * scaleX + 1;
%     points(:, 2) = (points(:, 2) - min(points(:, 2))) * scaleY + 1;
% 
%     % Initialize the image
%     image = zeros(imageSize);
% 
%     % Define a grid for the point thickness
%     [gridX, gridY] = meshgrid(-pointThickness:pointThickness, -pointThickness:pointThickness);
%     circle = (gridX.^2 + gridY.^2) <= pointThickness.^2;
% 
%     % Mark the points in the image with the specified thickness
%     for i = 1:size(points, 1)
%         % Find the bounds for the circle
%         xBounds = round(points(i, 1)) + (-pointThickness:pointThickness);
%         yBounds = round(points(i, 2)) + (-pointThickness:pointThickness);
% 
%         % Check bounds
%         xBounds(xBounds < 1 | xBounds > imageSize(2)) = [];
%         yBounds(yBounds < 1 | yBounds > imageSize(1)) = [];
% 
%         % Draw the circle
%         image(yBounds, xBounds) = image(yBounds, xBounds) | circle(1:length(yBounds), 1:length(xBounds));
%     end   
% end

