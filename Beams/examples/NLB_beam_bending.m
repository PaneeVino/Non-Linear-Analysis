clear; close all; clc; 
format short

addpath('../functions/')
addpath('../input_files/')

INPUT = inputNLB_beam_bending( 'thin', 1, 'Ramm', 20, 'full' );
[MODEL, POST, SOL] = fem_solver(INPUT);

%%

plot_def_shape(POST, MODEL)
plot_eq_path_bending(POST, MODEL)