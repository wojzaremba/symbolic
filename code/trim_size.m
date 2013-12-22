function grammarK = trim_size(grammar, k1, k2)
  grammarK = {};
  for i = 1:length(grammar)
      if ((grammar{i}.power(1) == k1) && (grammar{i}.power(2) == k2))
        grammarK{end + 1} = grammar{i};
      end
  end
end