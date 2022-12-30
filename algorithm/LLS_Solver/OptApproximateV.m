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
function [V, err] = OptApproximateV (A, U)

opt.UT = true;

[~, k] = size (U); 
[~, n]  = size (A); 

Vt = zeros(k,n);

[Q, R] = ThinQRfactorization(U);

for i = 1:n
    a = A(:, i);
    [x, ~] = linsolve(R, Q'*a, opt);
    Vt(:,i) = x;
end
V = Vt';

err = norm(A-U*V', "fro");
