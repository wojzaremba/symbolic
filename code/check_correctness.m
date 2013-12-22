function ret = check_correctness(grammar, marginal, coeffs, v_fixed, h_fixed, k)
  [F, E, D, A] = get_grammar_init(v_fixed, h_fixed);
  grammar_copy = cell(length(grammar), 1);
  for i = 1:length(grammar)
    tmp = eval(grammar{i}.desc_grammar);
    grammar_copy{i} = tmp{1};
  end
  grammar = grammar_copy;
  [X, Y] = encode_data(grammar, marginal, k);
  if (size(X, 2) ~= length(coeffs))
    ret = false;
    return;
  end
  if (std(X * coeffs ./ Y) < 1e-4)
    ret = true;
  else
    ret = false;
  end
end