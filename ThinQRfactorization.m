function [Q1,R1] = ThinQRfactorization (A)

[m, n] = size(A);   % dimension of matrix A
Q1 = eye(m,n);      % initialize Q1 as identity matrix mxm
U = zeros(m,n);     % initialize Q1 as zeros matrix mxm, here the houseolder vector will be stored

for i = 1:n% if m >> n then min(m-1,n) = n

    % compute houseolder vectors u and s for each column of the matrix A
    % store u vectors in U matrix, and store s in A matrix
    [U(i:m,i), A(i,i)] = HouseholderVector(A(i:m,i));
    
    %{
    another way to store s and fill A with zeros: 
    [u,s] = HouseholderVector(A(i:m,i))
    [U(i:m,i), s] = HouseholderVector(A(i:m,i));
    A(i:m, i) = [s; zeros(m-i,1)];
    %}
    
    % fill A with zeros where necessary and compute A(i:m, i+1:n) to obtain R
    A(i+1:m,i) = 0;
    A(i:m, i+1:n) = A(i:m, i+1:n) - 2 * U(i:m,i) * U(i:m,i)' * A(i:m, i+1:n);
end

R1 = A(1:n,1:n); % R1 is an upper triangular matrix nxn

% compute Q1 
for i = n:-1:1
    Q1(i:m, :) = Q1(i:m, :) - 2 * U(i:m,i) * U(i:m,i)' * Q1(i:m, :);
end
