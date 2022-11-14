%% Initialize_V
% Create a $V_0$ matrix to begin the alternate optimization cycle. 
%% Syntax 
% V = initialize_V(n, k);
% V = initialize_V(n, k, constraint);
% V = initialize_V(n, k, constraint, params);
%% Description 
% Generate a random values matrix of shape n x k. 
% Desired properties can be specified as constraints. 
% If no constrainnts are specified, V is just a random matrix.
%% Possible Constaint Keys
% - "dist": 
%   sample values of V from a distributuio specifying its parameters according to
%   RANDRAW" module: https://it.mathworks.com/matlabcentral/fileexchange/7309-randraw
% - "sparse": 
%    A percentage of the elements of V_0 will be 0s, according the d parameter (0 < d < 1). 
% - "orth":
%   The returned n x k matrix will be composed by k orthonormal columns.
% - "low_rank": 
%   Rank r of V_0 will be lower than k. 
%   r can be specified as a parameter, otherwise it would just be k-1
%% Examples
% Random $V_0$ matrix of shape 30 x 12. 
% V = initialize_V(30, 12);
%
% Random matrix composed by 12 orthonormal columns (of 30 elements each). 
% V = initialize_V(30, 12, "orth");
%
% Random matrix with 50% sparsity (Half of the elements being 0s). 
% V = initialize_V(30, 12, "sparse", 0.5);
%
% Matrix with shape 30 x 12 sampled from a Gaussian distribution with mean
% 0 and stdev=1. 
% V = initialize_V(30,12, "dist", {type: "normal", mu:"0", sigma:"1"} )
% --------------------------------------------------------------------------------------

function [V] = Initialize_V (n, k, constraint_key, param)
    
mat = randn(n,k);

%Initialization of the V_0 matrix. 
if nargin > 2
    if constraint_key == "dist" %second item is distribution type (i.e. "normal"). Possibilities here: 
            
        %dist = randraw(); % = Vo (starting point) 
    elseif  constraint_key == "sparse" %second item is density coefficient 0 < d < 1.  
            
        mat = sprandn(n,k, d); % = Vo (starting point) 
    elseif  constraint_key == "orth"
            
        mat = orth(mat); % output a matrix of orthogonal rows 
    elseif  constraint_key == "low_rank"
            
        mat = randn(n,k); % = Vo (starting point) 
    end  
end

V = mat;
