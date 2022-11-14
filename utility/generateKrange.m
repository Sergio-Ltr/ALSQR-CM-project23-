function [filter_k_range] = generateKrange (m,n, initial_values, k_stride, k_possible_max)

if k_possible_max == 0
    k_max = min(m,n)-1;
else
    k_max = min(k_possible_max, min(m,n)-1); 
end

range = [max(initial_values)+ k_stride:k_stride:k_max];
range = cat(2, range, k_max);

k_range = cat(2, initial_values, range);
filter_k_range = k_range(k_range <= k_max);

%len_krange = length(k_range);