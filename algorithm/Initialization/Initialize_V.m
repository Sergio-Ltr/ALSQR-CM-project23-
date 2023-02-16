%% Initialize_V
%
% Create a $V_0$ matrix to begin the alternate optimization cycle. 
%
%% Syntax 
%
% V = initialize_V(n, k, bissed);
% V = initialize_V(n, k, bissed, constraint);
% V = initialize_V(n, k, bissed, constraint, params);
%
%% Description 
%
% Generate a random values matrix of shape n x k. 
% Desired properties can be specified as constraints. 
% If no constrainnts are specified, V is just a random matrix.
%
%% Parameters
%
% n: number of rows.
%
% k: number of columns.
%
% constraint_key: string value corresponding to a partiucular constraint or
% characterization of the V' matrix
%
% param: possible additional value(s) for the constrained configuaration. 
%
% biased: secify if the matrix should be used for a biaed training process.
%   Each constraint handles differently the additoonal biases row.
%
%% Possible Constraint Keys
%
% - "dist": 
%   sample values of V from a distributuio specifying its parameters according to
%   RANDRAW" module: https://it.mathworks.com/matlabcentral/fileexchange/7309-randraw
%
% - "sparse": 
%    A percentage of the elements of V_0 will be 0s, by default half, or 
%    according the d parameter (0 < d < 1) if specified correctly. 
%
% - "orth":
%   The returned n x k matrix will be composed by k orthonormal columns.
%
% - "low_rank": 
%   Rank r of V_0 will be lower than k. 
%   r can be specified as a parameter, otherwise it would just be k-1
%
% - "uniform"
%   We assume for each one of the n feature to be equally determined by each
%   of the k low rank (latent) features. Therein the only value in V_0 will
%   be 1/k, having columns sum to one columns (sum to one rows in V'),
%
% - "feature-selection"
%   V will contain only zeros (epsions = 1e-5) and ones, hoping to randomly 
%   catch interesting feartures. 
%   Density of ones can be sepcified in the param in [0,1], default d = 0.5. 
%
% - "prob"
%   Each column of the matrix is a sum to one vector of random
%   probabilities.
%   
%% Examples
%
% Random $V_0$ matrix of shape 30 x 12. 
% V = initialize_V(30, 12);
%
% Random matrix composed by 12 orthonormal columns (of 30 elements each). 
% V = initialize_V(30, 12, "orth");
%
% Random matrix with 40% sparsity (Half of the elements being 0s). 
% V = initialize_V(30, 12, "sparse", 0.6);
%
% Matrix with shape 30 x 12 sampled from a Gaussian distribution with mean
% mu = 0 and stdev sigma=1. 
% V = initialize_V(30, 12, "dist", {type:"normal", params: [0, 1]}))
%
%% --------------------------------------------------------------------------------------

function [V] = Initialize_V (n, k, constraint_key, param, biased)
    
mat = randn(n,k);

% Biased default to false
if nargin < 5
   biased = false;
end

% @TODO, only if not costrainde, else handle sepearatley.
if biased
    k = k +1;
end

%Constraint application the V_0 matrix. 
if nargin > 2
    
    if constraint_key == "dist" %second item is distribution type (i.e. "normal"). Possibilities here: 
        dist_key = char(param(1));
        dist_type = cell2mat(param(2:end));
        values = randraw(dist_key, dist_type, n*k);
        mat = reshape(values, [n,k]);

    elseif  constraint_key == "sparse" %second item is density coefficient 0 < d < 1.  
        d = 0.5;
        if param > 0 && param < 1
            d = param;
        end
        mat = full(sprandn(n, k, d)); % = Vo (starting point) 
    
    elseif  constraint_key == "orth"
        mat = orth(randn(k,n));% output a matrix of orthogonal columns. 
    
    elseif  constraint_key == "low_rank"
        r = k - 1;
        if param > 1 && param < k
            r = param;
        end
        mat = randn(n,r)*rand(r,k); % resulting matrix will have rank r by construction.  

    elseif constraint_key == "uniform"
        mat = 1/k * ones(n,k);
    
    elseif constraint_key == "feature-selection"
        d = 0.5;
        if param > 0 && param < 1
            d = param;
        end
        mat = full(sprandn(n, k, d)) ~= 0; % = Vo (starting point) 
    
    elseif constraint_key == "prob"
        mat = rand(n,k);
        mat = mat./sum(mat);
    end  
end

V = mat;
