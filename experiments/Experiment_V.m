%% Experiment V 
%
% Encodes the setup(s) for experiment different initialization of the V0
% matrix, taking into account different matrix properties.
%
%% Syntax
%
% [] = Experiment_V (experiment)
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
%   - param : (int) or nan, parameter of the specific initialization. If
%   nan is used the deafult initialization parameter values is taken into account.
%
%% Parameters 
%
% Experiment_A has a unique parameter that is a key string referring to one possible values
% set. The possible values of "experiment" parameter are:
%  - sparse : sparse matrix V0 with density d
%  - dist : Element of V0 sampled from a specific distributions
%  - orth : orthonormal matrix V0
%  - low_rank : not full column rank matrix V0
%  - features-selection : sparse matrix V0 with density with only binary
%  values
%  - probs : column as sum to one vector with random values 
%
%% Output 
%
% No explicit output are avaible. The result of the experiments will be saved
% in the corresponding csv file: 
%   - Result of dist experiments will be avaialable in dist_experiments_Properties.csv and dist_experiments_Result.csv
%   - Result of sparse experiments will be avaialable in sparse_experiments_Properties.csv and sparse_experiments_Result.csv
%   - Result of orth experiments will be avaialable in orth_experiments_Properties.csv and orth_experiments_Result.csv
%   - Result of low_rank experiments will be avaialable in low_rank_experiments_Properties.csv and low_rank_experiments_Result.csv     
%   - Result of feature-selection experiments will be avaialable in feature-selection_experiments_Properties.csv and feature-selection_experiments_Result.csv
%   - Result of prob experiments will be avaialable in prob_experiments_Properties.csv and prob_experiments_Result.csv     
%
%% Examples
%
%   Experiment_V ("dist")
%   Experiment_V ("sparse")
%   Experiment_V ("orth")
%   Experiment_V ("low_rank")
%   Experiment_V ("feature-selection")
%   Experiment_V ("prob")
%
%% ------------------------------------------------------------------------

function [] = Experiment_V (experiment)

value2test = containers.Map;

value2test('m_range') = [100, 150, 200];
value2test('n_range') = [50, 100];
value2test('k_range') = [5, 20, 30];
value2test('d_range') = 1;
value2test('reg_parameter')  = [0, 0];
value2test('stop_parameter') = [500, 1e-6, 1e-12];

if experiment == "dist"

    value2test('type') = experiment;
    value2test('param') = nan; % normal distribution

    ExecuteExperiment_V(value2test)
    fprintf("Experiment successfully completed. " + ...
            "Results are available in files: " + ...
            "\n - dist_experiments_Properties.csv " + ...
            "\n - dist_experiments_Result.csv \n");
    
elseif experiment == "sparse"

    value2test('type') = experiment;
    value2test('param') = 0.5;

    ExecuteExperiment_V(value2test)
    fprintf("Experiment successfully completed. " + ...
            "Results are available in files: " + ...
            "\n - sparse_experiments_Properties.csv " + ...
            "\n - sparse_experiments_Result.csv \n");

elseif experiment == "orth"

    value2test('type') = experiment;
    value2test('param') = nan; % no parameter

    ExecuteExperiment_V(value2test)
    fprintf("Experiment successfully completed. " + ...
            "Results are available in files: " + ...
            "\n - orth_experiments_Properties.csv " + ...
            "\n - orth_experiments_Result.csv \n");

elseif experiment == "low_rank"

    value2test('type') = experiment;
    value2test('param') = nan; % rank(V0) = k-1
    
    ExecuteExperiment_V(value2test)
    fprintf("Experiment successfully completed. " + ...
            "Results are available in files: " + ...
            "\n - low_rank_experiments_Properties.csv " + ...
            "\n - low_rank_experiments_Result.csv \n");

elseif experiment == "feature-selection"

    value2test('type') = experiment;
    value2test('param') = 0.5;

    ExecuteExperiment_V(value2test)
    fprintf("Experiment successfully completed. " + ...
            "Results are available in files: " + ...
            "\n - feature-selection_experiments_Properties.csv " + ...
            "\n - feature-selection_experiments_Result.csv \n");

elseif experiment == "prob"

    value2test('type') = experiment;
    value2test('param') = nan; %no parameter needed
    
    ExecuteExperiment_V(value2test)
    fprintf("Experiment successfully completed. " + ...
            "Results are available in files: " + ...
            "\n - prob_experiments_Properties.csv " + ...
            "\n - prob_experiments_Result.csv \n");
    
else
    fprintf("The entered experiment type is invalid. Experiment not completed. \n")
end 




