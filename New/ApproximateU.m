function [U] = ApproximateU (A, V)

[n, k] = size (V);  % V size = n x k (now is not transpose)
A = A';             % here we need A transpose
[~, m]  = size (A); % A transpose size = n x m

U = zeros(m,k);

[Q, R] = QRfactorization(V);

%[Q,R] = qr(V);
if n > k
    Q = Q(:, 1:k);
    R = R(1:k, :);
end


for i = 1:m
    a = A(:, i);
    x = R\(Q'*a);
    U(i,:) = x';
end
