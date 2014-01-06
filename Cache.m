classdef Cache < handle
    
    properties(Constant)
        prime = int64(100069);
    end
    
    properties        
        all_bulk_hashes
        n % number of rows.
        m % number of columns.
        maxK % max power.
    end
    
    methods
        function obj = Cache(maxK)
            fprintf('Setting maximum power to %d\n', maxK);
            obj.maxK = maxK;                        
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