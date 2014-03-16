classdef Cache < handle
    
    properties(Constant)
        prime = int64(1299827);
        field_inv = Inverse(Cache.prime);        
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
            ret = mod(dot(Cache.dot_mult(1:length(expr(:))), double(expr(:))), Cache.prime);
            assert(~isnan(ret) && (ret ~= Inf));
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
        end
        
        function Reset(obj)
            obj.all_bulk_hashes = containers.Map('KeyType', 'double', 'ValueType', 'any');
        end        
    end    
end

% Linear time algorithm to invert numbers modulo p. It searches for
% generator (there are phi(p - 1) of them, so it gets it fast).
function ret = Inverse(p)
    try
        load(sprintf('field_inverse_%d', p), 'ret');
        return;
    catch
    end
    ret = zeros(p - 1, 1); 
    for i = 2 : (p - 1)
        for invi = 1 : (p - 1)
            if (mod(i * invi, p) == 1)
                break;                
            end
        end
        ret(:) = 0;
        a = 1;   
        b = 1;  
        fail = false;
        for k = 1 : (p - 1)
            if (ret(a) ~= 0)
                fail = true;
                break;
            end
            ret(a) = b;
            a = mod(a * i, p);
            b = mod(b * invi, p);
        end
        if (~fail)
            save(sprintf('field_inverse_%d', p), 'ret');
            return;
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