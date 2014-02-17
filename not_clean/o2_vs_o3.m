load('~/o3', 'Q');
load('~/o2', 'W');
Q = Q.expr_matrices;
W = W.expr_matrices;

for i = 1:length(Q)
   fprintf('Q(%d) = %s, complexity = %d\n', i, Q(i).toString, Q(i).computation.complexity); 
   fprintf('W(%d) = %s, complexity = %d\n', i, W(i).toString, W(i).computation.complexity); 
   fprintf('\n');
end


A = randn(3, 4);
sum(sum(( ( A * (A')) .* ( A * (A'))), 1), 2)
