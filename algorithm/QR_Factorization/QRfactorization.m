%% ThinQRfactorization 
% Compute QR factorization of a general matrix A
%
%% Syntax
%[Q,R] = QRfactorization (A)
%
%% Description
% This implementation refers to QR implementation proposed during course
% lecture.
%
%% Parameters 
% A : m x n matrix to be factorized 
%
%% Examples
% A = randn(30, 10) 
%[Q,R] = QRfactorization (A)
%
%% ------------------------------------------------------------------------
function [Q,R] = QRfactorization (A)

[m, n] = size(A);   % dimension of matrix A
Q = eye(m);         % initialize Q as identity matrix mxm


if m==n, last = n-1; else, last = n; end %  for square matrix we can stop iteration at n-1 (i = n-1)

for i = 1:min(m-1, last) %  m-1 because last iteration (i = m) is useless 
    
    %compute houseolder vectors
    [u, s] = HouseholderVector(A(i:m,i));
    
    % compute A to obtain R
    A(i:m, i) = [s; zeros(m-i,1)]; % this line replace if-else in previous version of our qr
    A(i:m, i+1:n) = A(i:m, i+1:n) - 2*u*(u'*A(i:m, i+1:n));

    % compute Q
    Q(:, i:m) = Q(:, i:m) - Q(:, i:m)*2*u*(u'); % perchè se non metto tra parentesi u' -> error
end
R = A;

%{
% Thin QR factorization (if m >> n)
if m > n
    Q = Q(:, 1:n);
    R = R(1:n, :);
end
%}


