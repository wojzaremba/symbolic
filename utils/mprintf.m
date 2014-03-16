function mprintf(name, matrix)
    global debug;
    if (debug >= 1)
        fprintf('%s\n', name);
        for i = 1 : size(matrix, 1)
            for j = 1 : size(matrix, 2)
                fprintf('%d ', matrix(i, j));
            end
            fprintf('\n');
        end
        fprintf('\n');
    end
end
