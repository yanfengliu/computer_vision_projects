img = imread('lenna.png');
H = [1.6944, -0.2843, -140.7916;
     -0.0330, 1.0096, -212.1333;
     0.0002, -0.0000, 1.0000];
new_img = inverseWarp(img, H);
figure();
imshow(new_img/255.0);