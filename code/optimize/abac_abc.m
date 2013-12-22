function [df, updated] = abac_abc(df)
  if (strcmp(df.name, 'df_sum'))
    assert(length(df.params) > 1);
    for i = 1:length(df.params)
      for j = (i + 1):length(df.params)
        if ((strcmp(df.params{i}.name, 'df_mult_elemwise')) && (strcmp(df.params{j}.name, 'df_mult_elemwise')))
          for k = 1:length(df.params{i}.params)
            for l = 1:length(df.params{j}.params)
              if (df.params{i}.dim1 ~= Inf) || (df.params{i}.dim2 ~= Inf)
                continue;
              end
              p1 = df.params{i}.params{k};
              p2 = df.params{j}.params{l};
              if (strcmp(toString(p1), toString(p2)))
                all_params = {};
                for a = 1:length(df.params)
                  if ((a == i) || (a == j))
                    continue
                  end
                  all_params{end + 1} = df.params{a};
                end
                pi_slim_params = {};
                for a = 1:length(df.params{i}.params)
                  if (a ~= k)
                    pi_slim_params{end + 1} = df.params{i}.params{a};
                  end
                end
                pj_slim_params = {};                
                for b = 1:length(df.params{j}.params)
                  if (b ~= l)
                    pj_slim_params{end + 1} = df.params{j}.params{b};
                  end
                end          
                if (length(pi_slim_params) > 1)
                  pi_slim = df_mult_elemwise(pi_slim_params);
                else
                  pi_slim = pi_slim_params{1};
                end
                if (length(pj_slim_params) > 1)
                  pj_slim = df_mult_elemwise(pj_slim_params);
                else
                  pj_slim = pj_slim_params{1};
                end
                all_params{end + 1} = df_mult_elemwise({p1; df_sum({pi_slim; pj_slim})});
                if (length(all_params) > 1)
                  df = df_sum(all_params);
                else
                  df = all_params{1};
                end
                updated = true;
                return;
              end
            end
          end
        end
      end
    end
      
  end
  updated = false;
end