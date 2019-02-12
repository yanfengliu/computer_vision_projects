function idxPairs = featureMatch(fA, fB, option)
    idxPairs = zeros(1, size(fA, 1));
    if option == 1 % option 1 Nearest Neighbor
        for i = 1:size(fA, 1)
            dist = sqrt(sum((fA(i, :) - fB).^2, 2));
            [~, argmax] = max(dist);
            idxPairs(i) = argmax;
        end
    elseif option == 2 % option 2 Nearest Neighbor Distance Ratio
        for i = 1:size(fA, 1)
            dist = sqrt(sum((fA(i, :) - fB).^2, 2));
            [dist, idx] = sort(dist);
            dist_1 = dist(1);
            dist_2 = dist(2);
            if (dist_1/dist_2 < 0.7)
                idxPairs(i) = idx(end);
            end
        end
        idxPairs = idxPairs(idxPairs ~= 0);
    elseif option == 3 % option 3 Consistent Nearest Neighbor Distance Ratio
        for i = 1:size(fA, 1)
            dist = sqrt(sum((fA(i, :) - fB).^2, 2));
            [dist, idx] = sort(dist);
            dist_1 = dist(1);
            dist_2 = dist(2);
            if (dist_1/dist_2 < 0.7)
                idxPairs(i) = idx(end);
            end
        end
        idxPairs = idxPairs(idxPairs ~= 0);
    end
end