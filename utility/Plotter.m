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
% norms_history: contains four l dimensional vectors, the first two are ones 
%   containing values of the Froious norm of the U and V matrix respctively, 
%   computed at each step after the update, while the last two contain 
%   the value of the frobenious norm of U_s*V_S'.
%   
% norm_opt_A: scalar corresponding to the frobenious norm of the k-truncated 
%   SVD of A (aka optimal solution of low rank approximation).  
% 
%% Examples
%
% Plotter(residual_history)
% Plotter(residual_history, convergence_history)
% Plotter(residual_history, convergence_history, norms_history)
% Plotter(residual_history, convergence_history, norms_history, norm_opt_A)
%
%% ---------------------------------------------------------------------------------------------------
function[] = Plotter(residual_history, convergence_history, norms_history, norm_opt_A, H_norm, stop_points)
tiledlayout(nargin,3);

l = size(norms_history,1);

if nargin > 5 
    eps_stop = stop_points(1);
    xi_stop = stop_points(2);
else 
    eps_stop = l;
    xi_stop = l;
end

%First plot: Approximation Residual normalized by ||A||
if nargin > 0
     
    residual_history = log1p(residual_history);

    nexttile;
    plot(residual_history(:,1));
    hold on
    %plot(residual_history(:,3), "m");

    if eps_stop ~= l
        scatter(eps_stop, residual_history(eps_stop,1), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop, residual_history(eps_stop,3), "x");
    end

    title('residual step 1');

    nexttile;
    plot(residual_history(:, 2));
    hold on 
    %plot(residual_history(:,4), "m");

    if eps_stop ~= l
        scatter(eps_stop, residual_history(eps_stop,2), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop, residual_history(eps_stop,4), "x");
    end
    title('residual step 2');

    a_residual_history = [residual_history(:,1) residual_history(:,2)]';
    h_residual_history = [residual_history(:,3) residual_history(:,4)]';
   
    nexttile;
    plot(a_residual_history(:));
    hold on 
    %plot(h_residual_history(:), "m");
    scatter(eps_stop*2,a_residual_history(2,eps_stop), "o");
    if xi_stop ~= l
        scatter(xi_stop*2,h_residual_history(2,xi_stop), "x");
    end
    title('full residual');
end 


%Second plot: Relative gap rate through iterations
if nargin > 1
   
    %convergence_history = log(convergence_history);
    
    nexttile;
    plot(convergence_history(:, 1));
    hold on

    if eps_stop~=1
        scatter(eps_stop, convergence_history(eps_stop,1), "o");
    end
    
    if xi_stop ~= l
        scatter(xi_stop, convergence_history(xi_stop,1), "x");
    end
    title('convergence U');

    nexttile;
    plot(convergence_history(:, 2));
    hold on

    if eps_stop ~= l
        scatter(eps_stop, convergence_history(eps_stop,2), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop, convergence_history(xi_stop,2), "x");
    end

    title('convergence V');
    convergence_history = convergence_history';

    nexttile;
    %residual at step 1
    plot(convergence_history(:));
    hold on
    if eps_stop ~= l
        scatter(eps_stop*2,convergence_history(2,eps_stop), "o");
    end
    if xi_stop ~= l
        scatter(xi_stop*2,convergence_history(2,xi_stop), "x");
    end
    title('full convergence');
end 


%Third plot: Param matrices norms through iterations
if nargin > 2

    %norms_history = log(norms_history);

    nexttile;
    plot(norms_history(:, 1));
    %hold on
    %plot(norms_history(:, 3), "m");
    hold on
    scatter(eps_stop, norms_history(eps_stop,1), "o");
    if xi_stop ~= l
        scatter(xi_stop, norms_history(xi_stop,3), "x");
    end
    title('U-norm');

    nexttile;
    plot(norms_history(:, 2));
    %hold on 
    %plot(norms_history(:, 4), "m");
    hold on 
    if eps_stop ~= l
        scatter(eps_stop, norms_history(eps_stop,2), "o");
    end
    if xi_stop ~= l
        scatter(xi_stop, norms_history(xi_stop,4), "x");
    end
    title('V-norm');

    nexttile;
    A_history = [norms_history(:, 5), norms_history(:, 6)]';
    plot(A_history(:))
    hold on
    if eps_stop ~= l
        scatter(eps_stop*2, A_history(2, eps_stop), "o")
    end
    hold on
   

    %If provided, also plot a constant corresponding to the 
    % norm of the optimal solution, showing if it is approached.

    if nargin > 3
        plot( ones(l*2)*norm_opt_A, 'g');
        hold on
    end

    if nargin > 4
        H_norm = H_norm';
        %plot(H_norm(:), "m");
        hold on

        if xi_stop ~= l
            scatter(xi_stop*2, H_norm(2,xi_stop), "x");
        end
    end


    title('A norm');
end
