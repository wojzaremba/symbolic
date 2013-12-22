len = 16;
times_n3 = zeros(len, 1);
times_n2 = zeros(len, 1);
for n_ = 1:len
    fprintf('n_ = %d\n', n_);
    n = 2^n_;
    W = randn(n, n);
    tic 
    Q = W * W';
    val1 = sum(Q(:));   
    times_n3(n_) = toc;
    tic
    val2 = sum(sum(( W .* repmat(sum(W, 1), [n, 1])), 2), 1);
    times_n2(n_) = toc;
    assert(abs(val1 - val2) < 1e-4);
end

