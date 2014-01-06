Init(struct('expr_type', 'Zp', ...
            'complexity', 'O', ...
            'debug', 0, ...
            'power', 4));

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


%%%%% XXX : Make sure that generated rule for X4 generalizes !!!!!!!!!!!!!!
%%%%% XXX : Find smallest complexity solution (prefer .* over *)

% Check what is really smallest size for k = 4
% Verify that symbolic works as well !!!


% Solve normalization issue for symbolic.