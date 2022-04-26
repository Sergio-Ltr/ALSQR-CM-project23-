function [Q,R] = QRfactorization (A)
%{
in this version we use the optimization method proposed in class:
we can design a fast alghorithm considering H*Aj = Aj - 2*u*(u'*Aj)
in this way we avoid to compute each H
%}

[m, n] = size(A);
Q = eye(m);

last = n;
if m==n, last = n-1; end%  for square matrix we can stop iteration at n-1 (i = n-1)

for i = 1:min(m-1, last) %  m-1 because last iteration (i = m) is useless 
    [u, s] = HouseholderVector(A(i:m,i));
    
    % compute A to obtain R
    A(i:m, i) = [s; zeros(m-i,1)]; % this line replace if-else in previous version of our qr
    A(i:m, i+1:n) = A(i:m, i+1:n) - 2*u*(u'*A(i:m, i+1:n));

    % compute Q
    Q(:, i:m) = Q(:, i:m) - Q(:, i:m)*2*u*(u'); % perchè se non metto tra parentesi u' -> error
end
R = A;

% Thin QR factorization (if m >> n)
if m > n
    Q = Q(:, 1:n);
    R = R(1:n, :);
end


%{
FATTO:
- risolto problema dei segni opposti dovuto alla condizione del for
(prima-> i = 1:min(m, n), ora i = 1:min(m-1, last)

DA FARE:
- altre ottimizzazioni -> quali vogliamo inserire? 
- questa versione è sviluppata sulla base di quanto visto in classe (->
molto simile -> potrebbero non accettarla ? -> da migliorare in ogni caso
con altre ottimizzazioni
%}