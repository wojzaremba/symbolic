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
        
        function [ W ] = repmat_expr( A, dim )   
            global c
            exprs = Expr_();
            d1 = size(A.exprs, 1);                
            d2 = size(A.exprs, 2);
            if (dim == 1)
                d1 = c.n;
            else
                d2 = c.m;
            end
            for j = 1 : d2
                for i = 1 : d1
                    if (dim == 1)
                        exprs(i, j) = A.exprs(1, j);
                    else
                        exprs(i, j) = A.exprs(i, 1);
                    end
                end
            end
            W = ExprMatrix(exprs, Repmat(A.computation, dim));                           
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
            global c
            ret = ExprMatrix();
            power = A.power + B.power;
            if (power > c.maxK) || (isempty(A.computation) || isempty(B.computation))
                return;
            end
            computation = MultElemwise({A.computation, B.computation});                
            if (c.find_desc(computation.toString()))
                return;
            end
            exprs(size(A.exprs, 1), size(A.exprs, 2)) = Expr_();
            for a = 1:size(A.exprs, 1)
                for b = 1:size(A.exprs, 2)              
                    exprs(a, b) = A.exprs(a, b).multiply_expressions(B.exprs(a, b));
                end
            end
            ret = ExprMatrix(exprs, computation);
            c.add_desc(computation.toString());
            % Elementwise multiplication is symmetric. 
            computation = MultElemwise({B.computation, A.computation});
            c.add_desc(computation.toString());
        end        
        
    end
end