function show_results(coeffs, normalization, grammar)
  computations = cell(length(grammar), 1);
  for i = 1:length(grammar)
    computations{i} = MultElemwise({grammar{i}.computation, Matrix(num2str(coeffs(i) / normalization), 1, 1)});
  end
  computation = Sum(computations);
  fprintf('P = %s;\n', toString(computation));
  fprintf('complex = %d\n', computation.complexity);
end