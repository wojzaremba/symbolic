Cache(5);
n = 10;
m = 5;
A = randn(n, 1);
B = Marginalize(RepmatScaled(Matrix('A', 10, 1), 2), 2);

assert(norm(eval(B.toString()) - A) < 1e-4);