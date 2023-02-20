function MNIST_denoising_experiment(k, lambda_u, lambda_v)
    if nargin < 2
        lambda_u = 0;
        lambda_v = 0;
    elseif nargin < 3
        lambda_v = lambda_u;
    end

    for digit = 8:9
        digit
        [tr, ts] = MNIST_Loader(digit);
        AE = Linear_AE(tr.images, k);
        
        %Epochs are 25.
        "AE Error:"
        A = awgn(ts.images,10,'measured');
        perform(AE, A, ts.images)
        
        A = A';
        "Bias Trained ALS Error"
        [v_enc, v_dec] = Solver(awgn(tr.images',10,'measured'), k, [lambda_u, lambda_v], [25, 0, 0, 0], Initialize_V(784, k), 1, 1);
        
        %Encoder Forward propagation
        if lambda_u == 0
            U = [ones(size(A,1),1),A]*v_enc;
        else
            U = [ones(size(A,1),1),A]*v_enc(1:size(A,2)+1,:);
        end

        %Decoder Forward propagation 
        A_rec = [ones(size(U,1),1),U]*v_dec';

        norm(ts.images' - A_rec)/size(A_rec,1)

        "Gready Biased ALS Error"
        [v_enc, v_dec] = Solver(awgn(tr.images',10,'measured'), k, [lambda_u, lambda_v], [25, 0, 0, 0], Initialize_V(784, k), 1, 2);
        %Encoder Forward propagation 
        if lambda_u == 0
            U = [ones(size(A,1),1),A]*v_enc;
        else
            U = [ones(size(A,1),1),A]*v_enc(1:size(A,2)+1,:);
        end
        %Decoder Forward propagation 
        A_rec = [ones(size(U,1),1),U]*v_dec';
       
        norm(ts.images' - A_rec)/size(A_rec,1)

        "Unbiased approximation"
        [v_enc, v_dec] = Solver(awgn(tr.images',10,'measured'), k, [lambda_u, lambda_v], [25, 0, 0, 0], Initialize_V(784, k), 1, 0);
        %Encoder Forward propagation 
        if lambda_u == 0
            U = A*v_enc;
        else
            U = A*v_enc(1:size(A,2),:);
        end
        %Decoder Forward propagation 
        A_rec = U*v_dec';
       
        norm(ts.images' - A_rec)/size(A_rec,1)
    end