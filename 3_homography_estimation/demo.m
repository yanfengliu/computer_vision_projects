% read image and preprocess data
img = imread('book.jpg');
resize_factor = 0.3; 
img = imresize(img, resize_factor);
img = rot90(img, 3);

% manually select a set of 4 correspondences
x1 = round(resize_factor * [1172, 473;
    956, 1715;
    2513, 2690;
    3113, 1202]);
x2 = [0, 0;
    0, 7;
    10, 7;
    10, 0];
x2 = round(x2 * mean(std(x1)) / mean(std(x2)));
x1 = [x1, zeros(4, 1)+1];
x2 = [x2, zeros(4, 1)+1];

H = normalized_dlt(x1, x2);
new_img = inverseWarp(img, H);
figure();
imshow(new_img/255.0);