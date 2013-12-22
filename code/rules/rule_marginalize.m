function [ res, updated ] = rule_marginalize( from, to, dim )
    rule_marginalize_time = tic; 
    updated = false;
    res = to;
    for i = 1:length(from)
        desc_grammar = sprintf('rule_marginalize(%s, [], %d)', from{i}.desc_grammar, dim);
        if (find_desc(desc_grammar))
          continue;
        end

        val = sum_expr(from{i}.val, dim);
        top_level = fix_top_level_expr(...
          struct('val', val, 'power', from{i}.power, ...
                 'desc', df_marg(from{i}.desc, dim), ...
                 'desc_grammar', desc_grammar));
        [updated_res, res] = add_top_level(res, top_level);
        updated = updated || updated_res;           
    end
    fprintf('rule marginalize, length(to) = %d, length(res) = %d, toc = %f\n', length(to), length(res), toc(rule_marginalize_time));
end

