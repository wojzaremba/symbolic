clc;
% addpath(genpath('../'));
global debug
debug = 1;
fun = Complex({1, 1, 1 / 2, 1 / 6, 1 / 24, 1 / 120, 1 / 720}, {One(), X(), X2(), X3(), X4(), X5(), X6()});
range = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024];
times_opt = zeros(length(range), 1);
times_num = zeros(length(range), 1);
for k = 1 : length(range);
    W = TestData(range(k), range(k));
    printf('k = %d, fun name = %s\n', range(k), fun.name);
    num = Numerical(Exp());
    tic;
    logZ = fun.FP(W);
    times_opt(k) = toc;
    if (range(k) > 8)
        continue
    end
    tic;
    num_logZ = num.FP(W);  
    times_num(k) = toc;
end

figure(1)
hold on
short = 1:3;
loglog(range(short), times_num(short), 'Color', 'red', 'LineStyle', '--', 'LineWidth', 2);
loglog(range, times_opt(:), 'Color', 'blue', 'LineStyle', '-', 'LineWidth', 2);

l = legend('\fontsize{14}{0}\selectfont Naive computation of $g(x \rightarrow e^x, W)$ ', ...
           '\fontsize{14}{0}\selectfont Our computation of $g(x \rightarrow 1 + ... + \frac{x^6}{5!}, W)$', ...
           'Location', 'North');
set(l, 'Interpreter', 'Latex', 'XColor', [1 1 1], 'YColor', [1 1 1]);

set(gca,'FontSize', 18);
xlabel('Size of weight matrix');
ylabel('time (s)');

