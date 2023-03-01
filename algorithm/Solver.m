%% Solver
%
% Low rank approximation algorithm (A), returning a low rank approximation
% of an input matrix A, already factorized as the k inner product of two matrices U and V.
%
%% Syntax
%
%  [U,V] = Solver(A, k) 
%  [U,V] = Solver(A, k, [lambda_u, lambda_v])
%  [U,V] = Solver(A, k, [lambda_u, lambda_v], [max_epoch, eps, xi])
%  [U,V] = Solver(A, k, [lambda_u, lambda_v], [max_epoch, eps, xi], V_0)
%  [U,V] = Solver(A, k, [lambda_u, lambda_v], [max_epoch, eps, xi], V_0, verbosity)
%   
%% Description
%
% Execute the alternate optimization loop, solving at each iteration the
% two subproblmes (1) and (2) as sets of LLS problmes. 
%
% Input constraint are checked here, if any (hyper)parameter is not specified, 
% default values are applied here. 
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
% stop_criteria: A three element array containing: 
%  -1): max number of epochs allowed. 
%  -2): epsilon threshold for real approximation error. 
%  -3): xi threshold for heuristic approximation error. 
% for more information check the "StoppingCriteria" function. 
%
% initial_V: The V_0 matrix to use at the very first iteration to compute U_1.
%
% verbosity: wether we want or not plots and logs to be computed and displayed. 
%
% bias: decides whetehr to have a biased or an unbiased optimization, 
%   if passed, V_enc (aka V^+) is returned instead of U anyway. 
%
%   - value = 0: "classical" alternate optimiation, no bias at all,  
%   - value = 1: biased training (officially alternate optimization). 
%   - value = 2: unbiased training, biased weights vectors are compouted
%       only at the end. 
%
%% Examples
%
%  A = randn(500, 12)
%  V_0 = ones(12, 12)

%  [U,V] = Solver(A, 8) <- Default config: No regularization, 100 epochs 
%   without early stopping, random (full column rank) initial V_0, verbose
%  
%  [U,V] = Solver(A, 8, [0.5, 0.5]) <- Custom Regularization 

%  [U,V] = Solver(A, 8, [0.5, 0.5], [200, 0, 0]) <- Custom Stopping
%   criterisa: 200 epochs, no early stopping.

%  [U,V] = Solver(A, 8, [0.5, 0.5], [200, 0, 0], V_0) <- Custom Initial V

%  [U,V] = Solver(A, 8, [0.5, 0.5], [200, 0, 0], V_0, 0) <- Non verbose
%  
%% ---------------------------------------------------------------------------------------------------

function [U, V, l] = Solver (A, k, reg_parameter, stop_param, initial_V, verbosity, bias)

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
    l = stop_condition(1);
    eps = stop_condition(2);
    xi = stop_condition(3);
else 
    % No stop criteria, only dummy iteration.
    % Stop_condition = [100, 0,0]; 
    l = 100;
    eps = 0;
    xi = 0;
end

eps_stop_epoch = l;
xi_stop_epoch = l;

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

[opt_err, opt_A] = optimalK(A, k);

if verbose == 1
    [opt_err, opt_A] = optimalK(A, k);

    %% Compute optimal error and A*
   

    %% Create arrays to save data for plots. 
    residual_s1_story = zeros(l,1);
    residual_s2_story = zeros(l,1);
    
    residual_H_s1_story = zeros(l,1);
    residual_H_s2_story = zeros(l,1);
    
    convergence_u_story = zeros(l,1);
    convergence_v_story = zeros(l,1);
    
    u_norm_story = zeros(l,1);
    v_norm_story = zeros(l,1);
    
    R_U_norm_story = zeros(l,1);
    R_V_norm_story = zeros(l,1);
    
    H_s1_norm_story = zeros(l,1);
    H_s2_norm_story = zeros(l,1);
    
    A1_norm_story = zeros(l, 1);
    A2_norm_story = zeros(l, 1);
end

%%Initialize Early Stopping Variables
R_U = randn(k,k);
prev_A = Inf;
prev_H= Inf;

%% Alternate optimization loop.
for i = 1:l
    
    %% Chek wether if it's time to stop
    if i - 1 == eps_stop_epoch        
        %if verbose == 0
            %break;
        %else
            disp(["eps-stop", eps_stop_epoch])
            disp(["gap:", norm(A - A_s2, "fro") - opt_err ])
        %end
    end

    if i - 1 == xi_stop_epoch
        disp(["xi-stop", xi_stop_epoch])
        disp(["gap:", norm(A - A_s2, "fro") - opt_err ])

        %if verbose == 0
            %break;
        %else
            disp(["xi-stop", xi_stop_epoch])
            disp(["gap:", norm(A - A_s2, "fro") - opt_err ])
        %end
    end

    %% Solve subproblem (1) and (2). 
    % Unbiased Training
    if nargin <= 6 || ( nargin > 6 && bias ~= 1) 
        % Subproblem (1)
        [U,A_s1, V_enc, ~, R_V] = ApproximateU(A, V, lambda_u,0);
        H_s1 = R_U*R_V';
        % Subproblem (2)
        [V,A_s2, ~, R_U] = ApproximateV(A, U, lambda_v);
        H_s2 = R_U*R_V';
    end

    %Biased Training
    if nargin > 6 && bias == 1
        % Subproblem (1)
        [U, ~, V_enc, ~, R_V] = ApproximateU(A, V_biased, lambda_u, 1);
        A_s1 = [ones(m,1), U]*V';
        H_s1 = R_U*R_V';
        % Subproblem (2)
        [V, A_s2] = ApproximateV(A, U, lambda_v, 2);
        [V_biased, ~, ~, R_U] = ApproximateV(A, U, lambda_v, 1);
        H_s2 = R_U*R_V';
    end

    %% Check stopping criteria.
    if eps ~= 0 && norm(prev_A - A_s2, "fro") < eps && eps_stop_epoch == l
        norm(prev_A - A_s2, "fro");
        eps_stop_epoch = i;
    end
    
    if xi ~= 0 && norm(prev_H - H_s2, "fro") < xi && xi_stop_epoch == l
        norm(prev_H - H_s2, "fro");
        xi_stop_epoch = i;
    end

    %% Save results for the plots.
    if verbose == 1
        r_s1 = norm(prev_A - A_s1, "fro");
        r_s2 = norm(A_s1 - A_s2, "fro");
    
        residual_s1_story(i) = r_s1;
        residual_s2_story(i) = r_s2;
    
        r_H_s1 = norm(prev_H - H_s1, "fro");
        r_H_s2 = norm(H_s1 - H_s2 , "fro");
    
        residual_H_s1_story(i) = r_H_s1;
        residual_H_s2_story(i) = r_H_s2;
    
        convergence_u_story(i) = (norm(A_s1 - opt_A, "fro") - opt_err) /opt_err;
        convergence_v_story(i) = (norm(A_s2 - opt_A, "fro") - opt_err) /opt_err;
    
        u_norm_story(i) = norm(U, "fro");
        v_norm_story(i) = norm(V, "fro");
    
        R_U_norm_story(i) = norm(R_U);
        R_V_norm_story(i) = norm(R_V);
    
        H_s1_norm_story(i) = norm(H_s1, "fro");
        H_s2_norm_story(i) = norm(H_s2 , "fro");
    
        A1_norm_story(i) = norm(A_s1, "fro");
        A2_norm_story(i) = norm(A_s2, "fro");
    end
   
    %prev_A_s1 = A_s1;
    prev_A = A_s2;

    %prev_H_s1 = H_s1;
    prev_H = H_s2;
end

%% Call the plotting functions.
if verbose == 1  
    Plotter([residual_s1_story residual_s2_story residual_H_s1_story residual_H_s2_story], ...
        [convergence_u_story convergence_v_story], ...
        [u_norm_story v_norm_story R_U_norm_story R_V_norm_story A1_norm_story A2_norm_story], norm(opt_A, "fro"),...
        [ H_s1_norm_story H_s2_norm_story], [eps_stop_epoch, xi_stop_epoch])

    %disp([ "Resiudal wrt to SVD optimal error", norm(A - A_s2, "fro") - opt_err])
end

disp([ "Resiudal wrt to SVD optimal error", norm(A - A_s2, "fro") - opt_err])

%% Adjust return values in case of bias
if  nargin > 6 && bias == 2
    [V_biased, ~] = ApproximateV(A, U, lambda_v, 1);
    [~,~,V_enc] = ApproximateU(A, V_biased, lambda_u, 1);
    [V, ~] =  ApproximateV(A, U, lambda_v, 2);
end

if nargin > 6
    U = V_enc;
end
