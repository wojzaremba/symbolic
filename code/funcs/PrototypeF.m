classdef PrototypeF < handle
    properties
        name
    end
    
    methods
          function obj = PrototypeF()
          end

          function [W11, W1R, WR1, WRR] = GetData(obj, W)
            W11 = zeros(size(W));
            W1R = zeros(size(W));
            WR1 = zeros(size(W));
            WRR = W;
          end
          
          function logZ = FP(obj, W)
              Z = obj.FP_unnorm(W);
              logZ = (size(W, 1) + size(W, 2)) * log(2) + log(complex(Z));
          end        
        
    end
end
   