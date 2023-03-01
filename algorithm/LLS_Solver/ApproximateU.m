%% Approximate U 
%
% Solve the subproblem (1).   
%
%% Syntax
%
% ApproximateU (A, V)
% ApproximateU (A, V, lambda)
%
%% Description
%
% Construct the new matrix U_s, calculating the solutions of the m LLS
% involving V' and the columns of A, obtaining the m rows of U. 
%
% If setted, regualrization is applied here, a lower identity part to the
% V' matrix (A considering common LLS notation) and appending zeros to the
% columns of A (corresponding to y).
%
%% Parameters 
%
% A: the target matrix, shaped m x n. 
% V: the fixed "parameter" matrix for the step, shaped n x k. 
% lambda: regularization hypermparameter. 
%   If setted, it multiplies the I matrix added as the k last columns of V. 
% bias: determines if U should be computed using an  unbiased (value = 0) or biased (value = 1) version of V: 
% - value = 1 =>  size(V) = [n+1,k] ) - V is the Encoder biased V
%
%% Examples
%
% ApproximateU (A, V_current)
% ApproximateU (A, V_current, 0.2)
%
%% ------------------------------------------------------------------------

function [U, A_s, V_enc, Q, R] = ApproximateU (A, V, lambda, bias)

opt.UT = true;
[n, k] = size (V);   % V size = n x k (now is not transpose)
[m, ~] = size(A); 

if nargin > 3 && bias == 1
    A = [ones(m,1), A];
    n = n - 1;
end


if lambda ~= 0  
    V = [V; lambda * eye(k)]; % reg. V size= (n+k)x k 
    A = [A, zeros(m,k)];  % reg. V size= m x (n+k)
end

[Q, R] = ThinQRfactorization(V);
%[Q, R] =qr(V, 0);


[V_enc, ~] = linsolve(R, Q', opt);
V_enc = V_enc';

% (m x n) * (n x k) matrix multiplication
U = A* V_enc;

%% Compute stepa-wise approximation
A_s = U*V(1:n,:)';


