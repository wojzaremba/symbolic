function [v, W, h] = TestData(n, m)
  randn('seed', 1);
  rand('seed', 1);
  v = ones(n, 1);
  h = ones(m, 1);
  while (length(unique(v)) ~= 3)
    v = randi(2, n, 1) - 1;
    v_inf = logical(randi(2, n, 1) - 1);
    v(v_inf) = Inf;
  end
  while (length(unique(h)) ~= 3)
    h = randi(2, m, 1) - 1;
    h_inf = logical(randi(2, m, 1) - 1);
    h(h_inf) = Inf;
  end
  W = randn(n + 1, m + 1);
  W(end, end) = 0;
end