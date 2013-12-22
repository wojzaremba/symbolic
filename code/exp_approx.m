function [ ret ] = exp_approx( x, nr )
    ret = 1;
    for i = 1:nr
        ret = ret + x^i / factorial(i);
    end
end

