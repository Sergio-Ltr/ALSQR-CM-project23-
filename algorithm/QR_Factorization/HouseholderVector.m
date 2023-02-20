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
function [u,s] = HouseholderVector (x)

s = norm(x);
if x(1) >= 0, s = -s; end

v = x;
v(1) = v(1) - s;

if all(v(:) == 0)
    u = v;  
else
    u = v / norm(v); 
end

