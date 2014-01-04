classdef Mult < Computation
    properties
        ones_params
        rest_params
    end
    
    methods
        function obj = Mult(params)
          obj.name = 'Mult';
          assert(length(params) > 1);  
          obj.ones_params = {};
          obj.rest_params = {};  
          obj.complexity = 0;
          for i = 1:length(params)
            if ((params{i}.dim1 == 1) && (params{i}.dim2 == 1))
              obj.ones_params{end + 1} = params{i};
            else
              obj.rest_params{end + 1} = params{i};
            end
            obj.complexity = obj.complexity + params{i}.complexity;
            if (i > 1)
                obj.complexity = obj.complexity + params{i - 1}.dim1 * params{i - 1}.dim2 * params{i}.dim2;
            end
          end
          for i = 1:(length(obj.rest_params) - 1)
            assert(obj.rest_params{i}.dim2 == obj.rest_params{i + 1}.dim1);
          end
          if (~isempty(obj.rest_params))
            obj.dim1 = obj.rest_params{1}.dim1;
            obj.dim2 = obj.rest_params{end}.dim2;
          else
            obj.dim1 = 1;
            obj.dim2 = 1;
          end  
          obj.params = [obj.ones_params(:); obj.rest_params(:)];
        end
  
        function str = matlab_toString(obj)   
            str = printf_list(obj.params, '*');
        end          
    end
end