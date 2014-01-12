n = 10;
m = 20;
W = randn(n, m);
Q = sum(sum(W * W'));
T = (( ( sum(( sum(W, 1) .* sum(W, 1)), 2) .* 1)));
assert(abs(Q - T) < 1e-4);

Q = sum(sum(W * W' * W));
T = (( (sum(sum(( ( repmat(sum(W, 2), [1, m]) .* repmat(sum(W, 1), [n, 1])) .* W), 2), 1)  .* 1)));
assert(abs(Q - T) < 1e-4);

