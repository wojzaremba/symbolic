function [ val ] = multiply_expressions( A, B )
    val = cell(size(A.expr, 2), size(B.expr, 2));
    for a = 1:size(A.expr, 2)
        if (A.quant(a) == 0)
          continue
        end
        for b = 1:size(B.expr, 2)
            if (B.quant(b) == 0)
              continue;
            end;
            quant = A.quant(a) * B.quant(b);
            expr = A.expr(:, a) + B.expr(:, b);
            val{a, b} = struct('quant', quant, 'expr', expr, 'hashes', hash(expr));
        end
    end
    val = add_many_expr(val);
end

