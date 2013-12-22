function [O11, O1R, OR1, ORR] = GetOuter(v, h)
    O11 = outer(v == 1, h == 1);
    O1R = outer(v == 1, h == Inf);
    OR1 = outer(v == Inf, h == 1);
    ORR = outer(v == Inf, h == Inf);
end

function ret = outer(v, h)
  ret = double(v == 1) * double(h' == 1);
end