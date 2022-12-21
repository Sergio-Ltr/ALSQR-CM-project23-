%% Stopping Criteria 
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
function [] = ShapeExperiment()

stop_parameter = [100, 10e-3, 10e-5, 10];
reg_parameter  = [true, 0.1, 0.1];

m_range = 10:10:30;  
n_range = 10:10:30; 

k_limits = [2,5,10];
k_min = 25; 
k_max = 250; 
k_stride = 25;

d_range = 0.5:0.25:1; 



textHeader = '"m_size", "n_size", "k_rank", "density", "last_epoch_mean", "last_epoch_std", "tot_time_mean","tot_time_std", "epoch_time_mean","epoch_time_std", "precision_mean",  "precision_std"';
%{
data = [0,0,0,0,0,0,0,0];
fid = fopen('sparsity_experiment.csv','w'); 
fprintf(fid,'%s\n',textHeader)
fclose(fid)
csvwrite_with_headers('sparsity_experiment.csv', data, textHeader);
%}
time_repetita = 5; 



for m = m_range
    for n = n_range
        %for k = cat(2, k_limits, k_min: k_stride: min( max(m,n), k_max))
        for k = [2,5]
            for d = d_range
                A = full(sprand(m,n,d));
                optimal_err = optimalK(A, k);

                tot_time_elapsed = zeros(time_repetita,1);
                epoch_time_elapsed = zeros(time_repetita,1);
                precision = zeros(time_repetita,1);
                l = zeros(time_repetita,1);
                for i = 1:time_repetita
                    tic 
                    %f = @() Solver (A, k, stop_parameter, 1);
                    %time_elapsed = timeit(f);
                    [U,V, l(i)] = Solver(A, k, reg_parameter, stop_parameter, 1); 
                    tot_time_elapsed(i) = toc;
                    epoch_time_elapsed(i) = tot_time_elapsed(i)/l(i); 
                    
                    err = norm(A-U*V', "fro");
                    
                    precision(i) = err - optimal_err;
                end

                dlmwrite('temp.csv',[m,n,k,d, mean(l),std(l), mean(tot_time_elapsed), std(tot_time_elapsed), mean(epoch_time_elapsed), std(epoch_time_elapsed), mean(precision), std(precision)],'delimiter',',','-append');
            end
        end
    end
end
data = csvread('temp.csv');
fid = fopen('sparsity_experiment.csv','w'); 
fprintf(fid,'%s\n',textHeader)
fclose(fid)
dlmwrite('sparsity_experiment.csv',data, '-append');

