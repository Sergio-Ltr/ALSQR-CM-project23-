%% generateKrange
%
% Given  m and n values, this function return all the suitable range of value
% for k rank in order to appropriatly perform the low rank approximation
% problem avoiding ill-posed problem definition.
%
%% Syntax
% 
% [filter_k_range] = generateKrange (m,n, initial_values, k_stride, k_possible_max)
%
%% Description
%
% This function compute a range of suitable value for k, given m, n,
% desidered min value of k, derisered stride of the range and the possible
% max k value.
% It check if k is always lower than min (m, n); if the posssible max k value is equal to
% 0 then the max value is choosen as min (k_possible_max, min(m,n)-1); 
%
%% Parameters 
% 
% m : value of  dimension
% n : value of n dimension
% initial_values : min value of k 
% k_stride : desired stride for the range of k values
% k_possible_max : max value of k 
%
%% Output
%
% filter_k_range = [k_1, k_2, k_3, k_4 .... k_i]
%
%% Examples
%
% [filter_k_range] = generateKrange (200, 300, 10, 20, 190)
%
%% ---------------------------------------------------------------------------------------------------
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

