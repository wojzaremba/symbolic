function [ X_k ] = vector_power( vec, k )
    len = length(vec);
    X_k = zeros(len^k, 1);
    for i = 0:(len^k - 1)
        entries = decode_vector(i, k, len);  
        entries = sort(entries);
        location = dot((len .^ (0:(k - 1))), entries - 1) + 1;
        X_k(location) = X_k(location) + prod(vec(entries));           
    end
end

