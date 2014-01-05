classdef Scheduler < handle
    properties
        rules % Grammar rules (this are function handles).
        grammars % It takes as argument some literals.
        params % Parameters of grammar rules.
        tried % Array indicating which combination was tried before.
    end
    
    methods
        function obj = Scheduler()
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
            if (length(grammars) == 1)
                if (length(obj.tried{idx}(:)) < length(grammars{1}.expr_matrices(:)))
                    obj.tried{idx}(length(grammars{1}.expr_matrices(:))) = 0;
                end
            elseif (length(grammars) == 2)
                if ((size(obj.tried{idx}, 1) < length(grammars{1}.expr_matrices(:))) || ...
                   (size(obj.tried{idx}, 2) < length(grammars{2}.expr_matrices(:)))) && ...
                    (length(grammars{1}.expr_matrices(:)) ~= 0) && (length(grammars{2}.expr_matrices(:)) ~= 0)
                    obj.tried{idx}(length(grammars{1}.expr_matrices(:)), length(grammars{2}.expr_matrices(:))) = 0;
                end
            else
                assert(0);
            end            
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
                    if (length(grammars) == 2)
                        for x = 1 : size(obj.tried{i}, 1)
                            for y = 1 : size(obj.tried{i}, 2)
                                if (obj.tried{i}(x, y) == 0)
                                    if (isempty(grammars{1}.expr_matrices(x))) || (isempty(grammars{2}.expr_matrices(y))) 
                                        obj.tried{i}(x, y) = 1;
                                        continue;
                                    end
                                    A = grammars{1}.expr_matrices(x);
                                    B = grammars{2}.expr_matrices(y);
                                    u(i) = u(i) | obj.rules{i}(grammars{1}, A, B, params{:});
                                end
                            end
                        end
                    elseif (length(grammars) == 1)
                        for x = 1 : size(obj.tried{i}, 1)
                            if (obj.tried{i}(x) == 0)
                                if (isempty(grammars{1}.expr_matrices(x)))
                                    obj.tried{i}(x) = 1;
                                    continue;
                                end
                                A = grammars{1}.expr_matrices(x);
                                u(i) = u(i) | obj.rules{i}(grammars{1}, A, params{:});
                            end
                        end                        
                    else
                        assert(0);
                    end                    
                    Grammar.Stats();            
                    fprintf('u = %d, %s, toc = %f\n', u(i), func2str(obj.rules{i}), toc(rule_time));
                    Grammar.Validate();      
                    obj.ResizeTried(i);
                end
                % Checks if there is enough mod p evaluations of polynomial
                % to recover coefficients.
                G11 = Grammar(1, 1);
                assert(length(G11.expr_matrices) < 0.9 * ExprZp.len);

                fprintf('single iter takes = %f, updates = sum(u)\n', toc(single_iter_time));                
            end
            
        end
    end
end