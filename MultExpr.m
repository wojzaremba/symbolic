classdef MultExpr < ExprMatrix
    properties
    end
    
    methods
        function obj = MultExpr()
            A = Grammar.CreateVar(0, 4);
            B = Grammar.CreateVar(1, 4);
            C = Grammar.CreateVar(2, 4);
            
            BT = transpose(B);
            Q = multiply(A, BT);
            W = multiply(Q, C);
            tmp = marginalize(marginalize(W, 1), 2);
            obj.exprs = tmp.exprs(1);
        end
        
        function ret = normalization(obj)
            ret = 1;
        end
    end
end

