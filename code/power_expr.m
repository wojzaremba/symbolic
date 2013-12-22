function [ res ] = power_expr( W, p, maxk )
    res = struct('quant', [], 'expr', [], 'hashes', []);
    if (isempty(W))
        return;
    end
    if (~exist('maxk', 'var'))
        maxk = Inf;
    end
    if (min(sum(W.expr, 1)) * p > maxk)
        return;
    end
    res = cell(size(W.expr, 2)^p, 1);
    for i = 1:(size(W.expr, 2)^p)
        res{i} = struct('quant', [], 'expr', [], 'hashes', []);
        idx = zeros(p, 1);
        copyi = i - 1;
        for divs = 1:p
            idx(divs) = mod(copyi, size(W.expr, 2));
            copyi = floor(copyi / size(W.expr, 2));
        end
        idx = idx + 1;
        term = zeros(size(W.expr, 1), 1);
        quant = 1;
        for a = 1:length(idx)
            term = term + W.expr(:, idx(a));
            quant = quant * W.quant(idx(a));
        end
        if (quant ~= 0) && (sum(term) <= maxk)
            res{i} = fix_exprs(struct('quant', quant, 'expr', term));
        end
        if (sum(term) > maxk)
            warning('powers over maxk\n');
        end
    end
    res = add_many_expr(res);
end

