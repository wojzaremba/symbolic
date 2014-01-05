global expr_type
expr_type = 'Zp'; 
power = 4;

clc;
addpath(genpath('.'));
Cache(power);
load('~/grammar', 'grammars', 'c');

G = grammars(1, 1);
GBig = grammars(4, 5);

W = GBig.expr_matrices(1);

R = {};
R{end + 1} = multiply( multiply(marginalize(marginalize(W, 2), 1), marginalize(marginalize(W, 2), 1)), multiply(marginalize(marginalize(W, 2), 1), marginalize(marginalize(W, 2), 1)));
R{end + 1} = marginalize(( elementwise_multiply(marginalize(W, 2), multiply(multiply(W, transpose(W)), marginalize(W, 2)))), 1);
R{end + 1} = marginalize(marginalize(elementwise_multiply(W, multiply(multiply(W, transpose(W)), W)), 2), 1);
R{end + 1} = marginalize(marginalize(elementwise_multiply( multiply( multiply(W, transpose(W)), W), repmat_expr(marginalize(W, 1), [c.n, 1])), 2), 1);
R{end + 1} = marginalize(marginalize(elementwise_multiply( marginalize(marginalize(W, 2), 1), multiply( multiply(W, transpose(W)), W)), 2), 1);
R{end + 1} = marginalize(marginalize(elementwise_multiply( multiply( marginalize(marginalize(W, 2), 1), marginalize(marginalize(W, 2), 1)), elementwise_multiply(W, W)), 2), 1);
R{end + 1} = marginalize(marginalize(elementwise_multiply( multiply( marginalize(marginalize(W, 2), 1), marginalize(marginalize(W, 2), 1)), elementwise_multiply( W, repmat_expr(marginalize(W, 2), [1, c.m]))), 2), 1);
R{end + 1} = marginalize(marginalize(elementwise_multiply( multiply( marginalize(marginalize(W, 2), 1), marginalize(marginalize(W, 2), 1)), elementwise_multiply( W, repmat_expr(marginalize(W, 1), [c.n, 1]))), 2), 1);
for i = 1 : length(R)
    if (~G.hashmap.isKey(R{i}.hash))
        fprintf('FAIL %d\n', i);
    else
        fprintf('PASS %d -> %d\n', i, G.hashmap(R{i}.hash));
    end
end

%      ( ( marginalize(( marginalize(W, 2) .* marginalize(W, 2)), 1) * marginalize(( marginalize(W, 2) .* marginalize(W, 2)), 1)) * 0.011719) + ...
%      ( ( marginalize(( marginalize(W, 2) .* marginalize(W, 2)), 1) * marginalize(marginalize(( W .* W), 2), 1)) * 0.023437) + ...
%      ( ( marginalize(( marginalize(W, 2) .* marginalize(W, 2)), 1) * marginalize(marginalize(( W .* repmat_expr(marginalize(W, 1), [c.n, 1])), 2), 1)) * 0.023438) + ...
%      ( ( marginalize(marginalize(( W .* W), 2), 1) * marginalize(marginalize(( W .* W), 2), 1)) * 0.011719) + ...
%      ( ( marginalize(marginalize(( W .* W), 2), 1) * marginalize(marginalize(( W .* repmat_expr(marginalize(W, 1), [c.n, 1])), 2), 1)) * 0.023438) + ...
%      ( ( marginalize(marginalize(( W .* repmat_expr(marginalize(W, 1), [c.n, 1])), 2), 1) * marginalize(marginalize(( W .* repmat_expr(marginalize(W, 1), [c.n, 1])), 2), 1)) * 0.011719) + ...
%      ( marginalize(( marginalize(W, 2) .* marginalize(( ( W .* W) .* repmat_expr(marginalize(W, 2), [1, c.m])), 2)), 1) * -0.046875) + ...
%      ( marginalize(( ( marginalize(W, 2) .* marginalize(W, 2)) .* ( marginalize(W, 2) .* marginalize(W, 2))), 1) * -0.0078125) + ...
%      ( marginalize(( marginalize(( W .* W), 2) .* marginalize(( W .* W), 2)), 1) * -0.023438) + ...
%      ( marginalize(marginalize(( ( W .* W) .* ( W .* W)), 2), 1) * 0.015625) + ...
%      ( marginalize(marginalize(( ( W .* repmat_expr(marginalize(W, 1), [c.n, 1])) .* ( W .* repmat_expr(marginalize(W, 1), [c.n, 1]))), 2), 1) * -0.046875) + ...
%      ( marginalize(marginalize(( ( W .* W) .* repmat_expr(marginalize(( W .* W), 1), [c.n, 1])), 2), 1) * -0.023437) + ...
%      ( marginalize(marginalize(( ( W .* repmat_expr(marginalize(W, 1), [c.n, 1])) .* repmat_expr(( marginalize(W, 1) .* marginalize(W, 1)), [c.n, 1])), 2), 1) * -0.0078125);