function ret = df_dot(a, b)
  ret = struct();  
  ret.name = 'df_dot';
  ret.params = {a, b}; 
  assert((a.dim1 == b.dim1) && (a.dim2 == b.dim2));
  
  ret.toStringImpl = @toStringImpl;
  ret.dim1 = 1;
  ret.dim2 = 1;
  ret.complex = a.complex + b.complex + a.dim1 * a.dim2;
  
  function str = toStringImpl(ret)
    global lang
    if (strcmp(lang, 'matlab'))
        str = sprintf('dot(%s, %s)', toString(ret.params{1}), toString(ret.params{2}));
    elseif (strcmp(lang, 'latex'))
        str = sprintf('<%s, %s>', toString(ret.params{1}), toString(ret.params{2}));
    else
        assert(0);
    end
  end  
end