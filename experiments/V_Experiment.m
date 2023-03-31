%% A Experiment 
% Encodes the setup(s) for experiment differnet configurations of the V0
% matrix, taking into account different matrix properties.
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
%   type : experiment type for taking into account a specific matrix
%   property
%   param : parameter of the specific experimental type
%% Parameters 
% the unique parameter is a key string referring to one possible values
% set.
% experiment: (possible values)
%  - sparse : sparse matrix V0 with density d
%  - dist : Element of V0 sampled from a specific distributions
%  - orth : orthonormal matrix V0
%  - low_rank : not full column rank matrix V0
%  - features-selection : sparse matrix V0 with density with only binary
%  values
%  - uniform : We assume for each one of the n feature to be equally
% determined by each of the k low rank (latent) features. Therein the only value in V0 will
% be 1/k, having columns sum to one column 
%  - probs : column as sum to one vector with random values 
%% Examples
% [value2test] = A_Experiment ("sparsity")
% [value2test] = A_Experiment ("shape")
%% ------------------------------------------------------------------------
function [value2test] = V_Experiment (experiment)

value2test = containers.Map;

value2test('m_range') = [100, 150, 200];
value2test('n_range') = [50, 100];
value2test('k_range') = [5, 20, 30];
value2test('d_range') = 1;
value2test('reg_parameter')  = [0.5, 0.5];
value2test('stop_parameter') = [500, 1e-6, 1e-12];

if experiment == "dist"
    value2test('type') = experiment;
    value2test('param') = nan;
    
elseif experiment == "sparse"
    value2test('type') = experiment;
    value2test('param') = 1;

elseif experiment == "orth"
    value2test('type') = experiment;
    value2test('param') = nan;

elseif experiment == "low_rank"
    value2test('type') = experiment;
    value2test('param') = nan; %k-1

elseif experiment == "uniform"
    value2test('type') = experiment;
    value2test('param') = nan;

elseif experiment == "feature-selection"
    value2test('type') = experiment;
    value2test('param') = 1;

elseif experiment == "prob"
    value2test('type') = experiment;
    value2test('param') = nan;
    
else
    fprintf("Experiment type is not well-defined")
end 

ExecuteVExperiment(value2test)



