classdef Marginalize < Computation
    properties
        sumdim
        item
    end
    
    methods
        function obj = Marginalize(item, sumdim)
            obj@Computation();
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
            obj.complexity = item.complexity + item.dim1 * item.dim2;            
        end
        
        function str = matlab_toString(obj)            
            if ((obj.sumdim == 1) || (obj.sumdim == 2))
              str = sprintf('sum(%s, %d)', toString(obj.item), obj.sumdim);
            else
              str = sprintf('sum(sum(%s))', toString(obj.item));
            end
        end    
                
        function str = latex_toString(obj)
	    assert(0);
            if (obj.sumdim == 1)
                str = sprintf('\\sum_{i = 1, \\dots, m} %s', toString(obj.item));
            elseif (obj.sumdim == 2)
                str = sprintf('\\sum_{j = 1, \\dots, m} %s', toString(obj.item));
            else
                str = sprintf('qqq(%s)', toString(obj.item));
            end        
        end  
        
    end
end
