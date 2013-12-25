classdef Expr < handle
    properties
        quant
        expr
        hashes
    end
    
    methods
        function A = Expr(quant, expr, hashes)
            global cache
            if (~exist('quant', 'var'))
                return;
            end
            A.quant = quant;
            A.expr = expr;            
            if (exist('hashes', 'var'))
                A.hashes = hashes;
                return;
            end
            
            A.hashes = zeros(sum(quant ~= 0), 1);
            nonzero = zeros(sum(quant ~= 0), 1);
            tmp = 1;
            for i = 1:size(expr, 2)
                if (quant(i) ~= 0)
                    A.hashes(tmp) = cache.hash(expr(:, i));
                    nonzero(tmp) = i;
                    tmp = tmp + 1;
                end
            end    
            if (length(unique(A.hashes)) ~= length(A.hashes))
              assert(0);
            end
            A.expr = A.expr(:, nonzero);
            A.quant = A.quant(:, nonzero);
            [A.hashes, idx] = sort(A.hashes);
            A.expr = A.expr(:, idx);
            A.quant = A.quant(:, idx);
        end
    
        function str = toString(A)
            str = '';
            for i = 1 : length(A.quant)
                if (i > 1)
                    str = sprintf('%s + ', str);
                end                
                str = sprintf('%s %d', str, A.quant(i));
                for j = 1 : size(A.expr, 1)
                    if (A.expr(j, i) > 0)
                        str = sprintf('%s%s', str, char('a') - 1 + j);
                        if (A.expr(j, i) > 1)
                            str = sprintf('%s^%d', str, A.expr(j, i));
                        end
                    end
                end
            end
        end
        
        function [ C ] = add_expr( A, B )
            if ((isempty(A)) || (isempty(A.quant)))
                C = B;
                return;
            elseif ((isempty(B)) || (isempty(B.quant)))
                C = A;
                return;
            end        
            hashes = [A.hashes; B.hashes];
            if (length(hashes) == length(unique(hashes)))
                [hashes, idx] = sort(hashes);
                quants = [A.quant, B.quant];
                expr = [A.expr, B.expr];
                expr = expr(:, idx);
                C = Expr(quants(idx), expr, hashes);        
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
            C = Expr(zeros(1, len), zeros(size(A.expr, 1), len), zeros(len, 1));    
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

        function [ res ] = power_expr( W, p )
            global cache
            maxK = cache.maxK;
            if ((isempty(W)) || (isempty(W.expr)) || (min(sum(W.expr, 1)) * p > maxK))
                res = Expr();
                return;
            end
            res = cell(size(W.expr, 2)^p, 1);
            for i = 1:(size(W.expr, 2)^p)
                res{i} = Expr();
                idx = zeros(p, 1);
                copyi = i - 1;
                for divs = 1:p
                    idx(divs) = mod(copyi, size(W.expr, 2));
                    copyi = floor(copyi / size(W.expr, 2));
                end
                idx = idx + 1;
                term = zeros(size(W.expr, 1), 1);
                quant = 1;
                for a = 1:length(idx)
                    term = term + W.expr(:, idx(a));
                    quant = quant * W.quant(idx(a));
                end
                if (quant ~= 0) && (sum(term) <= maxK)
                    res{i} = Expr(quant, term);
                end
                if (sum(term) > maxK)
                    warning('powers over maxK\n');
                end
            end
            res = Expr().add_many_expr(res);
        end
                  
        function ret = add_many_expr(ret, exprs)
            exprs = exprs(:);
            while(length(exprs(:)) > 1) 
              exprs_copy = {};
              for i = 1:ceil(length(exprs(:)) / 2)
                if (i + ceil(length(exprs(:)) / 2) <= length(exprs(:)))
                  exprs_copy{i} = exprs{i}.add_expr(exprs{i + ceil(length(exprs(:)) / 2)});
                else
                  exprs_copy{i} = exprs{i};
                end
              end
              exprs = exprs_copy;
            end
            if (~isempty(exprs(:)))
              ret = exprs{1};
            else 
              ret = Expr();
            end
        end        
        
        
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
                    val{a, b} = Expr(quant, expr);
                end
            end
            val = Expr().add_many_expr(val);
        end

        
        
    end
       
    
end