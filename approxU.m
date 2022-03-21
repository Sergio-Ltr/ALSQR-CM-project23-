function [U] = approxU (a, V) % approssima una sola riga di U
[Q,R] = qr(V);
U = a * Q * inv(R');

