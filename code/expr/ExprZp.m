classdef ExprZp < Expr
    properties
        power
        hash_
    end
    
    properties(Constant)             
        len = 60;
        Zp = 100069;
        mods = RandVals(ExprZp.len, 25, 10, ExprZp.Zp);
        field_inv = Inverse(ExprZp.Zp);
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
                            val = mod(val * ExprZp.mods(k, i, expr(i, j)), ExprZp.Zp);
                        end
                    end
                    val = mod(val * quant(j), ExprZp.Zp);
                    exprum = mod(exprum + val, ExprZp.Zp);
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
            str = char(obj.expr)';
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
                if (isempty(exprs{i}))
                    continue
                end
                C.expr = mod(C.expr + exprs{i}.expr, ExprZp.Zp);
                if (C.power > 0)
                    assert((exprs{i}.power == C.power) || (exprs{i}.power * C.power == 0));
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
        
        % This hash returns the same value regardless of multiplicative
        % constant.
        function ret = hash(obj)
            if (isempty(obj.hash_))
%                 ret = char(obj.expr)';
                if (((length(obj.expr(:)) == 1) && (obj.expr == 0)))
                    ret = 0;
                else
                    % It multiplies expr by mean of them. So this value is
                    % invariant to multiplications of expr by constant.
                    ret = sprintf('%d\n', mod(obj.expr * ExprZp.len * ExprZp.field_inv(mod(sum(obj.expr(:)), ExprZp.Zp)), ExprZp.Zp));
                end
                obj.hash_ = ret;
            else
                ret = obj.hash_;
            end
        end       
        
        function [expr_matrices, coeffs] = reexpres_data(marginal, F)
            X = [];
            for i = 1 : length(F.expr_matrices)
                X = [X, F.expr_matrices(i).exprs.expr];
            end
            Y = marginal.expr;
            coeffs = [];
            invert = modlinear(X, Y, ExprZp.Zp, ExprZp.field_inv);
            error = norm(mod(X * invert - Y, ExprZp.Zp));
            fprintf('error : %f\n', error);  
            if (error > 1e-5)
                fprintf('Couldnt find solution\n');
                assert(0);
            end

            expr_matrices = {};
            for i = 1:length(invert)
                if (abs(invert(i)) < 1e-5)
                    continue;
                end
                expr_matrices{end + 1} = F.expr_matrices(i);
                coeffs = [coeffs; invert(i)];
            end   
            fprintf('nr coeffs = %d\n', length(coeffs));          
        end             
        
    end           
end

function ret = Inverse(p)
    ret = zeros(p - 1, 1); 
    for i = 1 : (p - 1)
        for invi = 1 : (p - 1)
            if (mod(i * invi, p) == 1)
                break;                
            end
        end
        ret(:) = 0;
        a = 1;   
        b = 1;  
        fail = false;
        for k = 1 : (p - 1)
            if (ret(a) ~= 0)
                fail = true;
                break;
            end
            ret(a) = b;
            a = mod(a * i, p);
            b = mod(b * invi, p);
        end
        if (~fail)
            return;
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
                ret(k, i, j) = mod(ret(k, i, j - 1) * ret(k, i, 1), Zp);
            end
        end
    end
end