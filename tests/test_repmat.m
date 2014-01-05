function test_repmat
    global expr_type
    expr_type = 'Zp'; 
    Cache(20);
    A = ExprZp([3, 5, 4], [1,2,3,0; 0,2,3,5; 0,0,1,0]');
    B = ExprZp([6, 7], [0,2,3,5; 0,1,0,0]');
    exprs = ExprZp();
    exprs(1, 1) = A;
    exprs(1, 2) = A;
    for i = 2:3
        for j = 1:2
            exprs(i, j) = B;
        end
    end
    M = ExprMatrix(exprs, Matrix('M', 2, 3));
    MargM = marginalize(M, 2);
    MScaled = repmat_expr(MargM, [1, 2]);
    assert(sum(MScaled.hash - M.hash) == 0);
    
    MargM = marginalize(M, 1);
    MScaled = repmat_expr(MargM, [3, 1]);
    assert(length(MScaled.hash) ~= length(M.hash) || sum(MScaled.hash - M.hash) ~= 0);    
    
    % Checks if repmat verifies correctly sizes.
    passed = true;
    try
        repmat_expr(MargM, [3, 2]);       
        passed = false;
    catch        
    end
    assert(passed);
    
    passed = true;
    try
        repmat_expr(MargM, [1, 2]);       
        passed = false;
    catch        
    end
    assert(passed);    
end

