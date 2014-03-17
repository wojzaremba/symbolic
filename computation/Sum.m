classdef Sum < Computation
    properties
        ones_params
        rest_params
        params
    end
    
    methods
        
        function obj = Sum(params)  
          obj.name = 'Sum';
          assert(length(params) >= 1);  
          obj.params = params;
          obj.ones_params = {};
          obj.rest_params = {};  
          for i = 1:length(params)
            if ((params{i}.dim1 == 1) && (params{i}.dim2 == 1))
              obj.ones_params{end + 1} = params{i};
            else
              obj.rest_params{end + 1} = params{i};
            end
          end    
          for i = 2:length(obj.rest_params)   
              assert(obj.rest_params{i}.dim1 == obj.rest_params{1}.dim1);
              assert(obj.rest_params{i}.dim2 == obj.rest_params{1}.dim2);
              assert(obj.rest_params{i}.domain == obj.rest_params{1}.domain);
          end
          if (length(obj.rest_params) > 1)
              obj.dim1 = obj.rest_params{1}.dim1;
              obj.dim2 = obj.rest_params{1}.dim2;
              obj.domain = obj.rest_params{1}.domain;
          else
              obj.dim1 = 1;
              obj.dim2 = 1;
              obj.domain = 0;
          end
          obj.params = [obj.ones_params(:); obj.rest_params(:)];    
        end
        
        function ret = O_complexity(obj)
            ret = 2;
            for i = 1 : length(obj.params)
                ret = max(ret, obj.params{i}.complexity);
            end
        end
        
        function ret = NrOper_complexity(obj)
            ret = obj.item.complexity;
            for i = 1 : length(obj.rest_params)
                ret = ret + ...
                    obj.rest_params{i}.dim1 * ...
                    obj.rest_params{i}.dim2;
            end
        end            
        
        function str = matlab_toString(obj)
            str = printf_list(obj.params, '+');
        end        
    end
end


