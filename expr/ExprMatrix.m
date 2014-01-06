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
        
        function [ W ] = repmat_expr( A, dims )   
            exprs = Expr_();
            d1 = size(A.exprs, 1) * dims(1);
            d2 = size(A.exprs, 2) * dims(2);
            for i = 1 : d1            
                for j = 1 : d2
                    if (size(A.exprs, 1) == 1) && (dims(1) > 1)
                        exprs(i, j) = A.exprs(1, j);
                    elseif (size(A.exprs, 2) == 1) && (dims(2) > 1)
                        exprs(i, j) = A.exprs(i, 1);
                    else
                        assert(0);
                    end
                end
            end
            W = ExprMatrix(exprs, Repmat(A.computation, dims));                           
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
            exprs(size(A.exprs, 1), size(A.exprs, 2)) = Expr_();
            for a = 1 : max(size(A.exprs, 1), size(B.exprs, 1))
                for b = 1 : max(size(A.exprs, 2), size(B.exprs, 2))
                    exprs(a, b) = A.exprs(min(a, size(A.exprs, 1)), min(b, size(A.exprs, 2))).multiply_expressions(B.exprs(min(a, size(B.exprs, 1)), min(b, size(B.exprs, 2))));
                end
            end
            ret = ExprMatrix(exprs, computation);
        end        
        
        function ret = multiply(A, B)
            global c
            ret = ExprMatrix();
            power = A.power + B.power;
            if (power > c.maxK) || (isempty(A.computation) || isempty(B.computation))
                return;
            end
            computation = Mult({A.computation, B.computation});                
            assert(size(A.exprs, 2) == size(B.exprs, 1));
            exprs(size(A.exprs, 1), size(B.exprs, 2)) = Expr_();
            e = Expr_();
            for x = 1:size(A.exprs, 1)                
                for z = 1:size(B.exprs, 2)                                             
                    partial = cell(size(B.exprs, 2), 1);
                    for y = 1:size(A.exprs, 2)                               
                        partial{y} = A.exprs(x, y).multiply_expressions(B.exprs(y, z));
                    end
                    exprs(x, z) = e.add_many_expr(partial);
                end
            end
            ret = ExprMatrix(exprs, computation);
        end      
        
        function ret = transpose(A)
            ret = ExprMatrix();
            if (isempty(A.computation))
                return;
            end
            computation = Transpose(A.computation); 
            exprs(size(A.exprs, 2), size(A.exprs, 1)) = Expr_();
            for x = 1:size(A.exprs, 1)                
                for y = 1:size(A.exprs, 2)                               
                    exprs(y, x) = A.exprs(x, y);
                end                    
            end
            ret = ExprMatrix(exprs, computation);
        end            
        
    end
end