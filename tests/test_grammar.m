clear all
Init(struct('expr_type', 'symbolic', ...
            'complexity', 'O', ...
            'debug', 0, ...
            'power', 1, ...
            'vars', 1));

totaltime = tic;
S = SchedulerMock();
S.AddMarginalization();
S.Run();
global grammars
sizes = [1, 0, 1; 1, 0, 1];
for i = 1:size(sizes, 1)
    for j = 1:size(sizes, 2)
        assert(length(grammars(i, j).expr_matrices) == sizes(i, j));
    end
end