function [V, err] = ApproximateV (A, U)

[m, k] = size (U)  % U size = m x k
[~, n]  = size (A); % A size = m x n

Vt = zeros(k,n);

[Q, R] = ThinQRfactorization(U);

%[Q,R] = qr(U);
%[Q,R] = QRfactorization(U)

for i = 1:n
    a = A(:, i);
    x = R\(Q'*a);
    Vt(:,i) = x;
end
V = Vt';

% to do: use q2 when we have thin QR
err = norm(A-U*V', "fro");