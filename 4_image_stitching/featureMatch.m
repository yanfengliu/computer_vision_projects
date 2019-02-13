function idxPairs = featureMatch(fA, fB, option)
    idxPairs = zeros(size(fA, 1), 2);
    idxPairs(:, 1) = 1:size(fA, 1);
    if option == 1 % Nearest Neighbor
        for i = 1:size(fA, 1)
            dist = sqrt(sum((fA(i, :) - fB).^2, 2));
            [~, argmin] = min(dist);
            idxPairs(i, 2) = argmin;
        end
    elseif option == 2 % Nearest Neighbor Distance Ratio
        for i = 1:size(fA, 1)
            dist = sqrt(sum((fA(i, :) - fB).^2, 2));
            [dist, idx] = sort(dist);
            dist_1 = dist(1);
            dist_2 = dist(2);
            if (dist_1/dist_2 < 0.7)
                idxPairs(i, 2) = idx(1);
            end
        end
        idxPairs = idxPairs(idxPairs(:, 2) ~= 0, :);
    elseif option == 3 % Consistent Nearest Neighbor Distance Ratio
        for i = 1:size(fA, 1)
            dist = sqrt(sum((fA(i, :) - fB).^2, 2));
            [dist, idx] = sort(dist);
            dist_1 = dist(1);
            dist_2 = dist(2);
            if (dist_1/dist_2 < 0.7)
                idxPairs(i, 2) = idx(1);
            end
        end
        idxPairs = idxPairs(idxPairs(:, 2) ~= 0, :);
        
        idxPairsB = zeros(length(fB), 2);
        idxPairsB(:, 1) = 1:length(fB);
        for i = 1:size(fB, 1)
            dist = sqrt(sum((fB(i, :) - fA).^2, 2));
            [dist, idx] = sort(dist);
            dist_1 = dist(1);
            dist_2 = dist(2);
            if (dist_1/dist_2 < 0.7)
                idxPairsB(i, 2) = idx(1);
            end
        end
        idxPairs_temp = [];
        for i = 1:length(idxPairs)
            if (idxPairsB(idxPairs(i, 2), 2) == idxPairs(i, 1))
                idxPairs_temp = [idxPairs_temp; idxPairs(i, :)];
            end
        end
        idxPairs = idxPairs_temp;
    end
end