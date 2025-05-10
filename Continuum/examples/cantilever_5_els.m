clear; close all; clc; 
format short

addpath('../functions/')
addpath('../input files/')

%INPUT = inputNL_cantilever_5_els( 'Newton', 30, 'NL_TL_plane_stress', 'TL' );
INPUT = inputNL_cantilever_5_els( 'Newton', 10, 'NL_UL_neohookean', 'UL' );
[MODEL, SOL, POST, MATERIAL] = fem_solver(INPUT);

sigma_tab1 = disp_stresses_final_step(POST, MODEL, 1, 'int_points');
displ_tab = disp_displ(POST, MODEL, 17);