clear; close all; clc; 
format short

addpath('../functions/')
addpath('../input_files/')

INPUT = inputNLB_frame_wriggers('Ramm', 20, 'full');
[MODEL, POST_full, SOL_full] = fem_solver(INPUT);

INPUT = inputNLB_frame_wriggers('Ramm', 20, 'vK');
[~, POST_vK, SOL_vK] = fem_solver(INPUT);
%%

plot_def_shape(POST_full, MODEL)

plot_eq_path_wriggers(MODEL, POST_full, POST_vK, 12)