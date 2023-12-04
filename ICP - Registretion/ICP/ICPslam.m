clc, clear, close all;


imagen = imread('Real_cartographer.pgm');

% Muestra la imagen
imshow(imagen);
title('Imagen PGM');


% Cargar imágenes PGM
imagen1 = imread('Real_cartographer.pgm');
imagen2 = imread('Real_frontier.pgm');
imagen3 = imread('Real_hector.pgm');
imagen4 = imread('Real_karto.pgm');
imagen5 = imread('Real_gmapping.pgm');

% Crear un subplot con 2 filas y 3 columnas
subplot(2, 3, 1);
imshow(imagen1);
title('Imagen 1');

subplot(2, 3, 2);
imshow(imagen2);
title('Imagen 2');

subplot(2, 3, 3);
imshow(imagen3);
title('Imagen 3');

subplot(2, 3, 4);
imshow(imagen4);
title('Imagen 4');

subplot(2, 3, 5);
imshow(imagen5);
title('Imagen 5');
