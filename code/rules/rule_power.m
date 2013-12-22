function [ newX, updated ] = rule_power( X, maxk, maxk2 )
    tic;
    updated = false;
    newX = X;
    for i = 1:length(X)
      for k = 2:maxk
        if ((X{i}.power(1) * k > maxk) || (X{i}.power(2) * k > maxk2))
          break;
        end            
        pow = power_array_expr(X{i}, k, maxk, maxk2);
        newX{end + 1} = fix_top_level_expr(pow);
      end
    end
    newX = removeDups(newX);
    if (length(newX) > length(X))
        updated = true;
    end
    fprintf('rule power length(X) = %d, length(newX) = %d, toc = %f\n', length(X), length(newX), toc);
end

