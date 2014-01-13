Init(struct('expr_type', 'Zp', ...
            'complexity', 'O', ...
            'debug', 0, ...
            'power', 4, ...
            'vars', 4));

totaltime = tic;
S = Scheduler();
S.AddO2Rules();
% S.AddO2MultRules();
% S.AddO3Rules();
S.SetTarget(MultExpr());
S.Run();
fprintf('total time = %f\n', toc(totaltime));


% Solve normalization issue for symbolic. Podziel przez najwiekszy wspolny
% dzielnik, tak zeby pierwszy wspolrzedna byla dodatnia. Albo jak mam tam
% mod p to tak jak w Zp.


% XXX :add constaint that all the pices have to be from different vars. !!!!!
% XXX : change back c.n and c.m to maxk