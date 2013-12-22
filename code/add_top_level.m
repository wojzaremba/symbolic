function [updated, res] = add_top_level(res, top_level)
  global all_bulk_hashes
  desc_hash = top_level.power(2) * 10000 + length(top_level.desc);
  if (isKey(all_bulk_hashes, top_level.bulk_hash))
    map_desc_hash = all_bulk_hashes(top_level.bulk_hash);
    if (map_desc_hash > desc_hash)
      all_bulk_hashes(top_level.bulk_hash) = desc_hash;
      for i = 1:length(res(:))
        if (res{i}.bulk_hash == top_level.bulk_hash)
          res{i} = top_level;
        end
      end
    end
    updated = false;
    return;
  else 
    all_bulk_hashes(top_level.bulk_hash) = desc_hash;
    res{end + 1} = top_level;
    updated = true; 
  end
end