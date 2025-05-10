clear; close all; clc; 
format short

addpath('../functions/')
addpath('../input files/')

INPUT = inputNL_strip_hole_100_els('Modified_Newton', 10);
[MODEL, SOL, POST, MATERIAL] = fem_solver(INPUT);

sigma_tab1 = disp_stresses_final_step(POST, MODEL, 5, 'int_points');
%displ_tab = disp_displ(POST, MODEL, 110);

displ_tab = disp_displ_and_stresses(POST, MODEL, 110);