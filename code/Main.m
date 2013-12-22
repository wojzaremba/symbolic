%%%%%% XXXXXX Try to express as symetric polynomials ok ^l and marginalization

clc;
clear;
Init();
global lang
lang = 'matlab';

% Power for which we look for a rule. The only parameter to specify.
% For K = 4 computation takes ~10h. For K = 2 it takes 15 seconds.
K = 3; 
% This is a minimum size that gives 
% rise to non-planar graph. For such a graph it is difficult to compute Z.
ones_size = 0;
data_size = 2 * K;
maxk2 = 1;
computation_time = tic;
fprintf('Power = %d\nSize of data = %d\n', K, data_size);
[v_fixed, h_fixed] = get_fixed_data(ones_size, data_size);
marginal = compute_marginal_mult(v_fixed, h_fixed, K);
[grammar, dgrammar] = find_grammar(v_fixed, h_fixed, K);
grammar = trim_size(grammar, K, K);
[X, Y] = encode_data(grammar, marginal, K);
[grammar_solved, coeffs, fail] = get_final_result(X, Y, grammar);

if (fail)
  fprintf('Game over fail = %d\n', fail);
  return;  
end

fprintf('So far, so good !\n');
normalization = 2^(sum(v_fixed == Inf) + sum(h_fixed == Inf));
show_results(coeffs, normalization, grammar_solved);