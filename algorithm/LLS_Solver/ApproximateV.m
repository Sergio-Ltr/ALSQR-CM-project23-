%% ApproximateV
%
% Solve the subproblem (2).
%
%% Syntax 
%
% Approximate V(A, U) 
% Approximate V(A, U, lambda) 
% Approximate V(A, U, lambda, bias) 
%
%% Description
% 
% Construct the new matrix V_s, calculating the solutions of the m LLS
% involving U and the columns of A, obtaining the n columns of V'. 
%
% If setted, regualrization is applied here, a lower identity part is added 
% to the U matrix (A considering common LLS notation) and appending zeros to 
% the columns of A (corresponding to y).
%
% For the autoencodere experiment, in order to simulate the behaviour of a
% neural unit, a biased version of the solver is proposed, obtaining as the 
% U matrix, a mapping from m to k+1, adding a clumn of ones to the V matrix. 
% 
%% Parameters 
%
% A: the target matrix, shaped m x n. 
%
% U: the fixed "parameter" matrix for the step, shaped m x k. 
%
% lambda: regularization hypermparameter. 
%    If setted, it multiplies the I matrix added as the k last columns of U. 
%
% bias: determines if V should be computed unbiased  or biased: 
%   - value = 0, size(V) = [n,k] ) - Unibased V
%   - value = 1, size(V) = [n+1,k] ) - Encoder biased V
%   - value = 2, size(V) = [n,k+1] ) - Decoder biased V
%
%% Examples
%
% Approximate V(A, U_current) 
% Approximate V(A, U_current, 0.2) 
% Approximate V(A, U_current, 0.2, 2)
%
%% ------------------------------------------------------------------------

function [V, err] = ApproximateV (A, U, lambda, bias)

opt.UT = true;
[m, k] = size (U);  % U size = m x k
[~, n]  = size (A); 

%% Prepare to compute V_enc
if nargin > 3 && bias == 1
    A = [ones(m,1), A];
    n = n + 1;
    % In such case V_enc is given by 
    % [Q,R] = qr(V_biased)
    % V_enc = Q(:,1:k) * inv(R(1:k,1:k)')
end

%% Prepare to compute V_dec
if nargin > 3 && bias == 2
    U = [ones(m,1), U];
    k = k + 1;
    % In this case V_dec = V_biased
end

%% Applying Ridge Regression
if lambda ~= 0
    U = [U; lambda * eye(k)];
    A = [A; zeros(k,n)]; 
end

%% LLS Solver with QR
Vt = zeros(k,n);

%[Q, R] = ThinQRfactorization(U);
[Q,R] = qr(U, 0);
%[Q,R] = QRfactorization(U);

for i = 1:n
    a = A(:, i);
    %x = R\(Q'*a);
    [x, ~] = linsolve(R, Q'*a, opt);
    Vt(:,i) = x;
end
V = Vt';

% to do: use q2 when we have thin QR
err = norm(A-U*V', "fro");


