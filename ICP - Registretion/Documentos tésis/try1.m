clc;
clear;
close all;

% Load point clouds from PGM files
nube_puntos1 = pgm_a_nube_puntos('Env_1_Cartographer.pgm');
nube_puntos2 = pgm_a_nube_puntos('Env_1_Karto.pgm');

% Create PointCloud objects
pc1 = pointCloud(nube_puntos1);
pc2 = pointCloud(nube_puntos2);

% Perform ICP
[tform, nube_puntos_alineada] = pcregistericp(pc2, pc1, 'Metric', 'pointToPoint', 'Extrapolate', true);

% Apply the transformation to the second set of points
nube_puntos_alineada = pctransform(pc2, tform);

% Visualize the results
figure;
pcshowpair(pc1, nube_puntos_alineada);
title('ICP Results');

% Function to convert PGM data to a point cloud
function nube_puntos = pgm_a_nube_puntos(nombre_archivo)
    % Load the PGM file
    [datos_pixeles, ancho, altura] = cargar_archivo_pgm(nombre_archivo);

    % Create a mesh of coordinates
    [X, Y] = meshgrid(1:ancho, 1:altura);

    % Convert pixel intensity to Z-coordinate
    Z = double(datos_pixeles); % Ensure the pixel data is in double format for processing

    % Create the XYZ coordinates for the point cloud
    nube_puntos = [X(:), Y(:), Z(:)];
end

% Function to read PGM files
function [pixel_data, width, height] = cargar_archivo_pgm(file_name)
    % Open the PGM file
    fid = fopen(file_name, 'r');
    
    % Read the header
    fgetl(fid); % Magic number, not used
    dims = sscanf(fgetl(fid), '%d %d');
    width = dims(1);
    height = dims(2);
    fgetl(fid); % Max value, not used
    
    % Read the pixel data
    pixel_data = fscanf(fid, '%d', [width, height]);
    
    % Close the file
    fclose(fid);
    
    % Transpose the pixel data to match image orientation
    pixel_data = pixel_data';
end
