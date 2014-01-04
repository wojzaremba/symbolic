classdef Repmat < Computation
    properties
        item
        repdim
    end
    
    methods
        function obj = Repmat(item, dims)   
            obj.name = 'Repmat';
            obj.item = item;
            obj.dim1 = dims(1);
            obj.dim2 = dims(2);            
            assert((item.dim1 == 1) || (item.dim2 == 1));
            obj.complexity = item.complexity + obj.dim1 * obj.dim2;            
        end       
        
        function str = matlab_toString(obj)
            p = obj.item;
            if (obj.repdim == 1)
                str = sprintf('repmat(%s, [n, 1])', toString(p));
            else
                str = sprintf('repmat(%s, [1, m])', toString(p));
            end
        end          
    end
    
end

