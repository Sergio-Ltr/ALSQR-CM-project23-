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


   

