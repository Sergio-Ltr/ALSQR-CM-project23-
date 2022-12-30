%% V_0 Experiments
function [] =  V0_Experiment()

m = 40;
n = 30;
k = 10;

A = Initialize_A(m, n);

V_0_norms = ones(10,1); 
U_res_vect = ones(10,10);
V_res_vect = ones(10,10);
residual_vect = ones(10,10);

for i = 1:10
    V_0 = Initialize_V(n,k);
    %Check V_0 norm later
    V_0_norms(i) = norm(V_0, "fro");
        for j = 1:10
            [U,V] = Solver(A, k, [0.1,0.1], [50*(11-j),0,0,0], V_0);
            %Save results
            U_res_vect(i,j) =  norm(U, "fro");
            V_res_vect(i,j) =  norm(V, "fro");
            residual_vect(i,j) = norm(A-U*V', "fro");

            if j ~=1
                U_res_vect(i,j) = U_res_vect(i,j) - U_res_vect(i,1);
                V_res_vect(i,j) = V_res_vect(i,j) - V_res_vect(i,1);
                residual_vect(i,j) = residual_vect(i,j) - residual_vect(i,1);
            end
        end     

end
    
U_res_vect
V_res_vect
residual_vect