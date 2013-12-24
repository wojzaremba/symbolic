function [v_fixed, h_fixed] = get_fixed_data(data_size)
  v_fixed = Inf * ones(floor(data_size / 2), 1);
  h_fixed = Inf * ones(ceil(data_size / 2), 1);
end