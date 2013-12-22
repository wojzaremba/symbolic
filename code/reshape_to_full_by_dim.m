function str = reshape_to_full_by_dim(s, dim)
  rep_dim1 = '1';
  rep_dim2 = '1';
  if (dim == 1)
    rep_dim1 = 'n';
  else
    rep_dim2 = 'm';
  end 
  str = sprintf('repmat(%s, [%s, %s])', s, rep_dim1, rep_dim2);
end