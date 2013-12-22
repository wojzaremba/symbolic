function [ res ] = encode_in_hash_exprs( exprs, hash_map )
  res = zeros(length(exprs.val(:)) * length(hash_map), 1);
  for k = 1:length(exprs.val(:))
    offset = (k - 1) * length(hash_map);
    for j = 1:size(exprs.val(k).expr, 2)
      idx = hash_map(hash(exprs.val(k).expr(:, j)));
      res(offset + idx) = res(offset + idx) + exprs.val(k).quant(j);
    end
  end
end

