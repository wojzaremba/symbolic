function fun = Complex(coeffs, funs)
  assert(length(coeffs) == length(funs));
  name = '';
  for i = 1:length(coeffs)
    if (i > 1)
      name = sprintf('%s +', name);
    end
    name = sprintf('%s %f*%s', name, coeffs(i), funs(i).name);
  end
  fun = PrototypeF(struct('FP_unnorm', @FP_unnorm, ...
                          'BP_unnorm', @BP_unnorm, ...
                          'f', @f, ...
                          'df', @df, ...
                          'name', name));

  function P = FP_unnorm(v, W, h)
    P = 0;
    for i = 1:length(coeffs)
      P = P + coeffs(i) * funs(i).FP_unnorm(v, W, h);
    end    
  end

  function dW = BP_unnorm(v, W, h)
    dW = zeros(size(W));
    for i = 1:length(coeffs)
      dW = dW + coeffs(i) * funs(i).BP_unnorm(v, W, h);
    end    
  end

  function y = f(x)
    y = 0;
    for i = 1:length(coeffs)
      y = y + coeffs(i) * funs(i).f(x);
    end
  end

  function y = df(x)
    y = coeffs(1) * funs(1).df(x);
    for i = 2:length(coeffs)
      y = y + coeffs(i) * funs(i).df(x);
    end
  end
end