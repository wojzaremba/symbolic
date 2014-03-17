classdef Cache < handle
    
    properties(Constant)
        prime = int64(2^31 - 1);
        dot_mult = InitDotMult();        
    end
    
    properties        
        all_bulk_hashes
        n % number of rows.
        m % number of columns.
        maxK % max power.
        vars % Number of initial vars.
    end
    
    methods(Static)
        function [ ret ] = hash_expr(expr)
            assert(size(expr, 2) == 1);
            ret = 0;
            for i = 1 : length(expr(:))
                ret = ret + mod(Cache.dot_mult(i) * double(expr(i)), Cache.prime);
                ret = mod(ret, Cache.prime);
            end            
            assert(~isnan(ret) && (ret ~= Inf));
        end      
        
        function y = field_inv(x)
%           k * p + y * x = 1
            global field_inv_cache
            if (field_inv_cache.isKey(x))
                y = field_inv_cache(x);
                return;
            end       
            p = int64(Cache.prime);
            y = extended_euclid(int64(x), p);
            assert(mod(x * y, p) == 1);                
            field_inv_cache(x) = y;
        end
    end    
        
    methods
        function obj = Cache(maxK, vars)
            fprintf('Setting maximum power to %d\n', maxK);
            obj.maxK = maxK;           
            obj.vars = vars;
            obj.n = max(maxK, 2);
            obj.m = obj.n + 1;
            global c grammars
            c = obj;         
            grammars = [Grammar()];
            obj.Reset();     
            global field_inv_cache
            field_inv_cache = containers.Map('KeyType', 'int64', 'ValueType', 'any');                    
        end
        
        function Reset(obj)
            obj.all_bulk_hashes = containers.Map('KeyType', 'double', 'ValueType', 'any');
        end        
    end    
end

function dot_mult = InitDotMult()
    global c
    val = 1;
    dot_mult = zeros(100000, 1);
    for i = 1 : size(dot_mult, 1)
      val = mod(val * 10001, Cache.prime);
      dot_mult(i) = val;
    end      
end

function [x, y] = extended_euclid(a, b)
% /calculates a * x + b * y = 1 */
    if (b == 0)
        x = 1;
        y = 0;
        return;
    end
    x2 = int64(1);
    x1 = int64(0);
    y2 = int64(0);
    y1 = int64(1);
    while (b > 0)
        q = idivide(a, b, 'floor');%int64(floor(double(a) / double(b)));
        r = a - q * b;
        x = x2 - q * x1;
        y = y2 - q * y1;
        a = b;
        b = r;
        x2 = x1;
        x1 = x; 
        y2 = y1;
        y1 = y;
    end
    x = x2;
    y = y2;
end
