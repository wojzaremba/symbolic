classdef X5 < PrototypeF
    properties
    end

    methods
    
          function obj = X5()
              obj.name = 'X5';
          end
        
        
          function y = f(obj, x)
              y = x .^ 5;
          end
                  
          function P = FP_unnorm(obj, W)                     
            n = size(W, 1);
            m = size(W, 2);             
            P = (((sum(sum((repmat(( sum(W, 1) .* sum(W, 1)), [n, 1])  .* ( ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1])) .* W)), 2), 1)  .* -40) ...
              + (sum((( sum(W, 1) .* sum(W, 1))  .* sum((repmat(sum(W, 1), [n, 1])  .* ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1]))), 1)), 2)  .* -10) ...
              + (( sum(sum(W, 2), 1) .* sum(( ( sum(W, 2) .* sum(W, 2)) .* sum(( W .* W), 2)), 1))  .* -60) ...
              + (sum((repmat(sum(sum(W, 2), 1), [n, 1])  .* (repmat(sum(sum(W, 2), 1), [n, 1])  .* sum(( ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1])) .* W), 2))), 1)  .* 60) ...
              + (sum((sum(( W .* repmat(sum(W, 1), [n, 1])), 2)  .* sum((repmat(sum(W, 1), [n, 1])  .* ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1]))), 2)), 1)  .* 60) ...
              + (sum(sum(( ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1])) .* ( W .* ( W .* W))), 2), 1)  .* 80) ...
              + (sum((sum(W, 2)  .* (sum(W, 2)  .* sum(( ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1])) .* W), 2))), 1)  .* -40) ...
              + (sum((repmat(sum(( sum(W, 2) .* sum(W, 2)), 1), [n, 1])  .* sum(( ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1])) .* W), 2)), 1)  .* 60) ...
              + ( ( ( sum(W, 1) * (W')) * ( ( W * (W')) * sum(W, 2))) .* 120) ...
              + (sum((( sum(W, 2) .* sum(W, 2))  .* sum((repmat(sum(W, 2), [1, m])  .* ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1]))), 2)), 1)  .* -10) ...
              + (( sum(sum(W, 2), 1) .* sum(( ( sum(W, 1) .* sum(W, 1)) .* sum(( W .* W), 1)), 2))  .* -60) ...
              + (sum((sum(repmat(( sum(W, 2) .* sum(W, 2)), [1, m]), 1)  .* sum((repmat(sum(W, 2), [1, m])  .* ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1]))), 1)), 2)  .* 15) ...
              + ( ( ( sum(sum(W, 2), 1) * (sum(W, 2)')) * ( ( W * (W')) * sum(W, 2))) .* 60) ...
              + ( ( ( sum(sum(W, 2), 1) * ( sum(W, 1) * (W'))) * ( W * (sum(W, 1)'))) .* 60) ...
              + ((sum(sum(W, 2), 1)  .* ( sum(( sum(W, 1) .* sum(W, 1)), 2) .* sum(( sum(W, 1) .* sum(W, 1)), 2)))  .* 15) ...
              + ((sum(sum(W, 2), 1)  .* (( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1))  .* ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1))))  .* 1) ...
              + ((sum(( sum(W, 1) .* sum(W, 1)), 2)  .* ( sum(sum(W, 2), 1) .* ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1))))  .* 10) ...
              + (sum((sum(( ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1])) .* W), 2)  .* repmat(sum(sum(( W .* W), 2), 1), [n, 1])), 1)  .* 60) ...
              + ((sum(( sum(W, 2) .* sum(W, 2)), 1)  .* ( sum(sum(W, 2), 1) .* ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1))))  .* 10) ...
              + ((sum(sum(( W .* W), 2), 1)  .* ( sum(sum(W, 2), 1) .* ( sum(sum(W, 2), 1) .* sum(sum(W, 2), 1))))  .* 10) ...
              + (sum((sum(repmat(( sum(W, 1) .* sum(W, 1)), [n, 1]), 2)  .* sum((repmat(sum(W, 2), [1, m])  .* ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1]))), 2)), 1)  .* 30) ...
              + (sum(sum((( ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1])) .* W)  .* repmat(sum(( W .* W), 1), [n, 1])), 2), 1)  .* -120) ...
              + ((sum(sum(W, 2), 1)  .* ( sum(( sum(W, 1) .* sum(W, 1)), 2) .* sum(sum(( W .* W), 2), 1)))  .* 30) ...
              + (sum(sum((( repmat(sum(W, 2), [1, m]) .* repmat(sum(( W .* W), 1), [n, 1]))  .* repmat(sum(( W .* W), 1), [n, 1])), 2), 1)  .* -30) ...
              + ((sum(sum(W, 2), 1)  .* ( sum(( sum(W, 2) .* sum(W, 2)), 1) .* sum(sum(( W .* W), 2), 1)))  .* 30) ...
              + (sum(( repmat(sum(sum(W, 2), 1), [n, 1]) .* ( sum(( W .* W), 2) .* sum(( W .* W), 2))), 1)  .* -30) ...
              + (sum(( repmat(sum(sum(W, 2), 1), [n, 1]) .* sum(( ( W .* W) .* ( W .* W)), 2)), 1)  .* 20) ...
              + (( sum(sum(W, 2), 1) .* ( sum(sum(( W .* W), 2), 1) .* sum(sum(( W .* W), 2), 1)))  .* 15) ...
              + (sum((sum(( W .* W), 2)  .* sum(( ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1])) .* W), 2)), 1)  .* -120)  + ( sum(( ( ( W * (W')) .* ( W * (W'))) * repmat(sum(sum(W, 2), 1), [n, 1])), 1) .* 30))) / 1024;
      end
    end

end
