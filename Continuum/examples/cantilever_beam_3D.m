clear; close all; clc; 
format short

addpath('../functions/')
addpath('../input files/')

INPUT = inputNL_3Dcantilever_144_els('Newton', 100);
[MODEL, SOL, POST, MATERIAL] = fem_solver(INPUT);

sigma_tab1 = disp_stresses_final_step(POST, MODEL, 18, 'int_points');
displ_tab = disp_displ(POST, MODEL, 897);
displ_tab = disp_displ_and_stresses(POST, MODEL, 897);
%%
%POST = post_process(MODEL, POST);