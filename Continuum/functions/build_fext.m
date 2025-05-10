function [MODEL, SOL] = build_fext(MODEL, SOL)
% BUILD_FEXT assembles the external force vector for the finite element model.
%
% This function computes the external force vector (F) based on the prescribed load
% and load increment (lambda) and initializes the internal force vector (fint) to zero.
%
% Inputs:
%   MODEL - Structure containing the finite element model data:
%       - MODEL.Fhat: Prescribed external loads vector (from boundary conditions or applied loads).
%       - MODEL.ndof: Total number of degrees of freedom (DOFs).
%
%   SOL - Structure containing solution parameters:
%       - SOL.dlambda: The load increment factor, typically used to scale the applied loads.
%
% Outputs:
%   MODEL - Updated structure with the computed external force vector and initialized internal forces:
%       - MODEL.F: External force vector scaled by the load increment.
%       - MODEL.fint: Internal force vector, initialized to zero for this step.
%
%   SOL - The solution structure is returned unchanged in this case.

% Step 1: Compute the external force vector (F)
% The external force is scaled by the load increment (SOL.dlambda)
MODEL.F = SOL.nincr*SOL.dlambda * MODEL.Fhat;

% Step 2: Initialize the internal force vector (fint) to zero
MODEL.fint = zeros(MODEL.ndof, 1);

return
