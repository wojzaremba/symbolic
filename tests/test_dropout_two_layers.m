% clear all
% F = 2;
% B = 3;
% G = 4;
% H = 5;
F = 2;
B = 3;
G = 3;
H = 3;

randn('seed', 1);
W1 = randn(G, F);
W2 = randn(H, G);
X = randn(F, B);
Y = randn(H, B);
eps = 1e-6;

% W2(1) = W2(1) + eps;
W1(1) = W1(1) + eps;
[objective1, dW1, dW2] = dropout_two_layers(X, Y, W1, W2);
% W2(1) = W2(1) - 2 * eps;
W1(1) = W1(1) - 2 * eps;
[objective2, dW1, dW2] = dropout_two_layers(X, Y, W1, W2);

% assert(norm(dW2(1) - (objective1 - objective2) / (2 * eps)) / norm(dW2(1)) < 1e-3);
assert(norm(dW1(1) - (objective1 - objective2) / (2 * eps)) / norm(dW1(1)) < 1e-3);

fprintf('objective = %f\n', objective1);
I1 = eye(F);
I2 = eye(G);

dW2_short = W2 * W1 * (X * X') * W1' + W2 * W1 * ((X * X') .* I1) * W1' + W2 * ((W1 * ((X * X') .* I1) * W1') .* I2) + W2 * ((W1 * (X * X') * W1') .* I2) - 4 * Y * X' * W1';
dW1_short = (W2' * W2) * W1 * (X * X') + ...
            ((W2' * W2) .* I2) * W1 * (X * X') + ...
            ((W2' * W2) .* I2) * W1 * ((X * X') .* I1) + ...
            (W2' * W2) * W1 * ((X * X') .* I1) - ...
            4 *(W2' * Y) * X';

dW1(:) ./ dW1_short(:)
assert(std(dW1(:) ./ dW1_short(:)) < 1e-4);

dW2(:) ./ dW2_short(:)
assert(std(dW2(:) ./ dW2_short(:)) < 1e-4);