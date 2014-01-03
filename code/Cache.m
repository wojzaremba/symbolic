classdef Cache < handle
    properties
        prime
        all_desc
        all_bulk_hashes
        n % number of rows.
        m % number of columns.
        maxK % max power.
    end
    
    methods
        function obj = Cache(maxK)
            fprintf('Setting maximum power to %d\n', maxK);
            obj.maxK = maxK;                        
            obj.n = maxK;
            obj.m = maxK + 1;   
            obj.prime = 688846502588399;      
            global c grammars
            c = obj;         
            grammars = [Grammar()];
            obj.Reset();            
        end
        
        function Reset(obj)
            obj.all_desc = containers.Map;
            obj.all_bulk_hashes = containers.Map('KeyType', 'double', 'ValueType', 'any');
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