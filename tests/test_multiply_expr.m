function test_multiply_expr
    Cache(10, 1);
    A = ExprSymbolic([3, 5, 4], [1,2,3,0; 0,2,3,5; 0,0,1,0]');
    B = ExprSymbolic([6, 7], [0,2,3,5; 0,1,0,0]');
    C = A.multiply_expressions(B);
    assert(size(C.expr, 2) == 6);
    assert(norm(double(sort(C.quant) - int64(sort([28, 21, 35, 24, 18, 30])))) == 0);
    
    A = ExprZp(A.quant, A.expr);
    B = ExprZp(B.quant, B.expr);
    C_ = ExprZp(C.quant, C.expr);
    C = A.multiply_expressions(B);
    fprintf('%s\n', C.toString());
    assert(norm(double(C.expr - C_.expr)) == 0);        
end




% 28 b c + 
% 21 a b^3 c^3 + 
% 35 b^3 c^3 d^5 + 
% 24 b^2 c^4 d^5 + 
% 18 a b^4 c^6 d^5 + 
% 30 b^4 c^6 d^10