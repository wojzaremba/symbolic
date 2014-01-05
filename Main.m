% XXXX : Cos jest jeszcze popsute. power = 2 should work !!!!!


global expr_type c
% Two options : Zp, and symbolic. Zp is much faster.
expr_type = 'Zp'; 
% Indicates for which power we are looking for a formula discovery.
power = 2;

clc;
addpath(genpath('.'));
totaltime = tic;
Cache(power);

computation_time = tic;

fprintf('setting up a grammars\n');
S = Scheduler();

S.Add(@marginalize, {Grammar(c.n, c.m)}, {2});
S.Add(@marginalize, {Grammar(c.m, c.n)}, {2});    
S.Add(@marginalize, {Grammar(c.m, c.m)}, {2});
S.Add(@marginalize, {Grammar(c.n, c.n)}, {2});    
    
S.Add(@marginalize, {Grammar(c.n, c.m)}, {1});
S.Add(@marginalize, {Grammar(c.m, c.n)}, {1});    
S.Add(@marginalize, {Grammar(c.m, c.m)}, {1});
S.Add(@marginalize, {Grammar(c.n, c.n)}, {1});    
       
S.Add(@marginalize, {Grammar(c.n, 1)}, {1});
S.Add(@marginalize, {Grammar(1, c.n)}, {1});    
S.Add(@marginalize, {Grammar(1, c.m)}, {2});
S.Add(@marginalize, {Grammar(c.m, 1)}, {2});        

S.Add(@elementwise_multiply, {Grammar(c.n, c.m), Grammar(c.n, c.m)}, {});
S.Add(@elementwise_multiply, {Grammar(c.m, c.n), Grammar(c.m, c.n)}, {});    
S.Add(@elementwise_multiply, {Grammar(c.n, c.n), Grammar(c.n, c.n)}, {});    
S.Add(@elementwise_multiply, {Grammar(c.m, c.m), Grammar(c.m, c.m)}, {});
S.Add(@elementwise_multiply, {Grammar(c.n, 1), Grammar(c.n, 1)}, {});
S.Add(@elementwise_multiply, {Grammar(1, c.n), Grammar(1, c.n)}, {});    
S.Add(@elementwise_multiply, {Grammar(c.m, 1), Grammar(c.m, 1)}, {});   
S.Add(@elementwise_multiply, {Grammar(1, c.m), Grammar(1, c.m)}, {});
S.Add(@elementwise_multiply, {Grammar(1, 1), Grammar(1, 1)}, {});
    
S.Add(@repmat_expr, {Grammar(c.n, 1)}, {[c.n, c.n]});
S.Add(@repmat_expr, {Grammar(c.n, 1)}, {[c.n, c.m]});      
S.Add(@repmat_expr, {Grammar(1, c.m)}, {[c.n, c.m]});  
S.Add(@repmat_expr, {Grammar(1, c.m)}, {[c.m, c.m]});    
S.Add(@repmat_expr, {Grammar(1, 1)}, {[c.n, 1]});  
S.Add(@repmat_expr, {Grammar(1, 1)}, {[c.m, 1]});    
S.Add(@repmat_expr, {Grammar(1, 1)}, {[1, c.n]});  
S.Add(@repmat_expr, {Grammar(1, 1)}, {[1, c.m]});      
    
S.Add(@transpose, {Grammar(c.n, c.m)}, {});
S.Add(@transpose, {Grammar(c.n, c.n)}, {});
S.Add(@transpose, {Grammar(c.m, c.m)}, {});    
S.Add(@transpose, {Grammar(c.n, 1)}, {});
S.Add(@transpose, {Grammar(1, c.m)}, {});
S.Add(@transpose, {Grammar(c.m, c.n)}, {});
S.Add(@transpose, {Grammar(1, c.n)}, {});
S.Add(@transpose, {Grammar(c.m, 1)}, {});
    
S.Add(@multiply, {Grammar(c.n, c.m), Grammar(c.m, 1)}, {});
S.Add(@multiply, {Grammar(c.n, c.m), Grammar(c.m, c.n)}, {});
S.Add(@multiply, {Grammar(c.n, c.m), Grammar(c.m, c.m)}, {});
S.Add(@multiply, {Grammar(c.n, 1), Grammar(1, 1)}, {});
S.Add(@multiply, {Grammar(c.n, 1), Grammar(1, c.n)}, {});
S.Add(@multiply, {Grammar(c.n, 1), Grammar(1, c.m)}, {});    
S.Add(@multiply, {Grammar(c.n, c.n), Grammar(c.n, 1)}, {});
S.Add(@multiply, {Grammar(c.n, c.n), Grammar(c.n, c.n)}, {});
S.Add(@multiply, {Grammar(c.n, c.n), Grammar(c.n, c.m)}, {});
    
S.Add(@multiply, {Grammar(c.m, c.m), Grammar(c.m, 1)}, {});
S.Add(@multiply, {Grammar(c.m, c.m), Grammar(c.m, c.n)}, {});
S.Add(@multiply, {Grammar(c.m, c.m), Grammar(c.m, c.m)}, {});
S.Add(@multiply, {Grammar(c.m, 1), Grammar(1, 1)}, {});
S.Add(@multiply, {Grammar(c.m, 1), Grammar(1, c.n)}, {});
S.Add(@multiply, {Grammar(c.m, 1), Grammar(1, c.m)}, {});    
S.Add(@multiply, {Grammar(c.m, c.n), Grammar(c.n, 1)}, {});
S.Add(@multiply, {Grammar(c.m, c.n), Grammar(c.n, c.n)}, {});
S.Add(@multiply, {Grammar(c.m, c.n), Grammar(c.n, c.m)}, {});         
    
S.Add(@multiply, {Grammar(1, c.m), Grammar(c.m, 1)}, {});
S.Add(@multiply, {Grammar(1, c.m), Grammar(c.m, c.n)}, {});
S.Add(@multiply, {Grammar(1, c.m), Grammar(c.m, c.m)}, {});
S.Add(@multiply, {Grammar(1, 1), Grammar(1, 1)}, {});
S.Add(@multiply, {Grammar(1, 1), Grammar(1, c.n)}, {});
S.Add(@multiply, {Grammar(1, 1), Grammar(1, c.m)}, {});    
S.Add(@multiply, {Grammar(1, c.n), Grammar(c.n, 1)}, {});
S.Add(@multiply, {Grammar(1, c.n), Grammar(c.n, c.n)}, {});
S.Add(@multiply, {Grammar(1, c.n), Grammar(c.n, c.m)}, {});         
    
S.Run();

Grammar.FullStats();
trim_size(Grammar(1, 1));

marginal = RBM();

[grammar_solved, coeffs] = reexpres_data(marginal.exprs(1), Grammar(1, 1));
show_results(coeffs, marginal.normalization(), grammar_solved);
fprintf('total time = %f\n', toc(totaltime));
