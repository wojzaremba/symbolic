classdef MultExpr < ExprMatrix
    properties
    end
    
    methods
        function obj = MultExpr()
            A = Grammar.CreateVar(0, 4);
            B = Grammar.CreateVar(1, 4);
            C = Grammar.CreateVar(2, 4);
            D = Grammar.CreateVar(3, 4);
            
            BT = transpose(B);
            DT = transpose(D);
            Q = multiply(A, BT);
            W = multiply(Q, C);
            tmp = marginalize(marginalize(multiply(W, DT), 1), 2);
            obj.exprs = tmp.exprs(1);
        end
        
        function ret = normalization(obj)
            ret = 1;
        end
    end
end

