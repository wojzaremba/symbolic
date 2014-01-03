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
              P = ((sum(( ( sum(W, 2) .* sum(W, 2)) .* repmat(sum(sum(W, 2), 1), [n, 1])), 1)  .* 0.046875) ...
              + (sum(sum(( ( W .* repmat(sum(W, 2), [1, m])) .* repmat(sum(W, 1), [n, 1])), 2), 1)  .* 0.09375) ...
              + (sum(sum((( W .* repmat(sum(W, 1), [n, 1]))  .* repmat(repmat(sum(sum(W, 2), 1), [n, 1]), [1, m])), 2), 1)  .* 0.046875) ...
              + ( ( ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1)) .* sum(sum(W, 2), 1)) .* 0.015625)  + (sum(sum(( ( W .* W) .* repmat(repmat(sum(sum(W, 2), 1), [n, 1]), [1, m])), 2), 1)  .* 0.046875));           
          end

          function y = f(obj, x)
            y = x .^ 3;
          end
    end

end