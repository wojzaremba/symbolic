classdef Transpose < Computation
    properties
        item
    end
    
    methods
        function obj = Transpose(item)
          obj.name = 'Transpose';
          obj.item = item;
          obj.dim1 = item.dim2;
          obj.dim2 = item.dim1;
          obj.domain = item.domain;
        end
  
        function ret = O_complexity(obj)
            ret = max(obj.item.complexity, 2);
        end
        
        function ret = NrOper_complexity(obj)
            ret = obj.item.complexity + obj.dim1 * obj.dim2;
        end           
        
        function str = matlab_toString(obj)   
            p = obj.item;
            str = sprintf('(%s'')', toString(p));
        end          
    end
end