%% initial display
data = dlmread('colored_point_cloud.txt');
% camera calibration matrix
K = [500, 0, 250;
    0, 500, 265;
    0, 0, 1]; 
% camera rotation matrix
R = [1, 0, 0;
    0, 1, 0;
    0, 0, 1];
% camera center
C = [0; 
    0; 
    250];
% focal length of the camera is 500
% field of view (in degrees)
fov_h = atan(265/500) * 180/pi; 
fprintf("field of view horizontally is %f\n", fov_h);
fov_v = atan(250/500) * 180/pi; 
fprintf("field of view vertically is %f\n", fov_v);

% projection matrix
t = -R*C;
Rt = [R, t];
P = K * Rt;

% convert points to homogeneous coordinate
locations_3D = data(:, 1:3);
center_x = mean(locations_3D(:, 1));
center_y = mean(locations_3D(:, 2));
center_z = mean(locations_3D(:, 3));
locations_3D = locations_3D - [center_x, center_y, center_z];
dist_from_camera = sqrt(sum((locations_3D - C').^2, 2));
locations_3D_homogeneous = [locations_3D, ones(length(locations_3D), 1)];

% get colors
colors = data(:, 4:6);

% project points to image plane
locations_2D = locations_3D_homogeneous * P';
locations_2D = locations_2D(:, 1:2) ./ locations_2D(:, 3);
image = zeros(500, 500, 3) + 255;
pixel_dist_from_camera = zeros(500, 500) + 100000;
for i = 1:length(locations_2D)
    x = round(locations_2D(i, 2));
    y = round(locations_2D(i, 1));
    if dist_from_camera(i) < pixel_dist_from_camera(x, y)
        image(x, y, :) = colors(i, :);
        pixel_dist_from_camera(x, y) = dist_from_camera(i);
    end
end
image = image/255.0;
imshow(image);

%% enhanced version
% get mean x and z first 
figure();
thickness = 4;
locations_3D = data(:, 1:3);
center_x = mean(locations_3D(:, 1));
center_y = mean(locations_3D(:, 2));
center_z = mean(locations_3D(:, 3));
locations_3D = locations_3D - [center_x, center_y, center_z];

for i = 1:60
    theta = i*pi/30;
    R_y = [cos(theta), 0, sin(theta);
        0, 1, 0;
        -sin(theta), 0, cos(theta)];
    locations_3D_temp = locations_3D * R_y;
    dist_from_camera = sqrt(sum((locations_3D_temp - C').^2, 2));
    [dist_from_camera, idx] = sort(dist_from_camera, 'descend');
    locations_3D_temp = locations_3D_temp(idx, :);
    colors = data(:, 4:6);
    colors = colors(idx, :);
    locations_3D_homogeneous = [locations_3D_temp, ones(length(locations_3D_temp), 1)];
    % project points to image plane
    locations_2D = locations_3D_homogeneous * P';
    locations_2D = locations_2D(:, 1:2) ./ locations_2D(:, 3);
    image = zeros(500, 500, 3) + 255;
    pixel_dist_from_camera = zeros(500, 500) + 100000;
    for j = 1:length(locations_2D)
        x = round(locations_2D(j, 2));
        y = round(locations_2D(j, 1));
        if dist_from_camera(j) < pixel_dist_from_camera(x, y)
            thickened_color_vector = zeros(thickness, thickness, 3);
            thickened_color_vector(:, :, 1) = colors(j, 1);
            thickened_color_vector(:, :, 2) = colors(j, 2);
            thickened_color_vector(:, :, 3) = colors(j, 3);
            image(x-thickness/2:x-1+thickness/2, y-thickness/2:y-1+thickness/2, :) = thickened_color_vector;
            pixel_dist_from_camera(x, y) = dist_from_camera(j);
        end
    end
    image = image/255.0;
    imshow(image);
    drawnow;
end