%% Stopping Criteria 
%
%% Syntax
%
%
%% Description
%
%
%% Parameters 
%
%
%% Examples
%
%
%% ---------------------------------------------------------------------------------------------------
function [errore] = optimalK (A, k)
[U, S, V] = svd(A);
U = U(:, 1:k);
S = S(1:k,1:k);
V = V(:, 1:k);

M = U*S*V';
errore = norm(M-A, "fro");

