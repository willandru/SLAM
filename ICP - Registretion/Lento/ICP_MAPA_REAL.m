clc, clear, close all
% Load images
imagenA = imread('Real_Lento_gmapping.pgm');
imagenB = imread('Real_Lento_DA.pgm');
imagenC = imread('Real_Lento_hector.pgm');
imagenD = imread('Real_Lento_karto.pgm');


imagenA = imagenA(155:250, 200:300);
imagenB = imagenB(145:250, 200:300);
imagenC = imagenC(1000:1090, 1015:1100);
imagenD = imagenD(10:100, 60:end);


imagenA = imrotate(imagenA, -11, 'bilinear');
imagenA(:,1:20) = 205;
imagenA(:,100:end) = 205;
imagenA(1:16,:) = 205;
imagenA(100:end,:) = 205;
imagenA = imagenA(15:100, 15:100);

% Create a figure
figure(1);
subplot(1,4,1);
imshow(imagenA);
title('gmapping');
subplot(1,4,2);
imshow(imagenB);
title('DA');
subplot(1,4,3);
imshow(imagenC);
title('hector');
subplot(1,4,4);
imshow(imagenD);
title('karto');

mapA=imagenA;
mapB = imresize(imagenB, size(imagenA));
mapC = imresize(imagenC, size(imagenA));
mapD = imresize(imagenD, size(imagenA));


% Binarizar imágenes
binaryMapA = imbinarize(mapA);
binaryMapB = imbinarize(mapB);
binaryMapC = imbinarize(mapC);
binaryMapD = imbinarize(mapD);


% Visualizar mapas binarizados
figure(2);
subplot(2,2,1);
imshow(binaryMapA);
title('imA-GT');
subplot(2,2,2);
imshow(binaryMapB);
title('imB');
subplot(2,2,3);
imshow(binaryMapC);
title('imC');
subplot(2,2,4);
imshow(binaryMapD);
title('imD');


% Extraer características (bordes)
edgesMapA = edge(binaryMapA, 'Canny');
edgesMapB = edge(binaryMapB, 'Canny');
edgesMapC = edge(binaryMapC, 'Canny');
edgesMapD = edge(binaryMapD, 'Canny');

% Visualizar bordes
figure(3);
subplot(2, 2, 1);
imshow(edgesMapA);
title('Edges Map A');
subplot(2, 2, 2);
imshow(edgesMapB);
title('Edges Map B');
subplot(2, 2, 3);
imshow(edgesMapC);
title('Edges Map C');
subplot(2, 2, 4);
imshow(edgesMapD);
title('Edges Map D');

% Convertir a nubes de puntos
[rowsA, colsA] = find(edgesMapA);
[rowsB, colsB] = find(edgesMapB);
[rowsC, colsC] = find(edgesMapC);
[rowsD, colsD] = find(edgesMapD);

% Convertir índices a formato de nube de puntos
pointsA = [colsA, rowsA, zeros(size(colsA))];
pointsB = [colsB, rowsB, zeros(size(colsB))];
pointsC = [colsC, rowsC, zeros(size(colsC))];
pointsD = [colsD, rowsD, zeros(size(colsD))];

% Crear objetos de nube de puntos
ptCloudA = pointCloud(pointsA);
ptCloudB = pointCloud(pointsB);
ptCloudC = pointCloud(pointsC);
ptCloudD = pointCloud(pointsD);


%ICP

% ICP para alinear las nubes de puntos
[tformB, ptCloudRegB, rmseB] = pcregistericp(ptCloudB, ptCloudA, 'Extrapolate', true);
[tformC, ptCloudRegC, rmseC] = pcregistericp(ptCloudC, ptCloudA, 'Extrapolate', true);
[tformD, ptCloudRegD, rmseD] = pcregistericp(ptCloudD, ptCloudA, 'Extrapolate', true);

% Transformar las nubes de puntos alineadas
ptCloudAlignedB = pctransform(ptCloudB, tformB);
ptCloudAlignedC = pctransform(ptCloudC, tformC);
ptCloudAlignedD = pctransform(ptCloudD, tformD);

% Visualización de las nubes de puntos alineadas
figure(4);
pcshowpair(ptCloudA, ptCloudAlignedB);
title('Aligned Point Clouds MAP B');

figure(5);
pcshowpair(ptCloudA, ptCloudAlignedC);
title('Aligned Point Clouds MAP C');

figure(6);
pcshowpair(ptCloudA, ptCloudAlignedD);
title('Aligned Point Clouds MAP D');

% Cálculo de ADNN para cada nube de puntos alineada
adnnB = calculateADNN(ptCloudA, ptCloudAlignedB);
adnnC = calculateADNN(ptCloudA, ptCloudAlignedC);
adnnD = calculateADNN(ptCloudA, ptCloudAlignedD);


% Mostrar las estadísticas ADNN
disp(['ADNN for Map B: ', num2str(adnnB)]);
disp(['ADNN for Map C: ', num2str(adnnC)]);
disp(['ADNN for Map D: ', num2str(adnnD)]);




binaryMapA = ~binaryMapA; 
binaryMapB = ~binaryMapB;
binaryMapC = ~binaryMapC;
binaryMapD = ~binaryMapD; 

% Create RGB images for each map
imageRGBA = zeros([size(binaryMapA), 3], 'uint8');
imageRGBB = zeros([size(binaryMapB), 3], 'uint8');
imageRGBC = zeros([size(binaryMapC), 3], 'uint8');
imageRGBD = zeros([size(binaryMapD), 3], 'uint8');

% Assign red color to the points of interest for the first map
imageRGBA(:,:,1) = binaryMapA * 255; % Red for binaryMapA
% Assign green color to the points of interest for the second map
imageRGBB(:,:,2) = binaryMapB * 255; % Green for binaryMapB
imageRGBC(:,:,2) = binaryMapC * 255; % Green for binaryMapC
imageRGBD(:,:,2) = binaryMapD * 255; % Green for binaryMapD

% Combine the images
combinedImageB = imadd(imageRGBA, imageRGBB);
combinedImageC = imadd(imageRGBA, imageRGBC);
combinedImageD = imadd(imageRGBA, imageRGBD);

% Identify background pixels in the combined image
backgroundMaskB = all(combinedImageB == 0, 3);
backgroundMaskC = all(combinedImageC == 0, 3);
backgroundMaskD = all(combinedImageD == 0, 3);

% Change only background pixels to white
combinedImageB(repmat(backgroundMaskB, [1, 1, 3])) = 255;
combinedImageC(repmat(backgroundMaskC, [1, 1, 3])) = 255;
combinedImageD(repmat(backgroundMaskD, [1, 1, 3])) = 255;

% Visualize the combined images
figure;
subplot(3,1,1);
imshow(combinedImageB);
title('DA vs Gmapping');
subplot(3,1,2);
imshow(combinedImageC);
title('Hector vs Gmapping');
subplot(3,1,3);
imshow(combinedImageD);
title('Karto vs Gmapping');






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




