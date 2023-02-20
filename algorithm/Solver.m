%% Solver
%
% Low rank approximation algorithm (A), returning a low rank approximation
% of an input matrix A, already factorized as the k inner product of two matrices U and V.
%
%% Syntax
%
%  [U,V] = Solver(A, k) 
%  [U,V] = Solver(A, k, [lambda_u, lambda_v])
%  [U,V] = Solver(A, k, [lambda_u, lambda_v], [max_epoch, eps, xi, patience])
%  [U,V] = Solver(A, k, [lambda_u, lambda_v], [max_epoch, eps, xi, patience], V_0)
%  [U,V] = Solver(A, k, [lambda_u, lambda_v], [max_epoch, eps, xi, patience], V_0, verbosity)
%   
%% Description
%
% Execute the alternate optimization loop, solving at each iteration the
% two subproblmes (1) and (2) as sets of LLS problmes. 
%
% Input constraint are checked here, if any (hyper)parameter is not specified, default values are applied here. 
% 
% Values used to generate the plots are collected here and passed to the
% plotter function (unless verbosity is disabled). 
%
%% Parameters 
% 
% A: The target initial matrix. 
%
% k: (lower) rank we want to approximate A to. 
%
% reg_parameter: The two ridge regression parameter to use for subproblem
%   (1) and (2) respectively
%
% stop_criteria: A four element array containing: 
%  -1): max number of epochs allowed. 
%  -2): epsilon threshold for relative error. 
%  -3): xi threshold for converngence rate
%  -4): patience, number of iterations to be waited after local stop criteria being triggered.  
% for more information check the "StoppingCriteria" function. 
%
% initial_V: The V_0 matrix to use at the very first iteration to compute U_1.
%
% verbosity: wether we want or not plots and logs to be computed and displayed. 
%
% decides whetehr to have a biased or an unbiased optimization. 
%   - value = 0: "classical" alternate optimiation, no bias at all. 
%   - value = 1: biased training (officially alternate optimization). 
%   - value = 2: unbiased training, biased weights vectors are compouted
%       only at the end. 
%
%% Examples
%
%  A = randn(500, 12)
%  V_0 = ones(12, 12)

%  [U,V] = Solver(A, 8) 
%
%  No regularization, 100 epochs without early stopping, random (full
%  column rank) initial V_0, verbose
%  
%  [U,V] = Solver(A, 8, [0.5, 0.5]) <- Custom Regularization 
%  [U,V] = Solver(A, 8, [0.5, 0.5], [200, 0, 0, 0]) <- Custom Early Stopping
%  [U,V] = Solver(A, 8, [0.5, 0.5], [200, 0, 0, 0], V_0) <- Custom Initial V
%  [U,V] = Solver(A, 8, [0.5, 0.5], [200, 0, 0, 0], V_0, 0) <- Non verbose
%  
%% ---------------------------------------------------------------------------------------------------

function [U, V, l, last_cr_v, last_rs_v] = Solver (A, k, reg_parameter, stop_param, initial_V, verbosity, bias)

m = size(A,1);
n = size(A,2);

%% Handling of the custom parameters. 

if nargin > 2 
    % Custom Tikonov regularization hyper-parameter (lambda_u, lamda_v). 
    lambda_u = reg_parameter(1);
    lambda_v = reg_parameter(2);
else 
    % No regularization. 
    lambda_u = 0;
    lambda_v = 0;
end

if nargin > 3 
    % Custom stopping criteria.
    stop_condition = stop_param;
else 
    % No stop criteria, only dummy iteration.
    stop_condition = [100, 0,0,0]; 
end
max_epoch = stop_condition(1);

if nargin > 4 
    if size(initial_V, 2) == k 
        % Custom Initial V. 
        V = initial_V;
    else
        error("V size does not match with k ");
    end
else 
    % Random Initial V.
    V = Initialize_V(n, k); 
end

if nargin > 5 && verbosity == 0
    % Not verbose only if specified. 
    verbose = 0;
else
    % Default behaviour is verbose. 
    verbose = 1;
end

if nargin > 6 && bias == 1
    V = [V, zeros(n,1)];
    V_biased = randn(n+1, k);
end

%% Compute optimal error and A*
[opt_err, optA] = optimalK(A, k);

opt_err
size(A)


%% Create arrays to save data for plots. 

residual_step_1 = zeros(max_epoch,1);
residual_step_2 = zeros(max_epoch,1);

convergence_u_story = zeros(max_epoch,1);
convergence_v_story = zeros(max_epoch,1);

u_norm_story = zeros(max_epoch,1);
v_norm_story = zeros(max_epoch,1);

A_norm_story = zeros(max_epoch*2, 1);

%u_err_prev = 1;
%v_err_prev = 1;

%u_err2_prev = 1;
%v_err2_prev = 1;

%% Early stooping parameter;

local_stop = 0; 
l = max_epoch;

%% Alternate optimization loop.
for i = 1:max_epoch
    
    %% Solve subproblem (1) and (2). 
    if nargin <= 6 || ( nargin > 6 && bias ~= 1) 
        % Unbiased Training
        [U,u_err, V_enc] = ApproximateU(A, V, lambda_u,0);
         A_s1 = U*V';
        [V,v_err] = ApproximateV(A, U, lambda_v);
         A_s2 = U*V';

    end

    if nargin > 6 && bias == 1
        % V correspond to V_dec
        if i == max_epoch
            [U,~, V_enc] = ApproximateU(A, V_biased, lambda_u, 1);
            u_err = norm(A-[ones(m,1), U]*V', "fro");
            
        else 
            [U,~, ~] = ApproximateU(A, V_biased, lambda_u, 1);
            u_err = norm(A- [ones(m,1), U]*V', "fro");
        end

        [V,v_err] = ApproximateV(A, U, lambda_v, 2);
        [V_biased, ~] = ApproximateV(A, U, lambda_v, 1);
    end
    
    %% Computing A_k approximation fo the step
    if nargin > 6 && bias == 1
        A_k = [ones(m,1), U]*V';
    else
        A_k = U*V';
    end
    
    %% Save results for the plots.
    residual_step_1(i) = u_err/norm(A, "fro");
    residual_step_2(i) = v_err/norm(A, "fro");
    
    %convergence_u_story(i) = u_err/u_err_prev;
    %convergence_v_story(i) = v_err/v_err_prev;

    convergence_u_story(i) = (u_err - opt_err) /opt_err;
    convergence_v_story(i) = (v_err - opt_err) /opt_err;


    u_norm_story(i) = norm(U, "fro");
    v_norm_story(i) = norm(V, "fro");

    A_norm_story((i-1)*2+1) = norm(A_s1, "fro");
    A_norm_story(i*2) = norm(A_s2, "fro");

    %u_err_prev = u_err;
    %v_err_prev = v_err;

    %u_err2_prev = u_err2;
    %v_err2_prev = v_err2;
       
    %% Check stopping criteria.
    if i > 1
        rel_err = v_err/norm(A, "fro");
        convergence_rate = norm(A_prev - A_k, "fro") / norm(A_prev, "fro");
        [stop, local_stop] = StoppingCriteria(i, stop_condition, rel_err, convergence_rate, local_stop);
        if stop == true
            l = i; 
            break
        end
    end

    A_prev = A_k;
end

%% Call the plotting functions.
if verbose
    Plotter([residual_step_1 residual_step_2], [convergence_u_story convergence_v_story], [u_norm_story v_norm_story ], [A_norm_story], norm(optA, "fro"))
end

%% Return last values
last_cr_v = convergence_v_story(l);
last_rs_v = residual_step_2(l);

%% Adjust return values in case of bias
if  nargin > 6 && bias == 2
    [V_biased, ~] = ApproximateV(A, U, lambda_v, 1);
    [~,~,V_enc] = ApproximateU(A, V_biased, lambda_u, 1);
    [V, ~] =  ApproximateV(A, U, lambda_v, 2);
end

if nargin > 6
    
    U = V_enc;
end

%optimalError = optimalK(A, k)
%residual_step_2(50)

%norm(A*A' - U*U', "fro")

%norm(A'*A - V*V', "fro")
