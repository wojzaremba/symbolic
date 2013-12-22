function ret = df_mult_elemwise(params)
  ret = struct();   
  ret.name = 'df_mult_elemwise'; 
  assert(length(params) > 1);  
  ret.ones_params = {};
  ret.rest_params = {};  
  ret.complex = 0;
  for i = 1:length(params)
    if ((params{i}.dim1 == 1) && (params{i}.dim2 == 1))
      ret.ones_params{end + 1} = params{i};
    else
      ret.rest_params{end + 1} = params{i};
    end
    ret.complex = ret.complex + params{i}.complex + ...
                  params{i}.dim1 * params{i}.dim2;
  end
  for i = 1:(length(ret.rest_params) - 1)
    assert(ret.rest_params{i}.dim1 == ret.rest_params{i + 1}.dim1);
    assert(ret.rest_params{i}.dim2 == ret.rest_params{i + 1}.dim2);
  end
  if (~isempty(ret.rest_params))
    ret.dim1 = ret.rest_params{1}.dim1;
    ret.dim2 = ret.rest_params{1}.dim2;
  else
    ret.dim1 = 1;
    ret.dim2 = 1;
  end  
  ret.params = [ret.ones_params(:); ret.rest_params(:)];
  ret.toStringImpl = @toStringImpl;
  
  function str = toStringImpl(ret)    
    str = printf_list(ret.params, '.*');
  end  
end