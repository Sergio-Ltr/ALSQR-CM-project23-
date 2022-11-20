function [combinations] = GetTimeCombinations(values)

if length(values)==3
    m_range = values('m_range');
    n_range = values('n_range');
    combinations = {};
    for m = m_range
        for n = n_range
            combinations{end +1} = [m, n];
        end
    end

else
    combinations = GetCombinations(values);
end
