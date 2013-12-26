classdef Grammar < handle
    properties
        n
        m
        expr_matrices
        inited
    end
    
    methods(Static)
        function Stats()
            global grammars
            for i = 1:2
                for j = 1:2
                    fprintf('len G(%d, %d) = %d', i - 1, j - 1, length(grammars(i, j).expr_matrices(:)));
                    if (i ~= 2) || (j ~= 2)
                        fprintf(', ');
                    end
                end
            end
            fprintf('\n');
        end
        
        function Validate()
            global grammars
            for i = 1:2
                for j = 1:2            
                    for k = 1:length(grammars(i, j).expr_matrices(:))
                        try
                            grammars(i, j).expr_matrices(k).Validate();
                        catch
                            fprintf('Grammar validation failed for Grammar(%d, %d)\n', i - 1, j - 1);
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
                obj = grammars(n + 1, m + 1);
                if (~isempty(obj.inited));
                    return;
                end
                obj.inited = 1;                
            catch
                fprintf('Initializing grammar for n = %d, m = %d\n', n, m);
            end                       
            global cache
            obj.n = n;
            obj.m = m;
            W = [Expr()];
            obj.expr_matrices = [];
            if (n == 1) && (m == 1)               
                for i = 1 : cache.maxK
                    for j = 1 : cache.maxK
                        expr = zeros(cache.maxK * cache.maxK, 1);
                        expr((i - 1) * cache.maxK + j, 1) = 1;
                        W(i, j) = Expr(1, expr);
                    end
                end  
                obj.expr_matrices = ExprMatrix(W, Matrix('W', cache.n, cache.m));
            end
            grammars(n + 1, m + 1) = obj;
        end
        
        function trim_size(obj)
            global cache grammars
            maxK = cache.maxK;
            idx = [];
            for i = 1:length(obj.expr_matrices(:))
                if (obj.expr_matrices(i).power == maxK)
                    idx = [idx; i];
                end
            end
            obj.expr_matrices = obj.expr_matrices(idx);
            grammars(obj.n + 1, obj.m + 1) = obj;            
        end        
        
        function [X, Y] = encode_data(F, marginal)
          global cache
          powers = [];
          maxK = cache.maxK;
          for i = 1:length(F.expr_matrices(:))
              assert(F.expr_matrices(i).power == maxK);
              for j = 1:length(F.expr_matrices(i).exprs(:))
                powers = [powers, F.expr_matrices(i).exprs(j).expr];
              end
          end
          for i = 1:size(marginal.exprs.expr, 2)
            powers = [powers, marginal.exprs.expr(:, i)];
          end
          powers = unique(powers', 'rows')';
          hashes = [];
          for i = 1:size(powers, 2)
              hashes = [hashes, cache.hash(powers(:, i))];        
          end    
          if (length(unique(hashes)) ~= length(hashes))
              assert(0);
          end
          hash_map = containers.Map(num2cell(hashes), num2cell(1:length(hashes)));

          X = F.encode_in_hash(hash_map, maxK);  
          Y = F.encode_in_hash_exprs(marginal, hash_map);
        end        
        

        function [ X ] = encode_in_hash( F, hash_map, k )
          X = [];
          for i = 1:length(F.expr_matrices)
            if (F.expr_matrices(i).power == k)   
              tmp = F.encode_in_hash_exprs( F.expr_matrices(i), hash_map );
              X = [X, tmp];
            else 
              assert(0);
            end
          end
          X = double(X);
        end    
        
        function [ res ] = encode_in_hash_exprs(obj, matrix, hash_map)
            global cache
            res = zeros(length(matrix.exprs(:)) * length(hash_map), 1);
            for k = 1:length(matrix.exprs(:))
                offset = (k - 1) * length(hash_map);
                for j = 1:size(matrix.exprs(k).expr, 2)
                    idx = hash_map(cache.hash(matrix.exprs(k).expr(:, j)));
                    res(offset + idx) = res(offset + idx) + matrix.exprs(k).quant(j);
                end
            end
        end        
        
        function ret = Add(obj, expr_matrix)
            global grammars      
%             Grammar.Validate();
            initlen = length(obj.expr_matrices(:));
            if (initlen == 0)
                obj.expr_matrices = expr_matrix;
            else
                obj.expr_matrices(end + 1) = expr_matrix;
            end
            hashes = zeros(length(obj.expr_matrices), 1);
            for i = 1 : length(obj.expr_matrices)
                hashes(i) = obj.expr_matrices(i).hash;
            end
            [~, idx] = unique(hashes);
            obj.expr_matrices = obj.expr_matrices(idx);
            ret = (length(obj.expr_matrices(:)) > initlen);
            grammars(obj.n + 1, obj.m + 1) = obj;
            Grammar.Validate();
        end       
        
        function updated = marginalize(obj, dim)
            global cache
            rule_marginalize_time = tic; 
            updated = false;             
            for i = 1:length(obj.expr_matrices(:))
                if (isempty(obj.expr_matrices(i).computation))
                    continue;
                end
                computation = Marginalize(obj.expr_matrices(i).computation, dim);
                if (cache.find_desc(computation.toString()))
                    continue;
                end
                expr_matrix = obj.expr_matrices(i).marginalize(dim);
                res = Grammar(obj.n && (dim == 2), obj.m && (dim == 1));
                updated = updated | res.Add(expr_matrix);           
                cache.add_desc(computation.toString());
            end
            Grammar.Stats();            
            fprintf('marginalize, toc = %f\n', toc(rule_marginalize_time));
            Grammar.Validate();
        end       

        
        function updated = elementwise_multiply(obj, Y)
            rule_elementwise_multiply_time = tic;
            Grammar.Validate();
            updated = false;    
            for i = 1 : length(obj.expr_matrices(:))
                if (obj.n == Y.n) && (obj.m == Y.m)
                    idx = i;
                else
                    idx = 1;
                end
                for j = idx : length(Y.expr_matrices)
                    top_level = obj.expr_matrices(i).elementwise_multiply(Y.expr_matrices(j));
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