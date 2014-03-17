Init(struct('expr_type', 'symbolic', ...
            'complexity', 'O', ...
            'debug', 2, ...
            'power', 2, ...
            'vars', 1));

totaltime = tic;
S = Scheduler();
S.AddO2Rules();
S.AddO2MultRules();
% S.AddO3Rules();
% S.AddExpRules();
% S.AddOne();
S.Run();

G11 = Grammar(1, 1);
% G11.trim_domain();
target = RBM(2);
Grammar.FullStats();
[grammar_solved, coeffs] = ReexpresData(target.exprs(1), G11);                        
ShowResults(coeffs, target.normalization(), grammar_solved); 

fprintf('total time = %f\n', toc(totaltime));


% Test adding things to Grammar.

% Unify hashes, create class responsible for figuring out linear
% combination. Cache !
% Invariant subspaces !
% Zp per power.
