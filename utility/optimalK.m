%% Optimal k
%
% Compute Eckart-Young best low rank approsimation error using Truncated
% SVD for the problem (P)
%
%% Syntax
%
% [error] = optimalK (A, k)
%% Description
% 
% Given the matrix A and the desired rank K, solve the low rank
% approximation problem using MatLab implementation of SVD, and obtain its
% Truncated version. 
% Compute  M as the approximation of A, and obtain the optimal error by
% computing the frobenius norm of the difference between M and A.
%
%% Parameters 
% 
% A: The target initial matrix with dimension m, n.
% k: the desired rank to which you want to approximate A with k < min(m, n)
% 
%% Examples
%
% A = randn(500, 250);
% k = 100;
% error = optimalK(A, k)
% 
%% ---------------------------------------------------------------------------------------------------
function [error, M, factors_norms] = optimalK (A, k, lambda_u, lambda_v)


if nargin < 3 || ( lambda_u == 0 && (nargin == 3 || lambda_v == 0))
    %lambda_u = 0;
    %lambda_v = 0;

    % compute SVD
    [U, S, V] = svd(A);
    
    %obtain Truncated SVD
    U = U(:, 1:k);
    S = S(1:k,1:k);
    V = V(:, 1:k);
    
    % Compute approximation of A 
    M = U*S*V';
    
    % Compute optimal error
    error = norm(A-M, "fro");
    factors_norms = [];
else
    % If we ssek the regularized optimal solution, idea is to use a more
    % reliable solver like the matlab "optimproblem" toolbox. 

    reg_prob = optimproblem();
    
    m = size(A, 1);
    n = size(A, 2);

    U = optimvar('U',m, k);
    V = optimvar('V',n, k);

    reg_prob.Objective = norm(A - U*V') + lambda_u*norm(U) + lambda_v*norm(V);
    
    % Provide some initial pointsd
    X0.V = randn(n,k); 
    X0.U = randn(m,k);  

    options = optimoptions("fminunc");

    options.MaxIterations = 100000;
    options.StepTolerance = 1e-12;
    options.OptimalityTolerance = 1.000e-012; 

    solution = solve(reg_prob, X0, Options=options); 

    U_opt = solution.U; 
    V_opt = solution.V;

    M = U_opt*V_opt';
    error = norm(A - M, "fro") + lambda_u*norm(U_opt, "fro") + lambda_v*norm(V_opt, "fro");

    factors_norms = [norm(solution.U, "fro"), norm(solution.V,"fro")];
end





