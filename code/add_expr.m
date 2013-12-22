function [ C ] = add_expr( A, B )
    if ((length(A) == 0) || (length(A.quant) == 0))
        C = B;
        return;
    elseif ((length(B) == 0) || (length(B.quant) == 0))
        C = A;
        return;
    end        
    hashes = [A.hashes; B.hashes];
    if (length(hashes) == length(unique(hashes)))
        [hashes, idx] = sort(hashes);
        quants = [A.quant, B.quant];
        expr = [A.expr, B.expr];
        expr = expr(:, idx);
        C = struct('quant', quants(idx), 'expr', expr, 'hashes', hashes);        
        return;
    end
    if (length(unique(hashes)) == length(A.hashes)) || (length(unique(hashes)) == length(B.hashes))
      if (length(unique(hashes)) == length(A.hashes))
        C = A;
        S = B;
      else
        C = B;
        S = A;
      end
      j = 1;
      for i = 1:size(C.expr, 2)
        if (compare_expr(C, i, S, j) == 0)
          C.quant(i) = C.quant(i) + S.quant(j);
          j = j + 1;
          if (j > length(S.quant))
            return;
          end
        end
      end
    end
    a = 1;
    b = 1;
    len = length(A) + length(B);
    C = struct('quant', zeros(1, len), 'expr', zeros(size(A.expr, 1), len), 'hashes', zeros(len, 1));    
    A.hashes = [A.hashes; Inf];
    B.hashes = [B.hashes; Inf];
    counter = 1;
    while ((a <= size(A.expr, 2)) || (b <= size(B.expr, 2)))
        if (compare_expr(A, a, B, b) > 0)
            C.quant(counter) = B.quant(b);
            C.expr(:, counter) = B.expr(:, b);
            C.hashes(counter) = B.hashes(b);
            counter = counter + 1;
            b = b + 1;
        elseif (compare_expr(A, a, B, b) < 0)
            C.quant(counter) = A.quant(a);
            C.expr(:, counter) = A.expr(:, a);
            C.hashes(counter) = A.hashes(a);
            counter = counter + 1;
            a = a + 1;
        elseif (compare_expr(A, a, B, b) == 0)
            C.quant(counter) = A.quant(a) + B.quant(b);
            C.expr(:, counter) = A.expr(:, a);
            C.hashes(counter) = A.hashes(a);
            counter = counter + 1;
            a = a + 1;
            b = b + 1;
        end
    end
    counter = counter - 1;
    C.quant = C.quant(1:counter); 
    C.expr = C.expr(:, 1:counter);     
    C.hashes = C.hashes(1:counter);     
end

