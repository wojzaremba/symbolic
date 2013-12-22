function [F, E, D, A] = get_grammar_init(v_fixed, h_fixed)
  global all_desc n_ m_
  all_desc = containers.Map;
  v_l = length(v_fixed);
  h_l = length(h_fixed);
  O11 = emptyW();
  O1R = emptyW();
  OR1 = emptyW();
  ORR = emptyW();

  W11 = emptyW();
  W1R = emptyW();
  WR1 = emptyW();
  WRR = emptyW();

  W = emptyW();
  for i = 1:v_l
      for j = 1:h_l
          expr = zeros(2 * v_l * h_l, 1);
          expr(v_l * h_l + (i - 1) * h_l + j, 1) = 1;
          % Indicators.
%           O11(i, j) = fix_exprs(struct('quant', ((v_fixed(i) == 1) && (h_fixed(j) == 1)) + 0, 'expr', expr));
%           O1R(i, j) = fix_exprs(struct('quant', ((v_fixed(i) == 1) && (h_fixed(j) == Inf)) + 0, 'expr', expr));
%           OR1(i, j) = fix_exprs(struct('quant', ((v_fixed(i) == Inf) && (h_fixed(j) == 1)) + 0, 'expr', expr));
          ORR(i, j) = fix_exprs(struct('quant', ((v_fixed(i) == Inf) && (h_fixed(j) == Inf)) + 0, 'expr', expr));

          expr((i - 1) * h_l + j, 1) = 1;
          W(i, j) = fix_exprs(struct('quant', 1, 'expr', expr));

%           W11(i, j) = fix_exprs(struct('quant', ((v_fixed(i) == 1) && (h_fixed(j) == 1)) + 0, 'expr', expr));
%           W1R(i, j) = fix_exprs(struct('quant', ((v_fixed(i) == 1) && (h_fixed(j) == Inf)) + 0, 'expr', expr));
%           WR1(i, j) = fix_exprs(struct('quant', ((v_fixed(i) == Inf) && (h_fixed(j) == 1)) + 0, 'expr', expr));
          WRR(i, j) = fix_exprs(struct('quant', ((v_fixed(i) == Inf) && (h_fixed(j) == Inf)) + 0, 'expr', expr));
      end
  end  

%   F = rule_marginalize(rule_marginalize({fix_top_level_expr(struct('val', W11, 'power', [1, 1], ...
%           'desc', df_matrix('W11', n_, m_), 'desc_grammar', 'F'))}, [], 1), [], 2);
% 
%   E = rule_marginalize({fix_top_level_expr(struct('val', W1R, 'power', [1, 1], ...
%           'desc', df_matrix('W1R', n_, m_), 'desc_grammar', 'E'))}, [], 1);
% 
%   D = rule_marginalize({fix_top_level_expr(struct('val', WR1, 'power', [1, 1], ...
%           'desc', df_matrix('WR1', n_, m_), 'desc_grammar', 'D'))}, [], 2);

  F = {};
  E = {};
  D = {};
      
  A = [{fix_top_level_expr(struct('val', WRR, 'power', [1, 1], 'desc', df_matrix('WRR', n_, m_), 'desc_grammar', '{A{1}}'))}, ...
%        {fix_top_level_expr(struct('val', O11, 'power', [0, 1], 'desc', df_matrix('O11', n_, m_), 'desc_grammar', '{A{2}}'))}, ...
%        {fix_top_level_expr(struct('val', O1R, 'power', [0, 1], 'desc', df_matrix('O1R', n_, m_), 'desc_grammar', '{A{3}}'))}, ...
%        {fix_top_level_expr(struct('val', OR1, 'power', [0, 1], 'desc', df_matrix('OR1', n_, m_), 'desc_grammar', '{A{4}}'))}, ...
       {fix_top_level_expr(struct('val', ORR, 'power', [0, 1], 'desc', df_matrix('ORR', n_, m_), 'desc_grammar', '{A{5}}'))}];
end