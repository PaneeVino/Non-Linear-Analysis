clear; close all; clc; 
format short

addpath('../functions/')
addpath('../input files/')

INPUT = inputL_open_hole_bilinear_44_els;
[MODEL, SOL, POST, MATERIAL] = fem_solver(INPUT);

% Display the maximum absolute displacement and stress values using fprintf

% Calculate and print the maximum displacement in the X direction
max_Ux = max(max(abs(POST.STEP.Ux)));
fprintf('Maximum absolute displacement in X direction (Ux): %.4f\n', max_Ux);

% Calculate and print the maximum displacement in the Y direction
max_Uy = max(max(abs(POST.STEP.Uy)));
fprintf('Maximum absolute displacement in Y direction (Uy): %.4f\n', max_Uy);

% Calculate and print the maximum stress in the X direction (sigmaxx)
max_sigmaxx = max(max(abs(POST.STEP.sigmaxx)));
fprintf('Maximum absolute stress in X direction (sigmaxx): %.4f MPa\n', max_sigmaxx);

% Calculate and print the maximum stress in the Y direction (sigmayy)
max_sigmayy = max(max(abs(POST.STEP.sigmayy)));
fprintf('Maximum absolute stress in Y direction (sigmayy): %.4f MPa\n', max_sigmayy);

% Calculate and print the maximum shear stress (sigmaxy)
max_sigmaxy = max(max(abs(POST.STEP.sigmaxy)));
fprintf('Maximum absolute shear stress (sigmaxy): %.4f MPa\n', max_sigmaxy);
