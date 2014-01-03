classdef Grammar < handle
    properties
        n
        m
        expr_matrices
        inited
    end
    
    methods(Static)
        function Stats()
            global grammars c
            ns = [c.n, c.n, 1, 1];
            ms = [c.m, 1, c.m, 1];
            for i = 1 : length(ns)
                fprintf('len G(%d, %d) = %d', ns(i), ms(i), length(grammars(ns(i), ms(i)).expr_matrices(:)));
                if (i ~= length(ns))
                    fprintf(', ');
                end
            end
            fprintf('\n');
        end
        
        function Validate()
            global grammars c
            ns = [c.n, c.n, 1, 1];
            ms = [c.m, 1, c.m, 1];
            for i = 1 : length(ns)                 
                for k = 1:length(grammars(ns(i), ms(i)).expr_matrices(:))
                    try
                        grammars(ns(i), ms(i)).expr_matrices(k).Validate();
                    catch
                        fprintf('Grammar validation failed for Grammar(%d, %d)\n', ns(i), ms(i));
                        assert(0);
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
                obj.expr_matrices = ExprMatrix(W, Matrix('W', c.n, c.m));
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
            initlen = length(obj.expr_matrices(:));
            if (initlen == 0)
                obj.expr_matrices = expr_matrix;
            else
                obj.expr_matrices(end + 1) = expr_matrix;
            end
            if (strcmp(class(Expr_()), 'ExprZp') == 1)
                hashes = cell(length(obj.expr_matrices), 1);
                for i = 1 : length(obj.expr_matrices)
                    hashes{i} = obj.expr_matrices(i).hash;
                end
            else
                hashes = zeros(length(obj.expr_matrices), 1);
                for i = 1 : length(obj.expr_matrices)
                    hashes(i) = obj.expr_matrices(i).hash;
                end
            end
            [~, idx] = unique(hashes);            
            obj.expr_matrices = obj.expr_matrices(idx);
            ret = (length(obj.expr_matrices(:)) > initlen);
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
                if (c.find_desc(computation.toString()))
                    continue;
                end
                expr_matrix = obj.expr_matrices(i).marginalize(dim);
                if (dim == 1)
                    res = Grammar(1, obj.m);
                elseif (dim == 2)
                    res = Grammar(obj.n, 1);
                end
                updated = updated | res.Add(expr_matrix);           
                c.add_desc(computation.toString());
            end
            Grammar.Stats();            
            fprintf('marginalize, toc = %f\n', toc(rule_marginalize_time));
            Grammar.Validate();
        end   
        
        
        function updated = repmat_expr(obj, dim)
            global c
            rule_repmat_time = tic; 
            updated = false;             
            for i = 1:length(obj.expr_matrices(:))
                if (isempty(obj.expr_matrices(i).computation))
                    continue;
                end
                computation = RepmatScaled(obj.expr_matrices(i).computation, dim);
                if (c.find_desc(computation.toString()))
                    continue;
                end
                expr_matrix = obj.expr_matrices(i).repmat_expr(dim);
                if (dim == 1)
                    res = Grammar(c.n, obj.m);
                elseif (dim == 2)
                    res = Grammar(obj.n, c.m);
                end
                updated = updated | res.Add(expr_matrix);           
                c.add_desc(computation.toString());
            end
            Grammar.Stats();            
            fprintf('repmat, toc = %f\n', toc(rule_repmat_time));
            Grammar.Validate();
        end           

        
        function updated = elementwise_multiply(obj)
            rule_elementwise_multiply_time = tic;
            Grammar.Validate();
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
            fprintf('elementwise_multiply, toc = %f\n', toc(rule_elementwise_multiply_time));
            Grammar.Validate();
        end                     
        
    end
        
end