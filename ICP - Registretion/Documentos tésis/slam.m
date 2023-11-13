clc, clear, close all
% Cargar imágenes PGM
imagen1 = imread('Real_cartographer.pgm');
imagen2 = imread('Real_frontier.pgm');
imagen3 = imread('Real_hector.pgm');
imagen4 = imread('Real_karto.pgm');
imagen5 = imread('Real_gmapping.pgm');

im1= imresize(imagen1, size(imagen4)); 
im2= imresize(imagen2, size(imagen4)); 
im3= imresize(imagen3, size(imagen4)); 
im4= imresize(imagen4, size(imagen4)); 
im5= imresize(imagen5, size(imagen4)); 


imagen6 = imread('Env_1_Cartographer.pgm');
imagen7 = imread('Env_1_Frontier.pgm');
imagen8 = imread('Env_1_Gmapping.pgm');
imagen9 = imread('Env_1_Hector.pgm');
imagen10 = imread('Env_1_Karto.pgm');


imagen11 = imread('piso13_gmapping.pgm');
imagen12 = imread('Piso13_Cartographer.pgm');
imagen13 = imread('Piso13_Ideal_gmapping.pgm');
imagen14 = imread('Piso13_Ideal_Hector.pgm');
imagen15 = imread('Piso13_Ideal_karto.pgm');

% REDIMENSIONAR LAS IMAGENES


imagen2= imagen2(60:170, 190:310);
imagen3=imagen3(955:1035,1015:1095);
imagen4=imagen4(85:175,35:125);
imagen5=imagen5(170:260,120:220);





% Crear un subplot con 3 filas y 5 columna


figure()
subplot(3, 5, 1);
imshow(imagen1);
title('Imagen 1');
subplot(3, 5, 2);
imshow(imagen2);
title('Imagen 2');
subplot(3, 5, 3);
imshow(imagen3);
title('Imagen 3');
subplot(3, 5, 4);
imshow(imagen4);
title('Imagen 4');
subplot(3, 5, 5);
imshow(imagen5);
title('Imagen 5');
subplot(3, 5, 6);
imshow(imagen6);
title('Imagen 6');
subplot(3, 5, 7);
imshow(imagen7);
title('Imagen 7');
subplot(3, 5, 8);
imshow(imagen8);
title('Imagen 8');
subplot(3, 5, 9);
imshow(imagen9);
title('Imagen 9');
subplot(3, 5, 10);
imshow(imagen10);
title('Imagen 10');
subplot(3, 5, 11);
imshow(imagen11);
title('Imagen 11');
subplot(3, 5, 12);
imshow(imagen12);
title('Imagen 12');
subplot(3, 5, 13);
imshow(imagen13);
title('Imagen 13');
subplot(3, 5, 14);
imshow(imagen14);
title('Imagen 14');
subplot(3, 5, 15);
imshow(imagen15);
title('Imagen 15');








% figure()
% subplot(1, 5, 1);
% imshow(im1);
% title('Imagen 1');
% subplot(1, 5, 2);
% imshow(im2);
% title('Imagen 2');
% subplot(1, 5, 3);
% imshow(im3);
% title('Imagen 3');
% subplot(1, 5, 4);
% imshow(im4);
% title('Imagen 4');
% subplot(1, 5, 5);
% imshow(im5);
% title('Imagen 5');
