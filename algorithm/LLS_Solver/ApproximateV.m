function [V, err, zero_row_warning] = ApproximateV (A, U, lambda)

opt.UT = true;
[m, k] = size (U);  % U size = m x k
[~, n]  = size (A); 

if lambda ~= 0
    U = [U; lambda * eye(k)];
    A = [A; zeros(k,n)]; 
end

Vt = zeros(k,n);

[Q, R, zero_row_warning] = ThinQRfactorization(U);
if zero_row_warning == true
    U
end

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
