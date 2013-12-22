function ret = d_sigm(x)
    ret = exp(-x)/((1 + exp(-x))^2);
end