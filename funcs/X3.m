classdef X3 < PrototypeF
    properties
    end

    methods    
          function obj = X3()
              obj.name = 'X3';
          end
      
          function P = FP_unnorm(obj, W)         
              n = size(W, 1);
              m = size(W, 2);                   
              P = ((( ( sum(sum(W, 2), 1) .* ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1))) .* 2) ...
                  + ( ( sum(sum(W, 2), 1) .* sum(( sum(W, 2) .* sum(W, 2)), 1)) .* 6) ...
                  + ( ( sum(sum(W, 2), 1) .* sum(sum(( W .* W), 2), 1)) .* 6) ...
                  + ( ( sum(sum(W, 2), 1) .* sum(( sum(W, 1) .* sum(W, 1)), 2)) .* 6)  + ...
                  ( sum(( sum(W, 2) .* sum(( W .* repmat(sum(W, 1), [n, 1])), 2)), 1) .* 12))) / 128;
          end

          function y = f(obj, x)
            y = x .^ 3;
          end
    end

end