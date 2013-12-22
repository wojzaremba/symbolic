function df = derivative(f, v_l, h_l) 
  f = f.val;
  df_val = {};
  for x = 1:v_l
    for y = 1:h_l
      df_val.val(x, y) = struct('quant', [], 'expr', [], 'hashes', []);
      for i = 1:length(f.quant)        
        idx = (x - 1) * h_l + y;
        if (f.expr(idx, i) >= 1)
          df_val.val(x, y).quant = [df_val.val(x, y).quant, f.quant(i) * f.expr(idx, i)];
          df_val.val(x, y).expr = [df_val.val(x, y).expr, f.expr(:, i)];
          df_val.val(x, y).expr(idx, end) = df_val.val(x, y).expr(idx, end) - 1;
        end
      end
      df_val.val(x, y) = fix_exprs(df_val.val(x, y));
    end
  end
  df = fix_top_level_expr(df_val);
end