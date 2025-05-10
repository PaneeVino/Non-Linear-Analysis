clear; close all; clc; 
format short

addpath('../functions/')
addpath('../input files/')

INPUT = inputNL_open_hole_570_els('Newton', 180);
[MODEL, SOL, POST, MATERIAL] = fem_solver(INPUT);

sigma_tab1 = disp_stresses_final_step(POST, MODEL, 358, 'int_points');
displ_tab = disp_displ_and_stresses(POST, MODEL, 616);