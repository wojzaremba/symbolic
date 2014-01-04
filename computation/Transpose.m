classdef Transpose < Computation
    properties
        ones_params
        rest_params
    end
    
    methods
        function obj = Transpose(a)
          obj.name = 'Transpose';
          obj.params = {a};
          obj.dim1 = a.dim2;
          obj.dim2 = a.dim1;
          obj.complexity = a.complexity + a.dim1 * a.dim2;
        end
  
        function str = matlab_toString(obj)   
            p = obj.params{1};
            str = sprintf('(%s'')', toString(p));
        end          
    end
end