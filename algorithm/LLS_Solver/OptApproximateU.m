%% Approximate U 
% Solve the subproblem (1), calculating the solutions of the m LLS
% involving V' and the columns of A, obtaining the m rows of U.   
%% Syntax
%
%
%% Description
% 
% 
%% Parameters 
% A: the target matrix, shaped m x n. 
% V: the fixed "parameter" matrix for the step, shaped n x k. 
% lambda: regularization hypermparameter. 
%   If setted, it multiplies the I matrix added as the k last columns of V. 
%% Examples
%
%
%% ------------------------------------------------------------------------

function [U, err] = OptApproximateU (A, V)

opt.UT = true;
[~, k] = size (V);   % V size = n x k (now is not transpose)
[m, ~]  = size (A); % A size = m x n 

A = A';
U = zeros(m,k);

[Q, R] = ThinQRfactorization(V);

for i = 1:m
    a = A(:, i);
    [x, ~] = linsolve(R, Q'*a, opt);
    U(i,:) = x';
end
err = norm(A'-U*V', "fro");
