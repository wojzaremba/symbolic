clc;
addpath(genpath('.'));
totaltime = tic;
global expr_type c
expr_type = 'Zp';
Cache(2);

computation_time = tic;

fprintf('setting up a grammar\n');
u = 1;
fprintf('grammar started\n');
while (norm(u) > 0)
    single_iter_time = tic;
    u(:) = 0;
    u(1) = marginalize(Grammar(c.n, c.m), 2);
    u(2) = marginalize(Grammar(c.n, c.m), 1);
    
    u(3) = marginalize(Grammar(c.n, 1), 1);
    u(4) = marginalize(Grammar(1, c.m), 2);

    u(5) = elementwise_multiply(Grammar(c.n, c.m));
    u(6) = elementwise_multiply(Grammar(c.n, 1));        
    u(7) = elementwise_multiply(Grammar(1, c.m));
    u(8) = elementwise_multiply(Grammar(1, 1));
    
    u(9) = repmat_expr(Grammar(c.n, 1), 2);  
    u(10) = repmat_expr(Grammar(1, c.m), 1);  
    u(11) = repmat_expr(Grammar(1, 1), 1);  
    u(12) = repmat_expr(Grammar(1, 1), 2);  
    
    G11 = Grammar(1, 1);
    assert(length(G11.expr_matrices) < 0.9 * ExprZp.len);
    
    fprintf('single iter takes = %f\n', toc(single_iter_time));
end

trim_size(Grammar(1, 1));
marginal = RBM();

[grammar_solved, coeffs] = reexpres_data(marginal.exprs(1), Grammar(1, 1));
show_results(coeffs, marginal.normalization(), grammar_solved);
fprintf('total time = %f\n', toc(totaltime));



