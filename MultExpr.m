classdef MultExpr < ExprMatrix
    properties
    end
    
    methods
        function obj = MultExpr()
            global c
            k = c.maxK;
            W = Expr_();
            for i = 1:c.n
                for j = 1:c.m
                    expr = zeros(c.n * c.m, 1);
                    expr((i - 1) * c.m + j, 1) = 1;
                    W(i, j) = Expr_(1, expr);
                end
            end  
            W = ExprMatrix(W, Matrix('W', c.n, c.m));
            WT = transpose(W);
            Q = multiply(W, WT);
            tmp = marginalize(marginalize(multiply(Q, W), 1), 2);
%             tmp = marginalize(marginalize(multiply(W, WT), 1), 2);
            obj.exprs = tmp.exprs(1);
        end
        
        function ret = normalization(obj)
            global c
            ret = 1;
        end
    end
end

