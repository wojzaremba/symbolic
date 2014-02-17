Cache(12, 1);
quant = [3, 5, 4];
expr = [1,2,3,0; 0, 2,1,3; 6,0,0,0]';

A = ExprZp(quant, expr);
B = ExprZp(2 * quant, expr);
C = ExprZp(quant, 2 * expr);

assert(strcmp(A.hash, B.hash) == 1);
assert(strcmp(A.hash, C.hash) ~= 1);

A = ExprSymbolic(quant, expr);
B = ExprSymbolic(2 * quant, expr);
C = ExprSymbolic(quant, 2 * expr);

assert(norm(double(A.hash - B.hash)) == 0);
assert(norm(double(A.hash - C.hash)) ~= 0);