img = imread('lenna.png');
H = [1.6944, -0.2843, -140.7916;
     -0.0330, 1.0096, -212.1333;
     0.0002, -0.0000, 1.0000];
dims = size(img);
width = dims(2);
height = dims(1);
locations = zeros(3, width * height);
colors = zeros(3, width * height);
for i = 1:height
    for j = 1:width
        locations(:, (i-1)*height + j) = [i, j, 1];
        colors(:, (i-1)*height + j) = img(i, j, :);
    end
end
new_locations = H * locations;
new_locations = new_locations(1:2, :) ./ new_locations(3, :);
corners = [1, 1, 1;
    1, 512, 1;
    512, 1, 1;
    512, 512, 1];
new_corners = H * corners';
new_corners = new_corners(1:2, :) ./ new_corners(3, :);
new_corners = round(new_corners);
x_shift = min(new_corners(2, :));
y_shift = min(new_corners(1, :));
new_width = max(new_corners(2, :)) - min(new_corners(2, :)) + 1;
new_height = max(new_corners(1, :)) - min(new_corners(1, :)) + 1;
new_img = zeros(new_height, new_width, 3) + 255;

H_inv = inv(H);
for i = 1:new_height
    for j = 1:new_width
        idx_inv = H \ [i+y_shift; j+x_shift; 1];
        idx_inv = idx_inv(1:2) / idx_inv(3);
        idx_inv = round(idx_inv);
        if ~(any(idx_inv < 1) || (idx_inv(1) > height) || (idx_inv(2) > width))
            color_idx = (idx_inv(1)-1) * height + idx_inv(2);
            new_img(i, j, :) = colors(:, color_idx);
        end
    end
end

figure();
imshow(new_img/255.0);