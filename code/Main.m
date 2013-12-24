clc;
clear;
Init();
totaltime = tic;
global lang
lang = 'matlab';

K = 4; 
data_size = 2 * K;
maxk2 = 1;
computation_time = tic;
fprintf('Power = %d\nSize of data = %d\n', K, data_size);
[v_fixed, h_fixed] = get_fixed_data(data_size);
marginal = compute_marginal_rbm(v_fixed, h_fixed, K);
[grammar, dgrammar] = find_grammar(v_fixed, h_fixed, K);
fprintf('grammar size = %d\n', length(grammar));
tgrammar = trim_size(grammar, K, K);
[X, Y] = encode_data(tgrammar, marginal, K);
[grammar_solved, coeffs, fail] = get_final_result(X, Y, tgrammar);

if (fail)
  fprintf('Game over fail = %d\n', fail);
  return;  
end

fprintf('So far, so good !\n');
normalization = 2^(sum(v_fixed == Inf) + sum(h_fixed == Inf));
show_results(coeffs, normalization, grammar_solved);
fprintf('total time = %f\n', toc(totaltime));