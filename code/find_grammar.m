function [F, A] = find_grammar(v_fixed, h_fixed, k)
  [F, E, D, A] = get_grammar_init(v_fixed, h_fixed);

  fprintf('setting up a grammar\n');

  % A = n x m
  % D = n x 1
  % E = 1 x m
  % F = 1 x 1
  
  u = 1;
  fprintf('grammar started\n');
  while (norm(u) > 0)
      single_iter_time = tic;
      u(:) = 0;
      [D, u(1)] = rule_marginalize(A, D, 2);
      [E, u(2)] = rule_marginalize(A, E, 1);

      [F, u(3)] = rule_marginalize(D, F, 1);
      [F, u(4)] = rule_marginalize(E, F, 2);

      [A, u(5)] = rule_elementwise_multiply(A, A, A, true, k);
      [A, u(6)] = rule_elementwise_multiply(A, D, A, false, k);
      [A, u(7)] = rule_elementwise_multiply(A, E, A, false, k);
      [A, u(8)] = rule_elementwise_multiply(A, F, A, false, k);

      [D, u(9)] = rule_elementwise_multiply(D, D, D, true, k);
      [D, u(10)] = rule_elementwise_multiply(D, F, D, false, k);      
      [E, u(11)] = rule_elementwise_multiply(E, E, E, true, k);
      [E, u(12)] = rule_elementwise_multiply(E, F, E, false, k);      
      [F, u(13)] = rule_elementwise_multiply(F, F, F, true, k);  

      fprintf('length(F) = %d\n', length(F));
      fprintf('single iter takes = %f\n', toc(single_iter_time));
  end
end
