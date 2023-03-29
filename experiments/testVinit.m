function [output] = testVinit(m,n,k)

% initilize A
A = randn(m,n);

% initilize V0
v0 = Initialize_V(n,k);

%{
v1_05 = Initialize_V(n,k, "sparse", 0.5);
v1_02 = Initialize_V(n,k, "sparse", 0.2);
v1_08 = Initialize_V(n,k, "sparse", 0.8);
v2 = Initialize_V(n,k, "orth");
v3 = Initialize_V(n,k, "low-rank", k-1);
v4 = Initialize_V(n,k, "uniform");
v5_05 = Initialize_V(n,k, "feature-selection", 0.5);
v5_02 = Initialize_V(n,k, "feature-selection", 0.2);
v5_08 = Initialize_V(n,k, "feature-selection", 0.8);
v6 = Initialize_V(n,k,"probs");


[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v0, 1, 0, 'temp-v0.csv');
[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v1_05, 1, 0, 'temp-v1_05.csv');
[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v1_02, 1, 0, 'temp-v1_02.csv');
[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v1_08, 1, 0, 'temp-v1_08.csv');
[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v2, 1, 0, 'temp-v2.csv');
[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v3, 1, 0, 'temp-v3.csv');
[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v4, 1, 0, 'temp-v4.csv');
[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v5_05, 1, 0, 'temp-v5_05.csv');
[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v5_02, 1, 0, 'temp-v5_02.csv');
[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v5_08, 1, 0, 'temp-v5_08.csv');
[~, ~, ~, ~, ~, ~] = Solver(A, k, [0.0, 0.0], [500, 0, 0, 10], v6, 1, 0, 'temp-v6.csv');
%}

% Run solver with different lambda parameter
[~, ~, ~] = Solver (A, k, [0.0, 0.0], [1000, 0, 0], v0, 1, 0, 'temp_reg00.csv');
[~, ~, ~] = Solver (A, k, [0.2, 0.2], [1000, 0, 0], v0, 1, 0, 'temp_reg00.csv');
[~, ~, ~] = Solver (A, k, [0.4, 0.4], [1000, 0, 0], v0, 1, 0, 'temp_reg00.csv');
[~, ~, ~] = Solver (A, k, [0.6, 0.6], [1000, 0, 0], v0, 1, 0, 'temp_reg00.csv');
[~, ~, ~] = Solver (A, k, [0.8, 0.8], [1000, 0, 0], v0, 1, 0, 'temp_reg00.csv');
[~, ~, ~] = Solver (A, k, [1.0, 1.0], [1000, 0, 0], v0, 1, 0, 'temp_reg00.csv');


output = "FINISHED";
end


