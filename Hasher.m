classdef Hasher < handle
   properties
       idx_map
       complex_map       
       grammar
   end
   
   methods(Static)
        function [ X ] = encode_in_hash( F, hash_map)
            X = [];
            for i = 1:length(F.expr_matrices)
                tmp = Hasher.encode_in_hash_exprs(F, F.expr_matrices(i).exprs, hash_map);
                X = [X, tmp];
            end
            X = double(X);
        end    
        
        function [ res ] = encode_in_hash_exprs(obj, matrix, hash_map)
            res = zeros(length(hash_map), 1);
            for j = 1:size(matrix.expr, 2)
                idx = hash_map(Cache.hash_expr(matrix.expr(:, j)));
                if (strcmp(class(Expr_()), 'ExprZp') == 1)
                    quant = 1;
                else
                    quant = matrix.quant(j);
                end
                res(idx) = quant;
            end
        end                
   end
   
   methods
        function obj = Hasher(grammar)
            obj.grammar = grammar;
            obj.idx_map = containers.Map('KeyType', 'int64', 'ValueType', 'any');
            obj.complex_map = containers.Map('KeyType', 'int64', 'ValueType', 'any');
            for i = 1:length(grammar.expr_matrices)
                expr_matrix = grammar.expr_matrices(i);
                hash = expr_matrix.hash;
                obj.idx_map(hash) = i;
                obj.complex_map(hash) = expr_matrix.computation.complexity;                
            end            
        end
       
        function ret = Add(obj, expr_matrix)
            global grammars
            hash = expr_matrix.hash;     
            if (isempty(expr_matrix.computation))
                ret = false;                       
                return;
            end
            if (obj.idx_map.isKey(hash))
                if (obj.complex_map(hash) <= expr_matrix.computation.complexity)
                    ret = false;
                else
                    ret = true;
                end
                return;
            end
            n = size(expr_matrix.exprs, 1);
            m = size(expr_matrix.exprs, 2);
            G = grammars(n, m);
            obj.idx_map(hash) = length(G.expr_matrices) + 1;
            obj.complex_map(hash) = expr_matrix.computation.complexity;
            ret = true;                    
        end               
       
   end
end