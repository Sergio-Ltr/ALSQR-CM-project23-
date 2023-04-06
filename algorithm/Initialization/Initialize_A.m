%% Initialize_V
%
% Create a A matrix to experiment algorithm behaviour on different configurations. 
%
%% Syntax 
%
% V = initialize_A(m, n);
% V = initialize_A(m, n, constraint);
% V = initialize_A(m, n, constraint, params);
%
%% Description 
%
% Generate a random values matrix of shape n x k. 
% Desired properties can be specified as constraints. 
% If no constrainnts are specified, A is just a random matrix.
%
%% Possible Constraint Keys
%
% - "dist": 
%   sample values of A from a distributuio specifying its parameters according to
%   RANDRAW" module: https://it.mathworks.com/matlabcentral/fileexchange/7309-randraw
%
% - "sparse": 
%    A percentage of the elements of A will be 0s, by default half, or according the d parameter (0 < d < 1) if specified correctly. 
%
% - !THE SYMMETRICAL CASE SHOULD BE "HAND-HANDLED" like A = DD'
%
%% Examples
%
% Random A matrix of shape 30 x 12. 
% A = initialize_V(30, 12);
%
% Random matrix with 40% sparsity (Half of the elements being 0s). 
% A = initialize_V(30, 12, "sparse", 0.6);
%
% Matrix with shape 30 x 12 sampled from a Gaussian distribution with mean mu = 0 and stdev sigma=1. 
% A = initialize_V(30, 12, "dist", {type:"normal", params: [0, 1]}))
%
% --------------------------------------------------------------------------------------

function [A] = Initialize_A (m, n, constraint_key, param)
    
% Random initialization. 
mat = randn(m, n);

%Constraint application to the A matrix. 
if nargin > 2

    % Sample values from a probability distribution.
    if constraint_key == "dist" 
        % Second item is distribution type (i.e. "normal").
        % Possibilities here:  https://it.mathworks.com/matlabcentral/fileexchange/7309-randraw
        dist_key = char(param(1));
        dist_type = cell2mat(param(2:end));
        values = randraw(dist_key, dist_type, m*n);
        mat = reshape(values, [m,n]);

    % Sample random values according to a density coefficient.
    elseif  constraint_key == "sparse" 
        % Second item is density coefficient 0 < d < 1.  
        d = 0.5; 
        if param > 0 && param <= 1
            d = param;
        end
        mat = full(sprandn(m, n, d));

    % Other possible initialization can be added here
    % ................................................ 
    end  
end

A = mat;
