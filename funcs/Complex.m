classdef Complex < PrototypeF
    properties
        coeffs
        funs
    end

    methods    
      function obj = Complex(coeffs, funs)
          assert(length(coeffs) == length(funs));
          name = '';
          for i = 1:length(coeffs)
            if (i > 1)
              name = sprintf('%s +', name);
            end
            name = sprintf('%s %f*%s', name, coeffs{i}, funs{i}.name);
          end
          obj.name = name;
          obj.funs = funs;
          obj.coeffs = coeffs;
      end

      function P = FP_unnorm(obj, W)
          P = 0;
          for i = 1:length(obj.coeffs)
              P = P + obj.coeffs{i} * obj.funs{i}.FP_unnorm(W);
          end    
      end

      function y = f(obj, x)
          y = 0;
          for i = 1:length(obj.coeffs)
              y = y + obj.coeffs{i} * obj.funs{i}.f(x);
          end
      end
    end
end