classdef Grammar < handle
    properties
        n
        m
        expr_matrices
        hashmap
        inited
    end
    
    methods(Static)
        
        function FullStats()
            global grammars
            for i = 1 : size(grammars, 1)
                for j = 1 : size(grammars, 2)
                    G = grammars(i, j);
                    if (isempty(G)) || (isempty(G.expr_matrices))
                        continue;
                    end
                    fprintf('len G(%d, %d) = %d\n', i, j, length(G.expr_matrices(:)));
                    for k = 1 : length(G.expr_matrices(:))                
                        if (isempty(G.expr_matrices(k).computation))
                            continue;
                        end
                        fprintf('\t%s\n', G.expr_matrices(k).toString());
                    end
                    fprintf('\n');
                end
            end
            fprintf('\n');
        end        
        
        function Stats()
            global grammars
            for i = 1 : size(grammars, 1)
                for j = 1 : size(grammars, 2)
                    G = grammars(i, j);
                    if (isempty(G)) || (isempty(G.expr_matrices))
                        continue;
                    end
                    fprintf('len G(%d, %d) = %d', i, j, length(G.expr_matrices(:)));
                    if (i ~= size(grammars, 1)) || (j ~= size(grammars, 2))
                        fprintf(', ');
                    else
                        fprintf('\t\t');
                    end                                        
                end
            end
        end
        
        function Validate()
            global grammars
            for i = 1 : size(grammars, 1)
                for j = 1 : size(grammars, 2)
                    G = grammars(i, j);
                    if (isempty(G)) || (isempty(G.expr_matrices))
                        continue;
                    end         
                    assert(G.n == i);
                    assert(G.m == j);
                    for k = 1:length(grammars(i, j).expr_matrices(:))
                        try
                            expr_matrix = G.expr_matrices(k);
                            expr_matrix.Validate();
                            assert(size(expr_matrix.exprs, 1) == i);
                            assert(size(expr_matrix.exprs, 2) == j);
                        catch
                            fprintf('Grammar validation failed for Grammar(%d, %d)\n', i, j);
                            assert(0);
                        end
                    end
                end
            end
        end
    end
    
    methods
        function obj = Grammar(n, m)
            global grammars
            if (~exist('n'))  
                return;
            end
            try
                obj = grammars(n, m);
                if (~isempty(obj.inited));
                    return;
                end
                obj.inited = 1;                
            catch
                fprintf('Initializing grammar for n = %d, m = %d\n', n, m);
            end                       
            global c
            obj.n = n;
            obj.m = m;
            if (strcmp(class(Expr_()), 'ExprZp'))
                type = 'char';
            else
                type = 'int64';
            end
            obj.hashmap = containers.Map('KeyType', type, 'ValueType', 'any');                        
            W = [Expr_()];
            obj.expr_matrices = [];
            if (n == c.n) && (m == c.m)               
                for i = 1 : c.n
                    for j = 1 : c.m
                        expr = zeros(c.n * c.m, 1);
                        expr((i - 1) * c.m + j, 1) = 1;
                        W(i, j) = Expr_(1, expr);
                    end
                end  
                obj.Add(ExprMatrix(W, Matrix('W', c.n, c.m)));
            end
            grammars(n, m) = obj;
        end
        
        function trim_size(obj)
            global c grammars
            maxK = c.maxK;
            idx = [];
            for i = 1:length(obj.expr_matrices(:))
                if (obj.expr_matrices(i).power == maxK)
                    idx = [idx; i];
                end
            end
            obj.expr_matrices = obj.expr_matrices(idx);
            grammars(obj.n, obj.m) = obj;            
        end                            

        function [ X ] = encode_in_hash( F, hash_map, k )
          X = [];
          for i = 1:length(F.expr_matrices)
            if (F.expr_matrices(i).power == k)   
              tmp = F.encode_in_hash_exprs( F.expr_matrices(i).exprs, hash_map );
              X = [X, tmp];
            else 
              assert(0);
            end
          end
          X = double(X);
        end    
        
        function [ res ] = encode_in_hash_exprs(obj, matrix, hash_map)
            global c
            res = zeros(length(hash_map), 1);
            for j = 1:size(matrix.expr, 2)
                idx = hash_map(c.hash(matrix.expr(:, j)));
                if (strcmp(class(Expr_()), 'ExprZp') == 1)
                    quant = 1;
                else
                    quant = matrix.quant(j);
                end
                res(idx) = quant;
            end
        end        
        
        function ret = Add(obj, expr_matrix)
            global grammars      
            hash = expr_matrix.hash;
            if (isempty(expr_matrix.computation))
                ret = false;
                return;
            end
            if (obj.hashmap.isKey(hash))
                idx = obj.hashmap(hash);
                if (obj.expr_matrices(idx).computation.complexity <= expr_matrix.computation.complexity)
                    ret = false;
                    return;
                end
                obj.expr_matrices(idx) = expr_matrix;
                ret = true;
                return;
            end
            if (isempty(obj.expr_matrices))
                obj.expr_matrices = expr_matrix;                
            else
                obj.expr_matrices(end + 1) = expr_matrix;
            end
            obj.hashmap(hash) = length(obj.expr_matrices);
            ret = true;            
            grammars(obj.n, obj.m) = obj;
        end       
        
        function updated = marginalize(obj, dim)
            global c
            rule_marginalize_time = tic; 
            updated = false;             
            for i = 1:length(obj.expr_matrices(:))
                if (isempty(obj.expr_matrices(i).computation))
                    continue;
                end
                computation = Marginalize(obj.expr_matrices(i).computation, dim);
                expr_matrix = obj.expr_matrices(i).marginalize(dim);
                if (dim == 1)
                    res = Grammar(1, obj.m);
                elseif (dim == 2)
                    res = Grammar(obj.n, 1);
                end
                updated = updated | res.Add(expr_matrix);           
            end
            Grammar.Stats();            
            fprintf('marginalize, toc = %f\n', toc(rule_marginalize_time));
            Grammar.Validate();
        end   
        
        
        function updated = repmat_expr(obj, dims)
            rule_repmat_time = tic; 
            updated = false;             
            for i = 1:length(obj.expr_matrices(:))
                if (isempty(obj.expr_matrices(i).computation))
                    continue;
                end
                expr_matrix = obj.expr_matrices(i).repmat_expr(dims);
                res = Grammar(dims(1), dims(2));
                updated = updated | res.Add(expr_matrix);
            end
            Grammar.Stats();            
            fprintf('u = %d, repmat, toc = %f\n', updated, toc(rule_repmat_time));
            Grammar.Validate();
        end           

        
        function updated = elementwise_multiply(obj)
            rule_elementwise_multiply_time = tic;
            updated = false;    
            for i = 1 : length(obj.expr_matrices(:))
                idx = i;
                for j = idx : length(obj.expr_matrices)
                    top_level = obj.expr_matrices(i).elementwise_multiply(obj.expr_matrices(j));
                    if (isempty(top_level)) || (isempty(top_level.exprs))
                        continue;
                    end
                    res = Grammar(obj.n, obj.m);                    
                    updated = updated | res.Add(top_level);                    
                end
            end
            Grammar.Stats();            
            fprintf('u = %d, elementwise_multiply, toc = %f\n', updated, toc(rule_elementwise_multiply_time));
            Grammar.Validate();
        end             
        
        function updated = transpose(obj)
            rule_transpose_time = tic;
            updated = false;    
            for i = 1 : length(obj.expr_matrices(:))
                if (isempty(obj.expr_matrices(i).computation))
                    continue;
                end
                expr_matrix = obj.expr_matrices(i).transpose();
                res = Grammar(obj.m, obj.n);
                updated = updated | res.Add(expr_matrix);                   
            end
            Grammar.Stats();            
            fprintf('u = %d, rule_transpose_time, toc = %f\n', updated, toc(rule_transpose_time));
            Grammar.Validate();
        end     
        
        function updated = multiply(A, B)
            rule_multiply_time = tic;
            updated = false;    
            for i = 1 : length(A.expr_matrices(:))
                for j = 1 : length(B.expr_matrices)
                    top_level = A.expr_matrices(i).multiply(B.expr_matrices(j));
                    if (isempty(top_level)) || (isempty(top_level.exprs))
                        continue;
                    end
                    res = Grammar(A.n, B.m);
                    updated = updated | res.Add(top_level);                    
                end
            end
            Grammar.Stats();            
            fprintf('u = %d, rule_multiply_time, toc = %f\n', updated, toc(rule_multiply_time));
            Grammar.Validate();
        end             
        
    end
        
end