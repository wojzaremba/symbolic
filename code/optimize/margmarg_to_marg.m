function [df, updated] = margmarg_to_marg(df)
  if (strcmp(df.name, 'df_marg'))
    assert(length(df.params) == 1);
    if ((df.dim1 == 1) && (df.dim2 == 1) && (df.sumdim ~= 0))
      if ((strcmp(df.params{1}.name, 'df_marg')) && (df.sumdim ~= 0))
        assert(length(df.params{1}.params) == 1);
        df.params = df.params{1}.params;
        df.sumdim = 0;
        updated = true;
        return;
      end
    end
  end
  updated = false;
end