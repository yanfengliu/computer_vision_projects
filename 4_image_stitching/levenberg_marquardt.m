function H = levenberg_marquardt(n_x1, n_x2, lambda)
    % format is [x, y]
    H = eye(3);
    figure; hold on;
    for j = 1:10
        A = 0;
        b = 0;
        n_x2_ = zeros(4, 2);
        for i = 1:4
            h_x2_ = H * [n_x1(i, :), 1]';
            n_x2_(i, :) = h_x2_(1:2)/h_x2_(3);
            J = Jacobian(n_x1(i, :), n_x2_(i, :), H);
            A = A + J' * J;
            r = n_x2(i, :) - n_x2_(i, :)';
            b = b + J' * r';
        end
        scatter(n_x2(:, 1), n_x2(:, 2), 10, 'b', 'filled');
        scatter(n_x2_(:, 1), n_x2_(:, 2), 10, 'r', 'filled');
        xlim([-200, 1500]); ylim([-200, 1500]);
        p = H_to_p(H);
        delta_p = (A + lambda * diag(diag(A))) \ b;
        p = p + delta_p;
        H = p_to_H(p);
    end
end

function J = Jacobian(pt, new_pt, H)
    x = pt(2);
    y = pt(1);
    x_ = new_pt(2);
    y_ = new_pt(1);
    J = [x, y, 1, 0, 0, 0, -x_ * x, -x_ * y; 
         0, 0, 0, x, y, 1, -y_ * x, -y_ * y];
    h_20 = H(3, 1);
    h_21 = H(3, 2);
    J = J/(h_20 * x + h_21 * y + 1);
end

function p = H_to_p(H)
    p = [H(1, 1)-1, H(1, 2), H(1, 3), H(2, 1), H(2, 2)-1, H(2, 3), H(3, 1), H(3, 2)]';
end

function H = p_to_H(p)
    H = [1 + p(1), p(2),     p(3); 
         p(4),     1 + p(5), p(6);
         p(7),     p(8),     1    ];
end