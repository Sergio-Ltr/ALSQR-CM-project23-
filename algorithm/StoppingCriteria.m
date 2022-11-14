function [stop, local_stooping_active] = StoppingCriteria (i, parameter, rel_err, convergence_rate, local_stooping_active)

% ----- STOPPING CRITERIA (SC) -----
stop = false;

% initialize stopping criteria parameter
global_stop = false;
local_stop = false;
max_i = parameter(1);
e_SC1 = parameter(2);
e_SC2 = parameter(3);
patience = parameter(4); 

% (SC 1): GLOBAL CASE stopping condition
if rel_err <= e_SC1 && i < max_i
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



