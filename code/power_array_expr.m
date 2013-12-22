function [ B, empty ] = power_array_expr( A, p, maxk, maxk2 )
    savecell = false;
    if (iscell(A))
      savecell = true;
      assert(length(A) == 1);
      A = A{1};
    end
    empty = true;
    W = [struct('quant', [], 'expr', [], 'hashes', [])];
    if ((A.power(1) * p > maxk) || (A.power(2) * p > maxk2))
        return;
    end    
    for i = 1:size(A.val, 1)
        for j = 1:size(A.val, 2)            
            W(i, j) = power_expr(A.val(i, j), p, maxk);                        
        end
    end
    B = struct('val', W, 'power', A.power * p, ...
               'desc', [A.desc, '.^', num2str(p)], ...
               'desc_grammar', sprintf('power_array_expr(%s, %d, %d, %d)', A.desc_grammar, p, maxk, maxk2));
    if (savecell)
        B = {B};
    end
end

