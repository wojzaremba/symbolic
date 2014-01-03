classdef ExprZp < Expr
    properties
        power
        hash_
    end
    
    properties(Constant)        
       primes = ...
      [5099   5101   5107   5113   5119   5147   5153   5167   5171   5179 ...
       5189   5197   5209   5227   5231   5233   5237   5261   5273   5279 ...
       5281   5297   5303   5309   5323   5333   5347   5351   5381   5387 ...
       5393   5399   5407   5413   5417   5419   5431   5437   5441   5443 ...
       5449   5471   5477   5479   5483   5501   5503   5507   5519   5521 ...
       5527   5531   5557   5563   5569   5573   5581   5591   5623   5639 ...
       5641   5647   5651   5653   5657   5659   5669   5683   5689   5693 ...
       5701   5711   5717   5737   5741   5743   5749   5779   5783   5791 ...
       5801   5807   5813   5821   5827   5839   5843   5849   5851   5857 ...
       5861   5867   5869   5879   5881   5897   5903   5923   5927   5939 ...
       5953   5981   5987   6007   6011   6029   6037   6043   6047   6053 ...
       6067   6073   6079   6089   6091   6101   6113   6121   6131   6133 ...
       6143   6151   6163   6173   6197   6199   6203   6211   6217   6221 ...
       6229   6247   6257   6263   6269   6271   6277   6287   6299   6301 ...
       6311   6317   6323   6329   6337   6343   6353   6359   6361   6367 ...
       6373   6379   6389   6397   6421   6427   6449   6451   6469   6473 ...
       6481   6491   6521   6529   6547   6551   6553   6563   6569   6571 ...
       6577   6581   6599   6607   6619   6637   6653   6659   6661   6673 ...
       6679   6689   6691   6701   6703   6709   6719   6733   6737   6761 ...
       6763   6779   6781   6791   6793   6803   6823   6827   6829   6833 ...
       6841   6857   6863   6869   6871   6883   6899   6907   6911   6917 ...
       6947   6949   6959   6961   6967   6971   6977   6983   6991   6997 ...
       7001   7013   7019   7027   7039   7043   7057   7069   7079   7103 ...
       7109   7121   7127   7129   7151   7159   7177   7187   7193   7207 ...
       7211   7213   7219   7229   7237   7243   7247   7253   7283   7297 ...
       7307   7309   7321   7331   7333   7349   7351   7369   7393   7411 ...
       7417   7433   7451   7457   7459   7477   7481   7487   7489   7499 ...
       7507   7517   7523   7529   7537   7541   7547   7549   7559   7561 ...
       7573   7577   7583   7589   7591   7603   7607   7621   7639   7643 ...
       7649   7669   7673   7681   7687   7691   7699   7703   7717   7723 ...
       7727   7741   7753   7757   7759   7789   7793   7817   7823   7829 ...
       7841   7853   7867   7873   7877   7879   7883   7901   7907   7919];     
        
        len = 10;
        Zp = ExprZp.primes(1:ExprZp.len)';        
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
            if (isempty(obj.hash_))
                ret = obj.toString();
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
            invert = modsolve(X, Y, ExprZp.Zp);
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