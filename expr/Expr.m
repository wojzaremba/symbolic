classdef Expr < handle
    properties
        expr
        power
        hashes        
    end
    
    methods(Static)
        function hash = CombineHash(exprs)
            global c
            hash = 0;            
            for j = 1:length(exprs(:))
                hash = mod(Cache.prime * hash + exprs(j).hash(), Cache.prime);
            end            
            assert(~isnan(sum(hash)) && (sum(hash) ~= Inf));
        end
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
        
        function [X, Y] = reexpres_data(marginal, F)
            assert(0);
        end
        
    end       
    
end