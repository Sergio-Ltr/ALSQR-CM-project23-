%% Optimal k
%
% Compute the optimal solution M of the low rank approximation problem w.r.t. 
% to a given matrix A and rank k; then compute the optimal error as the
% distance between the the optimal approximation M and the target matrix A.
% 
%% Syntax
%
% [error] = optimalK (A, k,  lambda_u, lambda_v)
%
%% Description
% 
% The procedure employed depends on whether we are considering the low rank
% approximation problem with regularization or without. 
% 
% 1) Consider the unregularized problem (Thikonov parameter = 0):
%  According to Eckart-Young best low rank approximation error is achived
%  using Truncated SVD. Given the matrix A and the desired rank K, solve
%  the problem using MatLab implementation of SVD, and obtain its Truncated
%  version and compute optimal solution (i.e, best approximation of A) M.
%
% 2) Consider the regularized problem (Thikonov parameter != 0):
%  We compute optimal solution (i.e, best approximation of A) M using the
%  matlab "optimproblem" toolbox.
%
% In both cases, given  M as the approximation of A, obtain the optimal
% error by computing the frobenius norm of the difference between M and A.
%
%% Parameters 
% 
% - A: (matrix) the target initial matrix with dimension m, n.
% - k: (int) the desired rank to which you want to approximate A with k < min(m, n)
% - lambda_u : (float) - optional - Thikonov regularization parameter for matrix U 
% - lambda_v : (float) - optional - Thikonov regularization parameter for
% matrix V
%
%% Output 
%
% - error : frobenius norm of the difference A - M
% - M : optimal solution, best A approximation
% - factor : (array) it could be:
%           - unregularized case -> [ ] empty array
%           - regularized case -> [ norm of U*, norm of V* ]
%
%% Examples
%
% [error, M, factors_norms] = optimalK (randn(500,250), 100)
% [error, M, factors_norms] = optimalK (randn(500,250), 100, 0.2)
% [error, M, factors_norms] = optimalK (randn(500,250), 100, 0.2, 0.2)
%
%% ---------------------------------------------------------------------------------------------------
function [error, M, factors_norms] = optimalK (A, k, lambda_u, lambda_v)


if nargin < 3 || ( lambda_u == 0 && (nargin == 3 || lambda_v == 0))

    % compute SVD
    [U, S, V] = svd(A);
    
    % obtain Truncated SVD
    U = U(:, 1:k);
    S = S(1:k,1:k);
    V = V(:, 1:k);
    
    % Compute approximation of A 
    M = U*S*V';
    
    % Compute optimal error
    error = norm(A-M, "fro");
    factors_norms = [];

else
    % If we seek the regularized optimal solution, idea is to use a more
    % reliable solver like the matlab "optimproblem" toolbox. 

    [U,V,error] = ExternalSolver(A, k, lambda_u, lambda_v);

    M = U*V';
    
    factors_norms = [norm(U, "fro"), norm(V,"fro")];
end





