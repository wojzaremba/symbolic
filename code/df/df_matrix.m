function ret = df_matrix(val, dim1, dim2) 
  global n_ m_
  ret = struct();  
  ret.name = 'df_matrix';
  ret.params = {};
  ret.val = val;
  ret.dim1 = dim1;
  ret.dim2 = dim2;
  ret.toStringImpl = @toStringImpl;
  ret.complex = ret.dim1 * ret.dim2;
  
  function str = toStringImpl(ret)
    global lang
    if (strcmp(lang, 'matlab'))
        str = ret.val;
    else       
        str = 'W_{i, j}';
    end
  end  
end