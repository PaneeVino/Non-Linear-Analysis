clear; close all; clc; 
format short

addpath('../functions/')
addpath('../input_files/')

INPUT = inputNLB_beam_postbuckling('thin', 1, 'Ramm', 40, 'full' );
[MODEL_full, POST_full, SOL_full] = fem_solver(INPUT);

INPUT = inputNLB_beam_postbuckling('thin', 1, 'Ramm', 40, 'vK' );
[MODEL_vK, POST_vK, SOL_vK] = fem_solver(INPUT);
%%
plot_def_shape(POST_full, MODEL_full)

plot_eq_path_postbuckling(POST_full, MODEL_full, POST_vK)