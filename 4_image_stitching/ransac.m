function [H, fit, its] = ransac(xyA, xyB, distThresh, agreeThresh, maxIterations)
    its = 0;
    h_xyA = [xyA, zeros(length(xyA), 1)];
    while(its < maxIterations)
        its = its + 1;
        xy1 = xyA(randi([1, size(xyA, 1)], 1, 4), :);
        xy2 = xyB(randi([1, size(xyB, 1)], 1, 4), :);
        H = levenberg_marquardt(xy1, xy2, 0.1);
        xyB_ = H * h_xyA';
        nh_xyB_ = xyB_(1:2, :)./xyB_(3, :);
        nh_xyB = xyB';
        dist = sqrt(sum((nh_xyB - nh_xyB_).^2, 2));
        fit = sum(dist < distThresh)/length(dist);
        if (fit > agreeThresh)
            break;
        end
    end
end