classdef X4 < PrototypeF
    properties
    end

    methods
    
          function obj = X4()
              obj.name = 'X4';
          end
        
        
          function y = f(obj, x)
              y = x .^ 4;
          end
        
          % Total computation time = 2535.400473
          function P = FP_unnorm(obj, W)                     
            n = size(W, 1);
            m = size(W, 2);             
            P = ((((( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1))  .* ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1)))  .* 1) ...
              + ( sum(( ( sum(W, 1) .* sum(W, 1)) .* ( sum(W, 1) .* sum(W, 1))), 2) .* -2) ...
              + ( ( sum(( sum(W, 1) .* sum(W, 1)), 2) .* sum(( sum(W, 1) .* sum(W, 1)), 2)) .* 3) ...
              + ( sum(( ( sum(W, 1) .* sum(W, 1)) .* sum(( W .* W), 1)), 2) .* -12) ...
              + ( ( sum(( sum(W, 1) .* sum(W, 1)), 2) .* sum(sum(( W .* W), 2), 1)) .* 6) ...
              + (sum((repmat(sum(sum(W, 2), 1), [n, 1])  .* sum(( ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1])) .* W), 2)), 1)  .* 24) ...
              + (( ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1)) .* sum(( sum(W, 1) .* sum(W, 1)), 2))  .* 6) ...
              + ( sum(( ( sum(W, 2) .* sum(W, 2)) .* ( sum(W, 2) .* sum(W, 2))), 1) .* -2) ...
              + ( ( sum(( sum(W, 2) .* sum(W, 2)), 1) .* sum(( sum(W, 2) .* sum(W, 2)), 1)) .* 3) ...
              + ( ( (sum(W, 2)') * ( ( W * (W')) * sum(W, 2))) .* 12) ...
              + ( ( ( sum(W, 1) * (W')) * ( W * (sum(W, 1)'))) .* 12) ...
              + (( ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1)) .* sum(( sum(W, 2) .* sum(W, 2)), 1))  .* 6) ...
              + ( sum(( ( sum(W, 2) .* sum(W, 2)) .* sum(( W .* W), 2)), 1) .* -12) ...
              + ( ( sum(( sum(W, 1) .* sum(W, 1)), 2) .* sum(( sum(W, 2) .* sum(W, 2)), 1)) .* 6) ...
              + ( sum(sum(( ( W .* W) .* ( W .* W)), 2), 1) .* 4) ...
              + ( ( ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1)) .* sum(sum(( W .* W), 2), 1)) .* 6) ...
              + ( ( sum(( sum(W, 2) .* sum(W, 2)), 1) .* sum(sum(( W .* W), 2), 1)) .* 6) ...
              + ( ( sum(sum(( W .* W), 2), 1) .* sum(sum(( W .* W), 2), 1)) .* 3) ...
              + ( sum(( sum(( W .* W), 1) .* sum(( W .* W), 1)), 2) .* -6) ...
              + ( sum(( sum(( W .* W), 2) .* sum(( W .* W), 2)), 1) .* -6)  + ( sum(sum(( ( W * (W')) .* ( W * (W'))), 1), 2) .* 6))) / 256;
      end
    end

end