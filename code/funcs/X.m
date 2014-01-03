classdef X < PrototypeF
    properties
    end

    methods    
      function obj = X()
          obj.name = 'X';
      end

      function P = FP_unnorm(obj, W) 
          P = 0.250000 * (sum(sum(W, 2), 1));
      end

      function y = f(obj, x)
          y = x;
      end
    end
end