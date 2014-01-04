function obj = Expr_(quant, expr, hashes)
    global expr_type
    if (strcmp(expr_type, 'symbolic') == 1)
        if (~exist('quant', 'var'))
            obj = ExprSymbolic();
            return;
        end
        obj = ExprSymbolic(quant, expr);
    elseif (strcmp(expr_type, 'Zp') == 1)
        if (~exist('quant', 'var'))
            obj = ExprZp();
            return;
        end
        obj = ExprZp(quant, expr);        
    end
end