function [df, updated] = remove_mult_elemwise_one(df)
  if (strcmp(df.name, 'df_mult_elemwise'))
    assert(length(df.params) > 1);    
    for i = 1:length(df.params)
      if (strcmp(df.params{i}.name, 'df_mult_elemwise'))        
        params = df.params{i}.params;
        for j = 1:length(df.params)
          if (i == j)
            continue;
          end
          params{end + 1} = df.params{j};        
        end
        df = df_mult_elemwise(params);
        updated = true;
        return;
      end
    end    
  end
  updated = false;
end