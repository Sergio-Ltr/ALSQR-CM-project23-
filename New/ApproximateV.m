function [V] = ApproximateV (A, U)

[~, k] = size (U);  % U size = m x k
[~, n]  = size (A); % A size = m x n

Vt = zeros(k,n);

[Q, R] = QRfactorization(U);

for i = 1:n
    a = A(:, i);
    x = R\(Q'*a);
    Vt(:,i) = x;
end
V = Vt';

%{
function [V] = ApproximateV (A, U)
% V' size -> k x n 
[m, n] = size (A);
k = lenght(U(1));
 
V = zeros(m,k); % create V as zero matrix and then progressive replace columnn

[Q, R] = QRfactorization(U);

for i = n
    b = A(:, i);
    x = R\(Q'*b);
    V(:,i) = x;
end
%}