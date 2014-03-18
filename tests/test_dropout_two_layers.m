F = 2;
B = 4;
G = 2;
H = 3;

W1 = randn(G, F);
W2 = randn(H, G);
X = randn(F, B);
Y = randn(H, B);

dW1 = zeros(size(W1));
dW2 = zeros(size(W2));
for i = 0 : (2^(F * B) - 1)
    M1 = zeros(F, B);
    for k = 0 : (F * B - 1)
        M1(k + 1) = logical(bitand(i, 2^k));
    end
    
    for j = 0 : (2^(G * B) - 1)
        M2 = zeros(G, B);
        for k = 0 : (G * B - 1)
            M2(k + 1) = logical(bitand(i, 2^k));
        end    
    end
%     objective = (W2 * (W1 * (X .* M1) .* M2) - Y)
%     dW2 = dW2 + (W2 * ((W1 * (X .* M1)) .* M2) - Y) * ((W1 * (X .* M1)) .* M2)';
%     dW2 = dW2 - Y * ((W1 * (X .* M1)) .* M2)';
    dW2 = dW2 - Y * ((W1 * (X )) .* M2)';
end

I = eye(F);

dW2_short = Y * X' * W1';

assert(std(dW2(:) ./ dW2_short(:)) < 1e-4);