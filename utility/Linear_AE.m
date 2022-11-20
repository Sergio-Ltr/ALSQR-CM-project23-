function [AE] =  Linear_AE(data, k, hyperparameters)
    net = patternnet;

    net.layers{1}.name = "Encoder"; 
    net.layers{1}.transferFcn = 'purelin';
    net.layers{1}.dimensions = k;

    net.layers{2}.name = "Decoder";
    net.layers{2}.transferFcn = 'purelin';

    net = train(net, data, data);
    view(net);


    %AE.LW(2) Encoder weights !! But we also have biases | n x k 
    %AE.b(1) Encoder biases | k x 1

    %AE.IW(2) Decoder weights !! But we also have biases | k x n
    %AE.b(2) Decoder biases. | n x 1
    
    AE = net;

