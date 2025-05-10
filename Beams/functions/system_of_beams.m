clear; close all; clc; 

INPUT = inputNLB_beam_bending( 'thin', 1 );
%INPUT = inputNLB_beam_postbuckling( 'thin', 1 );
%INPUT = inputNLB_frame_wriggers;

[MODEL, POST, SOL] = set_model(INPUT);
MODEL = set_assembly_vectors(MODEL);
[MODEL, SOL, POST] = nonlinear_solver(MODEL, SOL, POST);


post_process(POST, MODEL)