function [ ret ] = hash( X )
    global dot_mult prime;
    assert(size(X, 2) == 1);
    ret = mod(dot(dot_mult(1:length(X(:))), double(X(:))), prime);
    assert(~isnan(ret) && (ret ~= Inf));
end

