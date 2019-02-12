function H = levenberg_marquardt(x1, x2, lambda)
    % non-homogeneous version of coordinates
    nh_x1 = x1(:, 1:2)./x1(:, 3);
    nh_x2 = x2(:, 1:2)./x2(:, 3);
    
    % randomly initialize H
    H = rand(3, 3); H(3, 3) = 1;
    A = 0;
    for i = 1:size(x1, 1)
        J = Jacobian(x1(i, :), H);
        A = A + J' * J;
    end
    b = 0;
    for i = 1:size(x1, 1)
        J = Jacobian(x1(i, :), H);
        r = nh_x2(i, :) - nh_x1(i, :);
        b = b + J' * r;
    end
    p = H_to_p(H);
    delta_p = linsolve((A + lambda * diag(diag(A))), b);
    p = p + delta_p;
    H = p_to_H(p);
end

function J = Jacobian(pt, H)
    x = pt(1);
    y = pt(2);
    new_pt = H * pt';
    new_pt = new_pt(1:2)/new_pt(3);
    x_ = new_pt(1);
    y_ = new_pt(2);
    J = [x, y, 1, 0, 0, 0, -x_ * x, -x_ * y; 
         0, 0, 0, x, y, 1, -y_ * x, -y_ * y];
    J = J/(h_20 * x + h_21 * y + 1);
end

function p = H_to_p(H)
    p = [H(1, 1)-1, H(1, 2), H(1, 3), H(2, 1), H(2, 2)-1, H(2, 3), H(3, 1), H(3, 2)];
end

function H = p_to_H(p)
    H = [1 + p(1), p(2),     p(3); 
         p(4),     1 + p(5), p(6);
         p(7),     p(8),     1    ];
end