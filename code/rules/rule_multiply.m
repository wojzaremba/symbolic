function [ res, updated ] = rule_multiply( X, Y, to, maxk )
    rule_multiply_time = tic;
    updated = false;
    res = to;    
    for i = 1:length(X)
        for j = 1:length(Y)
            power = X{i}.power + Y{j}.power;
            if ((power(1) > maxk) || (power(2) > maxk) || (power(2) > power(1) + 1))
                continue;
            end
            assert(size(X{i}.val, 2) == size(Y{j}.val, 1));            
            desc_grammar = sprintf('rule_multiply(%s, %s, [], %d)', X{i}.desc_grammar, Y{j}.desc_grammar, maxk);
            if (find_desc(desc_grammar))
              continue;
            end

            val(size(X{i}.val, 1), size(Y{j}.val, 2)) = emptyW();    
            for a = 1:size(X{i}.val, 1)
                for c = 1:size(Y{j}.val, 2) 
                    mult = cell(size(X{i}.val, 2), 1);
                    for b = 1:size(X{i}.val, 2)
                        mult{b} = multiply_expressions( X{i}.val(a, b), Y{j}.val(b, c));
                    end
                    val(a, c) = add_many_expr(mult);
                end
            end
            top_level = fix_top_level_expr(...
              struct('val', val, 'power', power, ...
                     'desc', df_mult({X{i}.desc, Y{j}.desc}), ...
                     'desc_grammar', desc_grammar));
            [updated_res, res] = add_top_level(res, top_level);
            updated = updated || updated_res;               
        end
    end
    fprintf('rule multiply, length(to) = %d, length(res) = %d, toc = %f\n', length(to), length(res), toc(rule_multiply_time));
end

