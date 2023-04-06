%% Experiment Time
%
% Encodes setting for performing different time efficiency evaluation of
% Alternate optimization for low rank approximantion algorithm (ALS QR) and Thin QR factorization on different
% matrix configuration as dataset.
%
%% Syntax
%
% [] = Time_Experiment (experiment)
%
%% Description
%
% A parameter set, implemented as a matlab container (a.k.a a key-value
% dictionary) is populated with the values to be used in executing the
% given experiment. 
%
% When study time efficiency of ThinQR factorization tThe parameter set will be populated as follow:
%   - m_range : (range or array) all possible values for first dimension of A matrix to try out 
%   - n_range : (range or array) all possible values for second dimension of A matrix to try out 
%
% When study time efficiency of ALSQR the parameter set will be populated as follow:
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
% Experiment_Time has a unique parameter that is a key string referring to one possible values
% set. The possible values of "experiment" parameter are:
%  - "QRfactorization_time" to evaluate time efficiency of our ThinQR wrt 
%  to our FullQR and matlab Thin QR.
%  - "ALSQR_time" to evaluate time efficiency of our low rank
%  approximation algorithm wrt Truncated SVD.
%
%% Output 
%
% No explicit output are avaible. The result of the experiments will be saved
% in the corresponding csv file: 
%   - Result of ALSQR time efficiency experiments will be avaialable in ALSQR_time_experiments_Properties.csv and ALSQR_time_experiments_Result.csv
%   - Result of QR factorization time efficiency experiments will be avaialable in QRfactorization_time_experiments_Properties.csv and QRfactorization_experiments_Result.csv     
%
%% Examples
% 
%   Time_Experiment ("QRfactorization_time")
%   Time_Experiment ("ALSQR_time")
%
%% ------------------------------------------------------------------------

function [value2test] = Experiment_Time (experiment)

value2test = containers.Map;

if experiment == "QRfactorization_time"
    
    value2test('type') = experiment;
    value2test('m_range') = 525:25:1000;
    value2test('n_range')  = 25:25:500;
   
    ExecuteExperiment_Time(value2test);
    fprintf("Experiment successfully completed. " + ...
            "Results are available in files: " + ...
            "\n - QRfactorization_time_experiments_Properties.csv " + ...
            "\n - QRfactorization_time_experiments_Result.csv \n");

elseif experiment == "ALSQR_time"

    value2test('type') = experiment;
    value2test('m_range') = 20;
    value2test('n_range') = 15;
    value2test('k_min') = 10;
    value2test('k_max') = 10;
    value2test('k_stride') = 1;
    value2test('k_limits') = [];
    value2test('d_range')  = 1; 
    value2test('reg_parameter')  = [0, 0];
    value2test('stop_parameter') = [500, 1e-6, 1e-12];

    ExecuteExperiment_Time(value2test);
    fprintf("Experiment successfully completed. " + ...
            "Results are available in files: " + ...
            "\n - ALSQR_time_experiments_Properties.csv " + ...
            "\n - ALSQR_time_experiments_Result.csv \n");

else
    fprintf("The entered experiment type is invalid. Experiment not completed. \n");
end


   

