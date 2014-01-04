classdef Sum < Computation
    properties
        ones_params
        rest_params
    end
    
    methods
        
        function obj = Sum(params)  
          obj.name = 'Sum';
          assert(length(params) >= 1);  
          obj.params = params;
          obj.ones_params = {};
          obj.rest_params = {};  
          obj.complexity = 0;
          for i = 1:length(params)
            if ((params{i}.dim1 == 1) && (params{i}.dim2 == 1))
              obj.ones_params{end + 1} = params{i};
            else
              obj.rest_params{end + 1} = params{i};
            end
            obj.complexity = obj.complexity + params{i}.complexity + params{i}.dim1 * params{i}.dim2;
          end    
          for i = 2:length(obj.rest_params)   
            assert(obj.rest_params{i}.dim1 == obj.rest_params{1}.dim1);
            assert(obj.rest_params{i}.dim2 == obj.rest_params{1}.dim2);
          end
          if (length(obj.rest_params) > 1)
            obj.dim1 = obj.rest_params{1}.dim1;
            obj.dim2 = obj.rest_params{1}.dim2;
          else
            obj.dim1 = 1;
            obj.dim2 = 1;
          end
          obj.params = [obj.ones_params(:); obj.rest_params(:)];    
        end
        
        function str = matlab_toString(obj)
            str = printf_list(obj.params, '+');
        end        
    end
end


