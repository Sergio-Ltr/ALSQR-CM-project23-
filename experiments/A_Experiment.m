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
    value2test('m_range') = [100, 150, 200];
    value2test('n_range') = [50, 100];
    value2test('k_range') = [5, 20, 30];
    value2test('d_range') = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0];
    value2test('reg_parameter')  = [0.0, 0.0];
    value2test('stop_parameter') = [500, 1e-6, 1e-12];
    ExecuteExperiment(value2test);
    
    
elseif experiment == "shape"

    value2test('type') = experiment;
    value2test('m_range') = [55:10:250];
    value2test('n_range')  =  [150];
    value2test('k_range') = [50];
    value2test('d_range')  = [1]; 
    value2test('reg_parameter')  = [0, 0];
    value2test('stop_parameter') = [500, 1e-6, 1e-12];

    ExecuteExperiment(value2test);

else
    fprintf("Experiment type is not well-defined")
end 



