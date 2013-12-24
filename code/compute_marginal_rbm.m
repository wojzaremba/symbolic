function marginal = compute_marginal_rbm(v_fixed, h_fixed, k)
  tic;
  v_l = length(v_fixed);
  h_l = length(h_fixed);
  W = emptyW();
  for i = 1:v_l
      for j = 1:h_l
          expr = zeros(v_l * h_l, 1);
          expr((i - 1) * h_l + j, 1) = 1;
          W(i, j) = fix_exprs(struct('quant', 1, 'expr', expr));
      end
  end  
  marginal_val = cell(2^v_l, 2^h_l);
  fprintf('Number of probs = %d\n', 2^(v_l + h_l));
  for v = 0:(2^v_l - 1)
      v_ = decode_vector(v, v_l) - 1;
      if ((sum(v_fixed(logical(v_)) == 0) ~= 0) || ...
          (sum(v_fixed(logical(v_)) == 1) ~= sum(v_fixed == 1)))
          continue;
      end
      for h = 0:(2^h_l - 1)
          fprintf('.');
          h_ = decode_vector(h, h_l) - 1;     
          if ((sum(h_fixed(logical(h_)) == 0) ~= 0) || ...
              (sum(h_fixed(logical(h_)) == 1) ~= sum(h_fixed == 1)))
              continue;
          end        
          posv = find(v_);
          posh = find(h_);
          E = cell(length(posv), length(posh)); 
          for a = 1:length(posv)
            for b = 1:length(posh)
              E{a, b} = W(posv(a), posh(b));
            end
          end
          marginal_val{v + 1, h + 1} = power_expr(add_many_expr(E), k, Inf);
      end
  end
  marginal = fix_top_level_expr(struct('val', add_many_expr(marginal_val)));
  fprintf('\nComputation of marginals took %f\n', toc);
end