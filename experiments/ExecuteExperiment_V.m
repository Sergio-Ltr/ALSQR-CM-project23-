%% Execute Experiment V
%
% This function is defined for performing experiments with respect to
% different V0 initialization using the QRALS algorithm for solving low rank
% approximation problem wrt A. 
%
%% Syntax
%
% [] = ExecuteExperiment_V(values)
%
%% Description
%
% Given all the possible parameter values  this function compute all possible
% combinations of them and solve the problem with respect to each
% combinations.  All the results obtained with each combinations are saved
% in a corresponding csv document : 
% - {...}_experiments_Properties.csv : contains info about performed combination and the corresponding parameter values
%    (id, m_size, n_size, k_rank, density, lambda_u, lambda_v)
% - {...}_experiments_Results.csv : contains resulting info about performed
% experiments and the obtained metrics score
%    (id, mean_loss, std_loss, mean_gap, std_gap, last_epoch_mean, last_epoch_std, rel_gap_mean, rel_gap_std)
%
%% Parameters 
%  
% The function ExecuteExperiment_A has a unique parameter "values" which
% define the parameter values for ALSQR algorithm.
%  - values : map.container previuosly defined in Experiment_V.m
%
%% Output 
%
% No explicit output are avaible. The result of the experiments will be saved
% in the corresponding csv file:
%   - {...}_experiments_Properties.csv and {...}_experiments_Result.csv
%   - {...}_experiments_Properties.csv and {...}_experiments_Result.csv     
%
%% Examples
%
% ExecuteExperiment_V(values)
%
%% ------------------------------------------------------------------------
function [] = ExecuteExperiment_V(values)

% declaring experimental type (es. "orth")
type = values('type');
param = values('param');

% get all possible values combinations
combs = GetCombinations(values);

% repeat each combination 5 times
time_repetita = 5; 

% total number of considered combinations
[~, tot_combinations] = size(combs);

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
    reg_parameter  = [combs{j}(8),combs{j}(9)];
    stop_parameter = [combs{j}(5),combs{j}(6), combs{j}(7)];

    if type == "low-rank"
        param = k-1;
    end

    % inizialize A
    A = Initialize_A(m, n);
    
    % compute optimal values
    [ ~,opt_A, ~] = optimalK(A, k, reg_parameter(1), reg_parameter(2));
    
    % inizialize variable for analyze required time and obtained solution 
    l = zeros(time_repetita,1);
    loss = zeros(time_repetita,1);
    gap = zeros(time_repetita,1);
    rel_gap = zeros(time_repetita,1);
    
    for i = 1:time_repetita
        if type ~= "dist"
            V0 = Initialize_V(n,k, type, param);
        else
             V0 = Initialize_V(n,k);
        end
        [~,~, l(i), loss(i), gap(i)] = Solver(A, k, reg_parameter, stop_parameter, V0, 0, 0, opt_A);
        rel_gap(i) = gap(i)/ norm(opt_A, "fro");

    end
    
    dlmwrite('temp.csv', ...
        [j, m,n,k,d, reg_parameter(1), reg_parameter(2), ...
        mean(loss), std(loss), mean(gap), std(gap), mean(l), std(l), ...
        mean(rel_gap), std(rel_gap)], ...
        'delimiter',',','-append');
end

% close progress bar
close(wb)

% read data from temp.csv and delete its content
data = csvread('temp.csv');
fclose(fopen('temp.csv','w'));

fid = fopen(type+'_experiments_Properties.csv','w'); 
fprintf(fid,'%s\n',norm(opt_A, "fro"));
fclose(fid);

% storing matrix properties
textHeaderProperties = 'id, m_size, n_size, k_rank, density, lambda_u, lambda_v';
fid = fopen(type+'_experiments_Properties.csv','w'); 
fprintf(fid,'%s\n',textHeaderProperties);
fclose(fid);
dlmwrite(type+'_experiments_Properties.csv', data(:,1:7), '-append');

% storing results
textHeaderResults = 'id, mean_loss, std_loss, mean_gap, std_gap, last_epoch_mean, last_epoch_std, rel_gap_mean, rel_gap_std';
fid = fopen(type+'_experiments_Results.csv','w'); 
fprintf(fid,'%s\n',textHeaderResults);
fclose(fid);
dlmwrite(type+'_experiments_Results.csv', data(:,[1 8:end]), '-append');

end

