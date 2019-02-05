%% read image and preprocess data
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

% normalize locations
dims = size(img);
width = dims(2);
height = dims(1);
locations = zeros(3, width * height);
colors = zeros(3, width * height);

for i = 1:height
    for j = 1:width
        locations(:, (i-1)*width + j) = [i, j, 1]';
        colors(:, (i-1)*width + j) = img(i, j, :);
    end
end

%% DLT
% calculate A
A = zeros(8, 9);
for i = 1:4
    A(2*(i-1)+1, :) = [0, 0, 0, -x2(i, 3) * x1(i, :), x2(i, 2) * x1(i, :)];
    A(2*i, :) = [x2(i, 3) * x1(i, :), 0, 0, 0, -x2(i, 1) * x1(i, :)];
end

% solve for H
[U, D, V] = svd(A);
h = V(:, end);
H = reshape(h, [3, 3])';

% apply H to get new image
new_locations = H * locations;
new_locations = new_locations(1:2, :) ./ new_locations(3, :);
corners = [1, 1, 1;
    1, width, 1;
    height, 1, 1;
    height, width, 1];
new_corners = H * corners';
new_corners = new_corners(1:2, :) ./ new_corners(3, :);
new_corners = round(new_corners);
x_shift = min(new_corners(2, :));
y_shift = min(new_corners(1, :));
new_width = max(new_corners(2, :)) - min(new_corners(2, :)) + 1;
new_height = max(new_corners(1, :)) - min(new_corners(1, :)) + 1;
new_img = zeros(new_height, new_width, 3) + 255;

H_inv = H \ eye(3);
for i = 1:new_height
    for j = 1:new_width
        idx_inv = H_inv * [i+y_shift; j+x_shift; 1];
        idx_inv = idx_inv(1:2) / idx_inv(3);
        idx_inv = round(idx_inv);
        if ~(any(idx_inv < 1) || (idx_inv(1) > height) || (idx_inv(2) > width))
            color_idx = (idx_inv(1)-1) * width + idx_inv(2);
            new_img(i, j, :) = colors(:, color_idx);
        end
    end
end

figure();
imshow(new_img/255.0);