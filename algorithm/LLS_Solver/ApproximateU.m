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

function [U, err, V_enc] = ApproximateU (A, V, lambda, bias)

opt.UT = true;
[n, k] = size (V);   % V size = n x k (now is not transpose)
[m, ~]  = size (A); % A size = m x n 

V_enc = ones(n+1, k);

if nargin > 3 && bias == 1
    A = [ones(m,1), A];
    % In such case V_enc is given by 
    % [Q,R] = qr(V_biased)
    % V_enc = Q * inv(R')
end

if lambda ~= 0  
    V = [V; lambda * eye(k)]; % reg. V size= (n+k)x k 
    A = [A, zeros(m,k)];  % reg. V size= m x (n+k)
end

[Q, R] = ThinQRfactorization(V);
%[Q, R] =qr(V, 0);

if nargin > 3 && bias == 1 
    V_enc = Q * inv(R)';
end

U = zeros(m,k);
for i = 1:m
    a = A(i, :);
    [x, ~] = linsolve(R, Q', opt);
    U(i,:) = a*x';
end


%% Alternative computation for U 
%U = A*Q*inv(R)';


% to do: use q2 when we have thin QR
if nargin > 3 && bias == 1
    err = 0;
else
   err = norm(A-U*V', "fro");
end
