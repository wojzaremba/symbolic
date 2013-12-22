function df = optimize_code(df)
  u = 1;
  n = 6;
  m = 9;
  [v, W, h] = TestData(n, m);
  v = [v; 1];
  h = [h; 1];
  [W11, W1R, WR1, WRR] = GetData(v, W, h);  
  [O11, O1R, OR1, ORR] = GetOuter(v, h);
  n = length(v);
  m = length(h);  
  while(norm(u) > 0)
    u = 0;
    for i = 1:length(df.params)
      df.params{i} = optimize_code(df.params{i});
    end    
    [df, u(1)] = add_verifier(@margmarg_to_marg, df);  
    [df, u(2)] = add_verifier(@remove_mult_one, df);    
    [df, u(3)] = add_verifier(@rep_to_sum, df);
    [df, u(4)] = add_verifier(@sum_to_ssum, df);
    [df, u(5)] = add_verifier(@abac_abc, df);
    [df, u(6)] = add_verifier(@mult_tree_to_line, df);  
    [df, u(7)] = add_verifier(@remove_mult_elemwise_one, df);
  end   
  function [df, u] = add_verifier(fun, dfinit)
    initial = eval(toString(dfinit));
    [df, u] = fun(dfinit);
    after = eval(toString(df));
    assert(norm(initial - after) < 1e-5);
    if ((~u) || (df.complex >= dfinit.complex))
        u = false;
    end
  end
end


function [W11, W1R, WR1, WRR] = GetData(v, W, h)
  W11 = zeros(size(W));
  W1R = zeros(size(W));
  WR1 = zeros(size(W));
  WRR = zeros(size(W));
  W11(v == 1, h == 1) = W(v == 1, h == 1);
  W1R(v == 1, h == Inf) = W(v == 1, h == Inf);
  WR1(v == Inf, h == 1) = W(v == Inf, h == 1);
  WRR(v == Inf, h == Inf) = W(v == Inf, h == Inf);
end