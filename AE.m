function [] =  Autoencoder()
    m = rand(15,20);
    ae = trainAutoencoder(m, 10);

    plotWeights(ae);

