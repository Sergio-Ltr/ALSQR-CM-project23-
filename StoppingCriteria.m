function [stop] = StoppingCriteria (i, max_i, A, U, V, criteria)

% ----- STOPPING CRITERIA (SC) -----

stop = false;

if criteria == "global" % -------- >(SC 1): GLOBAL CASE 
    
    % set e-precision costant
    e_SC1 = 0.0000001;

    % SC1 montior relative error
    rel_err = norm(A - U{i}*V{i}', "fro")/ norm(A, "fro");
    
    % SC1 stopping conditions
    if rel_err <= e_SC1 && i < max_i
        stop = true;
    end

elseif criteria == "local" % -------> (SC 2): LOCAL CASE 
    
    % set e-treshold costant and patience
    e_SC2 = 0.0000001;
    patience = 3;

    % initialize a sliding window (sw) of lenght = patience
    sw = zeros(1,patience);

    % SC1 monitor step-wise res. difference
    % fill the sw with the last n(=patience) step-wise error difference
    if i == 1
        stop = false;
    elseif i>1 && i<5 
        sw(i-1) = norm(U{i-1}*V{i-1}' - U{i}*V{i}', "fro") / norm(U{i-1}*V{i-1}', "fro");
    else
        sw(1:end-1) = sw(2:end);
        sw(end) = norm(U{i-1}*V{i-1}' - U{i}*V{i}', "fro") / norm(U{i-1}*V{i-1}', "fro");
    end

    % SC1 stopping conditions
    if i >= 4 && all(sw<= e_SC2)
        stop = true;
    end

else
    disp("Stopping criteria not valid")
end





