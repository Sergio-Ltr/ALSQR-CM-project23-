%% GetCombinations 
% 
% Get combinations of parameter values to test during experimental phase,
% given all the paramter and their values that must be considered.
%
%% Syntax
%  
% [combinations] = GetCombinations(values)
%
%% Description
% 
% Given the required parameter and their possibile value, the function
% compute all possible combinations of parameter values.
% it is useful in performing experiments with more combinations. 
%% Parameters 
% values: Container of all parameter and corresponding value to be tested
% 
% for QR experiments only 3 parameter are needed
%   - value('m_range') = [minimum value : stride : max value]
%   - value('m_range') = [minimum value : stride : max value]
%   - value('type') = "experiment type "
% 
% for all the other experiments
%   - value('m_range') = [minimum value : stride : max value]
%   - value('m_range') = [minimum value : stride : max value]
%   - value('type') = "experiment type "
%   - value('k_min') = min value;
%   - value('k_max') = max value;
%   - value('k_stride') = stride;
%   - value('k_limits') = [limit values 1, limit values 2 ...]
%   - value('d_range')  = [min values : stride : max value]
%   - value('reg_parameter')  = [1, 1];
%   - value('stop_parameter') = [max epochs, epsilon, xi, patience]
%% Examples
% 
% prepare container of parameters and values
%
% values('type') = "sparse"
% value('m_range') = [10:10:20];
% value('n_range')  = [10:10:20];
% value('k_min') = 4;
% value('k_max') = 4;
% value('k_stride') = 8;
% value('k_limits') = [2,9];
% value('d_range')  = [0.0:0.1:1]; 
% value('reg_parameter')  = [1, 1];
% value('stop_parameter') = [500, 10e-3, 10e-5, 10];
%
% get all the possible combinations of paramter values
% [combinations] = GetCombinations(values)
%% ---------------------------------------------------------------------------------------------------
function [combinations] = GetCombinations(values)

% inizialize a list of all possible combinations
combinations = {};

if length(values)==3

     % read possible values for each variable
    m_range = values('m_range');
    n_range = values('n_range');
    
    for m = m_range
        for n = n_range
            if m > n
                % add a single combination  to the list of all possible combinations
                combinations{end +1} = [m, n];
            end
        end
    end

else

    % read possible values for each variable
    m_range = values('m_range');
    n_range = values('n_range');
    %{
    k_min   = values('k_min');
    k_max   = values('k_max');
    k_stride = values ('k_stride');
    k_limits = values ('k_limits');
    %}
    k_range = values('k_range');
    stop = values('stop_parameter');
    reg  = values ('reg_parameter');
    
    if isKey(values, "d_range") == true
        d_range  = values('d_range'); 
    end
    
    for m = m_range
        for n = n_range
            %k_range = generateKrange(m,n, cat(2, k_limits, k_min), k_stride, k_max);
            for k = k_range
                for d = d_range
                    % add a single combination  to the list of all possible combinations
                    combinations{end +1} = [m, n, k, d, stop, reg];
                end
            end
        end
    end
end
