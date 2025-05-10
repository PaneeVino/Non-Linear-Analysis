clear; close all; clc; 

INPUT = inputNL_strip_hole_100_els;

[MODEL, POST, MATERIAL, SOL]  = set_model(INPUT);

MODEL = set_assembly_vectors(MODEL);

[MODEL, SOL] = initialize(MODEL, SOL);