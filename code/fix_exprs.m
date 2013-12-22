function [ new_exprs ] = fix_exprs( exprs )
  quant = exprs.quant;
  expr = exprs.expr;
  hashes = [];
  nonzero = [];
  for i = 1:size(expr, 2)
    if (quant(i) ~= 0)
      hashes = [hashes; hash(expr(:, i))];
      nonzero = [nonzero; i];
    end
  end    
  if (length(unique(hashes)) ~= length(hashes))
    assert(0);
  end
  expr = expr(:, nonzero);
  quant = quant(:, nonzero);
  [hashes, idx] = sort(hashes);
  expr = expr(:, idx);
  quant = quant(:, idx);
  new_exprs = struct('quant', quant, 'expr', expr, 'hashes', hashes);
end

