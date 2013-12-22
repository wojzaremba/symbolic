function [ res, updated ] = rule_concat( A, B )
    rule_concat_time = tic;
    updated = false;
    res = cat(1, A(:), B(:));
    res = removeDups(res);
    if (length(res) > length(A))
        updated = true;
    end      
    fprintf('rule concat, length(to) = %d, length(res) = %d, toc = %f\n', length(A), length(res), toc(rule_concat_time));
end

