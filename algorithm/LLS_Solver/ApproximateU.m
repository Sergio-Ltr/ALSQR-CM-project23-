%% Approximate U 
%
% Solve the subproblem (1).   
%
%% Syntax
%
% ApproximateU (A, V)
% ApproximateU (A, V, lambda)
% ApproximateU (A, V, lambda, bias)
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
%
% V: the fixed "parameter" matrix for the step, shaped n x k. 
%
% lambda: regularization hypermparameter. 
%   If setted, it multiplies the I matrix added as the k last columns of V. 
%
% bias: determines if U should be computed using an unbiased (value = 0) or biased (value = 1) version of V: 
% - value = 1 =>  size(V) = [n+1,k] ) - V is the Encoder biased V
%
%% Output 
%
% U: The new approximation of the U matrix
%
% A_s: The step wise approximation: the product of the new U and the V
%      passed as input parameter.
%
% V_enc: The transpose pseudoinverse corresponding to the weight vector of
%        the encoder. 
%
% Q: The Q factor of V. Useful when the computation of an approximated k-SVD
%       is required.
%
% R: The R factor of V. Useful when the computation of an approximated k-SVD
%       is required.
%
%% Examples
%
% ApproximateU (A, V_current)
% ApproximateU (A, V_current, 0.2)
% ApproximateU (A, V_current, 0.2, 1)
%
%% ------------------------------------------------------------------------

function [U, A_s, V_enc, Q, R] = ApproximateU (A, V, lambda, bias)

% V size = n x k (now it is not transposed).
[n, k] = size (V);  
[m, ~] = size(A); 

% Add ones if the approximation is biased. 
if nargin > 3 && bias == 1
    A = [ones(m,1), A];
    n = n - 1;
end

% If the problem is regularized, the V matrix is expanded with an identity
% matrix scaled by the lambda parameter. 
if lambda ~= 0  
    V = [V; lambda * eye(k)]; % reg. V size= (n+k)x k 
    A = [A, zeros(m,k)];  % reg. V size= m x (n+k)
end

% Use our QR implementation to solve the sub-problem.
[Q, R] = ThinQRfactorization(V);

% Compute the inverse of R w.r.t. Q' in order to solve the LLS. 
opt.UT = true;
[V_enc, ~] = linsolve(R, Q', opt);

% V_enc corressponds to the transpose pesudoinverse matrix of V a.k.a the weight of the encoder. 
V_enc = V_enc';

% (m x n) * (n x k) matrix multiplication.
U = A * V_enc;

% Also compute the step-wise approximation of A.
A_s = U*V(1:n,:)';


