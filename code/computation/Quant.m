classdef Quant < Computation
    properties
        val
    end
    
    methods
        function obj = Quant(val)
          obj@Computation();
          obj.name = 'Quant';
          obj.val = val;
          obj.dim1 = 1;
          obj.dim2 = 1;            
          obj.complexity = 1;
        end
        
        function str = matlab_toString(obj)
          str = obj.val;
        end
    end
end