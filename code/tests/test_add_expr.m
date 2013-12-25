function test_add_expr
    Cache();
    A = Expr([3, 5, 4], [1,2,3,0; 0,2,3,5; 0,0,1,0]');
    B = Expr([6, 7], [0,2,3,5; 0,1,0,0]');
    C = A.add_expr(B);
    assert(size(C.expr, 2) == 4);
    assert(norm(sort(C.quant) - [3, 4, 7, 11]) == 0);
end

