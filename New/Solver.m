function [U, V] = Solver (m,n,k)
A = randn(m,n); % known matrix A
residual_error = [];
% we want to find U and V that minimize ||A-U*Vt||
V = randn(n,k); % = Vo (starting point)  

for i = 1:1000 % choose numer of iteration 
    % --> next: insert stop condition when residual error is under a given treshold
    U = ApproximateU(A, V);
    V = ApproximateV(A, U);
    %temp_error = A - U*V';
    residual_error(end+1) = norm(A - U*V',"fro"); 
    % next -> preallocating residual_error for faster execution
end
plot(residual_error)

%{
NB. dopo poche iterazioni i<10) l'errore smette di diminuire
controllare tutto per individuare possibili errori
%}