function [AE] =  LinearAE(data, k, hyperparameters)
    net = patternnet;

    net.layers{1}.name = "Encoder"; 
    net.layers{1}.transferFcn = 'purelin';
    net.layers{1}.dimensions = k;

    net.layers{2}.name = "Decoder";
    net.layers{2}.transferFcn = 'purelin';

    net = train(net, data, data);
    view(net);

    AE = net;

