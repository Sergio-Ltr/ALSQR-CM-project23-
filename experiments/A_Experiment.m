
function [value2test] = A_Experiment (experiment)

%{ 
Experiment on A matrix: 
---> Choose one of the possibile experiment values 

(1) Experimens wrt A properties:

    sparsity
    distribution
    simmetry

(2) Experimens wrt A shapes:

    tall_thin
    short_fat
    almost_square
    square
    decreasing_rank
%}

value2test = containers.Map;

if experiment == "sparsity"
    
    value2test('type') = experiment;
    value2test('m_range') = [10:10:20];
    value2test('n_range')  = [10:10:20];
    value2test('k_min') = 4;
    value2test('k_max') = 4;
    value2test('k_stride') = 8;
    value2test('k_limits') = [2];
    value2test('d_range')  = 0.5:0.5:1; 
    value2test('reg_parameter')  = [1, 1];
    value2test('stop_parameter') = [100, 10e-3, 10e-5, 10];
    
    %[comb] = GetCombinations(value2test);
    ExecuteExperiment(value2test);
    %PlotExperiment(experiment+'.csv') 
    
elseif experiment == "shape"

    value2test('type') = experiment;
    value2test('m_range') = cat(2, [10, 50], [100:100:500]);
    value2test('n_range')  =  cat(2, [10, 50], [100:100:500]);
    value2test('k_min') = 50;
    value2test('k_max') = 0;
    value2test('k_stride') = 50;
    value2test('k_limits') = [2,5,10,25];
    value2test('d_range')  = [1]; 
    value2test('reg_parameter')  = [1, 1];
    value2test('stop_parameter') = [100, 0, 0, 10]; % non inizializzare patience uguale a 0 perchè vuol dire che si interrompe subito l'esecuzione  (vuol dire patience esaurita)  

    ExecuteExperiment(value2test);

elseif experiment == "distribution"

elseif experiment == "simmetry"
elseif experiment == "tall_thin"
elseif experiment == "short_fat"
elseif experiment == "almost_square"
elseif experiment == "square"
elseif experiment == "decreasing_rank"
else
    fprintf("Experiment type is not well-defined")
end 

