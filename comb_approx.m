global debug
debug = 2;
clc
n = 1;
m = 3;
randn('seed', 1);
rand('seed', 1);
W = randn(n, m);

W = [1, 0, 0];

mprintf('W', W);
Zvals = zeros(2^n, 2^m);
Zvals_real = zeros(2^n, 2^m);
vsize = 2^n;
hsize = 2^m;
maxpower = 12;
comb_order = 2;
for i = 1 : vsize
  for j = 1 : hsize
    bin_i = decode_vector(i - 1, size(W, 1), 2);
    bin_j = decode_vector(j - 1, size(W, 2), 2); 
    assert((sum(bin_i < 0) == 0) && (sum(bin_i > 1) == 0));
    assert((sum(bin_j < 0) == 0) && (sum(bin_j > 1) == 0));
    val = 0;    
    
    % Combinatorial approx.
    printf('_________\n');
    idxs = bin_i * bin_j';    
    mprintf('bin_i', bin_i(:));
    mprintf('bin_j', bin_j(:));
    mprintf('idxs', idxs);
    fidxs = find(idxs);    
    if (comb_order == 0)
        val = val + 1;
    end
    printf('+ 1\n');    
    if (~isempty(fidxs)) && (comb_order > 0)    
        for k = 1 : maxpower
            printf('x^%d / %d!\n', k, k);
            % 0-th power.       
            for c = comb_order : comb_order
                if (length(fidxs) < c)
                    continue;
                end
                combs = nchoosek(fidxs, c);
                for d = 1 : size(combs, 1)
                    entries = W(combs(d, :));
                    [quants, powers] = power_split(k, c);
                    if (length(powers) == 0)
                        continue
                    end
                    for ps = 1:size(powers, 1)
                        tmp = 1;                    
                        power = powers(ps, :);
                        printf('%d * ', quants(ps));
                        for p = 1:length(power)
                            tmp = tmp * entries(p) ^ power(p);
                            printf('W(%d, %d)^%d ', mod(combs(d, p) - 1, n) + 1, floor((combs(d, p) - 1) / n) + 1, power(p));
                        end
                        if (ps < size(powers, 1))
                            printf(' + ');
                        end
                        tmp = quants(ps) * tmp / factorial(k);
                        printf('/ %d = %f + \n', factorial(k), tmp);                        
                        val = val + tmp;                        
                    end
                end
            end
        end
    end
    Zvals(i, j, :, :) = val;
    
    % Taylor approx.
%     v = bin_i' * W * bin_j;    
%     for k = 0 : maxpower
%         val = val + v^k / factorial(k);
%     end 
    
    % Exact.   
    Zvals_real(i, j, :, :) = exp(bin_i' * W * bin_j);
  end
end
fprintf('_______________________________\n');
fprintf('Z = %f\n\n', sum(Zvals_real(:)));
fprintf('Z_comb = %f\n\n', sum(Zvals(:)));

P0 = 2^(n + m);
fprintf('P0 = %f\n', P0);

P1 = (sum(exp(W(:))) - length(W(:))) * 2^(n + m - 2);
fprintf('P1 = %f\n', P1);

% idxs
% 1 1 0 
% 
% x^2 / 2!
% 2 * W(1, 1)^1 W(1, 2)^1 / 2 = 1.000000 + 
% x^3 / 3!
% 3 * W(1, 1)^1 W(1, 2)^2  + / 6 = 0.500000 + 
% 3 * W(1, 1)^2 W(1, 2)^1 / 6 = 0.500000 +  
% 
% 
% idxs
% 1 0 1 
% 
% x^2 / 2!
% 2 * W(1, 1)^1 W(1, 3)^1 / 2 = 1.000000 + 
% x^3 / 3!
% 3 * W(1, 1)^1 W(1, 3)^2  + / 6 = 0.500000 + 
% 3 * W(1, 1)^2 W(1, 3)^1 / 6 = 0.500000 + 
% 
% 
% idxs
% 0 1 1 
% 
% x^2 / 2!
% 2 * W(1, 2)^1 W(1, 3)^1 / 2 = 1.000000 + 
% x^3 / 3!
% 3 * W(1, 2)^1 W(1, 3)^2  + / 6 = 0.500000 + 
% 3 * W(1, 2)^2 W(1, 3)^1 / 6 = 0.500000 + 
% 
% 
% idxs
% 1 1 1 
% 
% x^2 / 2!
% 2 * W(1, 1)^1 W(1, 2)^1 / 2 = 1.000000 + 
% 2 * W(1, 1)^1 W(1, 3)^1 / 2 = 1.000000 + 
% 2 * W(1, 2)^1 W(1, 3)^1 / 2 = 1.000000 + 
% x^3 / 3!
% 3 * W(1, 1)^1 W(1, 2)^2  + / 6 = 0.500000 + 
% 3 * W(1, 1)^2 W(1, 2)^1 / 6 = 0.500000 + 
% 3 * W(1, 1)^1 W(1, 3)^2  + / 6 = 0.500000 + 
% 3 * W(1, 1)^2 W(1, 3)^1 / 6 = 0.500000 + 
% 3 * W(1, 2)^1 W(1, 3)^2  + / 6 = 0.500000 + 
% 3 * W(1, 2)^2 W(1, 3)^1 / 6 = 0.500000 + 

 
% exp(sum(sum(W))) - 1 = 
% (W(1, 1) + W(1, 2) + W(1, 3)) / 1! + 
% (W(1, 1) ^ 2 + W(1, 2) ^ 2 + W(1, 3) ^ 2 + 2 * W(1, 1) W(1, 2) + 2 * W(1, 2) W(1, 3) + 2 * W(1, 1) W(1, 3)) / 1! + 
% (W(1, 1) ^ 3 + W(1, 2) ^ 3 + W(1, 3) ^ 3 + 3 * W(1, 1) ^ 2 W(1, 2) + 3 * W(1, 1) W(1, 2) ^ 2 + 3 * W(1, 1) ^ 2 W(1, 3) + 3 * W(1, 1) W(1, 3) ^ 2 + 3 * W(1, 2) ^ 2 W(1, 3) + 3 * W(1, 2) W(1, 3) ^ 2 ) / 2! + 

% sum(sum(exp(W))) .^ 2


% sum(sum(exp(W))) - length(W(:)) = 
% (W(1, 1) + W(1, 2)) / 1! +
% (W(1, 1)^2 + W(1, 2)^2 + W(1, 3)^2) / 2! +
% (W(1, 1)^3 + W(1, 2)^3 + W(1, 3)^3) / 3! +


% P2 = (sum(sum(W)) .^ 2 .* 2 + ...
%      (sum(sum(W, 2) .^ 2)) .* 2 + ...
%      sum(sum(W .^ 2)) .* 2  + ...
%      sum(sum(W, 1) .^ 2) .* 2) / 32 * 2 ^ (n + m);
P2 = (exp(sum(sum(W))) - 1 - sum(sum(exp(W))) + length(W(:))) * 2 ^ (n + m - 3);
% P2 = (sum(sum(exp(W))) .^ 2 - sum(sum(exp(W)))) * 2 ^ (n + m - 3);

fprintf('P2 = %f\n', P2);




