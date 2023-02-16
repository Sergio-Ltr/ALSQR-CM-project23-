%% HouseholderVector  
% Compute HouseholderVector for an input vector (column of a matrix)
%
%% Syntax
% [u,s] = HouseholderVector (x)
%
%% Description
%{
    normally s = norm (x)
    to avoid numerical problem in subtraction between close number we use:
    s = norm(x) if x(1) < 0 
    s = - norm(x) if x(1) >= 0
  then compute u as 
    v = [v(1) - s; x[2:end]]
    u = v / norm(v);
    
%}
%% Parameters 
% x : input vector (column of a matrix)
%
%% Examples
%   x = randn(5);
%  [u,s] = HouseholderVector (x)
%% ------------------------------------------------------------------------
function [u,s, nan_error] = HouseholderVector (x)
%{ 
normally s = norm (x)
to avoid numerical problem in subtraction between close number we use:
s = norm(x) if x(1) < 0 
s = - norm(x) if x(1) >= 0
%}

s =  - sign(x(1)) * norm(x);
v = x;

v(1) = v(1) - s;

u = v / norm(v);
nan_error = false;

%{
if isnan(u)
    
    x
    
    nan_error = true;
    a="houseolder nan"
end
%}