function [quants, powers] = power_split(power, nr_vars)
    if (nr_vars == 1)
        powers = [power];
        quants = 1;    
    elseif (nr_vars == 2)
        powers = [(1:(power - 1))', ((power - 1):-1:1)'];
        quants = zeros(power - 1, 1);
        for i = 1 : (power - 1)
            quants(i) = nchoosek(power, i);
        end
    else
        assert(0); % Non-generic impl.        
    end    
end