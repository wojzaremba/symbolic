function [ newX ] = removeDups( X )
    removeDups_time = tic;
    hashes = zeros(length(X), 1);   
    descs = zeros(length(X), 1);
    for i = 1:length(X)
        hashes(i) = X{i}.bulk_hash;
        descs(i) = X{i}.power(2) * 10000 + length(X{i}.desc);   
    end
    [~, idx, ic] = unique(hashes);
    if (length(idx) == length(X))
        newX = X;
        return;
    end
    idx2 = zeros(length(idx), 1);
    for i = 1:length(idx)
         if (sum(ic(idx(i)) == ic) == 1)
             idx2(i) = idx(i);
         else
             toimprove = find(ic(idx(i)) == ic);
             [~, midx] = min(descs(toimprove));
             idx2(i) = toimprove(midx);
         end
    end
    idx = idx2;
    
    newX = X(idx);
    for i = 1:length(newX)
         newX{i}.desc = strrep(newX{i}.desc, '''''', '');
    end
    fprintf('remove dups, length(to) = %d, length(res) = %d, toc = %f\n', length(X), length(newX), toc(removeDups_time));
end

