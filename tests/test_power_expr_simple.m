function test_power_expr_simple
    cache = Cache(Inf, 1);
    A = ExprSymbolic([1, 1], [1, 0; 0, 1]');
    B = A.power_expr(2);
    assert(size(B.expr, 2) == 3);
    val = cell(4, 1);
    expr = {[0, 2], [1, 1], [2, 0]};
    quant = {1, 2, 1};
    hashes = [];
    for i = 1:length(B.quant)
        hashes = [hashes, Cache.hash_expr(expr{i}')];
    end
    [~, idx] = sort(hashes);
    expr = expr(idx);
    quant = quant(idx);
    for i = 1:length(B)
        assert(B.quant(i) == quant{i});
        assert(norm(double(B.expr(:, i) - int64(expr{i}'))) == 0);
    end
    
    A = ExprZp(A.quant, A.expr);
    B_ = ExprZp(B.quant, B.expr);
    B = A.power_expr(2);
    fprintf('B  = %s\n', B.toString());
    fprintf('B_ = %s\n', B_.toString());
    assert(norm(double(B.expr - B_.expr)) == 0);    
end

