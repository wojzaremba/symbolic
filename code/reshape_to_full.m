function str = reshape_to_full(s, val)
  rep_dim1 = '1';
  rep_dim2 = '1';
  if (size(val, 1) == 1)
    rep_dim1 = 'n';
  end
  if (size(val, 2) == 1)
    rep_dim2 = 'm';
  end
  if ((size(val, 1) ~= 1) && (size(val, 2) ~= 1))
    str = s;
  else
    str = sprintf('repmat(%s, [%s, %s])', s, rep_dim1, rep_dim2);
  end
end