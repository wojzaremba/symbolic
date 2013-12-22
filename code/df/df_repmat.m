function ret = df_repmat(s, repdim)
  global n_ m_
  ret = struct();  
  ret.name = 'df_repmat';
  ret.params = {s};
  ret.dim1 = s.dim1;
  ret.dim2 = s.dim2;
  ret.repdim = repdim;
  if (ret.repdim == 1)
    assert(ret.dim1 == 1);
    ret.dim1 = n_;
  end
  if (ret.repdim == 2)
    assert(ret.dim2 == 1);
    ret.dim2 = m_;
  end  
  ret.complex = s.complex + ret.dim1 * ret.dim2;
  ret.toStringImpl = @toStringImpl;
  
  function str = toStringImpl(ret)
    p = ret.params{1};
    if (ret.repdim == 1)
      str = sprintf('repmat(%s, [n, 1])', toString(p));
    else
      str = sprintf('repmat(%s, [1, m])', toString(p));
    end
  end  
end