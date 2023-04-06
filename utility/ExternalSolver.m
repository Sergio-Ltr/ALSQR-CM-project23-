%% ExternalSolver 
%
% Compute the optimal solution for a regularized low rank approximation
% problem.
%
%% Syntax 
%
% [U,V,error] = ExternalSolver(A, k, lambda_u, lambda_v); 
%
%% Description 
%
% Call the matlab Optimization Toolbox to solve the regularized (P). 
% Solution is expressed in the bilinear form. 
% Error is usally comparable to the optimal one if lambdas are 0. 
% 
% The Frobenious norm cannot be used directly with this solver (in the
% objective), anyway the returned solutions always scores good results in
% terms of loss expressed in Frobenious norm: they are always better then our regularized
% algorithm results in terms of penalized loss. 
%
%% Examples
%
% [U,V,error] = ExternalSolver(A, k, 0, 0) <- Solve without regularization (like with SVD but bilinear); 
% [U,V,error] = ExternalSolver(A, k, 0.5, 0.2) Solve the regularized problem, balancing U and V. 
%
% -----------------------------------------------------------------------------------------------
function [U_opt, V_opt, error] = ExternalSolver(A,k, lambda_u, lambda_v)

    reg_prob = optimproblem();
    
    m = size(A, 1);
    n = size(A, 2);

    U = optimvar('U',m, k);
    V = optimvar('V',n, k);

    if nargin < 3 || ( lambda_u == 0 && (nargin == 3 || lambda_v == 0))
        reg_prob.Objective = norm(A - U*V');
    else 
        reg_prob.Objective = norm(A - U*V') + lambda_u*norm(U) + lambda_v*norm(V);
    end
    
    % Provide some initial pointsd
    X0.V = randn(n,k); 
    X0.U = randn(m,k);  

    options = optimoptions("fminunc");

    options.MaxIterations = 500;
    options.StepTolerance = 1e-04;
    options.OptimalityTolerance = 1.000e-04; 

    solution = solve(reg_prob, X0, Options=options); 

    U_opt = solution.U; 
    V_opt = solution.V;

    M = U_opt*V_opt';

    if nargin < 3 || ( lambda_u == 0 && (nargin == 3 || lambda_v == 0))
        error = norm(A - M, "fro");
    else
        error = norm(A - M, "fro") + lambda_u*norm(U_opt, "fro") + lambda_v*norm(V_opt, "fro");
    end
end

