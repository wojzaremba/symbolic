function [ res ] = compare_expr( A, a, B, b )
  res = sign(A.hashes(a) - B.hashes(b));
end

