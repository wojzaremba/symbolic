function [X, Y] = encode_data(F, marginal, k)
  powers = [];
  for i = 1:length(F)
      assert(F{i}.power(1) == k);
      for j = 1:length(F{i}.val(:))
        powers = [powers, F{i}.val(j).expr];
      end
  end
  for i = 1:length(marginal.val(:))
    powers = [powers, marginal.val(i).expr];
  end
  powers = unique(powers', 'rows')';
  hashes = [];
  for i = 1:size(powers, 2)
      hashes = [hashes, hash(powers(:, i))];        
  end    
  if (length(unique(hashes)) ~= length(hashes))
      assert(0);
  end
  hash_map = containers.Map(num2cell(hashes), num2cell(1:length(hashes)));

  X = encode_in_hash(F, hash_map, k);  
  Y = encode_in_hash_exprs( marginal, hash_map );  
end