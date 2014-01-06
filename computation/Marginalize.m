classdef Marginalize < Computation
    properties
        sumdim
        item
    end
    
    methods
        function obj = Marginalize(item, sumdim)
            obj@Computation();
            global c
            obj.name = 'Marginalize';
            obj.item = item;
            obj.dim1 = item.dim1;
            obj.dim2 = item.dim2;
            obj.sumdim = sumdim;
            if (sumdim == 1)
              obj.dim1 = 1;
            elseif (sumdim == 2)
              obj.dim2 = 1;
            elseif (sumdim == 0)
              obj.dim1 = 1;
              obj.dim2 = 1;
            end
        end
        
        function ret = O_complexity(obj)
            ret = max(obj.item.complexity, 2);
        end
        
        function ret = NrOper_complexity(obj)
            ret = obj.item.complexity + obj.dim1 * obj.dim2;
        end        
        
        function str = matlab_toString(obj)            
            if ((obj.sumdim == 1) || (obj.sumdim == 2))
              str = sprintf('sum(%s, %d)', toString(obj.item), obj.sumdim);
            else
              str = sprintf('sum(sum(%s))', toString(obj.item));
            end
        end                    
        
    end
end
