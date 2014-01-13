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
            for i = size(grammars, 1) : -1 : 1
                for j = size(grammars, 2) : -1 : 1
                    G = grammars(i, j);
                    if (isempty(G)) || (isempty(G.expr_matrices))
                        continue;
                    end
                    fprintf('|G(%d, %d)|=%d\n', i, j, length(G.expr_matrices(:)));
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
                    fprintf('|G(%d, %d)|=%d', i, j, length(G.expr_matrices(:)));
                    if (i ~= size(grammars, 1)) || (j ~= size(grammars, 2))
                        fprintf(', ');
                    else
                        fprintf('\t');
                    end                                        
                end
            end
        end
        
        function Validate()
            global grammars debug
            if (debug == 0)
                return;
            end
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
    
    methods(Static)
        function W = CreateVar(idx, maxvars)
            global c
            W = Expr_();
            for i = 1:c.n
                for j = 1:c.m
                    expr = zeros(maxvars * c.n * c.m, 1);
                    expr((i - 1) * c.m + j + idx * c.n * c.m, 1) = 1;
                    W(i, j) = Expr_(1, expr);
                end
            end  
            W = ExprMatrix(W, Matrix('A' + idx, c.n, c.m));                        
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
            obj.hashmap = containers.Map('KeyType', obj.hashtype(), 'ValueType', 'any');
            W = [Expr_()];
            obj.expr_matrices = [];
            if (n == c.n) && (m == c.m)        
                for i = 0:(c.vars - 1)
                    W = Grammar.CreateVar(i, c.vars);
                    obj.Add(W);
                end
            end
            grammars(n, m) = obj;
        end
        
        function ret = hashtype(obj)
            if (strcmp(class(Expr_()), 'ExprZp'))
                ret = 'char';
            else
                ret = 'int64';
            end            
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
            obj.hashmap = containers.Map('KeyType', obj.hashtype(), 'ValueType', 'any');
            for i = 1:length(obj.expr_matrices)
                obj.hashmap(obj.expr_matrices(i).hash) = i;
            end
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
            ret = false;            
            if (isempty(expr_matrix.computation))
                return;
            end
            if (obj.hashmap.isKey(hash))
                idx = obj.hashmap(hash);
                if (obj.expr_matrices(idx).computation.complexity <= expr_matrix.computation.complexity)
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
        
        function updated = marginalize(obj, A, dim)            
            expr_matrix = A.marginalize(dim);
            if (dim == 1)
                res = Grammar(1, obj.m);
            elseif (dim == 2)
                res = Grammar(obj.n, 1);
            end
            updated = res.Add(expr_matrix);           
        end   
        
        
        function updated = repmat_expr(obj, A, dims)
            expr_matrix = A.repmat_expr(dims);
            assert((obj.n == 1) || (obj.m == 1));
            assert((dims(1) == 1) || (dims(2) == 1));
            assert((dims(1) ~= obj.n) || (dims(2) ~= obj.m))
            res = Grammar(obj.n * dims(1), obj.m * dims(2));
            updated = res.Add(expr_matrix);
        end           
        
        function updated = elementwise_multiply(obj, A, B)
            updated = false;    
            top_level = A.elementwise_multiply(B);
            if (isempty(top_level)) || (isempty(top_level.exprs))
                return;
            end
            res = Grammar(obj.n, obj.m);                    
            updated = res.Add(top_level);                           
        end             
        
        function updated = transpose(obj, A)
            expr_matrix = A.transpose();
            res = Grammar(obj.m, obj.n);
            updated = res.Add(expr_matrix);                   
        end     
        
        function updated = multiply(obj, A, B, ~)
            updated = false;    
            top_level = A.multiply(B);
            if (isempty(top_level)) || (isempty(top_level.exprs))
                return;
            end
            res = Grammar(size(A.exprs, 1), size(B.exprs, 2));
            updated = updated | res.Add(top_level);                    
        end             
        
    end
        
end