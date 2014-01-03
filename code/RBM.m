classdef RBM < ExprMatrix
    properties
    end
    
    methods
        function obj = RBM()
            global cache
            k = cache.maxK;
            v_l = k;
            h_l = k;
            W = Expr_();
            for i = 1:v_l
                for j = 1:h_l
                    expr = zeros(v_l * h_l, 1);
                    expr((i - 1) * h_l + j, 1) = 1;
                    W(i, j) = Expr_(1, expr);
                end
            end  
            marginal_val = cell(2^v_l, 2^h_l);
            fprintf('Number of probs = %d\n', 2^(v_l + h_l));
            % We start from 1, because v = 0 generates zero value.
            for v = 1:(2^v_l - 1)
                v_ = decode_vector(v, v_l) - 1;
                for h = 1:(2^h_l - 1)
                  fprintf('.'); 
                  h_ = decode_vector(h, h_l) - 1;     
                    posv = find(v_);
                    posh = find(h_);
                    E = cell(length(posv), length(posh)); 
                    for a = 1:length(posv)
                      for b = 1:length(posh)
                        E{a, b} = W(posv(a), posh(b));
                      end
                    end
                    marginal_val{v + 1, h + 1} = power_expr(add_many_expr(Expr_(), E), k);
               end
            end           
            obj.exprs = add_many_expr(Expr_(), marginal_val);
        end
        
        function ret = normalization(obj)
            global cache
            ret = 2^(2 * cache.maxK);
        end
    end
end

