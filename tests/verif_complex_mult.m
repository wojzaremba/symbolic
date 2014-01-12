W = randn(10, 20);
Q = sum(sum(W * W'));
T = (( ( sum(( sum(W, 1) .* sum(W, 1)), 2) .* 1)));
assert(abs(Q - T) < 1e-4);