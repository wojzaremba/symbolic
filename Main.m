% XXXX : If it doesn't work. write tests for transpose and mult. !!!!!

global expr_type
% Two options : Zp, and symbolic. Zp is much faster.
expr_type = 'Zp'; 
% Indicates for which power we are looking for a formula discovery.
power = 4;

clc;
addpath(genpath('.'));
totaltime = tic;
Cache(power);

computation_time = tic;

fprintf('setting up a grammars\n');
S = Scheduler();
S.AddBasicRules();
S.AddMultRules();
S.Run();

Grammar.FullStats();
trim_size(Grammar(1, 1));

marginal = RBM();

[grammar_solved, coeffs] = reexpres_data(marginal.exprs(1), Grammar(1, 1));
show_results(coeffs, marginal.normalization(), grammar_solved);
fprintf('total time = %f\n', toc(totaltime));
