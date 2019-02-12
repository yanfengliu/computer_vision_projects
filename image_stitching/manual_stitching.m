clear; clc; close all;
% read two images
img_1 = imread('img_1.jpg');
img_2 = imread('img_2.jpg');

% figure;
% imshow(img_1);
% impixelinfo;
% figure;
% imshow(img_2);
% impixelinfo;

% manually select four correspondence points
x1 = [
    320, 813; 
    540, 780; 
    589, 856; 
    497, 910];
x2 = [
    291, 371; 
    505, 325; 
    556, 393; 
    468, 451];
x2 = round(x2 * mean(std(x1)) / mean(std(x2)));
x1 = [x1, zeros(4, 1)+1];
x2 = [x2, zeros(4, 1)+1];

% normalize locations
dims = size(img_1);
width = dims(2);
height = dims(1);
locations = zeros(3, width * height);
colors = zeros(3, width * height);

for i = 1:height
    for j = 1:width
        locations(:, (i-1)*width + j) = [i, j, 1]';
        colors(:, (i-1)*width + j) = img_1(i, j, :);
    end
end

gray_img_1 = rgb2gray(img_1);
gray_img_2 = rgb2gray(img_2);
points_1 = detectSURFFeatures(gray_img_1);
points_2 = detectSURFFeatures(gray_img_2);
[features_1, valid_points_1] = extractFeatures(gray_img_1, points_1);
[features_2, valid_points_2] = extractFeatures(gray_img_2, points_2);

