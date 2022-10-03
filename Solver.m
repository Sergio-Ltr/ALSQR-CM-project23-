function [U, V] = Solver2 (A, k, intial_V_constraint ,verbose)

m = size(A,1);
n = size(A,2);

if nargin > 2
    intial_V_constraint = 1; %To be used to test particular initializations
    init = randn(n,k); % = Vo (starting point) 
else
    intial_V_constraint = 0;
    init = randn(n,k); % = Vo (starting point)  
end

if nargin > 3
  verbose = 1;
else
  verbose = 0;
end

V = init;

residual_step_1 = zeros(50,1);
residual_step_2 = zeros(50,1);

convergence_u_story = zeros(50,1);
convergence_v_story = zeros(50,1);

u_norm_story = zeros(50,1);
v_norm_story = zeros(50,1);

u_err_prev = 1;
v_err_prev = 1;

for i = 1:100 % choose numer of iteration 
    % --> next: insert stop condition when residual error is under a given treshold
    [U,u_err] = ApproximateU(A, V);
    [V,v_err] = ApproximateV(A, U);
    %temp_error = A - U*V';
    residual_step_1(i) = u_err;
    residual_step_2(i) = v_err;

    convergence_u_story(i) = u_err/u_err_prev;
    convergence_v_story(i) = v_err/v_err_prev;

    u_norm_story(i) = norm(U,"fro");
    v_norm_story(i) = norm(V,"fro");

    u_err_prev = u_err;
    v_err_prev = v_err;

    % next -> preallocating residual_error for faster execution
end

% Top two plots
tiledlayout(3,2)
nexttile
plot(residual_step_1)
title('residual step 1')
nexttile
plot(residual_step_2)
title('residual step 2')
nexttile
plot(convergence_u_story)
title('convergence U')
nexttile
plot(convergence_v_story)
title('convergence V')
nexttile
plot(u_norm_story)
title(' U-norm')
nexttile
plot(v_norm_story)
title('V-norm')

optimalError = optimalK(A, k)
residual_step_2(50)

%{
NB. dopo poche iterazioni i<10) l'errore smette di diminuire
controllare tutto per individuare possibili errori
%}
