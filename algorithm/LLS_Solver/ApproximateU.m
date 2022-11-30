function [U, err, zero_row_warning] = ApproximateU (A, V, lambda)

opt.UT = true;
[n, k] = size (V);   % V size = n x k (now is not transpose)
[m, ~]  = size (A); % A size = m x n 

if lambda ~= 0  
    V = [V; lambda * eye(k)]; % reg. V size= (n+k)x k 
    A = [A, zeros(m,k)];  % reg. V size= m x (n+k)
end


A = A';             % here we need A transpose
%[~, m]  = size (A); % A transpose size = n x m
U = zeros(m,k);

[Q, R, zero_row_warning] = ThinQRfactorization(V);
if zero_row_warning == true
    V
    rank(V')
end
%[Q,R] = qr(V);
%[Q,R] = QRfactorization(V);

for i = 1:m
    a = A(:, i);
    % x = R\(Q'*a);
    [x, ~] = linsolve(R, Q'*a, opt);
    U(i,:) = x';
end

% to do: use q2 when we have thin QR
err = norm(A'-U*V', "fro");
