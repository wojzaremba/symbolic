function top_level = rule_elementwise_multiply_op(A, B, same, maxk)
    top_level = [];
    power = A.power + B.power;
    if ((power(1) > maxk) || (power(2) > maxk) || (power(2) > power(1) + 1))
        return;
    end
    assert((size(A.val, 1) == size(B.val, 1)) || ...
           (size(A.val, 1) == 1) || ...
           (size(B.val, 1) == 1));
    assert((size(A.val, 2) == size(B.val, 2)) || ...
           (size(A.val, 2) == 1) || ...
           (size(B.val, 2) == 1));
    desc_grammar = sprintf('rule_elementwise_multiply(%s, %s, [], %d, %d)', A.desc_grammar, B.desc_grammar, same, maxk);

    if (find_desc(desc_grammar))
      return;
    end
    % If the same size then this operation is symetric.
    if ((size(B.val, 1) == size(A.val, 1)) && (size(B.val, 2) == size(A.val, 2)))
      desc_grammar2 = sprintf('rule_elementwise_multiply(%s, %s, [], %d, %d)', B.desc_grammar, A.desc_grammar, same, maxk);
      find_desc(desc_grammar2);
    end

    val(size(A.val, 1), size(A.val, 2)) = emptyW();    
    for a = 1:size(A.val, 1)
      for b = 1:size(A.val, 2)              
        val(a, b) = multiply_expressions( A.val(a, b), B.val(min(a, size(B.val, 1)), min(b, size(B.val, 2))));
      end
    end
    desc = '';            
    if ((size(B.val, 1) < size(A.val, 1)) && (size(B.val, 2) < size(A.val, 2)))
      desc = df_mult_elemwise({A.desc; B.desc});
    elseif (size(B.val, 1) < size(A.val, 1))  
      desc = df_mult_elemwise({A.desc; df_repmat(B.desc, 1)});
    elseif (size(B.val, 2) < size(A.val, 2))  
      desc = df_mult_elemwise({A.desc; df_repmat(B.desc, 2)});
    else
      desc = df_mult_elemwise({A.desc; B.desc});
    end
    top_level = fix_top_level_expr(...
      struct('val', val, 'power', power, ...
             'desc', desc, ...
             'desc_grammar', desc_grammar));
end