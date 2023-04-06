%% Linear_AE
%
%  Train a one level autoencoder with k-hidden units and identity
%  activation function. 
%
%% Syntax
% 
% AE = Linear_AE(k, tr_x, tr_y, epochs)
%
%% Description
%
% Training is executed using the data provided and a custom number of epochs
% Best hyperparameter search is totally delegated to the library. 
%
%% Parameters 
%
% k: number of hidden units in the hidden level, for our low rank 
%   approximation purposes we assume n > k and hence the AE to be undercomplete.
%
% tr_x, tr_y: input and target vectors of the training data. They can be
%             identical or noise can be added to tr_x before the passage. 
% 
% epochs: number of training iterations. 
%
%% Examples
% 
% A = randn(1000, 10)
% k = 4
%
% AE = Linear_AE(k, tr_x, tr_y, epochs)
%
%% ---------------------------------------------------------------------------------------------------
function [AE] =  Linear_AE(k, tr_x, tr_y, epochs)
    net = patternnet;

    net.layers{1}.name = "Encoder"; 
    net.layers{1}.transferFcn = 'purelin';
    net.layers{1}.dimensions = k;

    net.layers{2}.name = "Decoder";
    net.layers{2}.transferFcn = 'purelin';
    net.layers{2}.dimensions = size(tr_x,1);

    net.trainParam.epochs = epochs;
    net.performFcn = 'mse';

    net = train(net, tr_x, tr_y);
    %view(net);

    AE = net;

    %AE.LW{2}; %Encoder weights !! But we also have biases | n x k 
    %AE.b{1}; %Encoder biases | k x 1

    %AE.IW{1}; %Decoder weights !! But we also have biases | k x n
    %AE.b{2}; %Decoder biases. | n x 1
