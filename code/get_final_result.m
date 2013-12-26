function [expr_matrices, coeffs] = get_final_result( X, Y, F )    
    coeffs = [];
    invert = quadprog(eye(size(X, 2)), zeros(size(X, 2), 1), [], [], X, Y, [], [], [], optimset('Algorithm', 'active-set', 'Display','off'));    
    error = norm(X * invert - Y);
    fprintf('error : %f\n', error);  
    if (error > 1e-5)
        fprintf('Couldnt find solution\n');
        assert(0);
    end
    
    expr_matrices = {};
    for i = 1:length(invert)
        if (abs(invert(i)) < 1e-5)
            continue;
        end
        expr_matrices{end + 1} = F.expr_matrices(i);
        coeffs = [coeffs; invert(i)];
    end   
    fprintf('nr coeffs = %d\n', length(coeffs));
end