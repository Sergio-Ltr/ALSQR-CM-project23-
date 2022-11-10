
function [] = ExecuteExperiment(values)

% declaring experimental type (es. "sparsity_experiment")
type = values('type');

% get all possible values combinations
combs = GetCombinations(values);

% repeat each combination 5 times
time_repetita = 5; 

% total number of considered combinations
[~, tot_combinations] = size(combs);

% total number of executions 
tot_executions = time_repetita * tot_combinations


for j = 1:tot_combinations

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
    l = zeros(time_repetita,1);
    cr = zeros(time_repetita,1);
    rs = zeros(time_repetita,1);
    
    % define matrix A
    A = full(sprand(m,n,d));
    % compute optimal error with Truncated SVD
    optimal_err = optimalK(A, k);
    
    
    for i = 1:time_repetita
        tic 
        % solve the problem with our algorithm
        [U,V, l(i), cr(i), rs(i)] = Solver(A, k, reg_parameter, stop_parameter, 1); 
        
        % compute time required          
        tot_time_elapsed(i) = toc;
        epoch_time_elapsed(i) = tot_time_elapsed(i)/l(i); 
         
        % compute precision
        err = norm(A-U*V', "fro");               
        precision(i) = err - optimal_err;
    end
    dlmwrite('temp.csv',[j, m,n,k,d, reg_parameter(1), reg_parameter(2), mean(cr), std(cr), mean(rs), std(rs), mean(l),std(l), mean(tot_time_elapsed), std(tot_time_elapsed), mean(epoch_time_elapsed), std(epoch_time_elapsed), mean(precision), std(precision)],'delimiter',',','-append');
end

% read data from temp.csv and delete its content
data = csvread('temp.csv');
fclose(fopen('temp.csv','w'));

% define final 
textHeader = '"id","m_size", "n_size", "k_rank", "density", "lambda_u", "lambda_v", "mean_convergencerate","std_convergencerate", "mean_residualstep", "std_residualstep",last_epoch_mean", "last_epoch_std", "tot_time_mean","tot_time_std", "epoch_time_mean","epoch_time_std", "precision_mean",  "precision_std"';
fid = fopen(type+'_experiments.csv','w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
dlmwrite(type+'_experiments.csv',data, '-append');
