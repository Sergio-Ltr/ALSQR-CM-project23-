%% Plotter
% 
% Produces the plots of the algorithm execution. 
%
%% Syntax
%
% Plotter(loss)
% Plotter(loss, gap)
% Plotter(loss, gap, norms_history)
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
function[] = Plotter(loss, gap, norms_history, norm_opt_solutions, stop_points)
tiledlayout(nargin,3);

l = size(norms_history,1);

if nargin > 5 
    eps_stop = stop_points(1);
    xi_stop = stop_points(2);
else 
    eps_stop = l;
    xi_stop = l;
end

%First plot: Approximation of losses
if nargin > 0
     
    nexttile;
    semilogy(loss(:,1));
    xlabel('Iterations')
    ylabel('Loss')
    hold on

    if eps_stop ~= l
        scatter(eps_stop, loss(eps_stop,1), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop, loss(eps_stop,3), "x");
    end

    title('Loss step 1');

    nexttile;
    semilogy(loss(:, 2));
    xlabel('Iterations')
    ylabel('Loss')
    hold on 

    if eps_stop ~= l
        scatter(eps_stop, loss(eps_stop,2), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop, loss(eps_stop,4), "x");
    end
    title('Loss');

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


%Second plot: Relative gap rate through iterations
if nargin > 1
   
    %convergence_history = log(convergence_history);
    
    nexttile;
    semilogy(gap(:, 1));
    xlabel('Iterations')
    ylabel('Relative Gap')
    hold on

    if eps_stop~=1
        scatter(eps_stop, gap(eps_stop,1), "o");
    end
    
    if xi_stop ~= l
        scatter(xi_stop, gap(xi_stop,1), "x");
    end
    title('Relative Gap at step 1');

    nexttile;
    semilogy(gap(:, 2));
    xlabel('Iterations')
    ylabel('Relative Gap')
    hold on

    if eps_stop ~= l
        scatter(eps_stop, gap(eps_stop,2), "o");
    end

    if xi_stop ~= l
        scatter(xi_stop, gap(xi_stop,2), "x");
    end

    title('Relative Gap');
    gap_history = gap';

    nexttile;
    %residual at step 1
    semilogy(gap_history(:));
    xlabel('Iterations')
    ylabel('Relative Gap')
    hold on
    if eps_stop ~= l
        scatter(eps_stop*2,gap_history(2,eps_stop), "o");
    end
    if xi_stop ~= l
        scatter(xi_stop*2,gap_history(2,xi_stop), "x");
    end
    title('Full RelativeGap ');
end 


%Third plot: Param matrices norms through iterations
if nargin > 2

    %norms_history = log(norms_history);

    nexttile;
    plot(norms_history(:, 1));
    xlabel('Iterations')
    ylabel('Frobenius Norm')
    %hold on
    %plot(norms_history(:, 3), "m");
    hold on
    scatter(eps_stop, norms_history(eps_stop,1), "o");
    if xi_stop ~= l
        scatter(xi_stop, norms_history(xi_stop,3), "x");
    end


    if  nargin > 3 && size(norm_opt_solutions, 2) > 1
        plot( ones(l)*norm_opt_solutions(2), 'g');
        hold on
    end

    title('U-norm');

    nexttile;
    plot(norms_history(:, 2));
    xlabel('Iterations')
    ylabel('Frobenius Norm')
    %hold on 
    %plot(norms_history(:, 4), "m");
    hold on 
    if eps_stop ~= l
        scatter(eps_stop, norms_history(eps_stop,2), "o");
    end
    if xi_stop ~= l
        scatter(xi_stop, norms_history(xi_stop,4), "x");
    end

    if  nargin > 3 && size(norm_opt_solutions, 2) > 1
        plot( ones(l)*norm_opt_solutions(3), 'g');
        hold on
    end

    title('V-norm');

    nexttile;
    A_history = [norms_history(:, 5), norms_history(:, 6)]';
    H_norm = [norms_history(:, 7), norms_history(:, 8)]'; 

    plot(A_history(:))
    hold on

    plot(H_norm(:), "m");
    xlabel('Iterations')
    ylabel('Frobenius Norm')
    hold on

    if eps_stop ~= l
        scatter(eps_stop*2, A_history(2, eps_stop), "o")
    end
    hold on

    if xi_stop ~= l
        scatter(xi_stop*2, H_norm(2,xi_stop), "x");
    end
    hold on
   

    %If provided, also plot a constant corresponding to the 
    % norm of the optimal solution, showing if it is approached.

    if nargin > 3
        plot( ones(l*2)*norm_opt_solutions(1), 'g');
    end

    title('A norm');
end
