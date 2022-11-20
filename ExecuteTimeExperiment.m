function [] = ExecuteTimeExperiment(values)

type = values('type');

combs = GetTimeCombinations(values);

% compute total number of executions and combinations
time_repetita = 3; 
[~, tot_combinations] = size(combs);
tot_executions = time_repetita * tot_combinations;


wb = waitbar(0,'Start executing '+type+' esperiment');

for j = 1:tot_combinations

    msg = sprintf('In progress: executing combination %3.0f / %g', j, tot_combinations);
    wb = waitbar(j/tot_combinations, wb, msg);
    
    if type == "QRfactorization_time"
        
        m = combs{j}(1);
        n = combs{j}(2);

        ThinQR_time_elapsed = zeros(time_repetita,1);
        QR_time_elapsed  = zeros(time_repetita,1);
        mQR_time_elapsed = zeros(time_repetita,1);

        for i = 1:time_repetita
             
            A = randn(m,n); % Define A matrix
            
            tic % measure time elapsed for our Thin QR factorization
            [~, ~] = ThinQRfactorization(A);
            ThinQR_time_elapsed(i) = toc;
            
    
            tic % measure time elapsed for our QR factorization
            [~, ~] = QRfactorization(A);
            QR_time_elapsed(i) = toc;
            
            tic % measure time elapsed for MatLab QR factorization
            [~, ~] = qr(A);
            mQR_time_elapsed(i) = toc;
    
        end
        dlmwrite('temp.csv',[j, m,n, mean(ThinQR_time_elapsed), std(ThinQR_time_elapsed), mean(QR_time_elapsed), std(QR_time_elapsed), mean(mQR_time_elapsed), std(mQR_time_elapsed)],'delimiter',',','-append');
        textHeaderProperties = '"id","m_size", "n_size"';
        textHeaderResults = '"id", "mean_ThinQR_time_elapsed","std_ThinQR_time_elapsed", "mean_QR_time_elapsed", "std_QR_time_elapsed", "mean_mQR_time_elapsed", "std_mQR_time_elapsed"';
    else
        m = combs{j}(1);
        n = combs{j}(2);
        k = combs{j}(3);
        d = combs{j}(4);
        reg_parameter  = [combs{j}(9),combs{j}(10)];
        stop_parameter = [combs{j}(5),combs{j}(6), combs{j}(7), combs{j}(8)];

        solver_time_elapsed = zeros(time_repetita,1);
        svd_time_elapsed  = zeros(time_repetita,1);
        
        for i = 1:time_repetita
            % add script for solver time experiments 
        end
        textHeaderProperties = '"id","m_size", "n_size", "k_rank", "density", "lambda_u", "lambda_v"';
        textHeaderResults = '"id", "mean_solver_time_elapsed","std_solver_time_elapsed", "mean_svd_time_elapsed", "std_svd_time_elapsed"';

        
    end

end
close(wb)

% read data from temp.csv and delete its content
data = csvread('temp.csv');
fclose(fopen('temp.csv','w'));

% storing matrix properties
fid = fopen(type+'_experiments_Properties.csv','w'); 
fprintf(fid,'%s\n',textHeaderProperties);
fclose(fid);
dlmwrite(type+'_experiments_Properties.csv', data(:,1:3), '-append');

% storing results
fid = fopen(type+'_experiments_Results.csv','w'); 
fprintf(fid,'%s\n',textHeaderResults);
fclose(fid);
dlmwrite(type+'_experiments_Results.csv', data(:,[1 4:end]), '-append');

