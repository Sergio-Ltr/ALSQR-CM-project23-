%% Stopping Criteria 
%
%% Syntax
%
%
%% Description
%
%
%% Parameters 
%
%
%% Examples
%
%
%% ---------------------------------------------------------------------------------------------------
function[] = Plotter(residual_history, convergence_history, norms_history)
 % Top two plots
tiledlayout(nargin,2);

%First plot: Error through iterations
if nargin > 0
    residual_history = log(residual_history);
    nexttile;
    %residual at step 1
    plot(residual_history(:, 1));
    title('residual step 1');
    nexttile;
    %residual at step 2
    plot(residual_history(:, 2));
    title('residual step 2');
end 

%Second plot: Convergence rate through iterations
if nargin > 1
    convergence_history = log(convergence_history);
    nexttile;
    plot(convergence_history(:, 1));
    title('convergence U');
    nexttile;
    plot(convergence_history(:, 2));
    title('convergence V');
end 

%Third plot: Param matrices norms through iterations
if nargin > 2
    norms_history = log(norms_history);
    nexttile;
    plot(norms_history(:, 1));
    title(' U-norm');
    nexttile;
    plot(norms_history(:, 2));
    title('V-norm');
end