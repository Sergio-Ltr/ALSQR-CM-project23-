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

function [U, V, final_iteration, final_loss, final_gap] = Solver (A, k, reg_parameter, stop_param, initial_V, verbosity, bias, filename, opt_A, norm_opt_U, norm_opt_V)

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

final_iteration = l;

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

%[opt_err, opt_A] = optimalK(A, k);

if verbose == 1
    %% Compute optimal error and A
     if nargin < 9
        %% TODO redefine optimalK in order to not return opt_err anymore. 
        [~, opt_A, factors] = optimalK(A, k, lambda_u, lambda_v);
        if lambda_u ~= 0 || lambda_v ~= 0
            norm_opt_U = factors(1);
            norm_opt_V = factors(2);
        end
    end

    %% Create arrays to save data for plots. 
    loss_u = zeros(l,1);
    loss_v = zeros(l,1);
    
    gap_u = zeros(l,1);
    gap_v = zeros(l,1);
    
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
prev_V_penalty = lambda_v*norm(V, "fro");

%% Alternate optimization loop.
for i = 1:l
    
    %% Chek wether if it's time to stop
    if i - 1 == eps_stop_epoch        
        if verbose == 0
            break;
        else
            disp(["eps-stop", eps_stop_epoch])
            disp(["gap:", norm(opt_A - A_s2, "fro")])
        end
    end

    if i - 1 == xi_stop_epoch
        if verbose == 0
            break;
        else
            disp(["xi-stop", xi_stop_epoch])
            disp(["gap:", norm(opt_A - A_s2, "fro")])
        end
    end

    %% Solve subproblem (1) and (2). 
    % Unbiased Training
    if nargin <= 6 || ( nargin > 6 && bias ~= 1) 
        % Subproblem (1)
        [U, A_s1, V_enc, ~, R_V] = ApproximateU(A, V, lambda_u,0);
        H_s1 = R_U*R_V';
        V_penalty = lambda_v*norm(V, "fro");

        % Subproblem (2)
        [V,A_s2, ~, R_U] = ApproximateV(A, U, lambda_v);
        H_s2 = R_U*R_V';
        U_penalty = lambda_u*norm(U,"fro"); 
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
        final_iteration = i;
    end
    
    if xi ~= 0 && norm(prev_H - H_s2, "fro") < xi && xi_stop_epoch == l
        norm(prev_H - H_s2, "fro");
        xi_stop_epoch = i;
        final_iteration = i;
    end

    %% Save results for the plots.
    if verbose == 1
        %% Stepwise Loss
        loss_u(i) = norm(A_s1 - A, "fro") + U_penalty + prev_V_penalty;
        loss_v(i) = norm(A_s2 - A, "fro") + V_penalty + U_penalty;

        %% Stepwise Gap
        gap_u(i) = norm(opt_A - A_s1, "fro")/norm(opt_A, "fro");
        gap_v(i) = norm(opt_A - A_s2, "fro")/norm(opt_A, "fro");

        %% Norms of factors and approximations
        u_norm_story(i) = norm(U, "fro");
        v_norm_story(i) = norm(V, "fro");
    
        R_U_norm_story(i) = norm(R_U, "fro");
        R_V_norm_story(i) = norm(R_V, "fro");
    
        H_s1_norm_story(i) = norm(H_s1, "fro");
        H_s2_norm_story(i) = norm(H_s2 , "fro");
    
        A1_norm_story(i) = norm(A_s1, "fro");
        A2_norm_story(i) = norm(A_s2, "fro");
    end
   
    %prev_A_s1 = A_s1;
    prev_A = A_s2;

    %prev_H_s1 = H_s1;
    prev_H = H_s2;

    prev_V_penalty = V_penalty;
end

%% Call the plotting functions.
if verbose == 1  
    if lambda_u ~= 0 || lambda_v ~= 0
        optimal_norms = [ norm(opt_A, "fro"), norm_opt_U, norm_opt_V];
    else
        optimal_norms = [ norm(opt_A, "fro"), 0, 0];
    end

    norms_history = [u_norm_story v_norm_story R_U_norm_story R_V_norm_story A1_norm_story A2_norm_story H_s1_norm_story H_s2_norm_story];

    Plotter([loss_u loss_v], [gap_u gap_v], norms_history, optimal_norms, [eps_stop_epoch, xi_stop_epoch]);

    disp([ "Loss", norm(A - A_s2, "fro") + U_penalty + V_penalty]);
    disp([ "Gap", norm(opt_A - A_s2, "fro")]);

    %disp([ "Relative Gap", norm(opt_A - A_s2, "fro")/norm(opt_A, "fro")]);
    %dlmwrite(filename,[optimal_norms],'delimiter',',','-append');
    %dlmwrite(filename,[loss_u, loss_v, gap_u, gap_v, u_norm_story, v_norm_story, A1_norm_story, A2_norm_story],'delimiter',',','-append');
end 

%% Todo integrate the filename dynamic into the verbose parametere i.e vernose neither 0 or 1.
%if nargin > 8 && filename ~= 0
    %dlmwrite(filename,[optimal_norms],'delimiter',',','-append');
    %dlmwrite(filename,[loss_u, loss_v, gap_u, gap_v, u_norm_story, v_norm_story, A1_norm_story, A2_norm_story],'delimiter',',','-append');
%end

%% Adjust return values in case of bias
if  nargin > 6 && bias == 2
    [V_biased, ~] = ApproximateV(A, U, lambda_v, 1);
    [~,~,V_enc] = ApproximateU(A, V_biased, lambda_u, 1);
    [V, ~] =  ApproximateV(A, U, lambda_v, 2);
end

if nargin > 6 && bias ~= 0
    U = V_enc;
end

final_loss = norm(A_s2 - A, "fro") + V_penalty + U_penalty;
if verbose ~= 0
    final_gap = norm(opt_A - A_s2, "fro");
else
    final_gap = 0;
end
