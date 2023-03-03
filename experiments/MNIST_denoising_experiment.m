function MNIST_denoising_experiment(k, lambda_u, lambda_v, noise, digit)
    
    if nargin < 2
        lambda_u = 0;
        lambda_v = 0;
    elseif nargin < 3
        lambda_v = lambda_u;
    end

    i = 1;
    epochs_comb = [5, 25, 100];
    d = size(epochs_comb,2) +1;
    
    [tr, ts] = MNIST_Loader([digit]);
        
    subplot(d,4,2), imshow(reshape(ts.images(:,18),[28,28])*255);

    A_tr = tr.images';
    A_ts = ts.images';

    rng default
    if nargin > 3 && noise ~= 0
        A_tr = awgn(A_tr,noise,'measured');
        A_ts = awgn(A_ts,noise,'measured');
    end

    subplot(d,4,3), imshow(reshape(A_ts(18,:),[28,28])*255);

    for epochs = epochs_comb
        AE = Linear_AE(k, A_tr', tr.images, epochs);
        A_rec= AE(A_ts');

        disp([digit, ") AE Error:", norm(ts.images - A_rec)/size(A_rec,2), "."]) 
        subplot(d,4,1+4*i), imshow(reshape(A_rec(:, 18),[28,28])*255);

        [v_enc, v_dec] = Solver(A_tr, k, [lambda_u, lambda_v], [epochs, 0, 0, 0], Initialize_V(784, k), 0, 1);
        
        %Encoder Forward propagation
        if lambda_u == 0
            U = [ones(size(A_ts,1),1),A_ts]*v_enc;
        else
            U = [ones(size(A_ts,1),1),A_ts]*v_enc(1:size(A_ts,2)+1,:);
        end

        %Decoder Forward propagation 
        A_rec = [ones(size(U,1),1),U]*v_dec';

        disp([digit, ") Fully biased ALS Error:", norm(ts.images' - A_rec)/size(A_rec,2), "."]) 
        subplot(d,4,2+4*i), imshow(reshape(A_rec(18,:),[28,28])*255);

        %Greedy Biased ALS
        [v_enc, v_dec] = Solver(A_tr, k, [lambda_u, lambda_v], [epochs, 0, 0, 0], Initialize_V(784, k), 0, 2);
        %Encoder Forward propagation 
        if lambda_u == 0
            U = [ones(size(A_ts,1),1),A_ts]*v_enc;
        else
            U = [ones(size(A_ts,1),1),A_ts]*v_enc(1:size(A_ts,2)+1,:);
        end
        %Decoder Forward propagation 
        A_rec = [ones(size(U,1),1),U]*v_dec';

        disp([digit, ") Gready Biased ALS Error:", norm(ts.images' - A_rec)/size(A_rec,2), "."]) 
        subplot(d,4,3+4*i), imshow(reshape(A_rec(18,:),[28,28])*255);


        %Unbiased ALS
        [v_enc, v_dec] = Solver(A_tr, k, [lambda_u, lambda_v], [epochs, 0, 0, 0], Initialize_V(784, k), 0, 0);
        %Encoder Forward propagation 
        if lambda_u == 0
            U = A_ts*v_enc;
        else
            U = A_ts*v_enc(1:size(A,2),:);
        end
        %Decoder Forward propagation 
        A_rec = U*v_dec';
       
       disp([digit, ") Unbiased ALS Error:", norm(ts.images' - A_rec)/size(A_rec,2), "."])
       subplot(d,4,4+4*i), imshow(reshape(A_rec(18,:),[28,28])*255);
       
       i = i+1;
    end