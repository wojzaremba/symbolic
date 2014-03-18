F = 3;
B = 4;
G = 2;

W = randn(G, F);
X = randn(F, B);
Y = randn(G, B);

dW = zeros(size(W));
for i = 0 : (2^(F * B) - 1)
    M = zeros(F, B);
    for k = 0 : (F * B - 1)
        M(k + 1) = logical(bitand(i, 2^k));
    end
    dW = dW + (W * (X .* M) - Y) * (X .* M)';
end

I = eye(F);

dW_short = 0.5 * W * (X * X' + (X * X') .* I) - Y * X';

assert(std(dW(:) ./ dW_short(:)) < 1e-4);