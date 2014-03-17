function test_additive_hashes()
    global c
    Cache(20, 1);
    A = ExprSymbolic([3, 5, 4], [1,2,3,0; 0,2,3,5; 0,0,1,0]');
    B = ExprSymbolic([6, 7], [0,2,3,5; 0,1,0,0]');
    C = A.add_expr(B);
    assert(norm(double(mod(C.unnorm_hash - A.unnorm_hash - B.unnorm_hash, c.prime))) == 0);
    
    A = ExprZp(A.quant, A.expr);
    B = ExprZp(B.quant, B.expr);
    C = A.add_expr(B);
    assert(norm(double(mod(C.unnorm_hash - A.unnorm_hash - B.unnorm_hash, c.prime))) == 0);
end

