% Suming values againa within dim gives back A.
function ret = RepmatScaled(A, dim)
    if (dim == 1)
        str = '(1 / n)';
    else
        str = '(1 / m)';
    end
    ret = Mult({Repmat(A, dim), Quant(str)});
end