classdef Cache < handle
    properties
        prime
        dot_mult
        all_desc
        all_bulk_hashes
        n % number of rows.
        m % number of columns.
        maxK % max power.
    end
    
    methods
        function obj = Cache(maxK)
            if (~exist('maxK', 'var'))
                maxK = Inf;
            end
            fprintf('Setting maximum power to %d\n', maxK);
            obj.maxK = maxK;                        
            obj.n = 99;
            obj.m = 100;   
            obj.prime = 100000000000000001;
            val = 1;
            obj.dot_mult = zeros(100000, 1);
            for i = 1:100000
              val = mod(val * 10000000001, obj.prime);
              obj.dot_mult(i) = val;
            end            
            global cache grammars
            cache = obj;         
            grammars = [Grammar()];
            obj.Reset();            
        end
        
        function Reset(obj)
            obj.all_desc = containers.Map;
            obj.all_bulk_hashes = containers.Map('KeyType', 'double', 'ValueType', 'any');
        end
        
        function [ ret ] = hash(obj, X)
            assert(size(X, 2) == 1);
            ret = mod(dot(obj.dot_mult(1:length(X(:))), double(X(:))), obj.prime);
            assert(~isnan(ret) && (ret ~= Inf));
        end        

        function ret = find_desc(obj, desc)
            if (isKey(obj.all_desc, desc))
                ret = true;
                return;
            else 
                ret = false; 
            end
        end        

        function add_desc(obj, desc)
            obj.all_desc(desc) = 1;
        end       
    end
    
end