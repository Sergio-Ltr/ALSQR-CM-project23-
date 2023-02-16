function [combinations] = GetTimeCombinations(values)

combinations = {};

if length(values)==3
    m_range = values('m_range');
    n_range = values('n_range');
    
    for m = m_range
        for n = n_range
            if m > n
                combinations{end +1} = [m, n];
            end
        end
    end

else
    combinations = GetCombinations(values);
end
