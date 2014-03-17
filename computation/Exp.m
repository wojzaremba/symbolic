classdef Exp < Computation
    properties
        item
    end
    
    methods
        function obj = Exp(item)
          obj.name = 'Exp';
          obj.item = item;
          obj.dim1 = item.dim1;
          obj.dim2 = item.dim2;
          assert(item.domain == 0);
          obj.domain = 1;
        end
  
        function ret = O_complexity(obj)
            ret = max(obj.item.complexity, 2);
        end
        
        function str = matlab_toString(obj)   
            str = sprintf('exp(%s)', toString(obj.item));
        end          
    end
end