%% Plotter
% 
% Produces the plots of the algorithm execution. 
%
%% Syntax
%
% Plotter(residual_history)
% Plotter(residual_history, convergence_history)
% Plotter(residual_history, convergence_history, norms_history)
%
%% Description
%
% Generate the plots of the passed timeseries, handling low level
% operations like titles, legends, logarithmic scaling and so on. 
%
%% Parameters 
%
% residual_history: a couple of l dimensional vector, first for subproblem 
%   (1) and second for subproblem (2). They both contain the normalized 
%   errors after each LLS solution step.   
%
% convergence_history: a couple of l dimensional vector, first for 
%   subproblem (1) and second for subproblem (2), containing the
%   convergence rate computed after each update. 
%
% norms_history: a couple of l dimensional vector, containing vale of the 
%   Frobenious norm of the U and V matrix respctively, computed at each 
%   step after the update.
    
%
%% Examples
%
% Plotter(residual_history)
% Plotter(residual_history, convergence_history)
% Plotter(residual_history, convergence_history, norms_history)
%
%% ---------------------------------------------------------------------------------------------------
function[] = Plotter(residual_history, convergence_history, norms_history, normA_history, normoptA)
 % Top two plots
tiledlayout(nargin,3);


%First plot: Error through iterations
if nargin > 0
     

    residual_history = log1p(residual_history);
    nexttile;
    %residual at step 1
    plot(residual_history(:,1));
    title('residual step 1');
    nexttile;
    %residual at step 2
    plot(residual_history(:, 2));
    title('residual step 2');

    residual_history = residual_history';
    nexttile;
    %residual at step 1
    plot(residual_history(:));
    title('full residual');
end 


%Second plot: Convergence rate through iterations
if nargin > 1
    convergence_history = log1p(convergence_history);
    nexttile;
    plot(convergence_history(:, 1));
    title('convergence U');
    nexttile;
    plot(convergence_history(:, 2));
    title('convergence V');

    convergence_history = convergence_history';
    nexttile;
    %residual at step 1
    plot(convergence_history(:));
    title('full convergence');
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

    
    nexttile;
    %residual at step 1
    plot(normA_history(:))
    hold on
    plot( ones( size(normA_history,1))*normoptA);
    title('A norm');

end

