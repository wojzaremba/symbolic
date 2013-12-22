function [ C ] = add_array_expr( A, B )
    C = [struct()];
    assert(size(A, 1) == size(B, 1));
    assert(size(A, 2) == size(B, 2));
    for i = 1:size(A, 1)
        for j = 1:size(A, 2)
            C(i, j) = add_expr(A(i, j), B(i, j));
        end
    end
end

