clear; clc; close all;
% read two images
img_1 = imread('img_1.jpg');
img_2 = imread('img_2.jpg');

gray_img_1 = rgb2gray(img_1);
gray_img_2 = rgb2gray(img_2);

points_1 = detectSURFFeatures(gray_img_1);
points_2 = detectSURFFeatures(gray_img_2);

[features_1, valid_points_1] = extractFeatures(gray_img_1, points_1);
[features_2, valid_points_2] = extractFeatures(gray_img_2, points_2);

idxPairs = featureMatch(features_1, features_2, 3);

xyA = valid_points_1(idxPairs(:, 1), :);
xyB = valid_points_2(idxPairs(:, 2), :);
figure; ax = axes;
showMatchedFeatures(img_1, img_2, xyA, xyB, 'montage', 'Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');
impixelinfo;

xyA = xyA.Location;
xyB = xyB.Location;

% index format must be [row, column]
xyA = [xyA(:, 2), xyA(:, 1)];
xyB = [xyB(:, 2), xyB(:, 1)];

distThresh = 20;
agreeThresh = 0.5;
maxIterations = 100;
[H, fits, its] = ransac(xyA, xyB, distThresh, agreeThresh, maxIterations);
final_img = imageStitch(img_1, img_2, H);
figure;
imshow(img_2);
figure;
imshow(final_img/255.0);