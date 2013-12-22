function ret = df_transpose(a)
  ret = struct();   
  ret.name = 'df_transpose';
  ret.params = {a};
  ret.dim1 = a.dim2;
  ret.dim2 = a.dim1;
  ret.toStringImpl = @toStringImpl;
  ret.complex = a.complex + a.dim1 * a.dim2;
  
  function str = toStringImpl(ret)
    p = ret.params{1};
    str = sprintf('(%s'')', toString(p));
  end  
end