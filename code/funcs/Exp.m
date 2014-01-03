classdef Exp < PrototypeF
    properties
    end

    methods
    
      function obj = Exp()
          obj.name = 'Exp';
      end

      function P = FP_unnorm(obj, v, W, h)
        assert(0);
      end

      function y = f(x)
        y = exp(x);
      end
    end
end