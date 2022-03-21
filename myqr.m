function [Q, R] = myqr (A)
[m, n] = size(A); %4x4
Q = eye(m,n);

for i=1:min(m,n)
    [ui, si] = householder_vector(A(i:m,i));
    
    Hi = eye(m-i+1)-2*(ui*ui');%4x4
    %A(i:m, i) = [si zeros(1,m-i)]'
    if i==1
        Q = Hi;
        A = Hi*A
    else
        Qi = eye(m);
        Qi (i:m, i:m) = Hi;
        Q = Q*Qi;
        A = Qi*A
    end
end
R = A;