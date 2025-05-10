clear; close all; clc; 

clear; close all; clc; 
format short

addpath('../functions/')
addpath('../input files/')

INPUT = inputNL_geocantilever_bilin( 2 );
[MODEL, SOL, POST, MATERIAL] = fem_solver(INPUT);
