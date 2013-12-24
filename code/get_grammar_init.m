function [F, E, D, A] = get_grammar_init(v_fixed, h_fixed)
  global all_desc n_ m_
  all_desc = containers.Map;
  v_l = length(v_fixed);
  h_l = length(h_fixed);

  W = emptyW();
  for i = 1:v_l
      for j = 1:h_l
          expr = zeros(v_l * h_l, 1);
          expr((i - 1) * h_l + j, 1) = 1;
          W(i, j) = fix_exprs(struct('quant', ((v_fixed(i) == Inf) && (h_fixed(j) == Inf)) + 0, 'expr', expr));
      end
  end  

  F = {};
  E = {};
  D = {};
      
  A = [{fix_top_level_expr(struct('val', W, 'power', [1, 1], 'desc', df_matrix('W', n_, m_), 'desc_grammar', '{A{1}}'))}];
end