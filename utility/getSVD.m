%% getSVD
%
% 
%
%% Syntax
% 
% [U,S,V] = getSVD(U,V)
%
%% Description
%  
% 
%% Parameters 
% 
% U : m x k matrix outcoming from alternate optimization step 
% V : n x k matrix outcoming from alternate optimization step 
%
%% Examples
%
% [U,S,V] = getSVD(U,V)
%% ------------------------------------------------------------------------
function [U,S,V] = getSVD(U,V)

    [QU, RU] = ThinQRfactorization(U);
    [QV, RV] = ThinQRfactorization(V);

    [UC, S, VC] = svd(RU*RV');
    U = QU*UC;
    
    V = VC'*QV';
    