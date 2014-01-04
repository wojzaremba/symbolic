
global expr_type c
% Two options : Zp, and symbolic. Zp is much faster.
expr_type = 'Zp'; 
% Indicates for which power we are looking for a formula discovery.
power = 2;

clc;
addpath(genpath('.'));
totaltime = tic;
Cache(power);

computation_time = tic;

fprintf('setting up a grammar\n');
u = 1;
fprintf('grammar started\n');
while (norm(u) > 0)
    single_iter_time = tic;
    u(:) = 0;
    u(1) = marginalize(Grammar(c.n, c.m), 2);
    u(2) = marginalize(Grammar(c.m, c.n), 2);    
    u(3) = marginalize(Grammar(c.m, c.m), 2);
    u(4) = marginalize(Grammar(c.n, c.n), 2);    
    
    u(5) = marginalize(Grammar(c.n, c.m), 1);
    u(6) = marginalize(Grammar(c.m, c.n), 1);    
    u(7) = marginalize(Grammar(c.m, c.m), 1);
    u(8) = marginalize(Grammar(c.n, c.n), 1);    
       
    u(9) = marginalize(Grammar(c.n, 1), 1);
    u(10) = marginalize(Grammar(1, c.n), 1);    
    u(11) = marginalize(Grammar(1, c.m), 2);
    u(12) = marginalize(Grammar(c.m, 1), 2);        

    u(13) = elementwise_multiply(Grammar(c.n, c.m));
    u(14) = elementwise_multiply(Grammar(c.m, c.n));    
    u(15) = elementwise_multiply(Grammar(c.n, c.n));    
    u(16) = elementwise_multiply(Grammar(c.m, c.m));
    u(17) = elementwise_multiply(Grammar(c.n, 1));
    u(18) = elementwise_multiply(Grammar(1, c.n));    
    u(19) = elementwise_multiply(Grammar(c.m, 1));    
    u(20) = elementwise_multiply(Grammar(1, c.m));
    u(21) = elementwise_multiply(Grammar(1, 1));
    
    u(22) = repmat_expr(Grammar(c.n, 1), [c.n, c.n]);
    u(23) = repmat_expr(Grammar(c.n, 1), [c.n, c.m]);      
    u(24) = repmat_expr(Grammar(1, c.m), [c.n, c.m]);  
    u(25) = repmat_expr(Grammar(1, c.m), [c.m, c.m]);    
    u(26) = repmat_expr(Grammar(1, 1), [c.n, 1]);  
    u(27) = repmat_expr(Grammar(1, 1), [c.m, 1]);    
    u(28) = repmat_expr(Grammar(1, 1), [1, c.n]);  
    u(29) = repmat_expr(Grammar(1, 1), [1, c.m]);      
    
    u(30) = transpose(Grammar(c.n, c.m));
    u(31) = transpose(Grammar(c.n, c.n));
    u(32) = transpose(Grammar(c.m, c.m));    
    u(33) = transpose(Grammar(c.n, 1));
    u(34) = transpose(Grammar(1, c.m));
    u(35) = transpose(Grammar(c.m, c.n));
    u(36) = transpose(Grammar(1, c.n));
    u(37) = transpose(Grammar(c.m, 1));
    
    u(38) = multiply(Grammar(c.n, c.m), Grammar(c.m, 1));
    u(39) = multiply(Grammar(c.n, c.m), Grammar(c.m, c.n));
    u(40) = multiply(Grammar(c.n, c.m), Grammar(c.m, c.m));
    u(41) = multiply(Grammar(c.n, 1), Grammar(1, 1));
    u(42) = multiply(Grammar(c.n, 1), Grammar(1, c.n));
    u(43) = multiply(Grammar(c.n, 1), Grammar(1, c.m));    
    u(44) = multiply(Grammar(c.n, c.n), Grammar(c.n, 1));
    u(45) = multiply(Grammar(c.n, c.n), Grammar(c.n, c.n));
    u(46) = multiply(Grammar(c.n, c.n), Grammar(c.n, c.m));
    
    u(47) = multiply(Grammar(c.m, c.m), Grammar(c.m, 1));
    u(48) = multiply(Grammar(c.m, c.m), Grammar(c.m, c.n));
    u(49) = multiply(Grammar(c.m, c.m), Grammar(c.m, c.m));
    u(50) = multiply(Grammar(c.m, 1), Grammar(1, 1));
    u(51) = multiply(Grammar(c.m, 1), Grammar(1, c.n));
    u(52) = multiply(Grammar(c.m, 1), Grammar(1, c.m));    
    u(53) = multiply(Grammar(c.m, c.n), Grammar(c.n, 1));
    u(54) = multiply(Grammar(c.m, c.n), Grammar(c.n, c.n));
    u(55) = multiply(Grammar(c.m, c.n), Grammar(c.n, c.m));         
    
    u(56) = multiply(Grammar(1, c.m), Grammar(c.m, 1));
    u(57) = multiply(Grammar(1, c.m), Grammar(c.m, c.n));
    u(58) = multiply(Grammar(1, c.m), Grammar(c.m, c.m));
    u(59) = multiply(Grammar(1, 1), Grammar(1, 1));
    u(60) = multiply(Grammar(1, 1), Grammar(1, c.n));
    u(61) = multiply(Grammar(1, 1), Grammar(1, c.m));    
    u(62) = multiply(Grammar(1, c.n), Grammar(c.n, 1));
    u(63) = multiply(Grammar(1, c.n), Grammar(c.n, c.n));
    u(64) = multiply(Grammar(1, c.n), Grammar(c.n, c.m));         
    
    % Checks if there is enough mod p evaluations of polynomial
    % to recover coefficients.
    G11 = Grammar(1, 1);
    assert(length(G11.expr_matrices) < 0.9 * ExprZp.len);
    
    fprintf('single iter takes = %f, updates = sum(u)\n', toc(single_iter_time));
end

Grammar.FullStats();
trim_size(Grammar(1, 1));

marginal = RBM();

[grammar_solved, coeffs] = reexpres_data(marginal.exprs(1), Grammar(1, 1));
show_results(coeffs, marginal.normalization(), grammar_solved);
fprintf('total time = %f\n', toc(totaltime));







Hi Yoram,

I have done a tremendous progress on the paper on RBM (right now theme is very different). I have finished all the experiments.
Would you be interest in contributing paper by writing, and revising some sections ? If yes, please let me know on which section would you like to work.



Best regards,
Wojciech


