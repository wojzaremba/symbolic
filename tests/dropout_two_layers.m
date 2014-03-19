function [objective, dW1, dW2] = dropout_two_layers(X, Y, W1, W2)
    G = size(W1, 1);
    F = size(W1, 2);
    H = size(W2, 1);
    B = size(X, 2);
    dW1 = zeros(size(W1));
    dW2 = zeros(size(W2));
    objective = 0;
    for i = 0 : (2^(F * B) - 1)
        M1 = zeros(F, B);
        for k = 0 : (F * B - 1)
            M1(k + 1) = logical(bitand(i, 2^k));
        end

        for j = 0 : (2^(G * B) - 1)
            M2 = zeros(G, B);
            for k = 0 : (G * B - 1)
                M2(k + 1) = logical(bitand(j, 2^k));
            end    
%             M1(:) = 1;
%             M2(:) = 1;            
            
            
            objective = objective + sum(sum((W2 * ((W1 * (X .* M1)) .* M2) - Y) .^ 2));
            dW2 = dW2 + 2 * (W2 * (((W1 * (X .* M1)) .* M2)) - Y) * ((W1 * (X .* M1)) .* M2)';
            
%             dW1 = dW1 + 2 * (W2' * (W2 * ((W1 * (X .* M1)) .* M2) - Y) .* M2) * (X .* M1)';
            dW1 = dW1 + 2 * (W2' * (W2 * ((W1 * (X .* M1)) .* M2)) .* M2) * (X .* M1)';
            dW1 = dW1 - 2 * ((W2' * Y) .* M2) * (X .* M1)';
        end        
    end
end