clc;
addpath(genpath('.'));
global debug
debug = 1;
W = TestData(6, 5);

funcs = {X(), X2(), X3(), X4()};

for i = 1 : length(funcs)
  fun = funcs{i};
  printf('Verifying function %s\n', fun.name);
  num = Numerical(fun);
  logZ = fun.FP(W);
  num_logZ = num.FP(W);  
  check_close(logZ, num_logZ, 'logZ');
end