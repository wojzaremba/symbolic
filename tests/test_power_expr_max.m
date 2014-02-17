function test_power_expr_max
    cache = Cache(5, 1);
    A = ExprSymbolic([3, 2, 2], [1,0,2,0; 1,2,3,0; 0,0,0,1]');
    B = A.power_expr(4);
    assert(size(B, 2) == 1);
    val = cell(1, 1);
    expr = {[0, 0, 0, 4]};
    quant = {2^4};
    hashes = [];
    for i = 1:length(B)
        hashes = [hashes, Cache.hash_expr(expr{i}')];
    end
    [~, idx] = sort(hashes);
    expr = expr(idx);
    quant = quant(idx);
    for i = 1:length(B)
        assert(B.quant(i) == quant{i});
        assert(norm(double(B.expr(:, i) - int64(expr{i}'))) == 0);
    end
end

