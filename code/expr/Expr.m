classdef Expr < handle
    properties
        expr
    end
    
    methods
        function obj = Expr()
        end
    
        % Virtual methods.
        function Validate(A)
            assert(0);
        end
        
        function str = toString(A)
            assert(0);
        end
        
        function [ C ] = add_expr(A, B)
            assert(0);
        end
        
        function [ res ] = power_expr( W, p )
            assert(0);
        end
                  
        function ret = add_many_expr(ret, exprs)
            assert(0);
        end
                
        function [ val ] = multiply_expressions( A, B )
            assert(0);
        end
        
        function ret = is_empty(obj)
            assert(0);
        end
    end       
    
end