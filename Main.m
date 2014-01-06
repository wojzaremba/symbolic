Init(struct('expr_type', 'Zp', ...
            'complexity', 'O', ...
            'debug', 0, ...
            'power', 2));

totaltime = tic;
S = Scheduler();
S.AddBasicRules();
S.AddMultRules();
S.Run();

Grammar.FullStats();
trim_size(Grammar(1, 1));
marginal = RBM();

[grammar_solved, coeffs] = ReexpresData(marginal.exprs(1), Grammar(1, 1));
ShowResults(coeffs, marginal.normalization(), grammar_solved);
fprintf('total time = %f\n', toc(totaltime));


% Solve normalization issue for symbolic. Podziel przez najwiekszy wspolny
% dzielnik, tak zeby pierwszy wspolrzedna byla dodatnia. Albo jak mam tam
% mod p to tak jak w Zp.