times = zeros(14, 2);
for nidx = 1:size(times, 1)
    fprintf('nidx = %d\n', nidx);
    n = 2^nidx;
    k = n;
    m = n;
    A = randn(n, k);
    B = randn(k, m);

    tic;
    q = sum(sum(A * B));
    times(nidx, 1) = toc;

    tic;    
    w = sum(sum(A .* repmat(sum(B, 2), [1, n])'));
    times(nidx, 2) = toc;
    assert(abs(q - w) < 1e-4);
end

plot(2.^(5:14), times(5:end, 1), 'Color', 'red', 'LineStyle', '--', 'LineWidth', 2);
hold on
plot(2.^(5:14), times(5:end, 2), 'Color', 'blue', 'LineStyle', '-', 'LineWidth', 2);

legend('Original computation', 'Our computation', 'Location', 'NorthWest');

set(gca,'FontSize', 18);
xlabel('Size of matrices');
ylabel('time (s)');
saveas(gcf, '/Users/wojto/symbolic/paper/img/ab.eps');
