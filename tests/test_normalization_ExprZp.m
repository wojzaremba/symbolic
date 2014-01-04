A = ExprZp([3, 5, 4], [1,2,3,0; 0, 2,1,3; 6,0,0,0]');
hash1 = A.hash;

B = ExprZp([3, 5, 4], [1,2,3,0; 0, 2,1,3; 6,0,0,0]');
B.expr = B.expr * 2;
hash2 = B.hash;

assert(norm(hash1 - hash2) == 0);