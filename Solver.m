function [U, V, l] = Solver (A, k, reg_parameter, stop_condition,intial_V_constraint, verbose)

m = size(A,1);
n = size(A,2);

if nargin > 4
    intial_V_constraint = 1; %To be used to test particular initializations
    init = randn(n,k); % = Vo (starting point) 
else
    intial_V_constraint = 0;
    init = randn(n,k); % = Vo (starting point)  
end

if nargin > 5
  verbose = 1;
else
  verbose = 0;
end

% ---- Tikonov regularization hyper-parameter (lambda_u, lamda_v) 
regularization = reg_parameter(1); % false = no regularization performed
lambda_u = reg_parameter(2);
lambda_v = reg_parameter(3);

V = init;

max_epoch = stop_condition(1);



residual_step_1 = zeros(max_epoch,1);
residual_step_2 = zeros(max_epoch,1);

convergence_u_story = zeros(max_epoch,1);
convergence_v_story = zeros(max_epoch,1);

u_norm_story = zeros(max_epoch,1);
v_norm_story = zeros(max_epoch,1);

u_err_prev = 1;
v_err_prev = 1;

%U_list = cell(max_epoch, 1);
%V_list = cell(max_epoch, 1);

% early stooping parameter;
local_stop = 0; 
l = max_epoch;
for i = 1:max_epoch
    
    [U,u_err] = ApproximateU(A, V, regularization, lambda_u);
    [V,v_err] = ApproximateV(A, U, regularization, lambda_v);
    
    residual_step_1(i) = u_err;
    residual_step_2(i) = v_err;

    convergence_u_story(i) = u_err/u_err_prev;
    convergence_v_story(i) = v_err/v_err_prev;

    u_norm_story(i) = norm(U,"fro");
    v_norm_story(i) = norm(V,"fro");

    u_err_prev = u_err;
    v_err_prev = v_err;
    
    if i>1
        rel_err = v_err/norm(A, "fro");
        convergence_rate = norm(U_prev*V_prev' - U*V', "fro") / norm(U_prev*V_prev', "fro");
    
        [stop, local_stop] = StoppingCriteria(i, stop_condition, rel_err, convergence_rate, "local", local_stop);
        if stop == true
            disp("Early stopping at epoch")
            disp(i)
            l = i; 
            break
        end
    end


    U_prev = U;
    V_prev = V;
   
end

if verbose

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
end


%optimalError = optimalK(A, k)
%residual_step_2(50)

%norm(A*A' - U*U', "fro")

%norm(A'*A - V*V', "fro")
%{
NB. dopo poche iterazioni i<10) l'errore smette di diminuire
controllare tutto per individuare possibili errori
%}
