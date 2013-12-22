function [F, A] = find_grammar(v_fixed, h_fixed, k)
  [F, E, D, A] = get_grammar_init(v_fixed, h_fixed);

  fprintf('setting up a grammar\n');
  B = {};
  C = {};

  u = 1;
  fprintf('grammar started\n');
  while (norm(u) > 0)
      single_iter_time = tic;
      u(:) = 0;
      [D, u(7)] = rule_marginalize(A, D, 2);
      [D, u(8)] = rule_marginalize(B, D, 2);
      [E, u(9)] = rule_marginalize(A, E, 1);
      [E, u(10)] = rule_marginalize(C, E, 1);

      [F, u(11)] = rule_marginalize(D, F, 1);
      [F, u(12)] = rule_marginalize(E, F, 2);

      AT = rule_transpose(A);
%       [B, u(13)] = rule_multiply(A, AT, B, k);
%       [A, u(14)] = rule_multiply(B, A, A, k);

      AT = rule_transpose(A);
      [C, u(15)] = rule_multiply(AT, A, C, k);
      [AT, u(16)] = rule_multiply(C, AT, AT, k);
      Atmp = rule_transpose(AT);
      [A, u(17)] = rule_concat(A, Atmp);

%       [F, u(18)] = rule_multiply(F, F, F, k);
% 
%       [B, u(19)] = rule_multiply(B, B, B, k);
%       [B, u(20)] = rule_multiply(B, rule_transpose(B), B, k);
%       [C, u(21)] = rule_multiply(C, C, C, k);
%       [C, u(22)] = rule_multiply(C, rule_transpose(C), C, k);

      [B, u(23)] = rule_concat(B, rule_transpose(B));
      [C, u(24)] = rule_concat(C, rule_transpose(C));

%       [D, u(25)] = rule_multiply(A, rule_transpose(E), D, k);
%       [E, u(26)] = rule_multiply(rule_transpose(D), A, E, k);
% 
%       [D, u(27)] = rule_multiply(B, D, D, k);
%       [E, u(28)] = rule_multiply(E, C, E, k);

      [A, u(29)] = rule_elementwise_multiply(A, A, A, true, k);
      [A, u(32)] = rule_elementwise_multiply(A, D, A, false, k);
      [A, u(33)] = rule_elementwise_multiply(A, E, A, false, k);
      [A, u(34)] = rule_elementwise_multiply(A, F, A, false, k);

      [B, u(35)] = rule_elementwise_multiply(B, B, B, true, k);
      [C, u(36)] = rule_elementwise_multiply(C, C, C, true, k);
      [D, u(37)] = rule_elementwise_multiply(D, D, D, true, k);
      [E, u(38)] = rule_elementwise_multiply(E, E, E, true, k);
      [F, u(39)] = rule_elementwise_multiply(F, F, F, true, k);  

      fprintf('length(F) = %d\n', length(F));
      fprintf('single iter takes = %f\n', toc(single_iter_time));
  end
end
