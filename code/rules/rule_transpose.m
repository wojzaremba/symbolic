function res = rule_transpose(X)
  rule_transpose_time = tic;
  res = {};
  for i = 1:length(X)
    top_level.val = X{i}.val';
    top_level.desc = df_transpose(X{i}.desc);
    top_level.power = X{i}.power;
    top_level = fix_top_level_expr(top_level);
    top_level.desc_grammar = ['rule_transpose(', X{i}.desc_grammar, ')'];
    [~, res] = add_top_level(res, top_level);
  end
  fprintf('rule rule_transpose_time, length(to) = %d, toc = %f\n', length(res), toc(rule_transpose_time));
end