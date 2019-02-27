function combined_img = imageStitch(A, B, H, xy1, xy2)
    dims = size(A);
    widthA = dims(2);
    heightA = dims(1);
    locations = zeros(3, widthA * heightA);
    colors = zeros(3, widthA * heightA);
    for i = 1:heightA
        for j = 1:widthA
            locations(:, (i-1)*widthA + j) = [i, j, 1];
            colors(:, (i-1)*widthA + j) = A(i, j, :);
        end
    end
    
    corners = [1, 1, 1;
        widthA, 1, 1;
        1, heightA, 1;
        widthA, heightA, 1];

    new_corners = H * corners';
    new_corners = new_corners(1:2, :) ./ new_corners(3, :);
    new_corners = round(new_corners);
    x_shift = min(new_corners(1, :));
    y_shift = min(new_corners(2, :));
    new_width = max(new_corners(1, :)) - x_shift + 1;
    new_height = max(new_corners(2, :)) - y_shift + 1;
    
    pt1 = xy1(1, :);
    pt1 = H * pt1';
    pt1 = pt1(1:2) / pt1(3);
    pt1 = round(pt1' + abs([x_shift, y_shift]));
    pt2 = round(xy2(1, :));
    
    width_offset = pt1(1) - pt2(1);
    height_offset = pt1(2) - pt2(2);
    
    dims = size(B);
    widthB = dims(2);
    heightB = dims(1);
    
    combined_img = zeros(max(new_height, heightB + height_offset), max(new_width, widthB + width_offset), 3);
    combined_img((height_offset + 1):(height_offset + heightB), (width_offset + 1):(width_offset + widthB), :) = B;
    
    H_inv = H \ eye(3);
    for i = 1:new_height
        for j = 1:new_width
            idx_inv = H_inv * [j+x_shift; i+y_shift; 1];
            idx_inv = idx_inv(1:2) / idx_inv(3);
            idx_inv = round(idx_inv);
            if ~(any(idx_inv < 1) || (idx_inv(2) > heightA) || (idx_inv(1) > widthA))
                color_idx = (idx_inv(2)-1) * widthA + idx_inv(1);
                combined_img(i, j, :) = colors(:, color_idx);
            end
        end
    end
end