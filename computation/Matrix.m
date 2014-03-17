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
          obj.domain = 0;
        end
        
        function ret = O_complexity(obj)
            ret = 2;
        end
        
        function ret = NrOper_complexity(obj)
            ret = obj.dim1 * obj.dim2;
        end                   
        
        function str = matlab_toString(obj)
          str = obj.val;
        end       
    end
end
