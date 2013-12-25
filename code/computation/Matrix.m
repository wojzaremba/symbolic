classdef Matrix < Computation
    properties
        val
    end
    
    methods
        function obj = Matrix(val, dim1, dim2)
          obj@Computation();
          obj.name = 'Matrix';
          obj.val = val;
          obj.dim1 = dim1;
          obj.dim2 = dim2;            
          obj.complexity = obj.dim1 * obj.dim2;
        end
        
        function str = matlab_toString(obj)
          str = obj.val;
        end
       
        function str = latex_toString(obj)
          str = 'W_{i, j}';
        end  
    end
end