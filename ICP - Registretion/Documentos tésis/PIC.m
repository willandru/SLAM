figure;

% First row with four images
subplot(2,4,1)
imshow(combinedImage2);
title('Hector SLAM');
subplot(2,4,2)
imshow(combinedImage3);
title('Frontier');
subplot(2,4,3)
imshow(combinedImage4);
title('Karto');
subplot(2,4,4)
imshow(combinedImage5);
title('Gmapping');

% Second row with three images, centered beneath the first four
% Calculate the offset to center the images on the second row
offset = 0.5; % Adjust the offset if necessary to center the images

subplot(2,4,5 + offset); % 2 rows, 4 columns, position 5 + offset
imshow(combinedImageB);
title('Gmapping');

subplot(2,4,6 + offset); % 2 rows, 4 columns, position 6 + offset
imshow(combinedImageC);
title('Hector');

subplot(2,4,7 + offset); % 2 rows, 4 columns, position 7 + offset
imshow(combinedImageD);
title('Karto');