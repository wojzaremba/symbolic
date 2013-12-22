function [v_fixed, h_fixed] = get_fixed_data(ones_size, data_size)
  v_fixed = ones(floor(ones_size / 2) + floor(data_size / 2), 1);
  h_fixed = ones(ceil(ones_size / 2) + ceil(data_size / 2), 1);
  v_fixed((floor(ones_size / 2) + 1):end) = Inf;
  h_fixed((ceil(ones_size / 2) + 1):end) = Inf;
end