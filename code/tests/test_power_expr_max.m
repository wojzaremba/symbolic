function test_power_expr_max
    A = fix_exprs(struct('quant', [3, 2, 2], 'expr', [1,0,2,0; 1,2,3,0; 0,0,0,1]'));
    B = power_expr(A, 4, 5);
    assert(size(B, 2) == 1);
    val = cell(1, 1);
    expr = {[0, 0, 0, 4]};
    quant = {2^4};
    hashes = [];
    for i = 1:length(B)
        hashes = [hashes, hash(expr{i}')];
    end
    [~, idx] = sort(hashes);
    expr = expr(idx);
    quant = quant(idx);
    for i = 1:length(B)
        assert(B.quant(i) == quant{i});
        assert(norm(B.expr(:, i) - expr{i}') == 0);
    end
end

