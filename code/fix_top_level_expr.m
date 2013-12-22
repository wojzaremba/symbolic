function [ X ] = fix_top_level_expr( X )
  global dot_mult prime
  % Hash is the same up to multiplicative constant.
  normalize = 0;
  for j = 1:length(X.val(:))
    normalize = normalize + sum(abs(X.val(j).quant));
  end
  bulk_hash = 0;
  for j = 1:length(X.val(:))
    bulk_hash = mod(10000000000001 * bulk_hash + dot(dot_mult(1:(2 * length(X.val(j).quant))), [X.val(j).quant(:) / normalize ; X.val(j).hashes(:)]), prime);
  end
  assert(~isnan(bulk_hash) && (bulk_hash ~= Inf));
  X.bulk_hash = bulk_hash;  
end

