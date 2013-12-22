function [df, updated] = sum_to_ssum(df)
  if ((strcmp(df.name, 'df_marg')) && (df.sumdim ~= 0))
    assert(length(df.params) == 1);
    if ((df.params{1}.dim1 == 1) && (df.params{1}.dim2 == 1))
      df = df.params{1};
      updated = true;
      return;
    end
    if ((df.params{1}.dim1 == 1) || (df.params{1}.dim2 == 1))
      df.sumdim = 0;
      updated = true;
      return;
    end
  end
  updated = false;
end