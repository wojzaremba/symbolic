function test_power_expr
    A = fix_exprs(struct('quant', [3, 2], 'expr', [1,0,2,0; 1,2,3,0]'));
    B = power_expr(A, 3, Inf);
    assert(size(B.expr, 2) == 4);
    val = cell(4, 1);
    expr = {[3, 6, 9, 0], [3, 4, 8, 0], [3, 2, 7, 0], [3, 0, 6, 0]};
    quant = {8, 36, 54, 27};
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

