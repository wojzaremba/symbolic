function [str, fetched] = toString(df)
  global all_expr
  key = df.toStringImpl(df);
  if (strcmp(df.name, 'df_matrix'))
    str = key;
    fetched = true;
  elseif (~isKey(all_expr, key))
    str = key;
    fetched = false;
  else
    str = all_expr(key);
    fetched = true;
  end
end