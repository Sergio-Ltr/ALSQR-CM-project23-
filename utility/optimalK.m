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
function [error] = optimalK (A, k)

% compute SVD
[U, S, V] = svd(A);

% obtain Truncated SVD
U = U(:, 1:k);
S = S(1:k,1:k);
V = V(:, 1:k);

% Compute approximation of A 
M = U*S*V';

% Compute optimal error
error = norm(M-A, "fro");

