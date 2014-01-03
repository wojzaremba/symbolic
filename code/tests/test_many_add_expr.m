function test_many_add_expr
    Cache(10);
    A = ExprSymbolic([3, 5, 4], [1,2,3,0; 0,2,3,5; 0,0,1,0]');
    B = ExprSymbolic([6, 7], [0,2,3,5; 0,1,0,0]');
    C = ExprSymbolic().add_many_expr({A, A, B, B});
    assert(size(C.expr, 2) == 4);
    assert(norm(sort(C.quant) - 2 * [3, 4, 7, 11]) == 0);
    
    A = ExprZp(A.quant, A.expr);
    B = ExprZp(B.quant, B.expr);
    C_ = ExprZp(C.quant, C.expr);
    C = ExprZp().add_many_expr({A, A, B, B});
    fprintf('%s\n', C.toString());
    assert(norm(C.expr - C_.expr) == 0);        
end

