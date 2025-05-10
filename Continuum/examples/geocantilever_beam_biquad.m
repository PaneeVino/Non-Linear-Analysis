clear; close all; clc; 

clear; close all; clc; 
format short

addpath('../functions/')
addpath('../input files/')

INPUT = inputNL_geocantilever_biquad( 3 );
[MODEL, SOL, POST, MATERIAL] = fem_solver(INPUT);