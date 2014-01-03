function test_add_expr
    Cache(20);
    A = ExprSymbolic([3, 5, 4], [1,2,3,0; 0,2,3,5; 0,0,1,0]');
    B = ExprSymbolic([6, 7], [0,2,3,5; 0,1,0,0]');
    C = A.add_expr(B);
    assert(size(C.expr, 2) == 4);
    assert(norm(sort(C.quant) - [3, 4, 7, 11]) == 0);
    
    A = ExprZp(A.quant, A.expr);
    B = ExprZp(B.quant, B.expr);
    C_ = ExprZp(C.quant, C.expr);
    C = A.add_expr(B);
    fprintf('%s\n', C.toString());
    assert(norm(C.expr - C_.expr) == 0);        
end

