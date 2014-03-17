classdef SchedulerMock < Scheduler
    
    methods
        function AddMarginalization(S)
            global c
            fprintf('Registering single marginalization\n');
            S.Add(@marginalize, {[c.n, c.m]}, {2});
            S.Add(@marginalize, {[c.n, c.m]}, {1});
            S.Add(@marginalize, {[c.n, 1]}, {1});
            S.Add(@marginalize, {[1, c.m]}, {2});
        end
    end
end