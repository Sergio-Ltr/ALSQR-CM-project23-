%% ThinQRfactorization 
% Compute Thin QR factorization of a tall thin matrix A
%
%% Syntax
%[Q1,R1] = ThinQRfactorization (A)
%
%% Description
% Given A matrix compute its size, obtain m and n 
% initialize Q1 as identity matrix m xn 
% compute houseolder vectors u and s for each column of the matrix A
% store u and s i the lower part of the A matrix
% get R1 from A and compute Q1 iterating over column starting from the last
% one
%
%% Parameters 
% A : m x n matrix to be factorized with m>n
%
%% Examples
% A = randn(30, 10) 
%[Q1,R1] = ThinQRfactorization (A)
%
%% ------------------------------------------------------------------------
function [Q1,R1] = ThinQRfactorization (A)

[m, n] = size(A);   % dimension of matrix A
Q1 = eye(m,n);      % initialize Q1 as identity matrix mxm
A=[A;zeros(1,n)];

%zero_row_warning = false;;


for i = 1:n% if m >> n then min(m-1,n) = n

    % compute houseolder vectors u and s for each column of the matrix A
    % store u and s i the lower part of the A matrix

    [A(i+1:m+1, i), A(i,i)] = HouseholderVector(A(i:m,i));
    %A(i:m, i+1:n) = (eye(m-i+1) - 2 * A(i+1:m+1,i) * A(i+1:m+1,i)') * A(i:m, i+1:n);
    
    A(i:m, i+1:n) = A(i:m, i+1:n) - 2 * A(i+1:m+1,i) * (A(i+1:m+1,i)' * A(i:m, i+1:n));
end

% compute Q1 
for i = n:-1:1
    Q1(i:m, :) = Q1(i:m, :) - 2 * A(i+1:m+1,i) * (A(i+1:m+1,i)'* Q1(i:m, :)); 
end

R1 = triu(A(1:n,:));

%{
for i = 1:n
    if nnz(R1(i, i:end)) == 0 
        rank(A)
        zero_row_warning = true;
    end
end

R1 = triu(A(1:n,:));
density_threshold = 0.72;
density = nnz(R1) / (n*n);
if density > density_threshold 
    R1
    % controllare per ogni riga r1 di R1 se r1 == tutti zeri
    % in tal aso sostituire un solo valore di r1 con valore != 0 
    
    R1 (R1==0) = 1;
    R1 = triu(R1);
end

zerosrow= false;
for i = 1:n
    if nnz(R1(i, i:end)) == 0 
         R1 (R1==0) = 1;
         R1 = triu(R1);
        zerosrow = true;
        a = "hello"
        %R1 (i, i:end) =[1, ones(n-i, 1)'];
        R1
        
    end
end



%R1 = triu(A(1:n,:)); % R1 is an upper triangular matrix nxn

%}


