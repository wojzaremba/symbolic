function [ ret ] = decode_vector( n, l, basis )
    if (~exist('basis', 'var'))
        basis = 2;
    end
    ret = ones(l, 1);
    pos = 1;
    while (n > 0)
        ret(pos) = mod(n, basis) + 1;
        n = floor(n / basis);
        pos = pos + 1;
    end
end

