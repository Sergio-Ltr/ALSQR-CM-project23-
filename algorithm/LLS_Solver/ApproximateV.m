%% Stopping Criteria 
% Solve the subproblem (2), calculating the solutions of the m LLS
% involving U and the columns of A, obtaining the m rows of U.   
%% Syntax
%
%
%% Description
% 
% 
%% Parameters 
% A: the target matrix, shaped m x n. 
% U: the fixed "parameter" matrix for the step, shaped m x k. 
% lambda: regularization hypermparameter. 
%   If setted, it multiplies the I matrix added as the k last columns of U. 
%% Examples
%
%
%% ------------------------------------------------------------------------
function [V, err] = ApproximateV (A, U, lambda)

opt.UT = true;
[m, k] = size (U);  % U size = m x k
[~, n]  = size (A); 

if lambda ~= 0
    U = [U; lambda * eye(k)];
    A = [A; zeros(k,n)]; 
end

Vt = zeros(k,n);

[Q, R] = ThinQRfactorization(U);

%[Q,R] = qr(U);
%[Q,R] = QRfactorization(U);

for i = 1:n
    a = A(:, i);
    %x = R\(Q'*a);
    [x, r] = linsolve(R, Q'*a, opt);
    Vt(:,i) = x;
end
V = Vt';

% to do: use q2 when we have thin QR
err = norm(A-U*V', "fro");
