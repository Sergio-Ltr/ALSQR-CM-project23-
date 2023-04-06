%% Experiment A
%
% Encodes the setup for experiment different configurations of the A
% matrix, taking into account different matrix shape/dimensions and sparsity
% property.
%
%% Syntax
%
% [] = A_Experiment (experiment)
%
%% Description
%
% A parameter set, implemented as a matlab container (a.k.a a key-value
% dictionary) is populated with the values to be used in executing the
% given experiment. 
% The parameter set will be populated as follow:
%   - m_range : (range or array) all possible values for first dimension of A matrix to try out 
%   - n_range : (range or array) all possible values for second dimension of A matrix to try out
%   - k_min : (int) min value of k 
%   - k_max : (int) max value of k
%   - k_stride : (int) stride for k range
%   - k_limits : (int) limits value for k to be added on the  k range 
%   - d_range : (int) density paramter of the involved matrix A, with d
%   belonging to (0,1)
%   - reg_parameter : (array) [lambda U, lambda V] Thikonov regularization parameter
%   - stop_parameter : (array) [Max num of iterations, epsilon, xi] stopping
%   condition parameter
%
%% Parameters 
%
% Experiment_A has a unique parameter that is a key string referring to one possible values
% set. The possible values of "experiment" parameter are:
%   - "sparsity": experiment useful to evaluate low rank approximation algorithm behaviour with
%  sparse matrix A
%   - "shape": experiment useful to evaluate low rank approximation algorithm behaviour with
%  matrix A with different dimension (tall-thin, square, fat-short)
%
%% Output 
%
% No explicit output are avaible. The result of the experiments will be saved
% in the corresponding csv file: 
%   - Result of sparsity experiments will be avaialable in sparsity_experiments_Properties.csv and sparsity_experiments_Result.csv
%   - Result of shape experiments will be avaialable in shape_experiments_Properties.csv and shape_experiments_Result.csv     
%
%% Examples
%
%   Experiment_A ("sparsity")
%   Experiment_A ("shape")
%
%% ------------------------------------------------------------------------
function [] = Experiment_A (experiment)

value2test = containers.Map;

if experiment == "sparsity"
    
    value2test('type') = experiment;
    value2test('m_range') = [100, 150, 200];
    value2test('n_range') = [50, 100];
    value2test('k_range') = [5, 20, 30];
    value2test('d_range') = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0];
    value2test('reg_parameter')  = [0.0, 0.0];
    value2test('stop_parameter') = [500, 1e-6, 1e-12];
    
    ExecuteExperiment_A(value2test);
    fprintf("Experiment successfully completed. " + ...
            "Results are available in files: " + ...
            "\n - sparsity_experiments_Properties.csv " + ...
            "\n - sparsity_experiments_Result.csv \n");
    
elseif experiment == "shape"

    value2test('type') = experiment;
    value2test('m_range') = 55:10:250;
    value2test('n_range')  = 150;
    value2test('k_range') = 50;
    value2test('d_range')  = 1; 
    value2test('reg_parameter')  = [0, 0];
    value2test('stop_parameter') = [500, 1e-6, 1e-12];

    ExecuteExperiment_A(value2test);
    fprintf("Experiment successfully completed. " + ...
            "Results are available in files: " + ...
            "\n - shape_experiments_Properties.csv " + ...
            "\n - shape_experiments_Result.csv \n");

else
    fprintf("The entered experiment type is invalid. Experiment not completed. \n");
end 



