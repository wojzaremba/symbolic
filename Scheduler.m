classdef Scheduler < handle
    properties
        rules % Grammar rules (this are function handles).
        grammars % It takes as argument some literals.
        params % Parameters of grammar rules.
        tried % Array indicating which combination was tried before.
    end
    
    methods
        function obj = Scheduler()
            fprintf('Creating Scheduler\n');
            obj.rules = {};
            obj.params = {};
        end
        
        function Add(obj, f, grammars, params)
            obj.rules{end + 1} = f;
            obj.grammars{end + 1} = grammars;
            obj.params{end + 1} = params;
            obj.tried{end + 1} = zeros(0, 0);
            obj.ResizeTried(length(obj.tried));
        end
        
        function ResizeTried(obj, idx)
            grammars = obj.grammars{idx};
            g1 = Grammar(grammars{1}(1), grammars{1}(2));
            l1 = length(g1.expr_matrices(:));            
            if (length(grammars) == 1)
                if (length(obj.tried{idx}(:)) < l1)
                    obj.tried{idx}(l1) = 0;
                end
            elseif (length(grammars) == 2)
                g2 = Grammar(grammars{2}(1), grammars{2}(2));                
                l2 = length(g2.expr_matrices(:));
                if ((size(obj.tried{idx}, 1) < l1) || ...
                   (size(obj.tried{idx}, 2) < l2)) && ...
                    (l1 ~= 0) && (l2 ~= 0)
                    obj.tried{idx}(l1, l2) = 0;
                end
            else
                assert(0);
            end            
        end
        
        function AddBasicRules(S)
            global c         
            fprintf('Registering basic grammar rules\n');
            S.Add(@marginalize, {[c.n, c.m]}, {2});
            S.Add(@marginalize, {[c.n, c.m]}, {1});            
            S.Add(@marginalize, {[c.n, 1]}, {1});            
            S.Add(@marginalize, {[1, c.m]}, {2});    
            
            S.Add(@elementwise_multiply, {[c.n, c.m], [c.n, c.m]}, {});            
            S.Add(@elementwise_multiply, {[c.n, 1], [c.n, 1]}, {});         
            S.Add(@elementwise_multiply, {[1, c.m], [1, c.m]}, {});
            S.Add(@elementwise_multiply, {[1, 1], [1, 1]}, {});        
            
            S.Add(@repmat_expr, {[c.n, 1]}, {[1, c.m]});   
            S.Add(@repmat_expr, {[1, c.m]}, {[c.n, 1]});            
            S.Add(@repmat_expr, {[1, 1]}, {[c.n, 1]});
            S.Add(@repmat_expr, {[1, 1]}, {[1, c.m]});
        end
        
        function AddMultRules(S)
            global c
            fprintf('Registering multiplication and transpose grammar rules\n');
            S.Add(@marginalize, {[c.m, c.n]}, {2});    
            S.Add(@marginalize, {[c.m, c.m]}, {2});
            S.Add(@marginalize, {[c.n, c.n]}, {2});    

            S.Add(@marginalize, {[c.m, c.n]}, {1});    
            S.Add(@marginalize, {[c.m, c.m]}, {1});
            S.Add(@marginalize, {[c.n, c.n]}, {1});    

            S.Add(@marginalize, {[1, c.n]}, {2});    
            S.Add(@marginalize, {[c.m, 1]}, {1});        

            S.Add(@elementwise_multiply, {[c.m, c.n], [c.m, c.n]}, {});    
            S.Add(@elementwise_multiply, {[c.n, c.n], [c.n, c.n]}, {});    
            S.Add(@elementwise_multiply, {[c.m, c.m], [c.m, c.m]}, {});
            S.Add(@elementwise_multiply, {[1, c.n], [1, c.n]}, {});    
            S.Add(@elementwise_multiply, {[c.m, 1], [c.m, 1]}, {});   

            S.Add(@repmat_expr, {[c.n, 1]}, {[1, c.n]});        
            S.Add(@repmat_expr, {[1, c.m]}, {[c.m, 1]});    
            S.Add(@repmat_expr, {[1, 1]}, {[c.m, 1]});    
            S.Add(@repmat_expr, {[1, 1]}, {[1, c.n]});  

            S.Add(@transpose, {[c.n, c.m]}, {});
            S.Add(@transpose, {[c.n, c.n]}, {});
            S.Add(@transpose, {[c.m, c.m]}, {});    
            S.Add(@transpose, {[c.n, 1]}, {});
            S.Add(@transpose, {[1, c.m]}, {});
            S.Add(@transpose, {[c.m, c.n]}, {});
            S.Add(@transpose, {[1, c.n]}, {});
            S.Add(@transpose, {[c.m, 1]}, {});

            S.Add(@multiply, {[c.n, c.m], [c.m, 1]}, {});
            S.Add(@multiply, {[c.n, c.m], [c.m, c.n]}, {});
            S.Add(@multiply, {[c.n, c.m], [c.m, c.m]}, {});
            S.Add(@multiply, {[c.n, 1], [1, 1]}, {});
            S.Add(@multiply, {[c.n, 1], [1, c.n]}, {});
            S.Add(@multiply, {[c.n, 1], [1, c.m]}, {});    
            S.Add(@multiply, {[c.n, c.n], [c.n, 1]}, {});
            S.Add(@multiply, {[c.n, c.n], [c.n, c.n]}, {});
            S.Add(@multiply, {[c.n, c.n], [c.n, c.m]}, {});

            S.Add(@multiply, {[c.m, c.m], [c.m, 1]}, {});
            S.Add(@multiply, {[c.m, c.m], [c.m, c.n]}, {});
            S.Add(@multiply, {[c.m, c.m], [c.m, c.m]}, {});
            S.Add(@multiply, {[c.m, 1], [1, 1]}, {});
            S.Add(@multiply, {[c.m, 1], [1, c.n]}, {});
            S.Add(@multiply, {[c.m, 1], [1, c.m]}, {});    
            S.Add(@multiply, {[c.m, c.n], [c.n, 1]}, {});
            S.Add(@multiply, {[c.m, c.n], [c.n, c.n]}, {});
            S.Add(@multiply, {[c.m, c.n], [c.n, c.m]}, {});         

            S.Add(@multiply, {[1, c.m], [c.m, 1]}, {});
            S.Add(@multiply, {[1, c.m], [c.m, c.n]}, {});
            S.Add(@multiply, {[1, c.m], [c.m, c.m]}, {});
            S.Add(@multiply, {[1, 1], [1, 1]}, {});
            S.Add(@multiply, {[1, 1], [1, c.n]}, {});
            S.Add(@multiply, {[1, 1], [1, c.m]}, {});    
            S.Add(@multiply, {[1, c.n], [c.n, 1]}, {});
            S.Add(@multiply, {[1, c.n], [c.n, c.n]}, {});
            S.Add(@multiply, {[1, c.n], [c.n, c.m]}, {});      
        end
        
        function Run(obj)
            u = zeros(length(obj.rules), 1);
            u(:) = 1;
            while (norm(u) > 0);
                single_iter_time = tic;
                u(:) = 0;
                for i = 1 : length(obj.rules)
                    rule_time = tic;
                    grammars = obj.grammars{i};
                    params = obj.params{i};
                    g1 = Grammar(grammars{1}(1), grammars{1}(2));                    
                    if (length(grammars) == 2)
                        g2 = Grammar(grammars{2}(1), grammars{2}(2));
                        for x = 1 : size(obj.tried{i}, 1)
                            for y = 1 : size(obj.tried{i}, 2)
                                if (obj.tried{i}(x, y) == 0)
                                    if (isempty(g1.expr_matrices(x))) || (isempty(g2.expr_matrices(y))) 
                                        obj.tried{i}(x, y) = 1;
                                        continue;
                                    end
                                    A = g1.expr_matrices(x);
                                    B = g2.expr_matrices(y);
                                    u(i) = u(i) | obj.rules{i}(g1, A, B, params{:});
                                    obj.tried{i}(x, y) = 1;
                                end
                            end
                        end
                    elseif (length(grammars) == 1)
                        for x = 1 : length(obj.tried{i}(:))
                            if (obj.tried{i}(x) == 0)
                                if (isempty(g1.expr_matrices(x)))
                                    obj.tried{i}(x) = 1;
                                    continue;
                                end
                                A = g1.expr_matrices(x);
                                u(i) = u(i) | obj.rules{i}(g1, A, params{:});
                                obj.tried{i}(x) = 1;
                            end
                        end                        
                    else
                        assert(0);
                    end                    
                    Grammar.Stats();    
                    params_str = '';
                    for k = 1 : length(grammars)
                        params_str = sprintf('%sG(%d, %d) ', params_str, grammars{k}(1), grammars{k}(2));
                    end
                    for k = 1 : length(params)
                        params_str = sprintf('%s%d ', params_str, params{k});
                    end
                    fprintf('u = %d, %s(%s), toc = %f\n', u(i), func2str(obj.rules{i}), params_str, toc(rule_time));
                    Grammar.Validate();      
                    obj.ResizeTried(i);
                end
                % Checks if there is enough mod p evaluations of polynomial
                % to recover coefficients.
                G11 = Grammar(1, 1);
                assert(length(G11.expr_matrices) < 0.9 * ExprZp.len);

                fprintf('single iter takes = %f, updates = %d\n', toc(single_iter_time), sum(u));
            end
            
        end
    end
end