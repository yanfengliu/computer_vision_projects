function H = normalized_dlt(x1, x2)
    x1 = x1(:, 1:2) ./ x1(:, 3);
    x2 = x2(:, 1:2) ./ x2(:, 3);
    x1_mean = mean(x1, 1);
    x2_mean = mean(x2, 1);
    x1_mean_dist = mean(sum(sqrt((x1 - x1_mean).^2), 2));
    x2_mean_dist = mean(sum(sqrt((x2 - x2_mean).^2), 2));
    x1_scale = sqrt(2) / x1_mean_dist;
    x2_scale = sqrt(2) / x2_mean_dist;
    x1_translate = x1_mean * x1_scale;
    x2_translate = x2_mean * x2_scale;
    T1 = [x1_scale, 0,        x1_translate(1);
          0,        x1_scale, x1_translate(2);
          0,        0,        1             ];
    T2 = [x2_scale, 0,        x2_translate(1);
          0,        x2_scale, x2_translate(2);
          0,        0,        1             ];
    normalized_x1 = T1 * [x1, zeros(length(x1), 1)+1]';
    normalized_x2 = T2 * [x2, zeros(length(x2), 1)+1]';
    H = dlt(normalized_x1', normalized_x2');
    H = inv(T2) * H * T1;
end