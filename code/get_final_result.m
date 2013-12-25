function [Fcorrect, coeffs] = get_final_result( X, Y, F )    
    Fcorrect = [];
    coeffs = [];
    invert = quadprog(eye(size(X, 2)), zeros(size(X, 2), 1), [], [], X, Y, [], [], [], optimset('Algorithm', 'active-set', 'Display','off'));    
    error = norm(X * invert - Y);
    fprintf('error : %f\n', error);  
    if (error > 1e-5)
        return;
    else
        assert(0);
    end
    
    for i = 1:length(invert)
        if (abs(invert(i)) < 1e-5)
            continue;
        end
        Fcorrect{end + 1} = F{i};
        coeffs = [coeffs; invert(i)];
    end   
    fprintf('nr coeffs = %d\n', length(coeffs));
end