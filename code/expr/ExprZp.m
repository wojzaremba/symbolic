classdef ExprZp < Expr
    properties
        power
    end
    
    properties(Constant)
        Zp = [937 941 947 953 967 971 977 983 991 997]';
        len = length(ExprZp.Zp(:));
        mods = RandVals(ExprZp.len, 25, 10, ExprZp.Zp);
    end
    
    
    methods(Static)
        function hash = CombineHash(exprs)
            hash = '';
            for j = 1:length(exprs(:))
                hash = [hash, ';' exprs(j).hash()];
            end            
        end
    end
    
    methods
        function obj = ExprZp(quant, expr) 
            if (~exist('quant', 'var'))
                obj.expr = 0;
                obj.power = 0;
                return
            end
            obj.expr = zeros(ExprZp.len, 1);
            for k = 1 : ExprZp.len
                exprum = 0;
                for j = 1 : size(expr, 2)                
                    val = 1;
                    for i = 1 : size(expr, 1)
                        if (expr(i, j) > 0)
                            val = mod(val * ExprZp.mods(k, i, expr(i, j)), ExprZp.Zp(k));
                        end
                    end
                    val = mod(val * quant(j), ExprZp.Zp(k));
                    exprum = mod(exprum + val, ExprZp.Zp(k));
                end
                obj.expr(k) = exprum;
            end
            obj.power = sum(expr(:, 1));
            if (length(unique(sum(expr(:, :), 1))) > 1)
                warning('Inconsistent powers\n');
                obj.power = max(sum(expr(:, :), 1));
            end
            
        end
        
        function Validate(A)
        end
    
        function str = toString(obj)
            str = '';
            for i = 1 : length(obj.expr)
                str = sprintf('%s%d ', str, obj.expr(i));
            end
        end

        function [ C ] = add_expr(A, B)
            C = ExprZp();
            C.expr = mod(A.expr + B.expr, ExprZp.Zp);
            assert(A.power == B.power);
            assert(A.power > 0);
            C.power = A.power;
        end

        function [ res ] = power_expr( W, p )
            res = ExprZp();
            res.expr = mod(W.expr .^ p, ExprZp.Zp);
            assert(W.power > 0);
            res.power = W.power * p;
        end

        function C = add_many_expr(ret, exprs)
            C = ExprZp();
            C.expr = ret.expr;
            C.power = ret.power;            
            for i = 1 : length(exprs(:))
                C.expr = mod(C.expr + exprs{i}.expr, ExprZp.Zp);
                if (i > 1)
                    assert((exprs{i}.power == exprs{i - 1}.power) || (exprs{i}.power * exprs{i - 1}.power == 0));
                end
                C.power = max(C.power, exprs{i}.power);
            end            
        end

        function [ C ] = multiply_expressions( A, B )
            C = ExprZp();
            C.expr = mod(A.expr .* B.expr, ExprZp.Zp);
            C.power = A.power + B.power;
        end
        
        function ret = is_empty(obj)
            ret = (sum(obj.expr) == 0);
        end
        
        function ret = hash(obj)
            ret = obj.toString();
        end       
        
    end           
end

function ret = RandVals(planes, rows, cols, Zp)
    rand('seed', 1);
    randn('seed', 1);
    ret = zeros(planes, rows, cols);
    ret(:, :, 1) = randi(min(Zp(:)) - 1, [planes, rows, 1]);
    for k = 1:planes
        for i = 1:rows
            for j = 2:cols
                ret(k, i, j) = mod(ret(k, i, j - 1) * ret(k, i, 1), Zp(k));
            end
        end
    end
end