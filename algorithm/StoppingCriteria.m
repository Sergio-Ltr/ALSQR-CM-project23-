%% Stopping Criteria
% 
% Function to check early stopping conditions accoridng to algorithm
% iteration state and stopping conditions. 
%
%% Description
%
% Early stopping works in two ways, global and local, respectively considering the relative error and convergence rate. 
%
% Global ES checks if relative error /criteria is not satisfied anymore, interruption
% is aborted and patience time resetted. 
%
%% Parameters 
%
% i: the current algorithm iteration
% parameters: list of early stopping parameters
%  - parameters(1): max number of epochs allowed. 
%  - parameters(2): epsilon threshold for relative error. 
%  - parameters(3): xi threshold for converngence rate
%  - parameters(4): patience, number of iterations to be waited after local stop criteria being triggered.  
% rel_err: current relative error. 
% convergence_rate: current convergence rate. 
% local_stopping_active: number of iterations passed since local stopping was triggered.
%% Examples
% 
% Stopping Criteria(1000, 0, 1, True, False)
%% ---------------------------------------------------------------------------------------------------

function [stop, local_stooping_active] = StoppingCriteria (i, parameters, rel_err, convergence_rate, local_stooping_active, use_global)


% if "use_global" parameter is not setted, it's assumed to be true. 
if nargin < 6
    use_global = false;
end

% optimal xi: 10e-7
% ----- STOPPING CRITERIA (SC) -----
stop = false;

% initialize stopping criteria parameter
global_stop = false;
local_stop = false;
max_i = parameters(1);
e_SC1 = parameters(2);
e_SC2 = parameters(3);
patience = parameters(4); 

% (SC 1): GLOBAL CASE stopping condition
% if only local flag is setted, skip control on local ES case. 
if use_global == true && rel_err <= e_SC1 && i < max_i
    global_stop = true;
end

% (SC 2): LOCAL CASE stopping condition
if convergence_rate < e_SC2
    local_stooping_active = local_stooping_active + 1; 
    local_stop = local_stooping_active >=  patience;
else
    local_stooping_active = 0;
end

% if (SC 1) stop conditions or  (SC 2) stop conditions are verified
% ---> interruption of the algorithm execution
if  global_stop == true || local_stop == true
    stop = true;
end



