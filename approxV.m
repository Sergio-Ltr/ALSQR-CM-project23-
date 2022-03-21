function [V] = approxV (a, U) %stiamo considerando v transposto
%approssima una sola colonna di v
[Q, R] = qr(U);
V = inv(R)*Q'*a;
