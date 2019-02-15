function [H, fit, its, xy1, xy2] = ransac(xyA, xyB, distThresh, agreeThresh, maxIterations)
    its = 0;
    h_xyA = [xyA, zeros(length(xyA), 1)+1];
    h_xyB = [xyB, zeros(length(xyB), 1)+1];
    while(its < maxIterations)
        its = its + 1;
        idx = randi([1, size(xyA, 1)], 1, 4);
        
%         xy1 = xyA(idx, :);
%         xy2 = xyB(idx, :);
%         H = levenberg_marquardt(xy1, xy2, 0.8);
        
        xy1 = h_xyA(idx, :);
        xy2 = h_xyB(idx, :);
        H = normalized_dlt(xy1, xy2);

        xyB_ = H * h_xyA';
        nh_xyB_ = xyB_(1:2, :)./xyB_(3, :);
        nh_xyB = xyB';
        dist = sqrt(sum((nh_xyB - nh_xyB_).^2, 1));
        fit = sum(dist < distThresh)/length(dist);
        if (fit > agreeThresh)
            break;
        end
    end
    if fit < agreeThresh
        error("Couldn't find a good H");
    end
end