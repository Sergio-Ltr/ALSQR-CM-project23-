### Computational Mathematics - Project 23 - University of Pisa - 2021/2022

The current repository contains the MATLAB files involved in the implementation of the project 23(NON-ML):


(P) is a low rank approximation of a matrix `$A \in xxz\mathbb{R}^{m \times n}$`:
`$\argmin_{U \in \mathbb{R}^{m \times k}, V\in \mathbb{R}^{n \times k}} \| A - UV^T \|_F$`
(A) is alternating optimization: first take an initial  `$V=V_0$`, and compute `$ U_{1} = \argmin_{U} \| A - UV^{T}_{0}\|_F$`, then use it to compute `$V_{1} = \argmin_{V} \|A - U_{1}V^{T}\|_{F}$`, then `$U_{2} = \argmin_{U} \| A - UV^{T}_{1}\|_{F} $`, and so on, until (hopefully) convergence. Use QR factorization to solve these sub-problems.


## Quick Start

To open the project use Matplab "Open" button and select the `LowRankWithQR.prj` file in this folder. 

All the code file are largely commented and documented, and execution examples can be found in every file heading. 

The main functionality, a.k.a the function to solve (p) using (A) is the Solver function:

```
[U,V] = Solver(randn(30,10), 5, [0,0], [100, 0, 0], randn(10,5))
```

The example line above solve the approximation at rank 5 of a 20 x 10 random input matrix, using a random initialization,100 iterations and no regularization.


## Code and file structure

Project is structuerd in three main folders: 

```
- algorithm
|- Initialization
|- LLS_Solver
|- QR_Factorization
- experiments 
- utility
```

The `algorithm` folder contains the main mathematical computations, it has three sub folders, including the one with our implementan of the QR factorization. 
The `experiments` folder contains all the functions implemented to authomatize the various empirical evaluation. 
The `utility` folder contains all the other functionalities implemented within the project, like the plotting function, the linear autoencoder, the external solver and so on. 

Some additiona Python notebooks were developed to combine charts ad achieve better data visualization: 
 
https://drive.google.com/drive/my-drive (qui mettere link al drive coi notebook)

## Dependencies 

To run the AE experiments, `Matlab Machine Learning Toolbox` should be installed. 
To run the `ExternalSolver.m` and compute the gap of the regularized problem, `Matlab Optimization Toolbox` should be installed. 

The MNIST dataset is contained in the resources folder. 
We do not own the dataset, it was taken from the following webpage: https://lucidar.me/en/matlab/load-mnist-database-of-handwritten-digits-in-matlab/

The randraw.m file is the implementation  `Alex Bar Guy  &  Alexander Podgaetsky` of a sampler from various statistical distribution. 
We do not own that code, and its use in the project was minimun (it's more an extra feature for future experiments). 

All the remaining files were implemented from scratches.  
Feel free to contact us for any information or suggestion. 

Irene Pisani:   i.pisani1@studenti.unipi.it
Sergio Latrofa: s.latrofa1@studenti.unipi.it


