function [df, updated] = remove_mult_one(df)
  if (strcmp(df.name, 'df_mult'))
    assert(length(df.params) > 1);
    for i = 1:2
      if (strcmp(df.params{i}.name, 'df_matrix') == 1)
        if (strcmp(df.params{i}.val, '1') == 1)
          df = df.params{3 - i};
          updated = true;
          return;
        end
      end
    end    
  end
  updated = false;
end