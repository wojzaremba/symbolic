classdef RBM < ExprMatrix
    properties
    end
    
    methods
        function obj = RBM()
            global cache
            k = cache.maxK;
            v_l = k;
            h_l = k;
            W = Expr();
            for i = 1:v_l
                for j = 1:h_l
                    expr = zeros(v_l * h_l, 1);
                    expr((i - 1) * h_l + j, 1) = 1;
                    W(i, j) = Expr(1, expr);
                end
            end  
            marginal_val = cell(2^v_l, 2^h_l);
            fprintf('Number of probs = %d\n', 2^(v_l + h_l));
            for v = 0:(2^v_l - 1)
                v_ = decode_vector(v, v_l) - 1;
                for h = 0:(2^h_l - 1)
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
                    marginal_val{v + 1, h + 1} = power_expr(Expr().add_many_expr(E), k);
               end
            end           
            obj.exprs = Expr().add_many_expr(marginal_val);
        end
        
        function ret = normalization(obj)
            global cache
            ret = 2^(2 * cache.maxK);
        end
    end
end