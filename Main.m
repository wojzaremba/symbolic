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
S.SetTarget(RBM());
S.Run();
fprintf('total time = %f\n', toc(totaltime));


% Solve normalization issue for symbolic. Podziel przez najwiekszy wspolny
% dzielnik, tak zeby pierwszy wspolrzedna byla dodatnia. Albo jak mam tam
% mod p to tak jak w Zp.


% XXX : In case of repmat in computation provide dim, and size !!! There is
% a bug (for power >= 6)