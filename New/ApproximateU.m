function [U] = ApproximateU (A, V)

[~, k] = size (V);  % V size = n x k (now is not transpose)
A = A';             % here we need A transpose
[~, m]  = size (A); % A transpose size = n x m

U = zeros(m,k);

[Q, R] = QRfactorization(V);

for i = 1:m
    a = A(:, i);
    x = R\(Q'*a);
    U(i,:) = x';
end

