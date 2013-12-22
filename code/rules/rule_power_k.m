function [ newX, updated ] = rule_power_k( X, k, maxk )
    tic;
    updated = false;
    newX = X;
    for i = 1:length(X)
      if (X{i}.power * k > maxk)
        break;
      end            
      pow = power_array_expr(X{i}, k, maxk);
      newX{end + 1} = fix_top_level_expr(pow);
    end
    newX = removeDups(newX);
    if (length(newX) > length(X))
      updated = true;
    end
    fprintf('rule power length(X) = %d, length(newX) = %d, toc = %f\n', length(X), length(newX), toc);
end

