classdef One < PrototypeF
    properties
    end

    methods    
      function obj = One()
          obj.name = 'One';
      end

      function P = FP_unnorm(obj, v, W, h)
        P = 1;
      end

      function y = f(obj, x)
        y = 1;
      end

    end
end