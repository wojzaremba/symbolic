function [ X ] = encode_in_hash( F, hash_map, k )
  X = [];
  for i = 1:length(F)
    if (F{i}.power(1) == k)   
      tmp = encode_in_hash_exprs( F{i}, hash_map );
      X = [X, tmp];
    else 
      assert(0);
    end
  end
  X = double(X);
end

