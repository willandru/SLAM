imagen6 = imread('Env_1_Cartographer.pgm');
imagen7 = imread('Env_1_Frontier.pgm');
imagen8 = imread('Env_1_Gmapping.pgm');
imagen9 = imread('Env_1_Hector.pgm');
imagen10 = imread('Env_1_Karto.pgm') ;




imagen11 = imread('piso13_gmapping.pgm');
imagen12 = imread('Piso13_Cartographer.pgm');
imagen13 = imread('Piso13_Ideal_gmapping.pgm');
imagen14 = imread('Piso13_Ideal_Hector.pgm');
imagen15 = imread('Piso13_Ideal_karto.pgm');


figure()
subplot(2, 3, 1);
imshow(imagen6);
title('Imagen 1');

subplot(2, 3, 2);
imshow(imagen10);
title('Imagen 2');

subplot(2, 3, 4);
imshow(imagen12);
title('Imagen 3');

subplot(2, 3, 5);
imshow(imagen13);
title('Imagen 4');

subplot(2, 3, 6);
imshow(imagen15);
title('Imagen 5');



J = imrotate(imagen10,-14,'bilinear','crop');
figure()
subplot(1, 2, 1);
imshow(imagen10);
title('Imagen 2');
subplot(1, 2, 2);
imshow(J)
title('Rotated Image')

figure()
subplot(1, 2, 1);
imshow(imagen6);
title('Imagen 2');
subplot(1, 2, 2);
imshow(J)
title('Rotated Image')