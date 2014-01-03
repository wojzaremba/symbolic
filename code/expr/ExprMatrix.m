classdef ExprMatrix < handle
    properties
        exprs
        power
        computation
        hash
    end
    
    methods 
        function obj = ExprMatrix(exprs, computation)          
            if (exist('exprs', 'var')) && (~isempty(exprs(:))) && (~is_empty(exprs(1)))
                obj.power = sum(exprs(1).power());
                obj.exprs = exprs;
                obj.computation = computation;
            else
                obj.power = 0;
                obj.exprs = Expr_();
            end
            e = Expr_();            
            obj.hash = e.CombineHash(obj.exprs());            
        end       
        
        function str = toString(obj)
            str = obj.computation.matlab_toString();
        end

        function [ W ] = marginalize( A, dim )   
            exprs = Expr_();
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
            exprs(size(A.exprs, 1), size(A.exprs, 2)) = Expr_();
            for a = 1:size(A.exprs, 1)
              for b = 1:size(A.exprs, 2)              
                exprs(a, b) = A.exprs(a, b).multiply_expressions(B.exprs(min(a, size(B.exprs, 1)), min(b, size(B.exprs, 2))));
              end
            end
            ret = ExprMatrix(exprs, computation);
            cache.add_desc(computation.toString());            
        end        
        
    end
end