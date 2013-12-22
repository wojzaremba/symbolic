function test_power_expr_simple
    A = fix_exprs(struct('quant', [1, 1], 'expr', [1, 0; 0, 1]'));
    B = power_expr(A, 2, Inf);
    assert(size(B.expr, 2) == 3);
    val = cell(4, 1);
    expr = {[0, 2], [1, 1], [2, 0]};
    quant = {1, 2, 1};
    hashes = [];
    for i = 1:length(B.quant)
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

