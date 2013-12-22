function [ W ] = sum_expr( A, dim )
    W = emptyW();
    if (dim == 1)
        for j = 1:size(A, 2)
            for i = 1:size(A, 1)
                if (i == 1)
                    W(1, j) = A(i, j);
                else
                    W(1, j) = add_expr(W(1, j), A(i, j));
                end
            end
        end
    elseif (dim == 2)
        for i = 1:size(A, 1)        
            for j = 1:size(A, 2)
                if (j == 1)
                    W(i, 1) = A(i, j);
                else
                    W(i, 1) = add_expr(W(i, 1), A(i, j));
                end
            end
        end        
    else
        assert(0);
    end
end

