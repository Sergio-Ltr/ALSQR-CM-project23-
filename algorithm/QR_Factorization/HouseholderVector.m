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
if isnan(u)
    
    x
    
    nan_error = true;
    a="houseolder nan"
end
