classdef X2 < PrototypeF
    properties
    end

    methods    
      function obj = X2()
          obj.name = 'X2';
      end

      function P = FP_unnorm(obj, W)   
          n = size(W, 1);
          m = size(W, 2);          
          P = ((( ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1)) .* 2) ...
              + ( sum(( sum(W, 2) .* sum(W, 2)), 1) .* 2) + ( sum(sum(( W .* W), 2), 1) .* 2)  + ( sum(( sum(W, 1) .* sum(W, 1)), 2) .* 2))) / 32;
      end

      function y = f(obj, x)
        y = x^2;
      end

    end
end