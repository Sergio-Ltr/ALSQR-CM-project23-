%% Execute Experiment 
%
%% Syntax
%
%
%% Description
%
%
%% Parameters 
%
%
%% Examples
%
%
%% ---------------------------------------------------------------------------------------------------
function [] = ExecuteExperiment(values)

% declaring experimental type (es. "sparsity_experiment")
type = values('type');

% get all possible values combinations
combs = GetCombinations(values);

% repeat each combination 5 times
time_repetita = 30; 

% total number of considered combinations
[~, tot_combinations] = size(combs);

% total number of executions 
tot_executions = time_repetita * tot_combinations;
%sprintf('Tototal combinations:'+tot_combinations);
%sprintf('Tototal execution:'+tot_executions);

wb = waitbar(0,'Start executing '+type+' esperiment');

for j = 1:tot_combinations
    msg = sprintf('In progress: executing combination %3.0f / %g', j, tot_combinations);
    wb = waitbar(j/tot_combinations, wb, msg);
    % get values from a given combination
    m = combs{j}(1);
    n = combs{j}(2);
    k = combs{j}(3);
    d = combs{j}(4);
    reg_parameter  = [combs{j}(9),combs{j}(10)];
    stop_parameter = [combs{j}(5),combs{j}(6), combs{j}(7), combs{j}(8)];
    
    % inizialize variable for analyze required time and obtained solution 
    tot_time_elapsed = zeros(time_repetita,1);
    epoch_time_elapsed = zeros(time_repetita,1);
    precision = zeros(time_repetita,1);
    rel_precision = zeros(time_repetita,1);
    l = zeros(time_repetita,1);
    cr = zeros(time_repetita,1);
    rs = zeros(time_repetita,1);
    
    % Define matrix A
    % TO DO: call correct A initilization wrt experiments type
    if type == "sparsity"
        A = full(sprand(m,n,d));
        
    elseif type == "simmetry"
        A = randn(m,n);
        A = A*A';
    
    elseif type == "distribution"
        A = randn(m,n);
        A = random('normal',0,1,size(A));   
    else
         A = randn(m,n);
    end

    % compute optimal error with Truncated SVD
    optimal_err = optimalK(A, k);
    
    
    for i = 1:time_repetita
        % define matrix A
        A = Initialize_A(m,n,'sparse',d);
        % compute optimal error with Truncated SVD
        optimal_err = optimalK(A, k);

        tic 
        % solve the problem with our algorithm
        [U,V, l(i), cr(i), rs(i)] = Solver(A, k, reg_parameter, stop_parameter, 1); 
        %tempcr = cr(i)
        %rs(i)
        
        % compute time required          
        tot_time_elapsed(i) = toc;
        epoch_time_elapsed(i) = tot_time_elapsed(i)/l(i); 
         
        % compute precision
        err = norm(A-U*V', "fro");               
        precision(i) = err - optimal_err;
        rel_precision(i) = precision(i)/optimal_err;
    end
    %meanrs = mean(rs)
    dlmwrite('temp.csv',[j, m,n,k,d, reg_parameter(1), reg_parameter(2), mean(cr), std(cr), mean(rs), std(rs), mean(l),std(l), mean(tot_time_elapsed), std(tot_time_elapsed), mean(epoch_time_elapsed), std(epoch_time_elapsed), mean(precision), std(precision), mean(rel_precision), std(rel_precision)],'delimiter',',','-append');
end
close(wb)

% read data from temp.csv and delete its content
data = csvread('temp.csv');
fclose(fopen('temp.csv','w'));

% storing matrix properties
textHeaderProperties = '"id","m_size", "n_size", "k_rank", "density", "lambda_u", "lambda_v"';
fid = fopen(type+'_experiments_Properties.csv','w'); 
fprintf(fid,'%s\n',textHeaderProperties);
fclose(fid);
dlmwrite(type+'_experiments_Properties.csv', data(:,1:7), '-append');

% storing results
textHeaderResults = '"id", "mean_cr","std_cr", "mean_rs", "std_rs",last_epoch_mean", "last_epoch_std", "tot_time_mean","tot_time_std", "epoch_time_mean","epoch_time_std", "precision_mean",  "precision_std", "rel_precision_mean",  "rel_precision_std"';
fid = fopen(type+'_experiments_Results.csv','w'); 
fprintf(fid,'%s\n',textHeaderResults);
fclose(fid);
dlmwrite(type+'_experiments_Results.csv', data(:,[1 8:end]), '-append');
