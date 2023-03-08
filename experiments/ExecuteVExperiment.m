%% ExecuteVExperiment 
% This function is defined for performing experiments with respect to
% different V properties.
%% Syntax
% ExecuteVExperiment(values)
%
%% Description
% Given all the possible parameter values  this function compute all possible
% combinations of them and solve the problem with respect to each
% combinations.  All the results obtained with each combinations are saved
% in a final 2 csv document : 
% - {...}_experiments_Properties.csv : contains info about performed combination and the corresponding paramter values
%    (id, m_size, n_size, k_rank, density, lambda_u, lambda_v)
% - {...}_experiments_Results.csv : contains resulting info about performed
% experiments and the corresponding 
%    (id, mean_cr, std_cr, mean_rs, std_rs, last_epoch_mean, last_epoch_std, 
%     tot_time_mean,tot_time_std, epoch_time_mean,epoch_time_std, precision_mean, precision_std, rel_precision_mean,  rel_precision_std
%     normVinit_mean, normVinit_std, normVend_mean, normVend_std)
%
%% Parameters 
%  values : map.container previuosly defined in V_Experiments.m
%% Examples
%
% [] = ExecuteVExperiment(values)
%% ------------------------------------------------------------------------
function [] = ExecuteVExperiment(values)

% declaring experimental type (es. "orth")
type = values('type');
param = values('param');

% get all possible values combinations
combs = GetCombinations(values);

% repeat each combination 5 times
time_repetita = 5; 

% total number of considered combinations
[~, tot_combinations] = size(combs);

% total number of executions 
%tot_executions = time_repetita * tot_combinations;

% show progress bar
wb = waitbar(0,'Start executing '+type+' esperiment');

for j = 1:tot_combinations

    % show progress bar message
    msg = sprintf('In progress: executing combination %3.0f / %g', j, tot_combinations);
    wb = waitbar(j/tot_combinations, wb, msg);

    % get values from a given combination
    m = combs{j}(1);
    n = combs{j}(2);
    k = combs{j}(3);
    d = combs{j}(4);
    reg_parameter  = [combs{j}(9),combs{j}(10)];
    stop_parameter = [combs{j}(5),combs{j}(6), combs{j}(7), combs{j}(8)];

    if type == "low-rank"
        param = k-1;
    end

    % inizialize A
    A = Initialize_A(m, n);
    
    % inizialize variable for analyze required time and obtained solution 
    tot_time_elapsed = zeros(time_repetita,1);
    epoch_time_elapsed = zeros(time_repetita,1);
    precision = zeros(time_repetita,1);
    rel_precision = zeros(time_repetita,1);
    l = zeros(time_repetita,1);
    cr = zeros(time_repetita,1);
    rs = zeros(time_repetita,1);
    normV_init = zeros(time_repetita,1);
    normV_end = zeros(time_repetita, 1);

    % compute optimal error with Truncated SVD

    optimal_err = optimalK(A, k);

    %counter_nan = 0;
    
    for i = 1:time_repetita

        V0 = Initialize_V(n,k, type, param);
        %V0
        if type ~= "feature-selection"
            normV_init(i) = norm(V0, "fro");
        end
        
        tic 
        % solve the problem with our algorithm
        [U,V, l(i), cr(i), rs(i)] = Solver(A, k, reg_parameter, stop_parameter, V0, 1); 

        % compute time required          
        tot_time_elapsed(i) = toc;
        epoch_time_elapsed(i) = tot_time_elapsed(i)/l(i); 
         
        % compute precision
        err = norm(A-U*V', "fro");               
        precision(i) = err - optimal_err;
        rel_precision(i) = precision(i)/optimal_err;
        normV_end(i) = norm(V, "fro");

        %{ 
        compute how many times nan error is verified
        if nan_error == true
            counter_nan = counter_nan +1;
        end
        %}

    end
    
    dlmwrite('temp.csv', ...
        [j, m,n,k,d, reg_parameter(1), reg_parameter(2), ...
        mean(cr), std(cr), mean(rs), std(rs), mean(l), std(l), ...
        mean(tot_time_elapsed), std(tot_time_elapsed), mean(epoch_time_elapsed), std(epoch_time_elapsed), ...
        mean(precision), std(precision), mean(rel_precision), std(rel_precision), ...
        mean(normV_init), std(normV_init), mean(normV_end), std(normV_end)], ...
        'delimiter',',','-append');
end

% close progress bar
close(wb)

% read data from temp.csv and delete its content
data = csvread('temp.csv');
fclose(fopen('temp.csv','w'));

% storing matrix properties
textHeaderProperties = 'id, m_size, n_size, k_rank, density, lambda_u, lambda_v';
fid = fopen(type+'_experiments_Properties.csv','w'); 
fprintf(fid,'%s\n',textHeaderProperties);
fclose(fid);
dlmwrite(type+'_experiments_Properties.csv', data(:,1:7), '-append');

% storing results
textHeaderResults = 'id, mean_cr, std_cr, mean_rs, std_rs, last_epoch_mean, last_epoch_std, tot_time_mean, tot_time_std, epoch_time_mean, epoch_time_std, precision_mean, precision_std, rel_precision_mean, rel_precision_std, normVinit_mean, normVinit_std, normVend_mean, normVend_std';
fid = fopen(type+'_experiments_Results.csv','w'); 
fprintf(fid,'%s\n',textHeaderResults);
fclose(fid);
dlmwrite(type+'_experiments_Results.csv', data(:,[1 8:end]), '-append');

end

