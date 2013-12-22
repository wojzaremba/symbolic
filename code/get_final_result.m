function [Fcorrect, coeffs, fail] = get_final_result( X, Y, F )    
    Fcorrect = [];
    coeffs = [];
    invert = quadprog(eye(size(X, 2)), zeros(size(X, 2), 1), [], [], X, Y);    
    error = norm(X * invert - Y);
    fprintf('error : %f\n', error);  
    if (error > 1e-5)
        fail = true;
        return;
    else
        fail = false;      
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