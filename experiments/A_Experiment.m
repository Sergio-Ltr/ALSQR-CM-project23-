%% A Experiment 
% Encodes the setup(s) for experiment differnet configurations of the A
% matrix.
%% Syntax
%
%
%% Description
% A parameter set, implemented as a matlab container (a.k.a a key-value
% dictionary) is populated with the values ot be used executing the
% algorithm. 
%% Parameters 
% the unique parameter is a key string referring to one possible values
% set.
% experiment: (possible values)
%  - "sparsity" number of 0s in the A matrix.
%  - "shape" m and n dimension of the A matrix. 
%  - "simmetry" A being a square matrix resulting from the product D*D'. 
%% Examples
%
%
%% ---------------------------------------------------------------------------------------------------
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
    %PlotExperiment(experiment+'.csv') 
    
elseif experiment == "shape"

    % 

    value2test('type') = experiment;
    value2test('m_range') = cat(2, [10, 50],[100:50:250]);
    value2test('n_range')  =  cat(2, [10, 50],[100:50:250]);
    value2test('k_min') = 50; 
    value2test('k_max') = 200;
    value2test('k_stride') = 50;
    value2test('k_limits') = [2];
    value2test('d_range')  = [1]; 
    value2test('reg_parameter')  = [1, 1];
    value2test('stop_parameter') = [2000, 0, 1e-6, 50]; % non inizializzare patience uguale a 0 perchè vuol dire che si interrompe subito l'esecuzione  (vuol dire patience esaurita)  

    ExecuteExperiment(value2test);

elseif experiment == "simmetry"
    
    value2test('type') = experiment;
    value2test('m_range') = cat(2, [50],[100:100:200]);
    value2test('n_range')  =  cat(2, [50],[100:100:200]);
    value2test('k_min') = 50;
    value2test('k_max') = 0;
    value2test('k_stride') = 100;
    value2test('k_limits') = [2];
    value2test('d_range')  = [1];
    value2test('reg_parameter')  = [1, 1];
    value2test('stop_parameter') = [100, 0, 0, 10];

    ExecuteExperiment(value2test);

elseif experiment == "distribution"
    
    value2test('type') = experiment;
    value2test('m_range') = cat(2, [10, 50],[100:100:200]);
    value2test('n_range')  =  cat(2, [10, 50],[100:100:200]);
    value2test('k_min') = 50;
    value2test('k_max') = 0;
    value2test('k_stride') = 100;
    value2test('k_limits') = [2];
    value2test('d_range')  = [1]; 
    value2test('reg_parameter')  = [1, 1];
    value2test('stop_parameter') = [100, 0, 0, 10];
    
else
    fprintf("Experiment type is not well-defined")
end 



