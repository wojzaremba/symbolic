function marginal = compute_marginal_mult(v_fixed, h_fixed, k)
  global all_desc all_bulk_hashes n_ m_
  tic;
  v_l = length(v_fixed);
  h_l = length(h_fixed);
  W = emptyW();
  for i = 1:v_l
      for j = 1:h_l
          expr = zeros(2 * v_l * h_l, 1);
          expr((i - 1) * h_l + j, 1) = 1;
          expr(v_l * h_l + (i - 1) * h_l + j, 1) = 1;
          W(i, j) = fix_exprs(struct('quant', 1, 'expr', expr));
      end
  end  
  W = {fix_top_level_expr(struct('val', W, 'power', [1, 1], 'desc', df_matrix('W', n_, m_), 'desc_grammar', 'W'))};
  Wt = rule_transpose(W);
  WWt = rule_multiply(W, Wt, {}, 2);
  WWtW = rule_multiply(WWt, W, {}, 3);
  WWtW = rule_marginalize(WWtW, {}, 1);
  WWtW = rule_marginalize(WWtW, {}, 2);
  marginal = WWtW{1};    
  all_desc = containers.Map;
  all_bulk_hashes = containers.Map('KeyType', 'double', 'ValueType', 'any');  
end