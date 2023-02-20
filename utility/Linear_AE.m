%% Linear_AE
%
%  Train a one level autoencoder with k-hidden units and identity
%  activation function. 
%% Syntax
% 
% AE = Linear_AE(data, k)
%% Description
%
% Training is executed using 
% Best hyperparameter search is totally delegated to the library. 
%
%% Parameters 
%
% data: the tall thin data matrix (m rows x n featueres) with m >> n.
% k: number of hidden units in the hidden level, for our low rank approximation purposes we assume
% n > k and hence the AE to be undercomplete.
%% Examples
% 
% A = randn(1000, 10)
% k = 4
% AE = Linear_AE(A, k)
%% ---------------------------------------------------------------------------------------------------
function [AE] =  Linear_AE(tr, k)
    net = patternnet;

    net.layers{1}.name = "Encoder"; 
    net.layers{1}.transferFcn = 'purelin';
    net.layers{1}.dimensions = k;

    net.layers{2}.name = "Decoder";
    net.layers{2}.transferFcn = 'purelin';
    net.layers{2}.dimensions = size(tr,1);
    net.trainParam.epochs = 25;
    net.performFcn = 'mse';

    net = train(net, awgn(tr,10,'measured'));
    view(net);

    AE = net;

    AE.LW{2}; %Encoder weights !! But we also have biases | n x k 
    AE.b{1}; %Encoder biases | k x 1

    AE.IW{1}; %Decoder weights !! But we also have biases | k x n
    AE.b{2}; % Decoder biases. | n x 1
    

   %size(AE.LW{2})
   %size(AE.b{1})

   %size(AE.IW{1})
   %size(AE.b{2})
 
    

