classdef Repmat < Computation
    properties
        item
        repdim
    end
    
    methods
        function obj = Repmat(item, repdim)
            global cache           
            obj.name = 'Repmat';
            obj.item = item;
            obj.dim1 = item.dim1;
            obj.dim2 = item.dim2;
            obj.repdim = repdim;
            if (obj.repdim == 1)
                assert(obj.dim1 == 1);
                obj.dim1 = cache.n;
            end
            if (obj.repdim == 2)
                assert(obj.dim2 == 1);
                obj.dim2 = cache.m;
            end  
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

