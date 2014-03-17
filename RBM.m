classdef RBM < ExprMatrix
    properties
    end
    
    methods
        function obj = RBM(power)
            global c
            W = Expr_();
            for i = 1:c.n
                for j = 1:c.m
                    expr = zeros(c.n * c.m, 1);
                    expr((i - 1) * c.m + j, 1) = 1;
                    W(i, j) = Expr_(1, expr);
                end
            end  
            marginal_val = cell(2^c.n, 2^c.m);
            fprintf('Number of RBM items = %d\n', 2^(c.n + c.m));
            % We start from 1, because v = 0 generates zero value.
            for v = 1:(2^c.n - 1)
                v_ = decode_vector(v, c.n);
                assert(sum(v_ < 0) == 0 && sum(v_ > 1) == 0);                
                for h = 1:(2^c.m - 1)
                  fprintf('.'); 
                  h_ = decode_vector(h, c.m);
                  assert(sum(h_ < 0) == 0 && sum(h_ > 1) == 0);                
                    posv = find(v_);
                    posh = find(h_);
                    E = cell(length(posv), length(posh)); 
                    for a = 1:length(posv)
                      for b = 1:length(posh)
                        E{a, b} = W(posv(a), posh(b));
                      end
                    end
		    if (power ~= -1)
                    	marginal_val{v + 1, h + 1} = power_expr(add_many_expr(Expr_(), E), power);
		    else
                    	marginal_val{v + 1, h + 1} = exp_apply(add_many_expr(Expr_(), E), c.maxK);
		    end
               end
            end           
            obj.exprs = add_many_expr(Expr_(), marginal_val);
        end
        
        function ret = normalization(obj)
            global c
            ret = 2^(c.n + c.m);
        end
    end
end

