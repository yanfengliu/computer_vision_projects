function B = inverseWarp(A, H)
    dims = size(A);
    width = dims(2);
    height = dims(1);
    locations = zeros(3, width * height);
    colors = zeros(3, width * height);
    for i = 1:height
        for j = 1:width
            locations(:, (i-1)*width + j) = [i, j, 1];
            colors(:, (i-1)*width + j) = A(i, j, :);
        end
    end
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
    B = zeros(new_height, new_width, 3) + 255;

    H_inv = H \ eye(3);
    for i = 1:new_height
        for j = 1:new_width
            idx_inv = H_inv * [i+y_shift; j+x_shift; 1];
            idx_inv = idx_inv(1:2) / idx_inv(3);
            idx_inv = round(idx_inv);
            if ~(any(idx_inv < 1) || (idx_inv(1) > height) || (idx_inv(2) > width))
                color_idx = (idx_inv(1)-1) * width + idx_inv(2);
                B(i, j, :) = colors(:, color_idx);
            end
        end
    end
end