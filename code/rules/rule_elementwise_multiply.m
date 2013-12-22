function [ res, updated ] = rule_elementwise_multiply( X, Y, to, same, maxk )
    rule_elementwise_multiply_time = tic;
    updated = false;    
    res = to;
    for i = 1 : length(X(:))
        if same
          idx = i;
        else
          idx = 1;
        end
        for j = idx : length(Y(:))       
            top_level = rule_elementwise_multiply_op(X{i}, Y{j}, same, maxk);
            if (isempty(top_level))
                continue;
            end
            [updated_res, res] = add_top_level(res, top_level);
            updated = updated || updated_res;
        end
    end
    
    fprintf('rule elementwise_multiply, length(to) = %d, length(res) = %d, toc = %f\n', length(to), length(res), toc(rule_elementwise_multiply_time));
end
