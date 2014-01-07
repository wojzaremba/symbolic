Init(struct('expr_type', 'Zp', ...
            'complexity', 'O', ...
            'debug', 0, ...
            'power', 5));

totaltime = tic;
S = Scheduler();
S.AddBasicRules();
S.AddMultRules();
S.SetTarget(RBM());
S.Run();
fprintf('total time = %f\n', toc(totaltime));


% Solve normalization issue for symbolic. Podziel przez najwiekszy wspolny
% dzielnik, tak zeby pierwszy wspolrzedna byla dodatnia. Albo jak mam tam
% mod p to tak jak w Zp.

% Maybe longer computation is neccessary to find cheaper rules .... (so
% looking for solution before doesn't pay).