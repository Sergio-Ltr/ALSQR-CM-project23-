%% Time Experiment 
% Encodes setting for performing different time efficiency evaluation of
% Alternate optimization algorithm and Thin QR factorization on different
% matrix configuration as dataset.
%% Syntax
%[value2test] = Time_Experiment (experiment)
%
%% Description
% A parameter set, implemented as a matlab container (a.k.a a key-value
% dictionary) is populated with the values to be used executing the
% algorithm.
%
% When study time efficiency of QR the parameter set will be populated with 
%   m_range : all possible values for first dimension of matrix to try out 
%   n_range : all possible values for second dimension of matrix to try out 
%
% When study time efficiency of QR the parameter set will be populated with 
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
%  - "QRfactorization_time" to evaluate time efficiency of our ThinQR wrt to our FullQR and matlab Thin QR.
%  - "solver_time" to evaluate time efficiency of our low rank
%  approximation algorithm wrt Truncated SVD.
%% Examples
% [value2test] = Time_Experiment ("QRfactorization_time")
% or 
% [value2test] = Time_Experiment ("solver_time")
%% ------------------------------------------------------------------------

function [value2test] = Time_Experiment (experiment)

value2test = containers.Map;

if experiment == "QRfactorization_time"
    
    value2test('type') = experiment;
    value2test('m_range') = 525:25:1000;
    value2test('n_range')  = 25:25:500;
   
    ExecuteTimeExperiment(value2test);

elseif experiment == "solver_time"

    value2test('type') = experiment;
    value2test('m_range') = [20];
    value2test('n_range')  =  [15];
    value2test('k_min') = 10;
    value2test('k_max') = 10;
    value2test('k_stride') = 1;
    value2test('k_limits') = [];
    value2test('d_range')  = [1]; 
    value2test('reg_parameter')  = [0, 0];
    value2test('stop_parameter') = [200, 0, 1e-6, 50];

    ExecuteTimeExperiment(value2test);

else
    fprintf("Experiment type is not well-defined")
end


   

