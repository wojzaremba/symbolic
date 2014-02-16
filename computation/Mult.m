classdef Mult < Computation
    properties
        ones_params
        rest_params
        params
    end
    
    methods
        function obj = Mult(params)
          obj.name = 'Mult';
          obj.params = params;
          assert(length(params) > 1);  
          obj.ones_params = {};
          obj.rest_params = {};  
          for i = 1:length(params)
            if ((params{i}.dim1 == 1) && (params{i}.dim2 == 1))
              obj.ones_params{end + 1} = params{i};
            else
              obj.rest_params{end + 1} = params{i};
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
          assert(length(obj.rest_params) <= 2);
        end
  
        function ret = O_complexity(obj)
            ret = 2;
            if (length(obj.rest_params) == 2)
                if (obj.rest_params{1}.dim1 > 1) && ...
                   (obj.rest_params{1}.dim2 > 1) && ...
                   (obj.rest_params{2}.dim1 > 1) && ...
                   (obj.rest_params{2}.dim2 > 1)
                    ret = 3;
                end
            end
            for i = 1 : length(obj.params)
                ret = max(ret, obj.params{i}.complexity);
            end
        end
        
        function ret = NrOper_complexity(obj)
            ret = obj.item.complexity;
            for i = 2 : length(obj.params)
                ret = ret + ...
                    obj.params{i - 1}.dim1 * ...
                    obj.params{i - 1}.dim2 * ...
                    obj.params{i}.dim2;
            end
        end        
        
        function str = matlab_toString(obj)   
            str = printf_list(obj.params, '*');
        end          
    end
end