function test_power_expr
    Cache(Inf, 1);
    A = ExprSymbolic([3, 2], [1,0,2,0; 1,2,3,0]');
    fprintf('A = %s\n', A.toString());
    B = A.power_expr(3);
    assert(size(B.expr, 2) == 4);
    expr = {[3, 6, 9, 0], [3, 4, 8, 0], [3, 2, 7, 0], [3, 0, 6, 0]};
    quant = {8, 36, 54, 27};
    for i = 1:length(B)
        valid = false;
        for j = 1:length(quant)
            if (B.quant(i) == int64(quant{j})) && (norm(double(B.expr(:, i) - int64(expr{j}'))) == 0)
                valid = true;
            end
        end
        assert(valid);
    end
    
    A = ExprZp(A.quant, A.expr);
    B_ = ExprZp(B.quant, B.expr);
    B = A.power_expr(3);
    fprintf('B  = %s\n', B.toString());
    fprintf('B_ = %s\n', B_.toString());
    assert(norm(double(B.expr - B_.expr)) == 0);        
end

