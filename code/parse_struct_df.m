function parse_struct_df(grammar)
  global all_expr stack last_expr
  for i = 1:length(grammar)
    if (isstruct(grammar))
      desc = grammar;
    else
      desc = grammar{i};
    end
    if (strcmp(desc.name, 'df_matrix'))
      continue;
    end
    [~, fetched] = toString(desc);
    if (~fetched)
      for j = 1:length(desc.params)
        parse_struct_df(desc.params{j});
      end 
      [key, fetched] = toString(desc);
      if (~fetched)
        expr = toString(desc);
        stack{end + 1} = sprintf('a%d = %s;', last_expr, expr);
        all_expr(key) = sprintf('a%d', last_expr);
        last_expr = last_expr + 1;
      end
    end
  end
end