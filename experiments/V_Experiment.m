%% A Experiment 
% Encodes the setup(s) for experiment differnet configurations of the V
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

%% Examples
%
%
%% ---------------------------------------------------------------------------------------------------
function [value2test] = V_Experiment (experiment)

value2test = containers.Map;

value2test('m_range') = 150;
value2test('n_range') = 100;
value2test('k_min') = [];
value2test('k_max') = 50;
value2test('k_stride') = 0;
value2test('k_limits') = [];
value2test('d_range') = 0.5;
value2test('reg_parameter')  = [0.5, 0.5];
value2test('stop_parameter') = [500, 0, 10e-6, 10];

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



