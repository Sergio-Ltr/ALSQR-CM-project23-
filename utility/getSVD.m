function [U,S,V] = getSVD(U,V)

    [QU, RU] = ThinQRfactorization(U);
    [QV, RV] = ThinQRfactorization(V);

    [UC, S, VC] = svd(RU*RV');
    U = QU*UC;
    
    V = VC'*QV';
    