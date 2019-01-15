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
% field of view is 500 * 530

% projection matrix
t = -R*C;
Rt = [R, t];
P = K * Rt;

% convert points to homogeneous coordinate
locations_3D = data(:, 1:3);
dist_from_camera = sqrt(sum((locations_3D - C').^2, 2));
locations_3D = [locations_3D, ones(length(locations_3D), 1)];

% get colors
colors = data(:, 4:6);

% project points to image plane
locations_2D = locations_3D * P';
locations_2D = locations_2D(:, 1:2) ./ locations_2D(:, 3);
image = zeros(1000, 1000, 3) + 255;
pixel_dist_from_camera = zeros(1000, 1000) + 100000;
for i = 1:length(locations_2D)
    x = round(locations_2D(i, 2));
    y = round(locations_2D(i, 1));
    if dist_from_camera(i) < pixel_dist_from_camera(x, y)
        for j = -1:1
            for k = -1:1
                image(x+j, y+k, :) = colors(i, :);
            end
        end
        pixel_dist_from_camera(x, y) = dist_from_camera(i);
    end
end
image = image/255.0;
imshow(image);

%% rotate points around vertical axis (y-axis)
% get mean x and z first 
figure();
locations_3D = data(:, 1:3);
center_x = mean(locations_3D(:, 1));
center_z = mean(locations_3D(:, 3));
locations_3D_centered = locations_3D - [center_x, 0, center_z];
for i = 1:60
    theta = i*pi/30;
    R_y = [cos(theta), 0, sin(theta);
        0, 1, 0;
        -sin(theta), 0, cos(theta)];
    locations_3D_temp = locations_3D_centered * R_y;
    locations_3D_temp = locations_3D_temp + [center_x, 0, center_z];
    dist_from_camera = sqrt(sum((locations_3D_temp - C').^2, 2));
    locations_3D_homogeneous = [locations_3D_temp, ones(length(locations_3D_temp), 1)];
    % project points to image plane
    locations_2D = locations_3D_homogeneous * P';
    locations_2D = locations_2D(:, 1:2) ./ locations_2D(:, 3);
    image = zeros(1000, 1000, 3) + 255;
    pixel_dist_from_camera = zeros(1000, 1000) + 100000;
    for i = 1:length(locations_2D)
        x = round(locations_2D(i, 2));
        y = round(locations_2D(i, 1));
        if dist_from_camera(i) < pixel_dist_from_camera(x, y)
            image(x, y, :) = colors(i, :);
        end
    end
    image = image/255.0;
    imshow(image);
    pause(0.25);
end

%% enhanced version
% get mean x and z first 
figure();
thickness = 4;
locations_3D = data(:, 1:3);
center_x = mean(locations_3D(:, 1));
center_z = mean(locations_3D(:, 3));
locations_3D_centered = locations_3D - [center_x, 0, center_z];
for i = 1:60
    theta = i*pi/30;
    R_y = [cos(theta), 0, sin(theta);
        0, 1, 0;
        -sin(theta), 0, cos(theta)];
    locations_3D_temp = locations_3D_centered * R_y;
    locations_3D_temp = locations_3D_temp + [center_x, 0, center_z];
    dist_from_camera = sqrt(sum((locations_3D_temp - C').^2, 2));
    locations_3D_homogeneous = [locations_3D_temp, ones(length(locations_3D_temp), 1)];
    % project points to image plane
    locations_2D = locations_3D_homogeneous * P';
    locations_2D = locations_2D(:, 1:2) ./ locations_2D(:, 3);
    image = zeros(1000, 1000, 3) + 255;
    pixel_dist_from_camera = zeros(1000, 1000) + 100000;
    for i = 1:length(locations_2D)
        x = round(locations_2D(i, 2));
        y = round(locations_2D(i, 1));
        if dist_from_camera(i) < pixel_dist_from_camera(x, y)
            thickened_color_vector = zeros(thickness, thickness, 3);
            thickened_color_vector(:, :, 1) = colors(i, 1);
            thickened_color_vector(:, :, 2) = colors(i, 2);
            thickened_color_vector(:, :, 3) = colors(i, 3);
            image(x-thickness/2:x-1+thickness/2, y-thickness/2:y-1+thickness/2, :) = thickened_color_vector;
            pixel_dist_from_camera(x, y) = dist_from_camera(i);
        end
    end
    image = image/255.0;
    imshow(image);
    pause(0.25);
end