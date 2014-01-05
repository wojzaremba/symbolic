% XXX : Reverse engineer previous X4() working solution !!!!!!
% XXXX : If it doesn't work. write tests for transpose and mult. !!!!!

global expr_type debug
% Two options : Zp, and symbolic. Zp is much faster.
expr_type = 'Zp'; 
debug = 0;
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

global grammars c
save('~/grammar', 'grammars', 'c');

% Check if here are all from X4 
% Check if here are all from X4 
% Check if here are all from X4 
% Check if here are all from X4 
% Check if here are all from X4 
% Check if here are all from X4 
% Make sure that there is no hash collision, verify it by setting random
% real values (maybe even write a Expr). Maybe my hash is order invariant,
% and it kills too much.


% trim_size(Grammar(1, 1));
% 
% marginal = RBM();
% 
% [grammar_solved, coeffs] = reexpres_data(marginal.exprs(1), Grammar(1, 1));
% show_results(coeffs, marginal.normalization(), grammar_solved);
% fprintf('total time = %f\n', toc(totaltime));
