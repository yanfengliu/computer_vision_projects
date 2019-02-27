close all; clc; clear; 
% format is [x, y]
n_x1 = [2, 1; 3, 2];
n_x2 = [2, 2; 1, 3];
lambda = 0;

H = eye(3);
figure; hold on;
for j = 1:10
    A = 0;
    b = 0;
    n_x2_ = zeros(2, 2);
    for i = 1:2
        h_x2_ = H * [n_x1(i, :), 1]';
        n_x2_(i, :) = h_x2_(1:2)/h_x2_(3);
        theta = acos(H(1, 1));
        J = testJ(n_x1(i, :), theta);
        A = A + J' * J;
        r = n_x2(i, :) - n_x2_(i, :);
        b = b + J' * r';
    end
    scatter(n_x2(:, 2), n_x2(:, 1), 10, 'b', 'filled');
    scatter(n_x2_(:, 2), n_x2_(:, 1), 10, 'r', 'filled');
    xlim([-5, 5]); ylim([-5, 5]);
    p = H_to_p(H);
    delta_p = (A + lambda * diag(diag(A))) \ b;
    p = p + delta_p;
    H = p_to_H(p);
end

function J = testJ(pt, theta)
    x = pt(2);
    y = pt(1);
    J = [1, 0, - sin(theta) * x - cos(theta) * y;
         0, 1, cos(theta) * x - sin(theta) * y];
end

function p = H_to_p(H)
    tx = H(1, 3);
    ty = H(2, 3);
    theta = acos(H(1, 1));
    p = [tx, ty, theta]';
end

function H = p_to_H(p)
    tx = p(1);
    ty = p(2);
    theta = p(3);
    
    H = [cos(theta), -sin(theta), tx;
         sin(theta), cos(theta) , ty;
         0         , 0          , 1];
end