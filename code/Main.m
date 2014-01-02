clc;
addpath(genpath('.'));
totaltime = tic;
global expr_type
expr_type = 'Zp';
Cache(2);

computation_time = tic;

fprintf('setting up a grammar\n');
u = 1;
fprintf('grammar started\n');
while (norm(u) > 0)
    single_iter_time = tic;
    u(:) = 0;
    u(1) = marginalize(Grammar(1, 1), 2);
    u(2) = marginalize(Grammar(1, 1), 1);
    
    u(3) = marginalize(Grammar(1, 0), 1);
    u(4) = marginalize(Grammar(0, 1), 2);

    u(5) = elementwise_multiply(Grammar(1, 1), Grammar(1, 1));
    u(6) = elementwise_multiply(Grammar(1, 1), Grammar(1, 0));
    u(7) = elementwise_multiply(Grammar(1, 1), Grammar(0, 1));
    u(8) = elementwise_multiply(Grammar(1, 1), Grammar(0, 0));

    u(9) = elementwise_multiply(Grammar(1, 0), Grammar(1, 0));
    u(10) = elementwise_multiply(Grammar(1, 0), Grammar(0, 0));
        
    u(11) = elementwise_multiply(Grammar(0, 1), Grammar(0, 1));
    u(12) = elementwise_multiply(Grammar(0, 1), Grammar(0, 0));
    
    u(13) = elementwise_multiply(Grammar(0, 0), Grammar(0, 0));
    
    fprintf('single iter takes = %f\n', toc(single_iter_time));
end
trim_size(Grammar(0, 0));
marginal = RBM();
[X, Y] = encode_data(Grammar(0, 0), marginal.exprs(1));
[grammar_solved, coeffs] = get_final_result(X, Y, Grammar(0, 0));

fprintf('So far, so good !\n');

show_results(coeffs, marginal.normalization(), grammar_solved);
fprintf('total time = %f\n', toc(totaltime));


% XXX: wywalic w hashowaniu mnozenie
% XXX: pomyslec o napisaniu tego w integer mod p !!!!!


