Init(struct('expr_type', 'Zp', ...
            'complexity', 'O', ...
            'debug', 0, ...
            'power', 2, ...
            'vars', 1));

totaltime = tic;
S = Scheduler();
S.AddO2Rules();
S.AddO2MultRules();
S.AddO3Rules();
S.Run();

G11 = Grammar(1, 1);
target = RBM();
Grammar.FullStats();
[grammar_solved, coeffs] = ReexpresData(target.exprs(1), G11);                        
ShowResults(coeffs, target.normalization(), grammar_solved); 

fprintf('total time = %f\n', toc(totaltime));