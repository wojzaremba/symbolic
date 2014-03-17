classdef Repmat < Computation
    properties
        item
        repdim
        dim_val
    end
    
    methods
        function obj = Repmat(item, dims)   
            obj.name = 'Repmat';
            obj.item = item;
            obj.dim1 = item.dim1 * dims(1);
            obj.dim2 = item.dim2 * dims(2);     
            if (dims(1) > 1) && (dims(2) == 1)
                obj.repdim = 1;
            elseif (dims(1) == 1) && (dims(2) > 1)
                obj.repdim = 2;
            else
                assert(0);
            end
            assert((item.dim1 == 1) || (item.dim2 == 1));
            assert((dims(1) == 1) || (dims(2) == 1));
            assert((item.dim1 ~= obj.dim1) || (item.dim2 ~= obj.dim2));
            obj.domain = item.domain;
        end       
        
        function ret = O_complexity(obj)
            ret = max(obj.item.complexity, 2);
        end
        
        function ret = NrOper_complexity(obj)
            ret = obj.item.complexity + obj.dim1 * obj.dim2;
        end
        
        function str = matlab_toString(obj)
            global c
            p = obj.item;
            if (obj.repdim == 1)        
                if (c.n == obj.dim1)
                    dim_str = '[n, 1]';
                elseif (c.m == obj.dim1)
                    dim_str = '[m, 1]';
                else       
                    assert(0);
                end
            else
                if (c.n == obj.dim2)                
                    dim_str = '[1, n]';
                elseif (c.m == obj.dim2)
                    dim_str = '[1, m]';
                else
                    assert(0);
                end                
            end
            str = sprintf('repmat(%s, %s)', toString(p), dim_str);                                
        end          
    end
    
end

