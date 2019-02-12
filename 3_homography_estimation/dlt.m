function H = dlt(x1, x2)
    A = zeros(8, 9);
    for i = 1:4
        A(2*(i-1)+1, :) = [0, 0, 0, -x2(i, 3) * x1(i, :), x2(i, 2) * x1(i, :)];
        A(2*i, :) = [x2(i, 3) * x1(i, :), 0, 0, 0, -x2(i, 1) * x1(i, :)];
    end

    % solve for H
    [U, D, V] = svd(A);
    h = V(:, end);
    H = reshape(h, [3, 3])';
end