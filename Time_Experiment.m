function [value2test] = Time_Experiment (experiment)

value2test = containers.Map;

if experiment == "QRfactorization_time"
    
    value2test('type') = experiment;
    value2test('m_range') = cat(2, [300],[100:100:200]);
    value2test('n_range')  =  cat(2, [50],[10:20:80]);
   
    ExecuteTimeExperiment(value2test);

elseif experiment == "solver_time"

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

    
    ExecuteTimeExperiment(value2test);
else
    fprintf("Experiment type is not well-defined")
end


   

