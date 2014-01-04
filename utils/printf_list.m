function str = printf_list(params, op)
  assert(length(params) >= 1);
  chunk = toString(params{1});
  str = '';
  for j = 2:length(params)
    p_str = toString(params{j});
    if ((length(chunk) + length(p_str)) >= 80)
        if (length(str) > 0)
            str = sprintf('%s ...\n %s', str, chunk);
        else
            str = chunk;
        end
        chunk = '';
    end
    chunk = sprintf('%s %s %s', chunk, op, p_str);    
  end
  str = sprintf('(%s %s)', str, chunk);
end