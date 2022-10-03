function [Q1,R1] = ThinQRfactorization (A)

[m, n] = size(A);   % dimension of matrix A
Q1 = eye(m,n);      % initialize Q1 as identity matrix mxm
A=[A;zeros(1,n)];


for i = 1:n% if m >> n then min(m-1,n) = n

    % compute houseolder vectors u and s for each column of the matrix A
    % store u and s i the lower part of the A matrix

    [A(i+1:m+1, i), A(i,i)] = HouseholderVector(A(i:m,i));
    A(i:m, i+1:n) = A(i:m, i+1:n) - 2 * A(i+1:m+1,i) * A(i+1:m+1,i)' * A(i:m, i+1:n);
end

% compute Q1 
for i = n:-1:1
    Q1(i:m, :) = Q1(i:m, :) - 2 * A(i+1:m+1,i) * A(i+1:m+1,i)' * Q1(i:m, :);   
end

R1 = triu(A(1:n,:)); % R1 is an upper triangular matrix nxn