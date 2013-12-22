% ssum((WRR .* repmat(sum(W1R, 1), [n, 1])))
% -> 
% sum(sum(WRR, 1) .* sum(W1R, 1), 2)
function [df, updated] = rep_to_sum(df)
  if ((strcmp(df.name, 'df_marg')) && (df.sumdim == 0))    
    if ((strcmp(df.params{1}.name, 'df_mult_elemwise')) && (length(df.params) == 2))
      for k = 1:2
        if ((df.params{1}.params{k}.dim1 == Inf) && (df.params{1}.params{k}.dim2 == Inf) && (strcmp(df.params{1}.params{3 - k}.name, 'df_repmat')))
          df = df_dot(df_marg(df.params{1}.params{k}, df.params{1}.params{3 - k}.repdim), df.params{1}.params{3 - k}.params{1});
          updated = true;
          return;
        end
      end
    end        
  end
  updated = false;
end