function [U, V] = Solver (m,n,k)
A = randn(m,n); % known matrix A

residual_error = zeros(50,1);
% we want to find U and V that minimize ||A-U*Vt||
V = randn(n,k); % = Vo (starting point)  


optimalE = optimalK(A, k)

for i = 1:50 % choose numer of iteration 
    % --> next: insert stop condition when residual error is under a given treshold
    U = ApproximateU(A, V);
    V = ApproximateV(A, U);
    %temp_error = A - U*V';
    residual_error(i) = norm(A - U*V',"fro");
    % next -> preallocating residual_error for faster execution
end

A = U*V'
residual_error(50)
plot(residual_error)

%{
NB. dopo poche iterazioni i<10) l'errore smette di diminuire
controllare tutto per individuare possibili errori
%}