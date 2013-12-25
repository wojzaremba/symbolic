classdef ExprMatrix < handle
    properties
        exprs
        power
        computation
        hash
    end
    
    methods 
        function obj = ExprMatrix(exprs, computation)          
            if (exist('exprs', 'var')) && (~isempty(exprs(:))) && (~isempty(exprs(1).expr))
                obj.power = sum(exprs(1).expr(:, 1));
                obj.exprs = exprs;
                obj.SetHash();
                obj.computation = computation;
            else
                obj.power = 0;
                obj.hash = 0;
                obj.exprs = Expr();
            end
        end
        
        function SetHash(obj)
            global cache
            prime = cache.prime;
            dot_mult = cache.dot_mult;
            % Hash is the same up to multiplicative constant.
            normalize = 0;
            exprs = obj.exprs;
            for j = 1:length(exprs(:))
                normalize = normalize + sum(abs(exprs(j).quant));
            end
            hash = 0;
            for j = 1:length(exprs(:))
                hash = mod(10000000000001 * hash + dot(dot_mult(1:(2 * length(exprs(j).quant))), [exprs(j).quant(:) / normalize ; exprs(j).hashes(:)]), prime);
            end
            assert(~isnan(hash) && (hash ~= Inf));
            obj.hash = hash;  
        end
        
        function str = toString(obj)
            str = obj.computation.matlab_toString();
        end

        function [ W ] = marginalize( A, dim )   
            exprs = Expr();
            if (dim == 1)
                for j = 1:size(A.exprs, 2)
                    for i = 1:size(A.exprs, 1)
                        if (i == 1)
                            exprs(1, j) = A.exprs(i, j);
                        else
                            exprs(1, j) = exprs(1, j).add_expr(A.exprs(i, j));                               
                        end
                    end
                end
            elseif (dim == 2)
                for i = 1:size(A.exprs, 1)        
                    for j = 1:size(A.exprs, 2)
                        if (j == 1)
                            exprs(i, 1) = A.exprs(i, j);
                        else
                            exprs(i, 1) = exprs(i, 1).add_expr(A.exprs(i, j));
                        end                        
                    end
                end        
            else
                assert(0);
            end
            W = ExprMatrix(exprs, Marginalize(A.computation, dim));                           
        end     
        
        function Validate(obj)
            for i = 1 : length(obj.exprs(:))
                try
                    obj.exprs(i).Validate();
                catch
                    fprintf('ExprMatrix validation failed for i = %d\n', i);
                    assert(0);
                end
            end            
        end
        
        function ret = elementwise_multiply(A, B)
            global cache
            ret = ExprMatrix();
            power = A.power + B.power;
            if (power > cache.maxK) || (isempty(A.computation) || isempty(B.computation))
                return;
            end
            if (size(A.exprs, 1) == size(B.exprs, 1)) && (size(A.exprs, 2) == size(B.exprs, 2))
                computation = MultElemwise({A.computation, B.computation});
            elseif (size(A.exprs, 1) == size(B.exprs, 1)) && (size(A.exprs, 2) == 1) 
                computation = MultElemwise({Repmat(A.computation, 2), B.computation});
            elseif (size(A.exprs, 1) == size(B.exprs, 1)) && (size(B.exprs, 2) == 1)
                computation = MultElemwise({A.computation, Repmat(B.computation, 2)});
            elseif (size(A.exprs, 2) == size(B.exprs, 2)) && (size(A.exprs, 1) == 1)
                computation = MultElemwise({Repmat(A.computation, 1), B.computation});
            elseif (size(A.exprs, 2) == size(B.exprs, 2)) && (size(B.exprs, 1) == 1)
                computation = MultElemwise({A.computation, Repmat(B.computation, 1)});
            elseif (size(A.exprs, 1) == 1) && (size(A.exprs, 2) == 1)
                computation = MultElemwise({Repmat(Repmat(A.computation, 1), 2), B.computation});
            elseif (size(B.exprs, 1) == 1) && (size(B.exprs, 2) == 1)
                computation = MultElemwise({A.computation, Repmat(Repmat(B.computation, 1), 2)});                
            else
                assert(0);
            end
                
                
            if (cache.find_desc(computation.toString()))
              return;
            end
%             % If the same size then this operation is symetric.
%             if ((size(B.exprs, 1) == size(A.exprs, 1)) && (size(B.exprs, 2) == size(A.exprs, 2)))
%                 computation2 = MultElemwise({B.computation, A.computation});
%                 cache.find_desc(computation2.toString());
%             end

            exprs(size(A.exprs, 1), size(A.exprs, 2)) = Expr();
            for a = 1:size(A.exprs, 1)
              for b = 1:size(A.exprs, 2)              
                exprs(a, b) = A.exprs(a, b).multiply_expressions(B.exprs(min(a, size(B.exprs, 1)), min(b, size(B.exprs, 2))));
              end
            end
            ret = ExprMatrix(exprs, computation);
        end        
        
    end
end