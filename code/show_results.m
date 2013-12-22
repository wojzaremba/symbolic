function show_results(coeffs, normalization, grammar)
  global all_expr stack last_expr
  all_expr = containers.Map;
  stack = {};
  last_expr = 0;
  descs = {};
  for i = 1:length(grammar)
    descs{end + 1} = df_mult({grammar{i}.desc, df_matrix(num2str(coeffs(i) / normalization), 1, 1)});
  end
  desc = df_sum(descs);
%   desc = optimize_code(desc);
%   parse_struct_df(desc);
%   for i = 1:length(stack)
%     fprintf('%s\n', stack{i});
%   end
  fprintf('P = %s;\n', toString(desc));
  fprintf('complex = %d\n', desc.complex);
end