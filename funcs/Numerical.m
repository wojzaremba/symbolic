classdef Numerical < PrototypeF
    properties
        testfun
    end

    methods    
      function obj = Numerical(testfun)
          obj.name = 'Numerical';
          obj.testfun = testfun;
      end
  
      function Z = fulliter(obj, W)
        Zvals = zeros(2^length(size(W, 1)), 2^length(size(W, 2)));
        vsize = 2^(size(W, 1));
        hsize = 2^(size(W, 2));
        for i = 1 : vsize
          for j = 1 : hsize
            bin_i = decode_vector(i - 1, size(W, 1), 2);
            bin_j = decode_vector(j - 1, size(W, 2), 2); 
            assert((sum(bin_i < 0) == 0) && (sum(bin_i > 1) == 0));
            assert((sum(bin_j < 0) == 0) && (sum(bin_j > 1) == 0));
            val = obj.testfun.f(bin_i' * W * bin_j);
            Zvals(i, j, :, :) = val;
          end
        end
        Z = squeeze(sum(sum(Zvals, 1), 2));
      end  

      function P = FP_unnorm(obj, W)
        P = obj.fulliter(v, W, h) / 2^(size(W, 1) + size(W, 2));
      end  

      function [logZ] = FP(obj, W)
        Z = obj.fulliter(W);
        logZ = log(Z);
      end

    end
end