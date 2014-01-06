function remove_border(path)
    A = imread(path);
    for x1 = 1 : size(A, 1)
        if (sum(A(x1, :, :) ~= 255) ~= 0)
            break;
        end
    end

    for x2 = size(A, 1) : -1 : 1
        if (sum(A(x2, :, :) ~= 255) ~= 0)
            break;
        end
    end

    for y1 = 1 : size(A, 2)
        if (sum(A(:, y1, :) ~= 255) ~= 0)
            break;
        end
    end

    for y2 = size(A, 2) : -1 : 1
        if (sum(A(:, y2, :) ~= 255) ~= 0)
            break;
        end
    end
    A = A((x1 - 1) : (x2 + 1), (y1 - 1) : (y2 + 1), :);
    imwrite(A, path);
end