%% A Experiment 
% Encodes the setup(s) for experiment differnet configurations of the A
% matrix, taking into account different matrix shape and sparsity
% properties.
%% Syntax
%[value2test] = A_Experiment (experiment)
%% Description
% A parameter set, implemented as a matlab container (a.k.a a key-value
% dictionary) is populated with the values to be used executing the
% algorithm. The parameter set will be populated with 
%   m_range : all possible values for first dimension of matrix to try out 
%   n_range : all possible values for second dimension of matrix to try out
%   k_min :  min value of k 
%   k_max : max value of k
%   k_stride : stride for k range
%   k_limits : limits value for k to be added on the  k range 
%   d_range : density paramter of the involved matrix A
%   reg_parameter : Thikonov regularization paramter, lambda U and lambda V
%   stop_parameter : Max epochs, epsilon, xi, patience
%% Parameters 
% the unique parameter is a key string referring to one possible values
% set.
% experiment: (possible values)
%  - "sparsity" to evaluate low rank approximation algorithm behaviour with
%  sparse matrix A
%  - "shape" to evaluate low rank approximation algorithm behaviour with
%  matrix A with different dimension (tall-thin, square, fat-short)
%% Examples
% [value2test] = A_Experiment ("sparsity")
% [value2test] = A_Experiment ("shape")
%% ------------------------------------------------------------------------
function [value2test] = A_Experiment (experiment)

value2test = containers.Map;

if experiment == "sparsity"
    
    value2test('type') = experiment;
    value2test('m_range') = [10:10:20];
    value2test('n_range')  = [10:10:20];
    value2test('k_min') = 4;
    value2test('k_max') = 4;
    value2test('k_stride') = 8;
    value2test('k_limits') = [2,9];
    value2test('d_range')  = 0.5:0.5:1; 
    value2test('reg_parameter')  = [1, 1];
    value2test('stop_parameter') = [500, 10e-3, 10e-5, 10];
    
    ExecuteExperiment(value2test);
    
elseif experiment == "shape"

    value2test('type') = experiment;
    value2test('m_range') = cat(2, [10, 50],[100:50:250]);
    value2test('n_range')  =  cat(2, [10, 50],[100:50:250]);
    value2test('k_min') = 50; 
    value2test('k_max') = 200;
    value2test('k_stride') = 50;
    value2test('k_limits') = [2];
    value2test('d_range')  = [1]; 
    value2test('reg_parameter')  = [1, 1];
    value2test('stop_parameter') = [2000, 0, 1e-6, 50];

    ExecuteExperiment(value2test);

else
    fprintf("Experiment type is not well-defined")
end 



