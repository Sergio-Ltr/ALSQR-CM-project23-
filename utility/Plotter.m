%% Plotter
% 
% Produces the plots of the algorithm execution. 
%
%% Syntax
%
% Plotter(loss)
% Plotter(loss, gap)
% Plotter(loss, gap, norms_history
% Plotter(loss, gap, norms_history, opt_norms)
% Plotter(loss, gap, norms_history, opt_norms, stop_points)
%
%% Description
%
% Generate the plots of the passed timeseries, handling low level
% operations like titles, legends, logarithmic scaling and so on. 
%
%% Parameters 
%
% loss: a couple of l dimensional vector, first for subproblem 
%   (1) and second for subproblem (2). They both contain the values of the 
%   loss after each LLS solution step.  
%   
% gap: a couple of l dimensional vector, first for 
%   subproblem (1) and second for subproblem (2), containing the
%   relative gap computed after each LLS solution step. 
%
% norms_history: contains four l dimensional vectors, the first two are ones 
%   containing values of the Froious norm of the U and V matrix respctively, 
%   computed at each step after the update, while the last two contain 
%   the value of the frobenious norm of U_s*V_S'.
%   Additionally, values of the approximation of the norms comute with the
%   norm of the R matrices can be passed appended in this history vector.  
%   
% norm_opt_solutions: scalar corresponding to the frobenious norm of the k-truncated 
%   SVD of A (aka optimal solution of low rank approximation).  
% 
% stop_points: a vector of two elements, first one is the point of trigger
%   of the epsilon criteria, second one is the trigger point of the xi stop.  
%
%% Examples
%
% Plotter(loss)
% Plotter(loss, gap)
% Plotter(loss, gap, norms_history)
% Plotter(loss, gap, norms_history, norm_opt_solutions, stop_points)
%
%% ---------------------------------------------------------------------------------------------------

function[] = Plotter(loss, gap, norms_history, norm_opt_solutions, stop_points)
tiledlayout(nargin,3);

l = size(norms_history,1);

% If stop points are not present, they coincide with the last iteration. 
if nargin > 5 
    eps_stop = stop_points(1);
    xi_stop = stop_points(2);
else 
    eps_stop = l;
    xi_stop = l;
end

%First plot: Loss
if nargin > 0
     
    nexttile;
    semilogy(loss(:,1));
    xlabel('Iterations')
    ylabel('Loss')
    hold on

    % Plot the stop indicators
    if eps_stop ~= l
        scatter(eps_stop, loss(eps_stop,1), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop, loss(eps_stop,3), "x");
    end

    title('Loss step (1)');

    nexttile;
    semilogy(loss(:, 2));
    xlabel('Iterations')
    ylabel('Loss')
    hold on 

    % Plot the stop indicators    
    if eps_stop ~= l
        scatter(eps_stop, loss(eps_stop,2), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop, loss(eps_stop,4), "x");
    end
    title('Loss step (2)');

    loss_history = [loss(:,1) loss(:,2)]';   
    nexttile;

    semilogy(loss_history(:));
    xlabel('Iterations')
    ylabel('Loss')
    hold on 

    scatter(eps_stop*2,loss_history(2,eps_stop), "o");
    if xi_stop ~= l
        scatter(xi_stop*2,loss_history(2,xi_stop), "x");
    end
    title('Full Loss');
end 


%Second plot: Relative gap
if nargin > 1

    nexttile;
    semilogy(gap(:, 1));
    xlabel('Iterations')
    ylabel('Relative Gap')
    hold on

    % Plot the stop indicators
    if eps_stop~=1
        scatter(eps_stop, gap(eps_stop,1), "o");
    end
    
    if xi_stop ~= l
        scatter(xi_stop, gap(xi_stop,1), "x");
    end
    title('Relative Gap at step (1)');

    nexttile;
    semilogy(gap(:, 2));
    xlabel('Iterations')
    ylabel('Relative Gap')
    hold on

    % Plot the stop indicators
    if eps_stop ~= l
        scatter(eps_stop, gap(eps_stop,2), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop, gap(xi_stop,2), "x");
    end

    title('Relative Gap at step (2)');
    gap_history = gap';

    nexttile;
    semilogy(gap_history(:));
    xlabel('Iterations')
    ylabel('Relative Gap')
    hold on

    % Plot the stop indicators
    if eps_stop ~= l
        scatter(eps_stop*2,gap_history(2,eps_stop), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop*2,gap_history(2,xi_stop), "x");
    end
    title('Full RelativeGap ');
end 


%Third plot: Norms
if nargin > 2

    nexttile;
    % Plot the norm of U.
    plot(norms_history(:, 1));
    xlabel('Iterations')
    ylabel('Frobenius Norm')
    hold on

    % Plot also the norm of R_U
    plot(norms_history(:, 3), "m");
    hold on
    
    % Plot the stop indicators
    if eps_stop ~= l
        scatter(eps_stop, norms_history(eps_stop,1), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop, norms_history(xi_stop,3), "x");
    end

    if  nargin > 3 && size(norm_opt_solutions, 2) > 1
        plot( ones(l)*norm_opt_solutions(2), 'g');
        hold on
    end

    title('U-norm');

    nexttile;
    %Plot the norm of V
    plot(norms_history(:, 2));
    xlabel('Iterations')
    ylabel('Frobenius Norm')
    hold on 

    % Plot also the norm of R_U
    plot(norms_history(:, 4), "m");

    % Plot the stop indicators
    if eps_stop ~= l
        scatter(eps_stop, norms_history(eps_stop,2), "o");
    end
    if xi_stop ~= l
        scatter(xi_stop, norms_history(xi_stop,4), "x");
    end
    
    % Plot optimal norm
    if  nargin > 3 && size(norm_opt_solutions, 2) > 1
        plot( ones(l)*norm_opt_solutions(3), 'g');
        hold on
    end

    title('V-norm');

    nexttile;
    % Plot the norm of A. 
    A_history = [norms_history(:, 5), norms_history(:, 6)]';
    plot(A_history(:))
    hold on

    % Plot the norm of R_U*R_V' (approximation for the xi stop criteria).
    H_norm = [norms_history(:, 7), norms_history(:, 8)]'; 
    plot(H_norm(:), "m");
    xlabel('Iterations')
    ylabel('Frobenius Norm')
    hold on

    % Plot the stop indicators
    if eps_stop ~= l
        scatter(eps_stop*2, A_history(2, eps_stop), "o")
    end
    hold on

    if xi_stop ~= l
        scatter(xi_stop*2, H_norm(2,xi_stop), "x");
    end
    hold on
   

    % If provided, also plot a constant corresponding to the 
    % norm of the optimal solution, showing if it is approached.
    if nargin > 3
        plot( ones(l*2)*norm_opt_solutions(1), 'g');
    end

    title('A_s norm');
end
