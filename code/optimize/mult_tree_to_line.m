function [df, updated] = mult_tree_to_line(df)
  if (strcmp(df.name, 'df_mult') || strcmp(df.name, 'df_mult_elemwise'))
    for k = 1:2
      if ((strcmp(df.params{k}.name, 'df_mult') || (strcmp(df.params{k}.name, 'df_mult_elemwise'))) ...
       && (df.params{3 - k}.dim1 == 1) && (df.params{3 - k}.dim2 == 1))
        params = {};
        for i = 1:length(df.params{k}.params)
          params{end + 1} = df.params{k}.params{i};
        end
        params{end + 1} = df.params{3 - k};
        if (strcmp(df.params{k}.name, 'df_mult'))
          df = df_mult(params);
        else
          df = df_mult_elemwise(params);
        end
        updated = true;
        return;
      end
    end
  end
  updated = false;
end