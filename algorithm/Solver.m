%% Solver
%
% Low rank approximation algorithm (A), returning a low rank approximation
% of an input matrix A, already factorized as the k inner product of two matrices U and V.
%
%% Syntax
%
%  [U,V, iteration, loss, gap] = Solver(A, k) 
%  [U,V, iteration, loss, gap] = Solver(A, k, [lambda_u, lambda_v])
%  [U,V, iteration, loss, gap] = Solver(A, k, [lambda_u, lambda_v], [max_iter, eps, xi])
%  [U,V, iteration, loss, gap] = Solver(A, k, [lambda_u, lambda_v], [max_iter, eps, xi], V_0)
%  [U,V, iteration, loss, gap] = Solver(A, k, [lambda_u, lambda_v], [max_iter, eps, xi], V_0, verbose)
%  [U,V, iteration, loss, gap] = Solver(A, k, [lambda_u, lambda_v], [max_iter, eps, xi], V_0, verbose, bias)
%  [U,V, iteration, loss, gap] = Solver(A, k, [lambda_u, lambda_v], [max_iter, eps, xi], V_0, verbose, bias, opt_a, opt_norms)
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
% plotter function (unless verbose is disabled). 
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
%  -1): max number of iters allowed. 
%  -2): epsilon threshold for real approximation error. 
%  -3): xi threshold for heuristic approximation error. 
%
% initial_V: The V_0 matrix to use at the very first iteration to compute U_1.
%
% verbose: wether we want or not plots and logs to be computed and displayed. 
%   - value = 0: No plots and logs at all.  Gap is not computed. 
%   - value = 1: The plots are displayed and some message is printed on the
%   console.
%   - value = 2: Everything is displayed as if value was 1, additionaly
%   everytihng is saved on the "results.csv" file in the project repository. 
%
% bias: decides whetehr to have a biased or an unbiased optimization, 
%       if passed, V_enc (aka V^+) is returned instead of U anyway. 
%
%   - value = 0: "classical" alternate optimiation, no bias at all,  
%   - value = 1: biased training (officially alternate optimization). 
%   - value = 2: unbiased training, biased weights vectors are compouted
%       only at the end. 
%   - value = 3: return the transpose pesudoinverse of V as the encoder
%       weight vector for the AE experiments. 
%   - value = 4: return a truncated SVD when the optimization ended.
%
% opt_a: Optimal solution matrix, obtained via SVD (no reg), or via the
%        external solver using matlab Optimization Toolbox. It is used
%        to compute the gaps. 
%
% opt_norms: Norms of some optimal U and V matrices, just used for the plots. 
%
%% Outputs
%
%  U: The U (m x k) matrix factor computed at the last step of the
%     optimization loop.
%     If the algorithm is in AE mode (bias = 1,2,3), this will correspond to the W_enc matrix
%     ((n + 1) x k) or ((n + 1) x k). 
%     If an approximation of the SVD is required (bias = 4), this will correspond to a
%     contaier with the all the U, S, and V matrices. 
%
%  V: The V (n x k) matrix factor computed at the last step of the
%     optimization loop.
%     If the algorithm is in AE mode (bias = 1,2,3), this will correspond to the W_dec matrix
%     (n x (k + 1)).
%     If an approximation of the SVD is required (bias = 4), this will correspond to a
%     contaier with the "classical" QR-ALS results:  the U and the V matrices. 
%
%  final_iterarion: number of last iteration, if no early stopping is
%                   applied it would correspond to the max_iteration value.
%
%  final_loss: value of the objective computed at the last step of the last
%               iteration. 
%
%  final_gap: value of the relative gap computed at the last step of the last
%               iteration. If execution is not verbose and A* is not
%               passed, this returned value would be Infinite. 
%               (better use the loss alone then). 
%
%% Examples
%
%  A = randn(500, 12)
%  V_0 = ones(12, 12)
%
%  [U,V] = Solver(A, 8) <- Default config: No regularization, 100 iters 
%   without early stopping, random (full column rank) initial V_0, verbose
%  
%  [U,V] = Solver(A, 8, [0.5, 0.5]) <- Custom Regularization 
%
%  [U,V] = Solver(A, 8, [0.5, 0.5], [200, 0, 0]) <- Custom Stopping
%   criterisa: 200 iters, no early stopping.
%
%  [U,V] = Solver(A, 8, [0.5, 0.5], [200, 0, 0], V_0) <- Custom Initial V
%
%  [U,V] = Solver(A, 8, [0.5, 0.5], [200, 0, 0], V_0, 0) <- Non verbose 
%
% [U,V] = Solver(A, 8, [0.5, 0.5], [200, 0, 0], V_0, 0, 1)  <- Biased Training.
%  
%% ---------------------------------------------------------------------------------------------------

function [U, V, final_iteration, final_loss, final_gap] = Solver (A, k, reg_parameter, stop_param, initial_V, verbose, bias, opt_A, opt_norms)

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

eps_stop_iter = l;
xi_stop_iter = l;

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

% If not specified, algorithm is verbose. 
if nargin < 6 
    verbose = 1;
end

if nargin <= 6 
    bias = 0;
end

if nargin > 6 && bias == 1
    V = [V, zeros(n,1)];
    V_biased = randn(n+1, k);
end

%[opt_err, opt_A] = optimalK(A, k);

if verbose ~= 0
    %% Compute optimal approximation of A to useful to evaluate the gap. 
     if nargin < 8
        [~, opt_A, opt_norms] = optimalK(A, k, lambda_u, lambda_v);
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

%% Initialize Early Stopping Variables
prev_V_penalty = lambda_v*norm(V, "fro");
R_U = randn(k,k);
prev_A = Inf;
prev_H= Inf;

%% Alternate optimization loop.
for i = 1:l
    
    %% Chek wether if it's time to stop
    if i - 1 == eps_stop_iter        
        if verbose == 0
            break;
        else
            disp(["eps-stop", eps_stop_iter])
            disp(["gap:", norm(opt_A - A_s2, "fro")])
        end
    end

    if i - 1 == xi_stop_iter
        if verbose == 0
            break;
        else
            disp(["xi-stop", xi_stop_iter])
            disp(["gap:", norm(opt_A - A_s2, "fro")])
        end
    end

    %% Solve subproblem (1) and (2). 

    % Unbiased Training
    if nargin <= 6 || ( nargin > 6 && bias ~= 1) 
        % Subproblem (1)
        [U, A_s1, V_enc, Q_V, R_V] = ApproximateU(A, V, lambda_u, 0);
        H_s1 = R_U*R_V';

        % Subproblem (2)
        [V,A_s2, Q_U, R_U] = ApproximateV(A, U, lambda_v);
        H_s2 = R_U*R_V';
    end
   
    
    % Biased Training
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

    V_penalty = lambda_v*norm(V, "fro");
    U_penalty = lambda_u*norm(U,"fro"); 

    %% Check stopping criteria.
    if eps ~= 0 && norm(prev_A - A_s2, "fro") < eps && eps_stop_iter == l
        norm(prev_A - A_s2, "fro");
        eps_stop_iter = i;
        final_iteration = i;
    end
    
    if xi ~= 0 && norm(prev_H - H_s2, "fro") < xi && xi_stop_iter == l
        norm(prev_H - H_s2, "fro");
        xi_stop_iter = i;
        final_iteration = i;
    end

    %% Save results for the plots.
    if verbose ~= 0

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
   
    % Save old thing for the next itration. 
    prev_V_penalty = V_penalty;
    prev_A = A_s2;
    prev_H = H_s2;
end

%% Call the plotting functions.
if verbose ~= 0
    % If regularization is applied and the optimal factor norms are
    % available, add them to the plots. 
    if (lambda_u ~= 0 || lambda_v ~= 0) && nargin ~= 8
        norm_opt_U = opt_norms(1);
        norm_opt_V = opt_norms(2);
        optimal_norms = [ norm(opt_A, "fro"), norm_opt_U, norm_opt_V];
    else
        optimal_norms = [ norm(opt_A, "fro")];
    end

    % Pass the norm stories of the factors and also of the R subfactors, and their products as well. 
    norms_history = [u_norm_story v_norm_story R_U_norm_story R_V_norm_story A1_norm_story A2_norm_story H_s1_norm_story H_s2_norm_story];

    Plotter([loss_u loss_v], [gap_u gap_v], norms_history, optimal_norms, [eps_stop_iter, xi_stop_iter]);

    % Notice if the early stop occurs.
    disp([ "Loss", norm(A - A_s2, "fro") + U_penalty + V_penalty]);
    disp([ "Gap", norm(opt_A - A_s2, "fro")]);
end 

%% If verbose is neither 0 or 1, it's expected to be the name of the file on wich results will be saved.
if verbose ~= 0 && verbose ~= 1
    filename = "results.csv";
    dlmwrite(filename,[optimal_norms],'delimiter',',','-append');
    dlmwrite(filename,[loss_u, loss_v, gap_u, gap_v, u_norm_story, v_norm_story, A1_norm_story, A2_norm_story],'delimiter',',','-append');
end

%% Adjust return values in case of bias
if  nargin > 6 && bias == 2
    [V_biased, ~] = ApproximateV(A, U, lambda_v, 1);
    [~,~,V_enc] = ApproximateU(A, V_biased, lambda_u, 1);
    [V, ~] =  ApproximateV(A, U, lambda_v, 2);
end

% If the solver was called in autoencoder mode, return the encoder wieghts
% instead of the matrix V. 
if nargin > 6 && bias ~= 0 && bias < 4
    U = V_enc;
end

% Compute the last loss to return user (even in case gap was not computed). 
final_loss = norm(A_s2 - A, "fro") + V_penalty + U_penalty;

% Return gap if it was computed, else return Inf. 
if verbose ~= 0 || nargin > 7 
    final_gap = norm(opt_A - A_s2, "fro");
else 
    final_gap = Inf;
end

%% Truncated SVD biasing. 
if  nargin > 6 && bias == 4
    % Save "classical" approximation in the second return value
    V = containers.Map({'U', 'V'},  {U, V});
    
    [HU, S_svd, HV] = svd(H_s2);
    
    % Save SVD in the first return value. 
    U = containers.Map({'U','S','V'}, {Q_U*HU, S_svd, Q_V*HV});
end

