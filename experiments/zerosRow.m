function [] = zerosRow()
ripetition = 200;
for i = 1:ripetition
    A = full(sprandn(10, 200, 0.3));
    [U, V, ~, ~ , zerosrows] = Solver(A,2, [0,0], [200, 0, 0, 10]);
    i
    if zerosrows==true
        
        normA =  norm(A,"fro")
        Opt_err = optimalK(A, 2)
        err = norm(A-U*V', "fro")
        fprintf("error at iteration i "+i )
        break
    end    
end

