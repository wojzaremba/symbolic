function ret = df_marg(s, sumdim)
  ret = struct();  
  ret.params = {s};  
  ret.name = 'df_marg';
  ret.dim1 = s.dim1;
  ret.dim2 = s.dim2;
  ret.sumdim = sumdim;
  if (sumdim == 1)
    ret.dim1 = 1;
  elseif (sumdim == 2)
    ret.dim2 = 1;
  elseif (sumdim == 0)
    ret.dim1 = 1;
    ret.dim2 = 1;
  end
  ret.toStringImpl = @toStringImpl;
  ret.complex = s.complex + s.dim1 * s.dim2;
  
  function str = toStringImpl(ret)
    global lang
    p1 = ret.params{1};
    if (strcmp(lang, 'matlab'))
        if ((ret.sumdim == 1) || (ret.sumdim == 2))
          str = sprintf('sum(%s, %d)', toString(p1), ret.sumdim);
        else
          str = sprintf('ssum(%s)', toString(p1));
        end
    elseif (strcmp(lang, 'latex'))
        if (ret.sumdim == 1)
            str = sprintf('\\sum_{i = 1, \\dots, m} %s', toString(p1));
        elseif (ret.sumdim == 2)
            str = sprintf('\\sum_{j = 1, \\dots, m} %s', toString(p1));
        else
            str = sprintf('qqq(%s)', toString(p1));
        end        
    end
  end  
end