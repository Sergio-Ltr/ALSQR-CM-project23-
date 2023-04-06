%% TSNE
%
% This function aims to compare the hidden representation resulting from
% different AE training like back-propagation, unbiased ALS-QR, Fully biased 
% ALS-QR and Greedy Biased ALS-QR. 
%
%% Syntax
%
% TSNE(k, lambda_u, lambda_v, noise, epochs)
%
%% Description
%
% t-SNE (tsne) is an algorithm for dimensionality reduction that is
% well-suited to visualizing high-dimensional data. 
% 
% We exploits tsne algorithm in order to visualize difference between the hidden 
% representation learned in the hidden layer (i.e. V matrix aka V encoded 
% matrix ) throughtout severals training algorithm: back-propagation, unbiased ALS-QR, 
% Fully biased ALS-QR and Greedy Biased ALS-QR. 
%
%% Parameters 
%
% -  k: rank for the low rank approximation problem 
% - lambda_u : thikonov paramter for U matrix
% - lambda_v : thikonov paramter for V matrix
% - noise : white gaussian noise to be added to dataset
% - epochs : max number of iteration to be performed
%
%% Examples
%
% TSNE(10, 0.2, 0.2, 0, 1000)
%
%% ------------------------------------------------------------------------
function TSNE(k, lambda_u, lambda_v, noise, epochs)
    rng default % for reproducibility
    [tr, ts] = MNIST_Loader([0,1,5]);

     A_tr = tr.images;
     A_ts = ts.images;

    if nargin > 3 && noise ~= 0
        A_tr = awgn(A_tr,noise,'measured');
        A_ts = awgn(A_ts,noise,'measured');
    end

    A_ts = A_ts';
    %"AE Embeddings"
    
    AE = Linear_AE(k, A_tr, tr.images, epochs);
    w_enc = zeros(785,k);

    w_enc(1,:) =  AE.b{1}'; %Encoder biases | k x 1
    w_enc(2:end,:) = AE.LW{2}; %Encoder weights| n x k 
    
    % Simualte forward propagation to obtain the hidden layer embeddings.
    U_ae = [ones(size(A_ts,1),1),A_ts]*w_enc;

    AE_ne = tsne(U_ae);
    subplot(2,2,1)
    gscatter(AE_ne(:,1),AE_ne(:,2), ts.labels')
    title('AE Embeddings')

    %"Unbiased ALS Embeddings"
    [v_enc, ~] = Solver(A_tr', k, [lambda_u, lambda_v], [epochs, 0, 0 ], Initialize_V(784, k), 0, 0);

    if lambda_u == 0
        U_als = A_ts*v_enc;
    else
        U_als = A_ts*v_enc(1:size(A,2),:);
    end

    ALS_ne = tsne(U_als);
    subplot(2,2,2)
    gscatter(ALS_ne(:,1), ALS_ne(:,2), ts.labels')
    title('Unbiased ALS Embeddings')

    %"Fully Biased ALS Embeddings"
    [v_enc, ~] = Solver(A_tr', k, [lambda_u, lambda_v], [epochs, 0, 0 ], Initialize_V(784, k), 0, 1);

    if lambda_u == 0
        U_als = [ones(size(A_ts,1),1),A_ts]*v_enc;
    else
        U_als = [ones(size(A_ts,1),1),A_ts]*v_enc(1:size(A,2),:);
    end

    ALS_ne = tsne(U_als);
    subplot(2,2,3)
    gscatter(ALS_ne(:,1),ALS_ne(:,2), ts.labels')
    title('Fully Biased ALS Embeddings')

    %"Greedy  Biased ALS Embeddings"
    [v_enc, ~] = Solver(A_tr', k, [lambda_u, lambda_v], [epochs, 0, 0 ], Initialize_V(784, k), 0, 2);

    if lambda_u == 0
        U_als = [ones(size(A_ts,1),1),A_ts]*v_enc;
    else
        U_als = [ones(size(A_ts,1),1),A_ts]*v_enc(1:size(A,2),:);
    end
    
    ALS_ne = tsne(U_als);
    subplot(2,2,4)
    gscatter(ALS_ne(:,1),ALS_ne(:,2), ts.labels')
    title('Greedy  Biased ALS ALS Embeddings')