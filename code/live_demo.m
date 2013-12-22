m = 5200;
n = 5000;
W = randn(n, m);
tic
Q = W * W' * W;
toc

sum(Q(:))
tic
P = (sum(sum(( ( W .* repmat(sum(W, 2), [1, m])) .* repmat(sum(W, 1), [n, 1])), 2), 1) );
toc
sum(P(:))
