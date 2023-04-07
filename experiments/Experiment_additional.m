%% Experiment additional
%
% Function to perform additional experiment and save metric score among
% iterations.
%
%% Syntax
%
%  [] = Experiment_additional(m,n,k)
%
%% Description
%
% Purpose of Experiment_additional functions:
%
% 1) Solve the low rank approximation problem of A using ALSQR considering
% each time a different V0 initilized with a different method
% 2) Solve the low rank approximation problem of A using ALSQR considering
% each time different values of the thikonov parameter (lambda)
% 3) Solve the low rank approximation problem of A using ALSQR considering
% each time a matrix A with different density of sparsity 
%
%% Parameters 
%
% - m : (int) number of row in A
% - n : (int) number of column in A
% - k : (int) rank for the low rank appoximation
%
%% Output 
%
% No explicit output are avaible. The result of the experiments will be saved
% in the corresponding csv files.
%
%% Examples
%
%  Experiment_additional(100, 30, 10)
%
%% ------------------------------------------------------------------------

function [] = Experiment_additional(m,n,k)

% Defeault initilizations
A = randn(m,n);
V0 = Initialize_V(n,k);
lambdas = [0, 0];

% ALSQR with different V0 initialization 

[~, opt_A, ~] = optimalK(A, k, lambdas(1), lambdas(2));

V1 = Initialize_V(n,k, "sparse", 0.5);
V2 = Initialize_V(n,k, "orth");
V3 = Initialize_V(n,k, "low-rank", k-1);
V4 = Initialize_V(n,k, "feature-selection", 0.5);
V5 = Initialize_V(n,k, "prob");

Solver(A, k, lambdas, [500, 0, 0], V0, 1, 0, 'V0_dist.csv',  opt_A);
Solver(A, k, lambdas, [500, 0, 0], V1, 1, 0, 'V0_sparse_05.csv', opt_A);
Solver(A, k, lambdas, [500, 0, 0], V2, 1, 0, 'V0_orth.csv', opt_A);
Solver(A, k, lambdas, [500, 0, 0], V3, 1, 0, 'V0_low-rank.csv', opt_A);
Solver(A, k, lambdas, [500, 0, 0], V4, 1, 0, 'V0_feature-selection.csv', opt_A);
Solver(A, k, lambdas, [500, 0, 0], V5, 1, 0, 'V0_prob.csv', opt_A);

% ALSQR with different lambda parameter among iterations

[~, ~, ~, ~, ~] = Solver (A, k, [0.0, 0.0], [1000, 0, 0], V0, 1, 0, 'reg00.csv');
[~, ~, ~, ~, ~] = Solver (A, k, [0.2, 0.2], [1000, 0, 0], V0, 1, 0, 'reg02.csv');
[~, ~, ~, ~, ~] = Solver (A, k, [0.4, 0.4], [1000, 0, 0], V0, 1, 0, 'reg04.csv');
[~, ~, ~, ~, ~] = Solver (A, k, [0.6, 0.6], [1000, 0, 0], V0, 1, 0, 'reg06.csv');
[~, ~, ~, ~, ~] = Solver (A, k, [0.8, 0.8], [1000, 0, 0], V0, 1, 0, 'reg08.csv');
[~, ~, ~, ~, ~] = Solver (A, k, [1.0, 1.0], [1000, 0, 0], V0, 1, 0, 'reg10.csv');

% SPARSITY OF A among iterations 

A02 = Initialize_A(m,n,"sparse", 0.2);
A04 = Initialize_A(m,n,"sparse", 0.4);
A06 = Initialize_A(m,n,"sparse", 0.6);
A08 = Initialize_A(m,n,"sparse", 0.8);
A10 = Initialize_V(m,n,"sparse", 1.0);

[~, ~, ~, ~, ~] = Solver (A02, k, lambdas, [1000, 0, 0], V0, 1, 0, 'Asparse02.csv');
[~, ~, ~, ~, ~] = Solver (A04, k, lambdas, [1000, 0, 0], V0, 1, 0, 'Asparse04.csv');
[~, ~, ~, ~, ~] = Solver (A06, k, lambdas, [1000, 0, 0], V0, 1, 0, 'Asparse06.csv');
[~, ~, ~, ~, ~] = Solver (A08, k, lambdas, [1000, 0, 0], V0, 1, 0, 'Asparse08.csv');
[~, ~, ~, ~, ~] = Solver (A10, k, lambdas, [1000, 0, 0], V0, 1, 0, 'Asparse10.csv');


fprintf("Experiments successfully completed")

end


