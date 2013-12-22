function ret = add_many_expr(exprs)
    exprs = exprs(:);
    while(length(exprs(:)) > 1) 
      exprs_copy = {};
      for i = 1:ceil(length(exprs(:)) / 2)
        if (i + ceil(length(exprs(:)) / 2) <= length(exprs(:)))
          exprs_copy{i} = add_expr(exprs{i}, exprs{i + ceil(length(exprs(:)) / 2)});
        else
          exprs_copy{i} = exprs{i};
        end
      end
      exprs = exprs_copy;
    end
    if (length(exprs(:)) > 0)
      ret = exprs{1};
    else 
      ret = struct('quant', [], 'expr', [], 'hashes', []);
    end
end