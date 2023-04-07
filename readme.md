### Computational Mathematics - Project 23 - University of Pisa - 2021/2022

The current repository contains the MATLAB files involved in the implementation of the project 23(NON-ML).

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

## Experimental set-up and result

In `experiments` folder are stored all the scripts useful for reproducing our experiments; you can use the following commands to run experiments  

* `Experiment_A("shape")`   
    It run experiment wrt to different A dimensions/shape;

* `Experiment_A("sparsity")`    
    It run experiments wrt to different sparse matrix A;

* `Experiment_V("sparse")`  
    It run experiments with  different initialization of matrix V (you can replace the paramter "sparse" with other type of avaialable intiliazation accuratly described in the file documentation and comments);

* `Experiment_Time("ALSQR_time")` 
    It run experiment regarding time_efficiency of our solver wrt matalab implememtation of SVD;

* `Experiment_Time("ALSQR_time")` 
    It run experiment regarding time efficiency of our solver wrt matalab implememtation of our ThinQR factorization wrt our FullQR and matlab ThinQR.

Note that by opening file `Experiment_Time.m`, `Experiment_V.m`, `Experiment_A.m`, you can modified the parameter like  stopping condition parameter, Thikonov parameter, dimension and shape you want to try, in order to arrange them according with your needs.

The results of our experiment are avaiable at the following Google Drive shared link: https://drive.google.com/drive/folders/10mFGBTKXmi-9MzdD4eTtgZ4XGMwh0z_N?usp=sharing 

All the results have been further explored and analyzed in the following Python Notebook (avaible at: https://colab.research.google.com/drive/1Vlv3R4xuTw8bvUMkNSLhheq1B4AULveW?usp=sharing ), in order to evaluate the performance obtained using graphs and charts produced with pandas and matplotlib. 


### Author 

> Irene Pisani:   i.pisani1@studenti.unipi.it   
> Sergio Latrofa: s.latrofa1@studenti.unipi.it