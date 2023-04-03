function [output] = testVinit(m,n,k)%, lambdas)

% initilize A
A = randn(m,n);

% initilize V0
v0 = Initialize_V(n,k);


%% Regularization among iterations (100,25,10)

lambdas = [0, 0];

[~, opt_A, ~] = optimalK(A, k, lambdas(1), lambdas(2));


v1_05 = Initialize_V(n,k, "sparse", 0.5);
%v1_02 = Initialize_V(n,k, "sparse", 0.2);
%v1_08 = Initialize_V(n,k, "sparse", 0.8);
v2 = Initialize_V(n,k, "orth");
v3 = Initialize_V(n,k, "low-rank", k-1);
%v4 = Initialize_V(n,k, "uniform");
v5_05 = Initialize_V(n,k, "feature-selection", 0.5);
%v5_02 = Initialize_V(n,k, "feature-selection", 0.2);
%v5_08 = Initialize_V(n,k, "feature-selection", 0.8);
v6 = Initialize_V(n,k,"probs");

disp(["V0"])
Solver(A, k, lambdas, [500, 0, 0], v0, 1, 0, 'temp-v0.csv',  opt_A);
disp(["V1_05"])
Solver(A, k, lambdas, [500, 0, 0], v1_05, 1, 0, 'temp-v1_05.csv', opt_A);
disp(["V2"])
Solver(A, k, lambdas, [500, 0, 0], v2, 1, 0, 'temp-v2.csv', opt_A);
disp(["V3"])
Solver(A, k, lambdas, [500, 0, 0], v3, 1, 0, 'temp-v3.csv', opt_A);
disp(["V5_05"])
Solver(A, k, lambdas, [500, 0, 0], v5_05, 1, 0, 'temp-v5_05.csv', opt_A);
disp(["V6"])
Solver(A, k, lambdas, [500, 0, 0], v6, 1, 0, 'temp-v6.csv', opt_A);


%{
% Run solver with different lambda parameter


disp(["1"])
[~, ~, ~] = Solver (A, k, [0.0, 0.0], [1000, 0, 0], v0, 1, 0, 'temp_reg00.csv');
disp(["2"])
[~, ~, ~] = Solver (A, k, [0.2, 0.2], [1000, 0, 0], v0, 1, 0, 'temp_reg02.csv');
disp(["3"])
[~, ~, ~] = Solver (A, k, [0.4, 0.4], [1000, 0, 0], v0, 1, 0, 'temp_reg04.csv');
disp(["4"])
[~, ~, ~] = Solver (A, k, [0.6, 0.6], [1000, 0, 0], v0, 1, 0, 'temp_reg06.csv');
disp(["5"])
[~, ~, ~] = Solver (A, k, [0.8, 0.8], [1000, 0, 0], v0, 1, 0, 'temp_reg08.csv');
disp(["6"])
[~, ~, ~] = Solver (A, k, [1.0, 1.0], [1000, 0, 0], v0, 1, 0, 'temp_reg10.csv');


%% SPARSITY OF A among iterations (200,50,20)

%A00 = Initialize_A(m,n,"sparse", 0.0);
A02 = Initialize_A(m,n,"sparse", 0.2);
A04 = Initialize_A(m,n,"sparse", 0.4);
A06 = Initialize_A(m,n,"sparse", 0.6);
A08 = Initialize_A(m,n,"sparse", 0.8);
A10 = Initialize_V(m,n,"sparse", 1.0);

v0 = Initialize_V(n,k);

%disp(["1"])
%[~, ~, ~] = Solver (A00, k, [0.0, 0.0], [1000, 0, 0], v0, 1, 0, 'Asparse00.csv');
disp(["2"])
[~, ~, ~] = Solver (A02, k, [0.0, 0.0], [1000, 0, 0], v0, 1, 0, 'Asparse02.csv');
disp(["3"])
[~, ~, ~] = Solver (A04, k, [0.0, 0.0], [1000, 0, 0], v0, 1, 0, 'Asparse04.csv');
disp(["4"])
[~, ~, ~] = Solver (A06, k, [0.0, 0.0], [1000, 0, 0], v0, 1, 0, 'Asparse06.csv');
disp(["5"])
[~, ~, ~] = Solver (A08, k, [0.0, 0.0], [1000, 0, 0], v0, 1, 0, 'Asparse08.csv');
disp(["6"])
[~, ~, ~] = Solver (A10, k, [0.0, 0.0], [1000, 0, 0], v0, 1, 0, 'Asparse10.csv');

output = "FINISHED";


disp(["1"])
[value2test] = V_Experiment("dist");

disp(["2"])
[value2test] = V_Experiment("sparse");
disp(["3"])
[value2test] = V_Experiment("orth");
disp(["4"])
[value2test] = V_Experiment("low_rank");
disp(["6"])
[value2test] = V_Experiment("feature-selection");
disp(["7"])
[value2test] = V_Experiment("prob");
%}

end


