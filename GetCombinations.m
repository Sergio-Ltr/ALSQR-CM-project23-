function [combinations] = GetCombinations(values)

% read possible values for each variable
m_range = values('m_range');
n_range = values('n_range');
k_min   = values('k_min');
k_max   = values('k_max');
k_stride = values ('k_stride');
k_limits = values ('k_limits');
d_range  = values('d_range'); 
stop = values('stop_parameter');
reg  = values ('reg_parameter');

% inizialize a list of all possible combinations
combinations = {};

for m = m_range
    for n = n_range
        %for k = cat(2, k_limits, k_min: k_stride: min(min(m,n), k_max))
        k_range = generateKrange(m,n, cat(2, k_limits, k_min), k_stride, k_max);
        for k = k_range
            for d = d_range
                % add a single combination  to the list of all possible combinations
                combinations{end +1} = [m, n, k, d, stop, reg];
            end
        end
    end
end

% total number of considered combinations
[~, tot_combinations] = size(combinations)

% total number of executions 
tot_executions = 5 * tot_combinations