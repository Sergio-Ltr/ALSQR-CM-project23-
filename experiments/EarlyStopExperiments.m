function[] = EarlyStopExperiments(r, criterias, sizes, lambda ) 
    rng default
    if nargin < 3
        sizes = [1000, 200, 50];
    end

    if nargin < 4
        lambda = 0;
    end


    m = sizes(1);
    n = sizes(2);
    k = sizes(3);
       
    for i = [0:r]
        A = rand(m,n);
        V_0 = Initialize_V(n,k);
        %[A_star,err_star] = optimalK(A, k);
        for crit = criterias'
            l = crit(1);
            eps = crit(2);
            xi = crit(3);

            disp(["Criteria: l=", l, " - eps=",eps," - xi=",xi, "- REPETITION: ", i])
            Solver(A, k, [lambda, lambda], [l, eps, xi], V_0, 1);
        end
    end

    %%EarlyStopExperiments(5, [
    %[1000, 10e-1,0],[1000, 10e-2,0],[1000, 10e-3,0],[1000, 10e-5,0], [1000, 10e-8,0],
    %[1000, 0, 10e-1],[1000, 0, 10e-2],[1000,0, 10e-3],[1000,0, 10e-5], [1000, 0, 10e-8],
    %])