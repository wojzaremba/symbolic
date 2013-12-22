function test_add_expr
    A = fix_exprs(struct('quant', [3, 5, 4], 'expr', [1,2,3,0; 0,2,3,5; 0,0,1,0]'));
    B = fix_exprs(struct('quant', [6, 7], 'expr', [0,2,3,5; 0,1,0,0]'));
    C = add_expr(A, B);
    assert(size(C.expr, 2) == 4);
    assert(norm(sort(C.quant) - [3, 4, 7, 11]) == 0);
end

