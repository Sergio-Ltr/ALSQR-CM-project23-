%% MNIST_Loader
%
% Load the MNIST dataset - both the training and the test set. 
%
%% Syntax
%
% [training, test] = MNIST_Loader(digits) 
%
%% Description
%
% Function has different reading option: you can read the whole dataset 
% (data for all digits) if no parameter are passed or
% the dataset filter by a single digits.
% 
%% Parameters 
%
%  digits : (optional) is a vector of numbers between 0 and 9 that indicates the
%  portion of dataset you want to read, related to those specific digits. 
%
%% Examples
% 
% Load the whole dataset.
% [tr, ts] = MNIST_Loader()
%
% Load all the images of the digit 4. 
% [4_training, 4_test] = MNIST_Loader([4])
%
%% ------------------------------------------------------------------------

function [training, test] = MNIST_Loader(digits) 
    
    %Import dataset from a static resource file
    data = load('resources\datasets\mnist.mat');   
    
    %Check if filter per digit was specified 
    if nargin > 0
        %Compute a mask corresponding to the digit indexes
        tr_indexes = (ismember(data.training.labels, digits));
        ts_indexes = (ismember(data.test.labels, digits));
        
        %Apply the mask to images and labels for both test and training set.
        training.images = reshape(data.training.images(:,:,tr_indexes), 28*28,[]);
        training.labels = data.training.labels(tr_indexes);
        test.images = reshape(data.test.images(:,:,ts_indexes),28*28,[]);
        test.labels = data.test.labels(ts_indexes);
    else
        %If no filter is specified return the whole dataset
        training.images = reshape(data.training.images, 28*28,[]);
        training.labels  = data.training.labels ;
        test.images = reshape(data.test.images, 28*28,[]);
        test.labels  = data.test.labels;
    end
end

